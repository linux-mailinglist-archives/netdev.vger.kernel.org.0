Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 050683091F3
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 06:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhA3FJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 00:09:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:39860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230114AbhA3FEs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 00:04:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DA5664DE7;
        Sat, 30 Jan 2021 05:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611983048;
        bh=+X/wqwC7kCIF1CPdD2uqsSbru5GobPbkF1Vf93d6khY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Lloam9rllbJwXoXarPW1BINgOQnvJ8uvlF4IJV67DyLItit1Hzng28gUIwdatrmfk
         Spp4plYLZvgUON93gxHd7HFvBNTUCVYrIoiXkYbK9mTt4esEzmxHPRAKPze+AsmOdw
         2yILD6uBdK7gOx1/Bstty774cNrCQ9KPxgM+lnf8P+pOB3Vh7DKcFnJmdkqFLQUrh1
         9JeRfbmjIKKlh3HjFNtUTnehylca26R5dv9GJpKrG3J+7TRuBKqON/WX68LhFKCYu9
         t3LpKFpqowsxg1qt9KxNO8pWnPpibXRiaQcYNPMq5vnMr68zzeRtN2yPz9Tg38QhYV
         496e5VpLWPq7Q==
Date:   Fri, 29 Jan 2021 21:04:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: hellcreek: Add missing TAPRIO
 dependency
Message-ID: <20210129210407.674bc187@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1a076f95-3945-c300-4fea-22d28205aef6@infradead.org>
References: <20210128163338.22665-1-kurt@linutronix.de>
        <1a076f95-3945-c300-4fea-22d28205aef6@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jan 2021 12:00:38 -0800 Randy Dunlap wrote:
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

nit: careful with the tags in replies to patches, patchwork will add
     them onto the patch you're replying to
