Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F6B3A7E2D
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 14:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbhFOM3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 08:29:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37496 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229520AbhFOM3u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 08:29:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=VXMxEukoEPoRi7lLZolXc745OPEEECBiwMa7K6XCRqw=; b=MU7o8Ot+VrGP6B/Q+Cuo6j95FJ
        DOszMHMVZl3M50Wpjg4Gk/Gtnm2n6HcJ22ymaAWGCsNSVNrgoSjB5h5Z1SfdYgR4iQECFkBQ2VYvs
        YcixKR/RLpkwszr/SMG6Y9Pu+1Z0a+8McCo8zIZYzqral/4AcEUg+TXvQnCh98tbPJPQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lt8AN-009Vdp-14; Tue, 15 Jun 2021 14:27:39 +0200
Date:   Tue, 15 Jun 2021 14:27:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     David Miller <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "frieder.schrempf@kontron.de" <frieder.schrempf@kontron.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 net-next 0/2] net: fec: fix TX bandwidth fluctuations
Message-ID: <YMicuzWwAKz5ffWB@lunn.ch>
References: <20210611095005.3909-1-qiangqing.zhang@nxp.com>
 <20210611.132514.1451796354248475314.davem@davemloft.net>
 <DB8PR04MB679518CF771FEBE118E395A3E6309@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB679518CF771FEBE118E395A3E6309@DB8PR04MB6795.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I can't reproduce these warnings with " make ARCH=arm64 allmodconfig", could you please show me the command you used? Thanks.

Try adding W=1

    Andrew
