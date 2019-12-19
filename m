Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC89C126F10
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 21:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbfLSUmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 15:42:05 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33936 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726982AbfLSUmE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 15:42:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vRZGUWjww/OXr4jwmLxiwVW+WujZFrynvml8tZlH584=; b=4yWqtv6o0APPl+XO29VtLOh7iO
        mdAUd3QgSPZHCpldTF8ckMTqRO2IxBgabTfhkB40rnOrkg0NdMYIZV77lb/uAPlrhju8nXsef/Nka
        JFiSG7FqOoCHLd1ypzr1gxhFl34IjI8DDrBn5sYAC882PSUY2Pk3sAD+erxPiaUgKnz8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ii2cU-0005eM-D7; Thu, 19 Dec 2019 21:42:02 +0100
Date:   Thu, 19 Dec 2019 21:42:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kernel@pengutronix.de
Subject: Re: [PATCH] net: dsa: ksz: use common define for tag len
Message-ID: <20191219204202.GO17475@lunn.ch>
References: <20191218160139.26972-1-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218160139.26972-1-m.grzeschik@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 05:01:39PM +0100, Michael Grzeschik wrote:
> Remove special taglen define KSZ8795_INGRESS_TAG_LEN
> and use generic KSZ_INGRESS_TAG_LEN instead.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
