Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7FC4375BA4
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 21:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbhEFTVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 15:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbhEFTVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 15:21:49 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA03C061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 12:20:50 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id g14so7428798edy.6
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 12:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+2pqN67PwfFE8bqIfQM3MOdZ3t468sO3rqqBqkpbJVs=;
        b=CNMrVTogZVxEGhlLNRXp3swMaVHSL8OC5OJQD6bV4HDGSNBMOtCFo3+x44UIqfaALl
         pRyVsAsfDEYcqB3o9pb5DEZkA7copWEPaAsTMW3xI5RzaiVxG+9YXtynW1D00JBNGJWw
         9/unxpSCffgt9TP37ARbBXQzvXhXPIREyw6hzSEmbpreffITwSdNj/gc6yL664eubvFd
         +47m4qwxStPBiXL80KWJfkHrxVZ7wqlhhDnuKDcw/JlVuyh9bwBto78wKZI+PDLAgPBa
         bRKqPcayti2dQtENKa55I1E4RmuCV9JuHdp9pxwHuoTlaHy66Z28AC/H3D2y5u25foAc
         RmhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+2pqN67PwfFE8bqIfQM3MOdZ3t468sO3rqqBqkpbJVs=;
        b=cq90rFkyfsoLvsc00CSgVhcehmVYu6FaQM9KrRRHTdCeSbZbqkvTAlmBoDECkh1OC2
         AR8mKKUbhabFqSGDykLRvXiYE6MSBDSV10C8sXMPlkLS7KZDnc9hxE9YGs1SxwXqohb2
         Lt+O0Q2JEWUtkUDjEZkCV/VKgTdIXvtUe8WZfn7VeQDxnHSmYq9D/Xl9ExBoA77YttJq
         3yHNGKkLhPWevr2r30RWL1AOo6we7RlMU9N0pFG1gpcF9A5qzplJBRTpvWbaLlWZm3l6
         xXSSXlKZdbxEzWe2hrjrhqEs6npNRdpBo7YWVn+SmCx3i0+m43Vde+eZBoTgXc1efPXP
         5WDg==
X-Gm-Message-State: AOAM532ML+9Fwzxx/1MgQnW6797SzClM/ONpoj9p2WkU5G+cl9t+An7/
        oNT4xxE7mcHYF9KdK6pJcR7cUZ1VLIn9fsXZcbg9T5ZyObE=
X-Google-Smtp-Source: ABdhPJyKGMF4BoBriAJYo0sWo6HTtsv00R9fczkeOdBsJOGI+8rrBMlpkBFwqxpmgkt7SVw2FB/N0zTOLaEJy0dxbeQ=
X-Received: by 2002:aa7:cb84:: with SMTP id r4mr7114791edt.187.1620328848711;
 Thu, 06 May 2021 12:20:48 -0700 (PDT)
MIME-Version: 1.0
References: <421cc86c-b66f-b372-32f7-21e59f9a98bc@kontron.de>
In-Reply-To: <421cc86c-b66f-b372-32f7-21e59f9a98bc@kontron.de>
From:   Adam Ford <aford173@gmail.com>
Date:   Thu, 6 May 2021 14:20:37 -0500
Message-ID: <CAHCN7xJCUtmi1eOftFq0mg28SFyt2a34q3Vy8c0fvOs5wHC-yg@mail.gmail.com>
Subject: Re: i.MX8MM Ethernet TX Bandwidth Fluctuations
To:     Frieder Schrempf <frieder.schrempf@kontron.de>
Cc:     NXP Linux Team <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 6, 2021 at 9:51 AM Frieder Schrempf
<frieder.schrempf@kontron.de> wrote:
>
> Hi,
>
> we observed some weird phenomenon with the Ethernet on our i.MX8M-Mini boards. It happens quite often that the measured bandwidth in TX direction drops from its expected/nominal value to something like 50% (for 100M) or ~67% (for 1G) connections.
>
> So far we reproduced this with two different hardware designs using two different PHYs (RGMII VSC8531 and RMII KSZ8081), two different kernel versions (v5.4 and v5.10) and link speeds of 100M and 1G.
>
> To measure the throughput we simply run iperf3 on the target (with a short p2p connection to the host PC) like this:
>
>         iperf3 -c 192.168.1.10 --bidir
>
> But even something more simple like this can be used to get the info (with 'nc -l -p 1122 > /dev/null' running on the host):
>
>         dd if=/dev/zero bs=10M count=1 | nc 192.168.1.10 1122
>
> The results fluctuate between each test run and are sometimes 'good' (e.g. ~90 MBit/s for 100M link) and sometimes 'bad' (e.g. ~45 MBit/s for 100M link).
> There is nothing else running on the system in parallel. Some more info is also available in this post: [1].
>
> If there's anyone around who has an idea on what might be the reason for this, please let me know!
> Or maybe someone would be willing to do a quick test on his own hardware. That would also be highly appreciated!

I have seen a similar regression on linux-next on both Mini and Nano.
I thought I broke something, but it returned to normal after a reboot.
  However, with a 1Gb connection, I was running at ~450 Mbs which is
consistent with what you were seeing with a 100Mb link.

adam

>
> Thanks and best regards
> Frieder
>
> [1]: https://community.nxp.com/t5/i-MX-Processors/i-MX8MM-Ethernet-TX-Bandwidth-Fluctuations/m-p/1242467#M170563
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
