Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5C03A5A13
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 20:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbhFMSqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 14:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbhFMSqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 14:46:18 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C95C061574;
        Sun, 13 Jun 2021 11:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=zd0ykvRTbEDpr2q2WgUG100JamY8WG7iW9Jws5t14Yc=; b=C0a5LoW6hFM+jmDI7Ejooc5Ot
        swqQSr8yHOXmKy6c7Hdu3ure1bUTpBsdVtyOJYtNCMjEjgsvWUjM+sVb1a9Eix/bytRECO+5uKYJd
        mGNQAHcp1aAgkjZkqWqwmOfOeKi0RdqHT7F18kp3MC5P69LFZIOI3TW399IGymE78osRTN4OeqqBq
        fBOyuQnwxEMCVv2F/xysisyiXK8Cd3ha3MRq78GZ1HdtEVKw3eT5y2EPoyngHB3MUsp1/dCBhoUdL
        lMldUTRynEcuIfB+RKVrPdkeEGKktKYXKqy8EIsl+xmcXeeoqIbeqbfB9XSZjlZVhk5IhRu+y+UF9
        luaNsTeZg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44982)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lsV5g-0003Zw-Ii; Sun, 13 Jun 2021 19:44:12 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lsV5d-0003OV-W4; Sun, 13 Jun 2021 19:44:10 +0100
Date:   Sun, 13 Jun 2021 19:44:09 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, jaz@semihalf.com,
        gjb@semihalf.com, upstream@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, jon@solid-run.com
Subject: Re: [net-next: PATCH 2/3] net: mvpp2: enable using phylink with ACPI
Message-ID: <20210613184409.GQ22278@shell.armlinux.org.uk>
References: <20210613183520.2247415-1-mw@semihalf.com>
 <20210613183520.2247415-3-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210613183520.2247415-3-mw@semihalf.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 13, 2021 at 08:35:19PM +0200, Marcin Wojtas wrote:
>  
>  	/* Phylink isn't used w/ ACPI as of now */
> -	if (port_node) {
> +	if (!mvpp2_use_acpi_compat_mode(port_fwnode)) {

Does this comment need to be updated?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
