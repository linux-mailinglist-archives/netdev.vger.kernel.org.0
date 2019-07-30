Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78DA47A9CF
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 15:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731175AbfG3Nhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 09:37:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47702 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbfG3Nhc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 09:37:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=00RmNAb/n2jprPrBpuchRHXCWQrxaSH+iEhQsGGChHQ=; b=R6k+ycnNKgE5OySMmyghm7qtzB
        q6baP6N6VJ79n01ot2L8GBNgpbSjI/K9TDyQPrn0qRbCb0rN4K8Q87RAbExnm8NZNENDcUf/HxTin
        iromtqWPrtzQeU/vC3W541uk0s7roNGBnS3wIH/hRRDCTQLHDYn7LxafBRMznvT8wMpY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hsSJm-0007nG-Km; Tue, 30 Jul 2019 15:37:30 +0200
Date:   Tue, 30 Jul 2019 15:37:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hubert Feurstein <h.feurstein@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH 2/4] dt-bindings: net: dsa: marvell: add 6220 model to
 the 6250 family
Message-ID: <20190730133730.GF28552@lunn.ch>
References: <20190730100429.32479-1-h.feurstein@gmail.com>
 <20190730100429.32479-3-h.feurstein@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730100429.32479-3-h.feurstein@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 12:04:27PM +0200, Hubert Feurstein wrote:
> The MV88E6220 is part of the MV88E6250 family.
> 
> Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
