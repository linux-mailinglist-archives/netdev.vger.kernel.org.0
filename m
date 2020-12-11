Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE4822D79AD
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 16:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391132AbgLKPno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 10:43:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390648AbgLKPnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 10:43:10 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B053C0613CF;
        Fri, 11 Dec 2020 07:42:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=sa9W2GR2/FvaisGRxGjDlKIsyl8dOna6JKJIFVWDh04=; b=kYFsqwhgoDlosmTk0n22+/hku
        8dRnzMrJBo1d5hyJLEzjem2Pk50sutkFl9I+lPc9b/13lvUxAMkj2kJv9rBwma8vC79Jf6TqJ5FgG
        QHMpZbSnEjswaQAS7XZu5C/D2J9LoKxUwQhfiNbt47Yw7D312HWhFLSCQ5JeCSQ9yDKQvIgzW/i/r
        f8WZYkX92ENmDhsbDoeCHrLRjVE33EjfEmtl2aTIDE7toJVp42IFZZwmrkIUKic7CIWTOORqRXG2h
        8Ftsfi3vtL07UquKhAScR3ppqsyBU+VzRmeN3YfQxRxvkUweWyTbP6PK67KUD3WzndduVW1jDtcq8
        z5PQsxkew==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42638)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1knkYo-000649-Gk; Fri, 11 Dec 2020 15:42:22 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1knkYm-00018z-Nb; Fri, 11 Dec 2020 15:42:20 +0000
Date:   Fri, 11 Dec 2020 15:42:20 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, mcroce@microsoft.com,
        sven.auhagen@voleatech.de, andrew@lunn.ch
Subject: Re: [PATCH] MAINTAINERS: add mvpp2 driver entry
Message-ID: <20201211154220.GX1551@shell.armlinux.org.uk>
References: <20201211144147.26023-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211144147.26023-1-mw@semihalf.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 03:41:47PM +0100, Marcin Wojtas wrote:
> Since its creation Marvell NIC driver for Armada 375/7k8k and
> CN913x SoC families mvpp2 has been lacking an entry in MAINTAINERS,
> which sometimes lead to unhandled bugs that persisted
> across several kernel releases.

Can you add me for this driver as well please?
Thanks.

> 
> Signed-off-by: Marcin Wojtas <mw@semihalf.com>
> ---
>  MAINTAINERS | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6f474153dbec..db88abf11db2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10513,6 +10513,13 @@ L:	netdev@vger.kernel.org
>  S:	Maintained
>  F:	drivers/net/ethernet/marvell/mvneta.*
>  
> +MARVELL MVPP2 ETHERNET DRIVER
> +M:	Marcin Wojtas <mw@semihalf.com>
> +L:	netdev@vger.kernel.org
> +S:	Maintained
> +F:	Documentation/devicetree/bindings/net/marvell-pp2.txt
> +F:	drivers/net/ethernet/marvell/mvpp2/
> +
>  MARVELL MWIFIEX WIRELESS DRIVER
>  M:	Amitkumar Karwar <amitkarwar@gmail.com>
>  M:	Ganapathi Bhat <ganapathi.bhat@nxp.com>
> -- 
> 2.29.0
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
