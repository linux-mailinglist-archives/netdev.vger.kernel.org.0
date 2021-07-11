Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2173C39B7
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 03:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbhGKBFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 21:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbhGKBFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 21:05:34 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0DD1C0613DD;
        Sat, 10 Jul 2021 18:02:48 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id p8so18540034wrr.1;
        Sat, 10 Jul 2021 18:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GVe3eJclmn+wBIMr6wtrhEVKg5cevdvrMqaw2kVlG4A=;
        b=RRR1OVyRjAENjc2sIbLLT+XM2+m4MfGCdlQ9oJG7TGjZilJyrQrYhi7sQ+wuu9deQf
         qfd8q58CjEFtZZ+N8NFVoKydZ0c6iLN9nghtjQqdJSglcY6+Y4OQiGut+Hhps+xabeWD
         HrrUifAwd23bstSTDkbr/u5VCnk6H80qEQMEScCA4i8EK56Qgtq/mcf3w7QeCRvJOnKp
         B3sOfnQ5FieEHBAJzY6g1E9WNibdFiB8YjKRD9HH0DRYzti73GELGNbs+v43bfp8N4no
         KokKnn54t/+lX3J1FqCnM5CyrB/nk2sDJ0SpXg08N5EnvjcEV0ypjTHsZBEMRgA0L6QF
         ru+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GVe3eJclmn+wBIMr6wtrhEVKg5cevdvrMqaw2kVlG4A=;
        b=OXPXBn376P7FysB6fS/jWXyZDBDmEsB5vBEp9QqAjWhsuVvo58MnTi28oIOlxbdBsD
         k0YdRf/B7DeVSP/JKFOpXNWVtM/QdcI1YJEZJSdkpx5w54f8bEJg0b8kdjGS8RLkjV+D
         7nUwghCcZJVcwlqqciO6eJ0Jb0t0/62vKPzNBTn15u1V6Go2B58SPiKb3abKI3kAXGxF
         2BjOBrYxXBUwZwmc+M+y/mNgx6BUQvO1y8uOZ3Vf6PyGAqGy92CevJLiwvivEzdzCWgM
         6k8+OmT66EVZbEFNXqzB0WoxVNvcImUEJMtYmRMe6Z6J80KYToMvYkrt22uKZlk1Hy9Q
         ntSQ==
X-Gm-Message-State: AOAM530csV9btTt28SEBAtR4X9JIIuRstYFxh76TGKE4rnodPXc36fqB
        TqAHi7LsqM9kVSaq1xbbN+g=
X-Google-Smtp-Source: ABdhPJxhv/RR4EMs9VzVwCaj90GBtMSVco2KEdl3KuvH+4/ZGQBtb/MJU+P6/G1dkmKJ6bFh4Hbz+A==
X-Received: by 2002:a05:6000:108:: with SMTP id o8mr12056590wrx.154.1625965366752;
        Sat, 10 Jul 2021 18:02:46 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-721c-fc00-f22f-74ff-fe21-0725.c22.pool.telefonica.de. [2a01:c22:721c:fc00:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id g3sm10027914wrv.64.2021.07.10.18.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jul 2021 18:02:46 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     pablo@netfilter.org
Cc:     nbd@nbd.name, coreteam@netfilter.org, davem@davemloft.net,
        fw@strlen.de, kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, olek2@wp.pl, roid@nvidia.com
Subject: Re: [PATCH nf] Revert "netfilter: flowtable: Remove redundant hw refresh bit"
Date:   Sun, 11 Jul 2021 03:02:44 +0200
Message-Id: <20210711010244.1709329-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614215351.GA734@salvia>
References: <20210614215351.GA734@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Aleksander,

> The xt_flowoffload module is inconditionally setting on the hardware
> offload flag:
[...]
>
> which is triggering the slow down because packet path is allocating
> work to offload the entry to hardware, however, this driver does not
> support for hardware offload.
> 
> Probably this module can be updated to unset the flowtable flag if the
> harware does not support hardware offload.

yesterday there was a discussion about this on the #openwrt-devel IRC
channel. I am adding the IRC log to the end of this email because I am
not sure if you're using IRC.

I typically don't test with flow offloading enabled (I am testing with
OpenWrt's "default" network configuration, where flow offloading is
disabled by default). Also I am not familiar with the flow offloading
code at all and reading the xt_FLOWOFFLOAD code just raised more
questions for me.

Maybe you can share some info whether your workaround from [0] "fixes"
this issue. I am aware that it will probably break other devices. But
maybe it helps Pablo to confirm whether it's really an xt_FLOWOFFLOAD
bug or rather some generic flow offload issue (as Felix suggested on
IRC).


Best regards,
Martin


[0] https://github.com/abajk/openwrt/commit/ee4d790574c0edd170e1710d7cd4819727b23721


<rsalvaterra> nbd: I saw your flow offloading updates. Just to make sure, this issue hasn't been addressed yet, has it? https://lore.kernel.org/netdev/20210614215351.GA734@salvia/
<nbd> i don't think so
<nbd> can you reproduce it?
<rsalvaterra> nbd: Not really, I don't have the hardware.
<rsalvaterra> It's lantiq, I think (bthh5a).
<rsalvaterra> However, I believe dwmw2_gone has one, iirc.
<xdarklight> nbd: I also have a HH5A. if you have any patch ready you can also send it as RFC on the mailing list and Cc Aleksander
<rsalvaterra> xdarklight: Have you been able to reproduce the flow offloading regression?
<xdarklight> I can try (typically I test with a "default" network configuration, where flow offloading is disabled)
<rsalvaterra> xdarklight: I don't have a lot of details, only this thread: https://github.com/openwrt/openwrt/pull/4225#issuecomment-855454607
<xdarklight> rsalvaterra: this is the workaround that Aleksander has in his tree: https://github.com/abajk/openwrt/commit/ee4d790574c0edd170e1710d7cd4819727b23721
<rsalvaterra> xdarklight: Well, but that basically breaks hw flow offloading everywhere else, if I'm reading correctly. :)
<xdarklight> rsalvaterra: I am not arguing with that :). I wanted to point out that Pablo's finding on the netfilter mailing list seems to be correct
<rsalvaterra> xdarklight: Sure, which is why I pinged nbd, since he's the original author of the xt_FLOWOFFLOAD target.
<rsalvaterra> What it seems is that it isn't such trivial fix. :)
<xdarklight> I looked at the xt_FLOWOFFLOAD code myself and it raised more questions than I had before looking at the code. so I decided to wait for someone with better knowledge to look into that issue :)
<rsalvaterra> Same here. I just went "oh, this requires divine intervention" and set it aside. :P
<nbd> xdarklight: which finding did you mean?
<xdarklight> nbd: "The xt_flowoffload module is inconditionally setting on the hardware offload flag" [...] flowtable[1].ft.flags = NF_FLOWTABLE_HW_OFFLOAD;
<xdarklight> nbd: from this email: https://lore.kernel.org/netdev/20210614215351.GA734@salvia/
<nbd> i actually think that finding is wrong
<nbd> xt_FLOWOFFLOAD registers two flowtables
<nbd> one with hw offload, one without
<nbd> the target code does this:
<nbd> table = &flowtable[!!(info->flags & XT_FLOWOFFLOAD_HW)];
<nbd> so it selects flowtable[1] only if info->flags has XT_FLOWOFFLOAD_HW set
<rsalvaterra> nbd: That's between you and Pablo, I mustn't interfere. :)
<nbd> i did reply to pablo, but never heard back from him
<rsalvaterra> nbd: The merge window is still open, he's probably busy at the moment… maybe ping him on Monday?
<xdarklight> nbd: it seems that your mail also didn't make it to the netdev mailing list (at least I can't find it)
<rsalvaterra> xdarklight: Now that you mention it, neither do I.
<nbd> he wrote to me in private for some reason
<xdarklight> oh okay. so for me to summarize: you're saying that the xt_FLOWOFFLOAD code should be fine. in that case Aleksander's workaround (https://github.com/abajk/openwrt/commit/ee4d790574c0edd170e1710d7cd4819727b23721) is also a no-op and the original problem would still be seen
<rsalvaterra> xdarklight: I don't think it's a no-op, otherwise he wouldn't carry it in his tree… maybe something's wrong in the table selection? table = &flowtable[!!(info->flags & XT_FLOWOFFLOAD_HW)]; does look correct, though.
<nbd> xdarklight: well, it's not a no-op if the issue was reproduced with option flow_offloading_hw 1 in the config
<rsalvaterra> nbd: Uh… If he has option flow_offloading_hw '1' on a system which doesn't support hw flow offloading… he gets to keep the pieces, right?
<nbd> it shouldn't break
<nbd> and normally i'd expect the generic flow offload api to be able to deal with it without attempting to re-enable hw offload over and over again
