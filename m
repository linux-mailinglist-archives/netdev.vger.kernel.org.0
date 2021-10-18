Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33AED432501
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 19:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234117AbhJRRaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 13:30:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234099AbhJRRaH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 13:30:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50DF561077;
        Mon, 18 Oct 2021 17:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634578075;
        bh=Bsrx7g92tYLygYaWvgBumvWoPy04BmyJB9LZTCvOM18=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=seIYQL5uL8PPzuTaOW4/RHE62JKmI6k72bsGcR5TYnoJl68cM0Ot/evAuoX3UlV4C
         HkPgxGxDFolW5e0FOFCTFeLJoPfxrq3XnwEFsUTzy8p5lZELAJ9yZbaw+vWCEEklRm
         iNmSMop9UOkCinkg0ozyB4EqI8t/vqkn56oG6Uz2nlG0ETn2KHQmlfE1VLeTd15/4O
         /hl19OooHsSkM5IDwSTztxJrAoNEkcK8rnrlDH5nDiRcf2eo7W+MmfMC6fzNuai0E2
         IVRyVSr6Z76dtBluKJZe7RNCQIrn+UEiGdcJlUM1n1S8EMzGGcnwwj1Znof4ckhUSz
         UwrkCfDaZGV3w==
Date:   Mon, 18 Oct 2021 10:27:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     f.fainelli@gmail.com, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        christophe.leroy@csgroup.eu, Stefan Agner <stefan@agner.ch>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] phy: micrel: ksz8041nl: do not use power down
 mode
Message-ID: <20211018102754.5b097ae4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211018171621.GC7669@francesco-nb.int.toradex.com>
References: <20211018094256.70096-1-francesco.dolcini@toradex.com>
        <20211018095249.1219ddaf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211018171621.GC7669@francesco-nb.int.toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Oct 2021 19:16:21 +0200 Francesco Dolcini wrote:
> > Fixes: 1a5465f5d6a2 ("phy/micrel: Add suspend/resume support to Micrel PHYs")  
> The errata is from 2016, while this commit is from 2013, weird?
> Apart of that I can add the Fixes tag, should we send this also to stable?

I'd lean towards sending it to stable, yes.

> > Should we leave a comment in place of the callbacks referring 
> > to the errata?  
> I think is a good idea, I'll add it.
