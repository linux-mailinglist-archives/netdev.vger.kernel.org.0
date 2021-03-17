Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1C933F4E4
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 17:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbhCQQCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 12:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232133AbhCQQCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 12:02:01 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C05C06175F;
        Wed, 17 Mar 2021 09:02:00 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id g25so1810348wmh.0;
        Wed, 17 Mar 2021 09:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=mkZpaRKaAC11bsxM26+BYFNTUQfq6TwJKJyFwjG4W3M=;
        b=OFvCtpxgfGZFLEwssoemcSO5D4hvMJtlNpJHD+We6BgcCPhYxpm0eqsZLgnUsv5Yk5
         EgUASdYTSjBZMeKS0X/6zPq8ZUzlzJ5dopC0SviMOBsPByx38pcF/HMN4YfL2+Q4aGS8
         YXIXI0VqzyBtn7SFIM4zCe1Ce87T31OF68e3AiXWnawiZM6Fk9rwRFk27jY2e/cFJJfX
         RSb9ap+dxrffZKxCu0H0WxquQmSfgKTqFHBs7QvuDUuRhwv+aJr10m1IoA7zfV7vzJKe
         p7TXvsmlNHWfpZ9upeeVu4PV0spX1VI3SaRX742uL7YsxDyZeRzWtn/hQWCkls8TYm1u
         1wTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=mkZpaRKaAC11bsxM26+BYFNTUQfq6TwJKJyFwjG4W3M=;
        b=m5C2FvUyhy/m798svSp9iQlLj7I44STvfkzbdJ0pbl/a5SL1Rfo/xAgmyLiGfydmFC
         CoKZ5Su461XPyppquvM35cVHC3SnTF4ifENKfNf3TI+3JY7lM3U+WgBBH/5U/gMU4rxU
         9NwtrwKKeo/Fk2enQkL1fFtAFxItglHlotpozKgocPHIsYy9kc57NH8u79v2nCE60+FL
         8ckgzwTslNIte+TyyawZ0iy2l9X7TRBGCUPuw5iIbjWs+yBNGix6frhSUjXdfZxfgzPa
         X0GParL/A9bF1uDr2/xsJuSYMwf8t0xsvpqaUxJLNNeuDNERrxRESWU64JECDQB/uZvi
         ELZw==
X-Gm-Message-State: AOAM530ttjdVSPirLMnpBMXDweXG/HZcQ8kLm78eCXYAzkaeebAdKbCg
        kD/GJsfrA68QKVzul3g7BeA=
X-Google-Smtp-Source: ABdhPJwTabkFhcZpzndqEFzdCZGDmLfLmvVayiYVqj4ifLnZJnYgJ3RWbGwgrnFiW23/39nIfGBYcA==
X-Received: by 2002:a05:600c:190c:: with SMTP id j12mr4406457wmq.133.1615996918480;
        Wed, 17 Mar 2021 09:01:58 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id y8sm2836431wmi.46.2021.03.17.09.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 09:01:57 -0700 (PDT)
Date:   Wed, 17 Mar 2021 17:01:56 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Belisko Marek <marek.belisko@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, mripard@kernel.org, wens@csie.org,
        jernej.skrabec@siol.net
Subject: Re: set mtu size broken for dwmac-sun8i
Message-ID: <YFIn9CRmZGrTILXI@Red>
References: <CAAfyv37z0ny=JGsRrVwkzoOd3RNb_j-rQii65a0e2+KMt-YM3A@mail.gmail.com>
 <YFHpGmgOV/O+6lTZ@Red>
 <CAAfyv37JbPtV3uUzc0ZUHNMCh+_y1XOH-auGWYJSzy4id07VCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAfyv37JbPtV3uUzc0ZUHNMCh+_y1XOH-auGWYJSzy4id07VCw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Wed, Mar 17, 2021 at 12:37:48PM +0100, Belisko Marek a écrit :
> On Wed, Mar 17, 2021 at 12:33 PM Corentin Labbe
> <clabbe.montjoie@gmail.com> wrote:
> >
> > Le Wed, Mar 17, 2021 at 10:19:26AM +0100, Belisko Marek a écrit :
> > > Hi,
> > >
> > > I'm hunting an issue when setting mtu failed for dwmac-sun8i driver.
> > > Basically adding more debug shows that in stmmac_change_mtu
> > > tx_fifo_size is 0 and in this case EINVAL is reported. Isaw there was
> > > fix for similar driver dwmac-sunxi driver by:
> > > 806fd188ce2a4f8b587e83e73c478e6484fbfa55
> > >
> > > IIRC dwmac-sun8i should get tx and rx fifo size from dma but seems
> > > it's not the case. I'm using 5.4 kernel LTS release. Any ideas?
> > >
> > > Thanks and BR,
> > >
> > > marek
> > >
> >
> > Hello
> >
> > Could you provide exact command line you tried to change mtu ?
> > Along with all MTU values you tried.
> I tried with ifconfig eth0 down && ifconfig eth0 mtu 1400 return:
> ifconfig: SIOCSIFMTU: Invalid argument
> 
> btw board is orange-pi-pc-plus
> >
> > Thanks
> > Regards
> 

I have added as CC sunxi maintainers

I can confirm that dwmac-sun8i need the same fix as 806fd188ce2a4f8b587e83e73c478e6484fbfa55.
With the patch below, I successfully changed MTU ... and the network is still working.
My first test was on orange-pi-pc which is the same SoC than your board.
I test this patch on all other sunxi SoCs and I send it upstream after.

@netdev, does there is some specific MTU values interesting to test ? (I curently try 68 500 1000 1200 1400 1500 1600 9000)

Regards

Author: Corentin Labbe <clabbe.montjoie@gmail.com>
Date:   Wed Mar 17 16:49:50 2021 +0100

    net: stmmac: dwmac-sun8i: Provide TX and RX fifo sizes
    
    MTU cannot be changed on dwmac-sun8i.
    This is due to tx_fifo_size being 0.
    Like dwmac-sunxi (with 806fd188ce2a ("net: stmmac: dwmac-sunxi: Provide TX and RX fifo sizes"))
    dwmac-sun8i need to have tx and rx fifo sizes set.
    
    Fixes: 9f93ac8d408 ("net-next: stmmac: Add dwmac-sun8i")
    Reported-by: Belisko Marek <marek.belisko@gmail.com>
    Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 6b75cf2603ff..e62efd166ec8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -1214,6 +1214,8 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
        plat_dat->init = sun8i_dwmac_init;
        plat_dat->exit = sun8i_dwmac_exit;
        plat_dat->setup = sun8i_dwmac_setup;
+       plat_dat->tx_fifo_size = 4096;
+       plat_dat->rx_fifo_size = 16384;
 
        ret = sun8i_dwmac_set_syscon(&pdev->dev, plat_dat);
        if (ret)

