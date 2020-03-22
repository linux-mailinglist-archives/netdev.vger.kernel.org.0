Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7A3518E926
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 14:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgCVNcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 09:32:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50160 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbgCVNcR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 09:32:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Uqkjdi1Il5dKCpnHj9E5UVPNDlUi2SUTAgMlZK52PvA=; b=Vrm8IAeaYkQ+RgnhRGiGTfGP7Z
        ijKzRHh/9CspS0aEzQGJeciyvlh8iG6dMTbu4jejuJj5Tywta4cwo9nDE0G1KS5NXzYaSZX1lMCRK
        EvzNGIQLv6410/9Of/x5feRs3xNqmjaiiGrxWFR/BsEr7pV/gFdJANVyeRgRiecU8i98=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jG0i3-0008Lj-L5; Sun, 22 Mar 2020 14:32:11 +0100
Date:   Sun, 22 Mar 2020 14:32:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux-usb@vger.kernel.org
Subject: Re: [PATCH v3 2/2] net: phy: add marvell usb to mdio controller
Message-ID: <20200322133211.GB11481@lunn.ch>
References: <20200321202443.15352-1-tobias@waldekranz.com>
 <20200321202443.15352-2-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200321202443.15352-2-tobias@waldekranz.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 21, 2020 at 09:24:43PM +0100, Tobias Waldekranz wrote:
> An MDIO controller present on development boards for Marvell switches
> from the Link Street (88E6xxx) family.
> 
> Using this module, you can use the following setup as a development
> platform for switchdev and DSA related work.
> 
>    .-------.      .-----------------.
>    |      USB----USB                |
>    |  SoC  |      |  88E6390X-DB  ETH1-10
>    |      ETH----ETH0               |
>    '-------'      '-----------------'
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
