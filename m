Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94FC62A3614
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 22:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgKBVhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 16:37:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:58140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725833AbgKBVhw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 16:37:52 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C33421534;
        Mon,  2 Nov 2020 21:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604353072;
        bh=iiR3P7UV2uVRCUE8wz2oWTALo+XwO7DQLLymYE/bCuY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CS3ctc/1Gp/rM9dq3KwpTk0Q3WSsydg5Vu0QY8Tf1OOZhDZWEpZ2qF1TVlZXcBW1T
         Q1v2UYPVPf9K0pTlU91aSEMbJQ6eaRTVlfmHo2O24hG6AIwGQa4EMfopyj9Qrv0A6K
         b3DSy17+W9cT8FTyQ52LHqyIGkE/10PZx4q6FvPk=
Date:   Mon, 2 Nov 2020 13:37:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/5] net: make ip_tunnel_get_stats64 an alias
 for dev_get_tstats64
Message-ID: <20201102133750.0d981073@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <944fa7d0-9b0e-5ae2-d4f8-9c609f1a7c20@gmail.com>
References: <25c7e008-c3fb-9fcd-f518-5d36e181c0cb@gmail.com>
        <944fa7d0-9b0e-5ae2-d4f8-9c609f1a7c20@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 1 Nov 2020 13:35:14 +0100 Heiner Kallweit wrote:
> ip_tunnel_get_stats64() now is a duplicate of dev_get_tstats64().
> Make it an alias so that we don't have to change all users of
> ip_tunnel_get_stats64().

Why would we not change all the users?  It's just an ndo pointer.
