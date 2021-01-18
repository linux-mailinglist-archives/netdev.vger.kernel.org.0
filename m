Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE7002FA9A0
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 20:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436960AbhARTGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 14:06:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:42496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436982AbhARTFa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 14:05:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B536B206DB;
        Mon, 18 Jan 2021 19:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610996689;
        bh=9+tgcAZWEmg70qzEITqMi1j45XpETACfGzVyxvR4OQI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WcGz3zIPWgxUq6bck24uqrHjOOBFWq/YXm83upLH6W9pNOti0GJw1mJ9FKecze+L6
         3Znw1bkHCnFDzP696q3JiraVUeECAuXN/+ldxDZsYzVKOAg+3nDYgHD11HGfZ4JbZ7
         4DnVRzu+/64iLTWEnSRMrlkseW/DV/48ZWMocTJNnemxVFgsqMGzdtRsMibJRE3Tv7
         8yYBfruZEAafMZ2JUx/tufmINveGOo8MERPduYkoWc/vaN8sEskBwzbY7WRgHBZhe5
         mYY1kYMqCFJnIqUw7T9+VQu62U8fK8KUrKdWEYxl/7QTCWLHwC+0mL7KHu+d5HRV7w
         VxQprxr3Yhryw==
Date:   Mon, 18 Jan 2021 11:04:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: Re: [PATCH v2 net-next 01/14] net: mscc: ocelot: allow offloading
 of bridge on top of LAG
Message-ID: <20210118110447.3c31521a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210117123744.erw2i34oap5xkapo@skbuf>
References: <20210116005943.219479-1-olteanv@gmail.com>
        <20210116005943.219479-2-olteanv@gmail.com>
        <20210116172623.2277b86a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210117123744.erw2i34oap5xkapo@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 17 Jan 2021 14:37:44 +0200 Vladimir Oltean wrote:
> That being said, if we want to engage in a rigid demonstration of
> procedures, sure we can do that. I have other patches anyway to fill the
> pipeline until "net" is merged back into "net-next" :)

If you don't mind I'd rather apply the fix to net, and the rest on
Thu/Fri after the trees get merged.
