Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5473471BD5
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 18:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhLLRQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 12:16:06 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51472 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229787AbhLLRQG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Dec 2021 12:16:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1wo9ue0IPBBD9tqcmN+31xcYEpmU6Z8Yl7/UZXFocCs=; b=LOrbySGP6a7jKSBcFzqy3JImEF
        IUvqRIfzzf381LtUoQiW5swFTNAjBg61uXgIfA1xNKHx8osJ+48xGhAu2sUIYY2gbEOUk7dc543iM
        B0k8uazBifJugzylTKLVuG19KxjODtIO71PGmSNtLM5qnyq0ENE+3sh7UG9eI0RLXKas=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mwSRx-00GKjU-CP; Sun, 12 Dec 2021 18:15:49 +0100
Date:   Sun, 12 Dec 2021 18:15:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joseph CHANG <josright123@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, joseph_chang@davicom.com.tw,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4, 0/2] ADD DM9051 ETHERNET DRIVER
Message-ID: <YbYuRcrW6QdIkzmM@lunn.ch>
References: <20211212104604.20334-1-josright123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211212104604.20334-1-josright123@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 12, 2021 at 06:46:02PM +0800, Joseph CHANG wrote:
> DM9051 is a spi interface ethernet controller chip
> Fewer connect pins to CPU compare to DM9000
 
Please include in the cover letter what has changed since the previous
version.

I see you have not removed the wrappers, nor swapped to phylib.

  Andrew
