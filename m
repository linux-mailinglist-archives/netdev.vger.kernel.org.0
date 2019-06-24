Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF87750D13
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 16:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731561AbfFXN74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 09:59:56 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34954 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbfFXN74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 09:59:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gB+YtwF1CCvyWJF96tCqERzNV7J9Nn4aq3GHlCbQVQE=; b=s++Fp2FWLJX/Zryy3+btSyY1P
        L8fpMJdYpiWeCgcfFXNiGt2HtnW13Afl7/4RP1zRnDSgR4gZ1n4wP/hoNVNdNJiZeZEyaNSUtv98W
        dob+djl8mggc6eud/1vLTercsfRs4L2hkxfl41dfUsbaxY7La9NlCwiUuGWsiLIPzuWxhVEpr8V81
        itjPY0iNSxxrQbxIURpH8GrSWBZn7ZdebWhYLYnemA684FixmP3LcLLSBlgWtttqwN0q9C4J+nzp1
        9sfI0cZk7xeN2EyLXzRDHBZaVYZmXuiiOpczGwRzhxx43uM9fcDR0i//GZJhN9crHe8m5kJZ55iDQ
        q38JhgOdA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:58950)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hfPVP-0008RA-QV; Mon, 24 Jun 2019 14:59:36 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hfPVM-0006LH-3b; Mon, 24 Jun 2019 14:59:32 +0100
Date:   Mon, 24 Jun 2019 14:59:32 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Phong Tran <tranmanphong@gmail.com>
Cc:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        alexander.sverdlin@gmail.com, allison@lohutok.net, andrew@lunn.ch,
        ast@kernel.org, bgolaszewski@baylibre.com, bpf@vger.kernel.org,
        daniel@iogearbox.net, daniel@zonque.org, dmg@turingmachine.org,
        festevam@gmail.com, gerg@uclinux.org, gregkh@linuxfoundation.org,
        gregory.clement@bootlin.com, haojian.zhuang@gmail.com,
        hsweeten@visionengravers.com, illusionist.neo@gmail.com,
        info@metux.net, jason@lakedaemon.net, jolsa@redhat.com,
        kafai@fb.com, kernel@pengutronix.de, kgene@kernel.org,
        krzk@kernel.org, kstewart@linuxfoundation.org,
        linux-arm-kernel@lists.infradead.org, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, liviu.dudau@arm.com,
        lkundrak@v3.sk, lorenzo.pieralisi@arm.com, mark.rutland@arm.com,
        mingo@redhat.com, namhyung@kernel.org, netdev@vger.kernel.org,
        nsekhar@ti.com, peterz@infradead.org, robert.jarzmik@free.fr,
        s.hauer@pengutronix.de, sebastian.hesselbarth@gmail.com,
        shawnguo@kernel.org, songliubraving@fb.com, sudeep.holla@arm.com,
        swinslow@gmail.com, tglx@linutronix.de, tony@atomide.com,
        will@kernel.org, yhs@fb.com
Subject: Re: [PATCH V2 08/15] ARM: mmp: cleanup cppcheck shifting errors
Message-ID: <20190624135931.kvf4xddxfcaisnq5@shell.armlinux.org.uk>
References: <20190623151313.970-1-tranmanphong@gmail.com>
 <20190624135105.15579-1-tranmanphong@gmail.com>
 <20190624135105.15579-9-tranmanphong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624135105.15579-9-tranmanphong@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 08:50:58PM +0700, Phong Tran wrote:
>  #define MPMU_PLL2_CTRL1				MPMU_REG(0x0414)
>  #define MPMU_CGR_PJ				MPMU_REG(0x1024)
>  #define MPMU_WUCRM_PJ				MPMU_REG(0x104c)
> -#define MPMU_WUCRM_PJ_WAKEUP(x)			(1 << (x))
> -#define MPMU_WUCRM_PJ_RTC_ALARM			(1 << 17)
> +#define MPMU_WUCRM_PJ_WAKEUP(x)			BIT((x))

Extra parens not required.

> +#define MPMU_AWUCRM_WAKEUP(x)			BIT(((x) & 0x7))

Ditto.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
