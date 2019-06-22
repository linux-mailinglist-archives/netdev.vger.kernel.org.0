Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3BDB4F677
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 17:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfFVPSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 11:18:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49146 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbfFVPSp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Jun 2019 11:18:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=109yTA8WVLcNXNY+uTfvlDNYMd4+6cA+EC1oJNs2Dvs=; b=WBzo0w5kOnoO5Z8D1feM2ynbSy
        8gQKNzqbS9ANpLpwY+2sd+LLv+zp4BRJgHlKrBn7BIylz1VvmEw78Yh7OQVUnmmJ2spgjpUR1bqqn
        W6sWLMpwoGKB+yXz+OAIsQw1fBiXMbxZ1DjRrEoDmbFKVt//rLOTfrtcK5E5Uz3IowYI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hehmp-0002fG-Ea; Sat, 22 Jun 2019 17:18:39 +0200
Date:   Sat, 22 Jun 2019 17:18:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 3/7] maintainers: declare aquantia atlantic
 driver maintenance
Message-ID: <20190622151839.GD8497@lunn.ch>
References: <cover.1561210852.git.igor.russkikh@aquantia.com>
 <83a97b48060f078beac0953cc6e8ced7112d03c1.1561210852.git.igor.russkikh@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83a97b48060f078beac0953cc6e8ced7112d03c1.1561210852.git.igor.russkikh@aquantia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 22, 2019 at 01:45:17PM +0000, Igor Russkikh wrote:
> Aquantia is resposible now for all new features and bugfixes.
> Reflect that in MAINTAINERS.
> 
> Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
> ---
>  MAINTAINERS | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0c55b0fedbe2..0f525f1a12dd 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1139,6 +1139,14 @@ L:	linux-media@vger.kernel.org
>  S:	Maintained
>  F:	drivers/media/i2c/aptina-pll.*
>  
> +AQUANTIA ETHERNET DRIVER (atlantic)
> +M:	Igor Russkikh <igor.russkikh@aquantia.com>
> +L:	netdev@vger.kernel.org
> +S:	Supported
> +W:	http://www.aquantia.com
> +Q:	http://patchwork.ozlabs.org/project/netdev/list/
> +F:	drivers/net/ethernet/aquantia/atlantic/

Please add a F: for the documentation you just added.

       Andrew
