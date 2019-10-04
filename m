Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1C30CBC31
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 15:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388696AbfJDNsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 09:48:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34066 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388662AbfJDNsx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 09:48:53 -0400
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com [209.85.208.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 04A95C06513B
        for <netdev@vger.kernel.org>; Fri,  4 Oct 2019 13:48:53 +0000 (UTC)
Received: by mail-lj1-f200.google.com with SMTP id q185so1786667ljb.20
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 06:48:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Wva8vraPObqOZIt8st2114o0Y/gX0tBPWrlisaTLCDs=;
        b=n1NV3f1R75irsQJ37O+PS2KdNHdMuJ18Hv1BjLA+tq2It9qjA99aseqf8oMx+ajy7J
         irlNeBh5T9NyoISfsLdlTidt8Q1wKvJNhVhpDqMWdtlXiMUuodWQjv2ifR0Y2/ZsqHgE
         hThi+27OF1jTw1bhrdOaXXrdQJLcuy+wVRkoqpeN8fbIGV6r+hsjWoHuCCdmOCIj3acz
         TqWsvfdbL1KPvaCkk5eToOpZYylzorWslv2+CIB97m2xqHH95QYmhu0gfE0bUjbrUx86
         esurwUDS+qw377gLNOHKwDMAkOrBzBQFqZtyvTXIL1Xaewjv8rVCPbvjiWLAo6PQ7aka
         hSVA==
X-Gm-Message-State: APjAAAXRN4IlBPFoOG4sKH/QUi4nw5owyU/Vpdax1axndrvA1ULW46HO
        MSr2wL+Ec43rRvIc507rN0nAka/bKwqQ2sGgoBV7dgK4MQHi9fA9Sbv4H7KCFjSC6o/cQhT/UNC
        NiBets3URx749uLpB
X-Received: by 2002:ac2:43b8:: with SMTP id t24mr7404835lfl.24.1570196931381;
        Fri, 04 Oct 2019 06:48:51 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxsskEcvwDYz9YZe4y2yQ9EnxR7lxymDUYlzH+PFQR609PHcycvN2SMYeIJ1smwipxCk+ZZYg==
X-Received: by 2002:ac2:43b8:: with SMTP id t24mr7404825lfl.24.1570196931194;
        Fri, 04 Oct 2019 06:48:51 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id h5sm1340786ljf.83.2019.10.04.06.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 06:48:50 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 426C218063D; Fri,  4 Oct 2019 15:48:49 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [v4 1/4] samples: pktgen: make variable consistent with option
In-Reply-To: <CAEKGpzhmkDBGV5BmwwYgb0ng+Eyyzp2CFoGeZ65aEgR=CxWnMg@mail.gmail.com>
References: <20191004013301.8686-1-danieltimlee@gmail.com> <20191004145153.6192fb09@carbon> <CAEKGpzhmkDBGV5BmwwYgb0ng+Eyyzp2CFoGeZ65aEgR=CxWnMg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 04 Oct 2019 15:48:49 +0200
Message-ID: <87lfu0oc3i.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Daniel T. Lee" <danieltimlee@gmail.com> writes:

> On Fri, Oct 4, 2019 at 9:52 PM Jesper Dangaard Brouer <brouer@redhat.com>
> wrote:
>
>>
>> On Fri,  4 Oct 2019 10:32:58 +0900 "Daniel T. Lee" <danieltimlee@gmail.com>
>> wrote:
>>
>> > [...]
>>
>>
> Thanks for the review!
>
>
>> A general comment, you forgot a cover letter for your patchset.
>>
>>
> At first, I thought the size of the patchset (the feature to enhance) was
> small so
> I didn't include it with intent, but now it gets bigger and it seems
> necessary for cover letter.
>
> When the next version is needed, I'll include it.
>
>
>> And also forgot the "PATCH" part of subj. but patchwork still found it:
>> https://patchwork.ozlabs.org/project/netdev/list/?series=134102&state=2a
>>
>>
> I'm not sure I'm following.
> Are you saying that the word "PATCH" should be included in prefix?
>     $ git format-patch --subject-prefix="PATCH,v5"
> like this?

$ git format-patch --subject-prefix="PATCH bpf-next" -v5

would be the right incantation for this :)

-Toke
