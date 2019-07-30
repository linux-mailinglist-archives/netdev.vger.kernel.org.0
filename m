Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C51EE7A9DD
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 15:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731049AbfG3Nk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 09:40:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47718 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbfG3Nk1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 09:40:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xsKlSPUt+t96WucanLpGm9pacti1+sht3mOBu0RWlQA=; b=gyEVyutDm2h4yhQsFDfJ0ZuIXr
        VckIH+k6gRtRnIsSUyQPK0fxfX+8khySimgKNELznCEqvgzjIyOFGAp/ej3bjzNgud/jdB+ki4y/V
        EBt/0fgRQNNozFaIlwA/c2X6kWqpgsoOKfuyiRop50S+I9Rasx9+o/T9xRl+j9MJTF2Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hsSMb-0007pv-AW; Tue, 30 Jul 2019 15:40:25 +0200
Date:   Tue, 30 Jul 2019 15:40:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hubert Feurstein <h.feurstein@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH 3/4] net: dsa: mv88e6xxx: setup message port is not
 supported in the 6250 family
Message-ID: <20190730134025.GG28552@lunn.ch>
References: <20190730100429.32479-1-h.feurstein@gmail.com>
 <20190730100429.32479-4-h.feurstein@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730100429.32479-4-h.feurstein@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 12:04:28PM +0200, Hubert Feurstein wrote:
> The MV88E6250 family doesn't support the MV88E6XXX_PORT_CTL1_MESSAGE_PORT
> bit.
> 
> Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
