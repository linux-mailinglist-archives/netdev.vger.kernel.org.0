Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 869C19EA2D
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 15:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729746AbfH0Ny7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 09:54:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34554 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726170AbfH0Ny6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 09:54:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=gL3hrT1kW+RGeTJIoTm8QRjfCrHyCr2PtMwLOY5wg+w=; b=cmbC/ds4Ht+UeTmC2kR8ZjCn0j
        lJNRNz6I5MO6e1JNXGn+rS8kX3iuS9XJ0LRVMzfeoeUIz41wGvxk9ewBak3xYEIdX8/M3q1IfyUzN
        7Gk2CGCHu+5MJQMDt4cskHShFln1Y7vChh02YNrXEvSftUFWgCXV29LVphPvye71cX+A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i2bw0-0003dU-7A; Tue, 27 Aug 2019 15:54:56 +0200
Date:   Tue, 27 Aug 2019 15:54:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v5 4/6] net: dsa: mv88e6xxx: simplify SERDES
 code for Topaz and Peridot
Message-ID: <20190827135456.GM2168@lunn.ch>
References: <20190826213155.14685-1-marek.behun@nic.cz>
 <20190826213155.14685-5-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190826213155.14685-5-marek.behun@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 26, 2019 at 11:31:53PM +0200, Marek Behún wrote:
> By adding an additional serdes_get_lane implementation (for Topaz), we
> can merge the implementations of other SERDES functions (powering and
> IRQs). We can skip checking port numbers, since the serdes_get_lane()
> methods inform if there is no lane on a port or if the lane cannot be
> used for given cmode.
> 
> Signed-off-by: Marek Behún <marek.behun@nic.cz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
