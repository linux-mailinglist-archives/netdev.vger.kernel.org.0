Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA74739A232
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 15:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhFCNa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 09:30:58 -0400
Received: from mail-ed1-f48.google.com ([209.85.208.48]:42873 "EHLO
        mail-ed1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbhFCNa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 09:30:57 -0400
Received: by mail-ed1-f48.google.com with SMTP id i13so7107180edb.9;
        Thu, 03 Jun 2021 06:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AsY4CC2jUsbhA7Sh7zEuXYTCJ/q9mQ3pTZZVOhrOvaw=;
        b=YI+sslnEov5+3qblH1HHF/85Z7lGvnkhNs9kvYTyd8zfuO3C2acB8IK0YN3hPZrlII
         mmeqPrcJ2ci2otKqp3ZygBHDes6X7oiyCxj5ImpkmheOTInQLuO59NIB0lCg7/fVEO8d
         nXjGfvrYthHtj13R6iRTCjgbT4haRmRVJhaduDFaoBFW1E54z1sxs7YGG04jt3e7JFC8
         7I945rGXSK4fGdjAgwHfvyfNLfnN5zi5Joe/GjgxPMxSD8e/UI5J5NJQAX93N64jCDLX
         /7fwjPOMqlEO/LXzIBgWiWkgztzmEn9/TANNSQfDQfQiYKaAFN/7xkRgykObXZCFK+CZ
         fwiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AsY4CC2jUsbhA7Sh7zEuXYTCJ/q9mQ3pTZZVOhrOvaw=;
        b=ncFTo333HcWi18cbmEqMGk+8m83V1CBmPS5yby1bSBmV4k9IIfpJ/EI3XwOPYHitdV
         13TJeidTEcCkXavz7rYW+kVSKSPcRPCAYlOG4ep/Eu8352OSWIXp7oNOsVxj6K+cqFYB
         36LQ0GRoVePn0Tg/6xAYyjDLfymPUSyMG4NVjCw4byUh5EfuhHVTL5JaIEZV44UMCbqt
         +82ADutS39+0Wb/qKKB6sJGYvbBejjL5kv29cIl9+npRKQO17mHM2Xru1nRIVIjLQI1U
         +HggpanCOZCtsm/9VJHkTBsN6rjtSzJX7TVjVcBIz5P4D8k3g5P6CX9p0pg7yv8oyEq8
         CzZQ==
X-Gm-Message-State: AOAM530+ZHz7hfOoq24EIN79lKvnVFaCMGbtlPZ/7/jwuzY/IikIeUbP
        aT6mLh7FSZUmNLalsYptdl4=
X-Google-Smtp-Source: ABdhPJwC4Eb4uhIsV+JBMZdkSQBTOHkx9nuChPxQic5GV974vvB4qh3kqgw+xBz93xsL3q9Jdwurjw==
X-Received: by 2002:aa7:c799:: with SMTP id n25mr41586057eds.16.1622726891599;
        Thu, 03 Jun 2021 06:28:11 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id u4sm1515033eje.81.2021.06.03.06.28.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 06:28:11 -0700 (PDT)
Date:   Thu, 3 Jun 2021 16:28:09 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Jose.Abreu@synopsys.com, andrew@lunn.ch, hkallweit1@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, weifeng.voon@intel.com,
        boon.leong.ong@intel.com, tee.min.tan@intel.com,
        vee.khee.wong@linux.intel.com, vee.khee.wong@intel.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH net-next v4 0/3] Enable 2.5Gbps speed for stmmac
Message-ID: <20210603132809.2z3jhpuxaryaql6v@skbuf>
References: <20210603115032.2470-1-michael.wei.hong.sit@intel.com>
 <20210603130851.GS30436@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603130851.GS30436@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Michael,

On Thu, Jun 03, 2021 at 02:08:51PM +0100, Russell King (Oracle) wrote:
> Hi,
> 
> On Thu, Jun 03, 2021 at 07:50:29PM +0800, Michael Sit Wei Hong wrote:
> > Intel mGbE supports 2.5Gbps link speed by overclocking the clock rate
> > by 2.5 times to support 2.5Gbps link speed. In this mode, the serdes/PHY
> > operates at a serial baud rate of 3.125 Gbps and the PCS data path and
> > GMII interface of the MAC operate at 312.5 MHz instead of 125 MHz.
> > This is configured in the BIOS during boot up. The kernel driver is not able
> > access to modify the clock rate for 1Gbps/2.5G mode on the fly. The way to
> > determine the current 1G/2.5G mode is by reading a dedicated adhoc
> > register through mdio bus.
> 
> How does this interact with Vladimir's "Convert xpcs to phylink_pcs_ops"
> series? Is there an inter-dependency between these, or a preferred order
> that they should be applied?
> 
> Thanks.

My preferred order would be for my series to go in first, if possible,
because I don't have hardware readily available to test, and VK already
has tested my patches a few times until they reached a stable state.

I went through your patches and I think rebasing on top of my
phylink_pcs_ops conversion should be easy.

Thanks.
