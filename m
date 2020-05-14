Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE971D3FEB
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 23:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728319AbgENVYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 17:24:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33110 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728273AbgENVYK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 17:24:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dadKmYTY4fPbUdE69+bZsNy1n7tYrQl+77NAdRoAVUU=; b=XXEYG+RCgaNtZ2AiOlSnhZXYz2
        37uXfX7Jf5W1zcZigOwbQcBchYHDUbxnsahaxIzhufuFWAbg4LL82paY0TJ65F6YmgcV3xMkoL9Fx
        aPtqIvCp8HIVgntLwL2rKE8tENGtTTBqttxwbJI2zn+QifulynbebHcKjP5BG61XYvDE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jZLKq-002KbS-AN; Thu, 14 May 2020 23:24:08 +0200
Date:   Thu, 14 May 2020 23:24:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Add Jakub to networking drivers.
Message-ID: <20200514212408.GC499265@lunn.ch>
References: <20200514.131403.168568797789507233.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514.131403.168568797789507233.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 01:14:03PM -0700, David Miller wrote:
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
> 
> Honestly this is just a formality as NETWORKING general is
> a superset of this.
> 
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 391e7eea6a3e..4b270dbdf09b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11718,6 +11718,7 @@ F:	net/core/drop_monitor.c
>  
>  NETWORKING DRIVERS
>  M:	"David S. Miller" <davem@davemloft.net>
> +M:	Jakub Kicinski <kuba@kernel.org>
>  L:	netdev@vger.kernel.org
>  S:	Odd Fixes

Now there are two of you, do you think you can do a bit better than
Odd Fixes?

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
