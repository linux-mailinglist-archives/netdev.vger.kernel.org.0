Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE183B5472
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 19:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbhF0RLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 13:11:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58938 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230315AbhF0RLK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Jun 2021 13:11:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=BIPBb1eADU51oD618Lk66HkmeKOn+NYYoIzPDDft1MY=; b=cBswgElmRUKx9UrR9KAsPnzBKH
        LNzDZZhMwqQwIWCwGj2mvtVvf+nk/bDwFVnsllM4E7FSo8zyhBvnK1zH/WZp25qFVhTqx6LTdTOy8
        ynczQCeeMuJKTYmDc+SaAFPNsWveFI5DSInoIsduYdVHJg3U779s3fU9bGUStm5tvndM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lxYGq-00BL0e-Fp; Sun, 27 Jun 2021 19:08:36 +0200
Date:   Sun, 27 Jun 2021 19:08:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Bauer <mail@david-bauer.net>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: at803x: mask 1000 Base-X link mode
Message-ID: <YNiwlHiNH7rVKpip@lunn.ch>
References: <20210627101607.79604-1-mail@david-bauer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210627101607.79604-1-mail@david-bauer.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 27, 2021 at 12:16:07PM +0200, David Bauer wrote:
> AR8031/AR8033 have different status registers for copper
> and fiber operation. However, the extended status register
> is the same for both operation modes.
> 
> As a result of that, ESTATUS_1000_XFULL is set to 1 even when
> operating in copper TP mode.
> 
> Remove this mode from the supported link modes, as this driver
> currently only supports copper operation.
> 
> Signed-off-by: David Bauer <mail@david-bauer.net>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
