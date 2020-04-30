Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E80B1C0642
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 21:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgD3TX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 15:23:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34798 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726437AbgD3TX5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 15:23:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HRyo+xAYHrJYwANtD58RqMtQm6dEr2Op0wfpZO+V86s=; b=OU3XafEnMVhSKE4ZAuGeaPxbhy
        ctmZj7cvIkjFbrjh+NHaHt3URwEqe+GokBcs76jFB85C3uuUO2S5exCF/K1L/Ui930l48wpnXx9RY
        VtUj3Rtk2ArVs4pyFB1428dhbJhJIDMCJAjVftSkW4ciF1SLt+ihJz+kj7W9wRatLCa8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jUEmo-000SCe-RI; Thu, 30 Apr 2020 21:23:54 +0200
Date:   Thu, 30 Apr 2020 21:23:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH net-next 3/4] net: dsa: b53: Bound check ARL searches
Message-ID: <20200430192354.GD107658@lunn.ch>
References: <20200430184911.29660-1-f.fainelli@gmail.com>
 <20200430184911.29660-4-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430184911.29660-4-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 11:49:10AM -0700, Florian Fainelli wrote:
> ARL searches are done by reading two ARL entries at a time, do not cap
> the search at 1024 which would only limit us to half of the possible ARL
> capacity, but use b53_max_arl_entries() instead which does the right
> multiplication between bins and indexes.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
