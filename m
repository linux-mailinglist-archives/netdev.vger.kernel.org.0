Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 502D23DBC6
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 22:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406502AbfFKUXR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 11 Jun 2019 16:23:17 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:39891 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406133AbfFKUXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 16:23:16 -0400
Received: by mail-ed1-f66.google.com with SMTP id m10so21974759edv.6
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 13:23:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=mviP/ipQs1frf+/GlU4ubf2G3KiZDQmIq8RB9mvaFho=;
        b=s23Upd4UBNs15gwJtHJzKqcz8k048SCSJCP/IwY7wYfCarGUzkuv3Jn6qr4gCJEDe1
         /y7dqMGCmk4j19h51bmbOSbs6Ta7dzypsFY/O8FYxp7wJPM+p8M48Sogc8GNSNrvjDuV
         Mz297TziYfUAs82X98IkSPqT6NQSUF2hat/mZ7npOPSjBB2xmCuPNZ9nb7nlEdrHJj6r
         kJe3SjUPMUM7g0jkvIk/KfsqFi/p+v9IeU7oQ7zC1/cNTFXZ3yrQzzG1ctEVk+rtpIkX
         oe/zwRPVtnhMe3d0t6bOFI8goRiOYIj2X0cLj/KNneyDp9KIxsJqSCmzU0OT8naE2Ls8
         U6Ww==
X-Gm-Message-State: APjAAAVKwSRtvgNjmqYg5PbaYkdCp/pMB3ZLlE8liNEnsKuFdAFP1W6E
        DU9rDRYcDGV0R6M2L4ON5n50vIAp3k8=
X-Google-Smtp-Source: APXvYqzg2v8sagfUFnGvcvr3a0q5q3hCwTG42NJWrNwbs2qv+M/bpV0cQdaa8o5JJfRgUnlG2eoDXw==
X-Received: by 2002:a17:906:451:: with SMTP id e17mr12156771eja.161.1560284594995;
        Tue, 11 Jun 2019 13:23:14 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id i6sm1883144eda.79.2019.06.11.13.23.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 13:23:14 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6A8A418037E; Tue, 11 Jun 2019 22:23:13 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Paul Blakey <paulb@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>,
        Rony Efraim <ronye@mellanox.com>,
        "nst-kernel\@redhat.com" <nst-kernel@redhat.com>,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>,
        Kevin Darbyshire-Bryant <kevin@darbyshire-bryant.me.uk>
Subject: Re: [PATCH net-next 1/3] net/sched: Introduce action ct
In-Reply-To: <20190611155350.GC3436@localhost.localdomain>
References: <1560259713-25603-1-git-send-email-paulb@mellanox.com> <1560259713-25603-2-git-send-email-paulb@mellanox.com> <87d0jkgr3r.fsf@toke.dk> <da87a939-9000-8371-672a-a949f834caea@mellanox.com> <877e9sgmp1.fsf@toke.dk> <20190611155350.GC3436@localhost.localdomain>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 11 Jun 2019 22:23:13 +0200
Message-ID: <87pnnjg9ce.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> writes:

> On Tue, Jun 11, 2019 at 05:34:50PM +0200, Toke Høiland-Jørgensen wrote:
>> Paul Blakey <paulb@mellanox.com> writes:
>> 
>> > On 6/11/2019 4:59 PM, Toke Høiland-Jørgensen wrote:
>> >> Paul Blakey <paulb@mellanox.com> writes:
>> >>
>> >>> Allow sending a packet to conntrack and set conntrack zone, mark,
>> >>> labels and nat parameters.
>> >> How is this different from the newly merged ctinfo action?
>> >>
>> >> -Toke
>> >
>> > Hi,
>> >
>> > ctinfo does one of two very specific things,
>> >
>> > 1) copies DSCP values that have been placed in the firewall conntrack 
>> > mark back into the IPv4/v6 diffserv field
>> >
>> > 2) copies the firewall conntrack mark to the skb's mark field (like 
>> > act_connmark)
>> >
>> > Originally ctinfo action was named conndscp (then conntrack, which is 
>> > what our ct shorthand stands for).
>> >
>> > We also talked about merging both at some point, but they seem only 
>> > coincidentally related.
>> 
>> Well, I'm predicting it will create some confusion to have them so
>> closely named... Not sure what the best way to fix that is, though...?
>
> I had suggested to let act_ct handle the above as well, as there is a
> big chunk of code on both that is pretty similar. There is quite some
> boilerplate for interfacing with conntrack which is duplicated.
> But it was considered that the end actions are unrelated, and ctinfo
> went ahead. (I'm still not convinced of that, btw)
>
> Other than this, which is not an option anymore, I don't see a way to
> avoid confusion here. Seems anything we pick now will be confusing
> because ctinfo is a generic name, and we also need one here.

Hmm, yeah, dunno if I have any better ideas for naming that would avoid
this. act_runct ? Meh...

-Toke
