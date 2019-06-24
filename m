Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6494F50CC9
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 15:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731336AbfFXNzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 09:55:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53376 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728762AbfFXNzO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 09:55:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KptglKiorU95pwI/pjmagyuGLuNXr9MKuaB4FPPE9s8=; b=uJ0CROumKYnIINu/Kn05ZH0uoL
        GfiyAMb3GcFHu3H/GBB9sorrbrNTlWHcX79EvuuSUHHm3uJb0o6sXAEEY7hTrc/5+lwnEITziu049
        oGsn/V/hBpIdbBKKOY5yOnyy8MQTaUqCBiKrLW7orid9XoeakRedtH6uFFHTsz+8OVaY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hfPQV-0005Ig-9V; Mon, 24 Jun 2019 15:54:31 +0200
Date:   Mon, 24 Jun 2019 15:54:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Phong Tran <tranmanphong@gmail.com>
Cc:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        alexander.sverdlin@gmail.com, allison@lohutok.net, ast@kernel.org,
        bgolaszewski@baylibre.com, bpf@vger.kernel.org,
        daniel@iogearbox.net, daniel@zonque.org, dmg@turingmachine.org,
        festevam@gmail.com, gerg@uclinux.org, gregkh@linuxfoundation.org,
        gregory.clement@bootlin.com, haojian.zhuang@gmail.com,
        hsweeten@visionengravers.com, illusionist.neo@gmail.com,
        info@metux.net, jason@lakedaemon.net, jolsa@redhat.com,
        kafai@fb.com, kernel@pengutronix.de, kgene@kernel.org,
        krzk@kernel.org, kstewart@linuxfoundation.org,
        linux-arm-kernel@lists.infradead.org, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux@armlinux.org.uk,
        liviu.dudau@arm.com, lkundrak@v3.sk, lorenzo.pieralisi@arm.com,
        mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
        netdev@vger.kernel.org, nsekhar@ti.com, peterz@infradead.org,
        robert.jarzmik@free.fr, s.hauer@pengutronix.de,
        sebastian.hesselbarth@gmail.com, shawnguo@kernel.org,
        songliubraving@fb.com, sudeep.holla@arm.com, swinslow@gmail.com,
        tglx@linutronix.de, tony@atomide.com, will@kernel.org, yhs@fb.com
Subject: Re: [PATCH V2 10/15] ARM: orion5x: cleanup cppcheck shifting errors
Message-ID: <20190624135431.GO31306@lunn.ch>
References: <20190623151313.970-1-tranmanphong@gmail.com>
 <20190624135105.15579-1-tranmanphong@gmail.com>
 <20190624135105.15579-11-tranmanphong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624135105.15579-11-tranmanphong@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 08:51:00PM +0700, Phong Tran wrote:
> [arch/arm/mach-orion5x/pci.c:281]: (error) Shifting signed 32-bit value
> by 31 bits is undefined behaviour
> [arch/arm/mach-orion5x/pci.c:305]: (error) Shifting signed 32-bit value
> by 31 bits is undefined behaviour
> 
> Signed-off-by: Phong Tran <tranmanphong@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Thanks for swapping to the BIT macro.

       Andrew
