Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53D1F51E0C
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 00:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbfFXWQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 18:16:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55354 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbfFXWQW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 18:16:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hXKUM26mKmYZak0tnjE9HLJf54zw5bq0iKH7fXr/o48=; b=lKPUM9DZyGmqPhyOwLCfzRz9OI
        5YDpfckFPTBAwrzQ1Aq0qY0LojYdDrQNX+bUQtYHlQROyuyculgaTEKCfbtNCKSWjIGx3OjVIJ0rw
        uERtdYUJbkhMbzZPSVIMA9m03uz4Z61BRRrHswdokfVxdBze4LO3WxCY5sKuMlEzE+QU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hfXG8-000122-1H; Tue, 25 Jun 2019 00:16:20 +0200
Date:   Tue, 25 Jun 2019 00:16:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 3/8] maintainers: declare aquantia atlantic
 driver maintenance
Message-ID: <20190624221620.GF31306@lunn.ch>
References: <cover.1561388549.git.igor.russkikh@aquantia.com>
 <2b413d26ebc04cfca7f7dfa5422f1ea28d9cd76d.1561388549.git.igor.russkikh@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b413d26ebc04cfca7f7dfa5422f1ea28d9cd76d.1561388549.git.igor.russkikh@aquantia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 03:10:49PM +0000, Igor Russkikh wrote:
> Aquantia is resposible now for all new features and bugfixes.
> Reflect that in MAINTAINERS.
> 
> Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
