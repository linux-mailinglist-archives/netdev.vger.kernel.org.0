Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C86B18E94E
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 15:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgCVOIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 10:08:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50212 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgCVOIj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 10:08:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/gYOxpupD88wMd0YFCOuEya0uthdMDOWSDl9BR6hXgM=; b=UvsKUUN0c1Bstha/22trqWMeOt
        +l1WxkRfztCovV7VL3Efg68a9aibsOuKzXyYrIFe5enlWQXqxWnZPP8dj+WG3Of6O5WouTWd66A/s
        2UobSWScfF9AXJA4Z93tfuGOfaa010JZz6K55/hgTWwrZS6xZtD4xh5EBOOsf2+iYr48=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jG1HJ-0008Uq-0R; Sun, 22 Mar 2020 15:08:37 +0100
Date:   Sun, 22 Mar 2020 15:08:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] ethtool: remove XCVR_DUMMY entries
Message-ID: <20200322140837.GG11481@lunn.ch>
References: <44908ff8-22dd-254e-16f8-f45f64e8e98e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44908ff8-22dd-254e-16f8-f45f64e8e98e@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 22, 2020 at 02:14:20PM +0100, Heiner Kallweit wrote:
> The transceiver dummy entries are not used any longer, so remove them.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  include/uapi/linux/ethtool.h | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index d586ee5e1..77721ea36 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -1673,9 +1673,6 @@ static inline int ethtool_validate_duplex(__u8 duplex)
>  /* Which transceiver to use. */
>  #define XCVR_INTERNAL		0x00 /* PHY and MAC are in the same package */
>  #define XCVR_EXTERNAL		0x01 /* PHY and MAC are in different packages */
> -#define XCVR_DUMMY1		0x02
> -#define XCVR_DUMMY2		0x03
> -#define XCVR_DUMMY3		0x04

Hi Heiner

We need to be careful here. This is a UAPI header. The kernel might
not use them, but is there any user space code using them?

A quick search found:

http://www.infradead.org/~tgr/libnl/doc/api/ethtool_8c_source.html

	Andrew
