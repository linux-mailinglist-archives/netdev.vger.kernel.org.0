Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B2D2A362B
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 22:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725818AbgKBV4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 16:56:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:49162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbgKBV4N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 16:56:13 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07A90206DD;
        Mon,  2 Nov 2020 21:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604354172;
        bh=6pLmQUeoLLKvPZ5XHWudQ87LKJoC5GeJq60MxQQXTuc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=L2xwKRhdQ5/hbt26AxQNYEaA4JkZPgwXN2hdhksLLJDY+T50wXDPchAzK4xzx4U9q
         Hrz/G0g57GCc1lYM2D8FKz1b/uLEc7ZQ2RfL0QylI7/H/LH9d0a7Sb4fv7Z37Pet6o
         YUCNTydVQY5t13ypd6jYtnh9YnDquMvQzNQ2t9/4=
Message-ID: <74b5588360920da299353fb5071b852b952c41f2.camel@kernel.org>
Subject: Re: [PATCH net-next 2/5] net: make ip_tunnel_get_stats64 an alias
 for dev_get_tstats64
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Mon, 02 Nov 2020 13:56:11 -0800
In-Reply-To: <20201102133750.0d981073@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <25c7e008-c3fb-9fcd-f518-5d36e181c0cb@gmail.com>
         <944fa7d0-9b0e-5ae2-d4f8-9c609f1a7c20@gmail.com>
         <20201102133750.0d981073@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-11-02 at 13:37 -0800, Jakub Kicinski wrote:
> On Sun, 1 Nov 2020 13:35:14 +0100 Heiner Kallweit wrote:
> > ip_tunnel_get_stats64() now is a duplicate of dev_get_tstats64().
> > Make it an alias so that we don't have to change all users of
> > ip_tunnel_get_stats64().
> 
> Why would we not change all the users?  It's just an ndo pointer.

+1.

