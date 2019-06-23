Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1374FC78
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 17:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfFWPYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 11:24:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50638 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726399AbfFWPYV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Jun 2019 11:24:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tO9c/rs97W0ia9zMhQ+rkqpEZpffIjpr7pWLTraofSE=; b=qaLFmSnMQl4sPp1o2z/HXGCzah
        gMwwcsQXCYPlG6KtqEJ2hGiujAEeoKTqb98ksLJhFsHhnSDfRILIc+zxWu0H7DSDIuWGK71T6hTOU
        14HFECNi1bjjVp3jlL82mzgEJBIVQFKM1uMHnP/u93T3aVmFe6tYIfHVKB48U4sWi+G8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hf4Kt-00088y-5x; Sun, 23 Jun 2019 17:23:19 +0200
Date:   Sun, 23 Jun 2019 17:23:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Phong Tran <tranmanphong@gmail.com>
Cc:     mark.rutland@arm.com, kstewart@linuxfoundation.org,
        songliubraving@fb.com, peterz@infradead.org, nsekhar@ti.com,
        ast@kernel.org, jolsa@redhat.com, netdev@vger.kernel.org,
        gerg@uclinux.org, lorenzo.pieralisi@arm.com, will@kernel.org,
        linux-samsung-soc@vger.kernel.org, daniel@iogearbox.net,
        festevam@gmail.com, gregory.clement@bootlin.com,
        allison@lohutok.net, linux@armlinux.org.uk, krzk@kernel.org,
        haojian.zhuang@gmail.com, bgolaszewski@baylibre.com,
        tony@atomide.com, mingo@redhat.com, linux-imx@nxp.com, yhs@fb.com,
        sebastian.hesselbarth@gmail.com, illusionist.neo@gmail.com,
        jason@lakedaemon.net, liviu.dudau@arm.com, s.hauer@pengutronix.de,
        acme@kernel.org, lkundrak@v3.sk, robert.jarzmik@free.fr,
        dmg@turingmachine.org, swinslow@gmail.com, namhyung@kernel.org,
        tglx@linutronix.de, linux-omap@vger.kernel.org,
        alexander.sverdlin@gmail.com, linux-arm-kernel@lists.infradead.org,
        info@metux.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, alexander.shishkin@linux.intel.com,
        hsweeten@visionengravers.com, kgene@kernel.org,
        kernel@pengutronix.de, sudeep.holla@arm.com, bpf@vger.kernel.org,
        shawnguo@kernel.org, kafai@fb.com, daniel@zonque.org
Subject: Re: [PATCH 10/15] ARM: orion5x: cleanup cppcheck shifting errors
Message-ID: <20190623152319.GD28942@lunn.ch>
References: <20190623151313.970-1-tranmanphong@gmail.com>
 <20190623151313.970-11-tranmanphong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190623151313.970-11-tranmanphong@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 23, 2019 at 10:13:08PM +0700, Phong Tran wrote:
> [arch/arm/mach-orion5x/pci.c:281]: (error) Shifting signed 32-bit value
> by 31 bits is undefined behaviour
> [arch/arm/mach-orion5x/pci.c:305]: (error) Shifting signed 32-bit value
> by 31 bits is undefined behaviour
> 
> Signed-off-by: Phong Tran <tranmanphong@gmail.com>

Maybe using the BIT() macro would be better, but this is O.K.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
