Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A55F2CF9D
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 21:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbfE1Tit convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 May 2019 15:38:49 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:44290 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbfE1Tit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 15:38:49 -0400
Received: by mail-ed1-f66.google.com with SMTP id b8so7544400edm.11
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 12:38:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=kLL0dJaa5oX1Gk5I3Sa4gmAoDUPCUfKzZyhWdhkmdQE=;
        b=d6aVagcPnVfAq4WG6xEAScv2WwsfQ+kWAC6aFHD5hA+xxVAy013Na1uxrNVrG2+D5F
         8HF9gmzIJpYwoGHDczmJ2btnIWvU3r+iKVyepuAYEpxN+5iK1Va22clRlI46nxLMDPTH
         V+kAfq+cMFIt8b2mhfzpr2Tzec/bQbX7T0KynjLrLauIdo1XPFqupKEXN0VbQw3wjFGq
         BzbBTSrOyoVo0eYcPbhIhn+3DGghNNFldncqZcqF7zAEifZOpmq4T8CN6Sh78L7uQRex
         3tiSNSDtZsCxlZQvJ/loBJspZEfMVlPjMFh7fLtQfm7uGHSOrrJqiNbYhk+VUX2NDKcp
         sHNw==
X-Gm-Message-State: APjAAAUxhHcUcT7kb2X0Z2Zdh+sc+rRaxq5m/o8Q5cr/vRKXUZx0cnns
        UQ/8Lc1BLa7bYFJ9aZeKYHaQq9XtwH4=
X-Google-Smtp-Source: APXvYqzVHMFryBZBZMRM4MOK16iPJIpB3qarOjlrA9l+3rjhgwayJYlt+mr9eRgNDZU54Inth2I1fw==
X-Received: by 2002:a50:91cc:: with SMTP id h12mr130836558eda.3.1559072328089;
        Tue, 28 May 2019 12:38:48 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (alrua-x1.vpn.toke.dk. [2a00:7660:6da:10::2])
        by smtp.gmail.com with ESMTPSA id f44sm4577918eda.73.2019.05.28.12.38.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 May 2019 12:38:47 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5770318031E; Tue, 28 May 2019 21:38:46 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Cc:     "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v6] net: sched: Introduce act_ctinfo action
In-Reply-To: <70B35849-D2D4-4B4E-8D3E-8AF089B0947F@darbyshire-bryant.me.uk>
References: <20190528170236.29340-1-ldir@darbyshire-bryant.me.uk> <87ef4itpsq.fsf@toke.dk> <70B35849-D2D4-4B4E-8D3E-8AF089B0947F@darbyshire-bryant.me.uk>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 28 May 2019 21:38:46 +0200
Message-ID: <87blzmtlmh.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk> writes:

>> On 28 May 2019, at 19:08, Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>> 
> <stuff snipped>
>> 
>> Thank you for doing another iteration!
>> 
>> No further comments on the actual code, but I still get the whitespace
>> issue with the patch... And now it results in stray ^M characters in the
>> Kconfig file, which makes the build blow up :/
>
> This is very odd.  I produced the last patch (v6) from within a debian VM
> and sent it from there also.  No weird line endings in the locally produced
> patch text and it applied cleanly to a local tree.  I’ve sent test patches
> into the openwrt tree and applied those cleanly direct from patchwork.
>
> Similarly I’ve downloaded the v5 patch from netdev patchwork
> http://patchwork.ozlabs.org/patch/1105755/mbox/ and applied that with
> git am without problem.
>
> Am totally confused!

Hmm, yeah, that is odd. Guess it may be mangled somewhere in transit on
the way to my system? I'll try to investigate that...

Anyway, if I download the patch from patchwork and apply it manually
things seems to work, so I guess you can ignore this for now. I'm sure
Davem will let you know if he has problems applying the patch :)

-Toke
