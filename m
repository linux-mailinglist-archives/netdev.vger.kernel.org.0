Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC0A3A59A1
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 18:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbhFMQj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 12:39:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33692 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231839AbhFMQj1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Jun 2021 12:39:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=lzS35IciFKB4/B8HJ5TI6FUVS7HO0yOu7Pa8uz1GnDo=; b=NvVR+l5Xd1T+2nMSzpN0a0qJli
        TBI9RoNdDG/iYrGxEts+3aUBNcYXzb+81wqV22OuU/ReGc+w3KRzQZ/KMpSb94xSMnTnWP4fI9h25
        1FFqHDCVkX0ox60bp6CP7HwXT1UvMlvd0krUpHD7c7Sr5Wi7jF/bUa5Wk6qTymOHJbU8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lsT6v-009B7K-LD; Sun, 13 Jun 2021 18:37:21 +0200
Date:   Sun, 13 Jun 2021 18:37:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Colin King <colin.king@canonical.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: micrel: remove redundant assignment to pointer
 of_node
Message-ID: <YMY0QZrxoarKSgkR@lunn.ch>
References: <20210613132740.73854-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210613132740.73854-1-colin.king@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 13, 2021 at 02:27:40PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The pointer of_node is being initialized with a value that is never
> read and it is being updated later with a new value inside a do-while
> loop. The initialization is redundant and can be removed and the
> pointer dev is no longer required and can be removed too.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
