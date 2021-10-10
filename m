Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874A0428153
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 14:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbhJJMoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 08:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbhJJMop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 08:44:45 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0734C061570;
        Sun, 10 Oct 2021 05:42:46 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id d3so28519264edp.3;
        Sun, 10 Oct 2021 05:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zdYDq5Av5B7eWPDldarPUoIQ+FE7KvPbOZ75x5f48u8=;
        b=iosWXV76ux8Lx47OQTWIQSmyuQhNIXwUhf2iVz+7lt+NOXF+tR6+LMcGFgQWm11IrI
         SZY4KcCbbkxuywJVFynqD69FBBMoz2dfOEtkgUC4DrV0HbFkXreEPQdpT3YLD2TS/X9A
         daR6BtCTWIm5tnvAwz2PeI8jWkbkXjmxRWIS6HISznKZQ+wJXTDZK4/kJc4qBMDiF/N1
         GkIK75ujCyS4EDTwMfcA8B3rde3YoKLG1flRb+RX9ydnlkcHDO+JnpCCRMaLx3y3xYAd
         IShD2qbOrG+u2Cbj19JoR9XebISCfWC4+nUBnmRdZKjaznJyPSsg8WzaMzQUVMqY7vfw
         OMDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zdYDq5Av5B7eWPDldarPUoIQ+FE7KvPbOZ75x5f48u8=;
        b=BuzjlkAglIMf8NtCOtwisiOBL5tF7ufWbopBjKblI3eYk+pFaHJdquklIv+i6zUIKm
         W6fwcE8oQruxVSNjzIxOKP0lPzYxbMD7vHklPOh1B92WDmACrrIdZMu/UV1kKazFJp8n
         XE1i1WlQLaRWeNrWT2VIeNblMfrCel0npGlVbWlZlQCScoqiBO9RYuDoA3QQ8logUKMn
         3cnKGWtVynNvABYD9i3DT8yXZl07gx9hef+tKu3gnkESpiNoUEMgJk1AamdMVPXJUKD0
         HXn48mEdyQDxQPPN+YBo4ajhx9JO2miUxcnyghN7StHi6w0Cvbbjpu0efxSebjM8M2is
         Muog==
X-Gm-Message-State: AOAM531lzDLJL+Oorvnsigs1P5+0uGqCZKg4iCjzIjOvWv+d0Efqla4i
        bbF1BrOK0sEBPteS+HWrK5k=
X-Google-Smtp-Source: ABdhPJzhxGTjGg72y79BWT9rA9b3OzkPVDzgHtCiMyMSayiGmbd5zLfmr1j4JQeaSmoXfiFH+LWbQg==
X-Received: by 2002:a05:6402:2553:: with SMTP id l19mr32090121edb.321.1633869765338;
        Sun, 10 Oct 2021 05:42:45 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id e22sm2561199edu.35.2021.10.10.05.42.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 05:42:45 -0700 (PDT)
Date:   Sun, 10 Oct 2021 15:42:43 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan McDowell <noodles@earth.li>
Subject: Re: [net-next PATCH v4 04/13] drivers: net: dsa: qca8k: add support
 for cpu port 6
Message-ID: <20211010124243.lhbh46pkwribztrl@skbuf>
References: <20211010111556.30447-1-ansuelsmth@gmail.com>
 <20211010111556.30447-5-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211010111556.30447-5-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 10, 2021 at 01:15:47PM +0200, Ansuel Smith wrote:
> Currently CPU port is always hardcoded to port 0. This switch have 2 CPU
> port. The original intention of this driver seems to be use the
> mac06_exchange bit to swap MAC0 with MAC6 in the strange configuration
> where device have connected only the CPU port 6. To skip the
> introduction of a new binding, rework the driver to address the
> secondary CPU port as primary and drop any reference of hardcoded port.
> With configuration of mac06 exchange, just skip the definition of port0
> and define the CPU port as a secondary. The driver will autoconfigure
> the switch to use that as the primary CPU port.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---

Does this really work? What about GLOBAL_FW_CTRL0 bit 10 (CPU_PORT_EN),
which this patch leaves alone, and whose description is:
0 = No CPU connect to switch
1 = CPU is connected to port0
If this bit is set to 1, HEAD_EN of MAC0 is set to 1

I see all of PORT0_HEADER_CTRL - PORT6_HEADER_CTRL have the option of
setting RX_HEADER_MODE and TX_HEADER_MODE.
I just have this doubt: what is port 0 supposed to do when the CPU port
is port 6? Can it be used as a regular user port, attached to an RGMII PHY?

Isn't that use case broken anyway, due to qca8k.c's broken
interpretation of RGMII delay device tree bindings (it always applies
RGMII delays on "rgmii-id", and the PHY will apply them too)?

If I were to trust the documentation, that DSA headers are enabled on
port 0 when the driver does this:

	/* Enable CPU Port */
	ret = qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
			    QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);

doesn't that mean that using port 0 as a user port is double-broken,
since this would implicitly enable DSA headers on it?

Or is the idea of using port 6 as the CPU port to be able to use SGMII,
which is not available on port 0? Jonathan McDowell did some SGMII
configuration for the CPU port in commit f6dadd559886 ("net: dsa: qca8k:
Improve SGMII interface handling"). If the driver supports only port 0
as CPU port, and SGMII is only available on port 6, how did he do it?

On the boards that you have with port 6 as CPU port, what is port 0 used
for? Can port 0 and 6 be CPU ports simultaneously?

I also want to understand what's the use case of this port swap. In the
QCA8337 block diagram I see a dotted-line connection between Port 0 and
the SerDes, presumably this is due to the port swap. But I don't see any
dotted line between the Port 6 and the first GMII/RGMII/MII/RMII MAC.
So what will happen to what software believes is port 6, with the swap
in place?
