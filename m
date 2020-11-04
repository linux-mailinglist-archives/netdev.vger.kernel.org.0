Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF1B2A667F
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbgKDOia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:38:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbgKDOia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 09:38:30 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001E8C0613D3
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 06:38:29 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id g12so22263072wrp.10
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 06:38:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=jwYMBekLoIKb2pm9DukLcAj6ADHyN32ia4DmRJK4DS0=;
        b=VlEVv4ZDC3O+NPRX6BLRwQs9edu5cEqDOdvLbmy1jYvUGQOz45VzpyVGsBslfEzWmb
         7GQaW3FVfTJ1eDtD079rCrZK5yK0Aw7SnrJhj/eGx//yBv4S/KixkILhu4f7XFz8PKv+
         HIPK0FbQADpfBMNcD/iY9UMvTV2y0EgLtAyEauogLjsWvsdl9u6tqoQKwhg7C0nG4aZe
         4Z296NEAdZoy/dq8WzG4S7yhStynoqcGXmg+02P4pagOYHs+NZDqlHHNhNyuCjCH1mv+
         j7tsThllOlibfJ92hJlbt0KwgiBZSDXC2C2ruutV6i4DLTTLw2TmH901Rp4Qf5H6Fkhi
         7H6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=jwYMBekLoIKb2pm9DukLcAj6ADHyN32ia4DmRJK4DS0=;
        b=NmmmSna69m/3bNu5RTWRymEaEYhDYeifkEJEW+ChNEsW/D/ybY2cfiKJx5x56xPEMN
         95SLqeA+MdJ8LLqUhuZiaoeVlLRXZZjfg+AHzaN5ZVRKBUAwdVaL2aYWYXQ3+P5ZbNJj
         DGfM6XaRPEkbe7MNieMBCfsrokEGWeWV9BDwGPqGDWj0xOHEkc/vapqcekB6rXMx+ylA
         1VWmsQjshdVRZudtRc9/G1lL3cQAHMWDTlo2x2mVhUgRrMKKO834wM7d/+Bq9X2/7UIl
         zEkqx8D7CQFhIcfP+KleEiir6jjTDjB1KDPeVC/q+XC5+bbXLJrqTiR0kFXLeC51KUOz
         rdKg==
X-Gm-Message-State: AOAM5307GzZ8/fvsXbwL17EHnf1yj8wdYw/4HqA4PjHN0oYvNxEfs7bE
        11GhlTpA/l0Tohiv/OHBHDGKHA==
X-Google-Smtp-Source: ABdhPJzZ9CTvMxcdcYZaAx+0uG46KE5hHoBTQvmrnLm2i6lD/ZhFwA1+beDV76UgTfBHdVBvt/ftqQ==
X-Received: by 2002:a5d:4f8c:: with SMTP id d12mr34057674wru.351.1604500708743;
        Wed, 04 Nov 2020 06:38:28 -0800 (PST)
Received: from dell ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id t2sm2839960wrw.95.2020.11.04.06.38.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 06:38:27 -0800 (PST)
Date:   Wed, 4 Nov 2020 14:38:26 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Dustin McIntire <dustin@sensoria.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 02/12] net: ethernet: smsc: smc911x: Mark 'status' as
 __maybe_unused
Message-ID: <20201104143826.GF4488@dell>
References: <20201104090610.1446616-1-lee.jones@linaro.org>
 <20201104090610.1446616-3-lee.jones@linaro.org>
 <20201104132200.GW933237@lunn.ch>
 <20201104143140.GE4488@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201104143140.GE4488@dell>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 04 Nov 2020, Lee Jones wrote:

> On Wed, 04 Nov 2020, Andrew Lunn wrote:
> 
> > On Wed, Nov 04, 2020 at 09:06:00AM +0000, Lee Jones wrote:
> > > 'status' is used to interact with a hardware register.  It might not
> > > be safe to remove it entirely.  Mark it as __maybe_unused instead.
> > 
> > Hi Lee
> > 
> > https://www.mail-archive.com/netdev@vger.kernel.org/msg365875.html
> > 
> > I'm working on driver/net/ethernet and net to make it w=1 clean.  I
> > suggest you hang out on the netdev mailing list so you don't waste
> > your time reproducing what i am doing.
> 
> I believe that ship has sailed.  Net should be clean now.
> 
> It was it pretty good shape considering.  Only 2 sets.
> 
> Wireless alone was more like 4.  And SCSI, well ... :D
> 
> Maybe that was down to some of your previous efforts? 

Our of interest, are you planning on working on any other areas?

I'm slowly working my way through the whole kernel.

Completed so far:

 - ASoC
 - backlight
 - cpufreq
 - crypto
 - dmaengine
 - gpio
 - hwmon
 - iio
 - input
 - mfd
 - misc
 - mmc
 - mtd
 - net
 - pinctrl
 - pwm
 - regulator
 - remoteproc
 - scsi
 - soc
 - spi
 - tty
 - usb
 - wireless 

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
