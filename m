Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFC8E1555A7
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 11:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgBGK2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 05:28:00 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40714 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbgBGK14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 05:27:56 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 102EF15A3287A;
        Fri,  7 Feb 2020 02:27:54 -0800 (PST)
Date:   Fri, 07 Feb 2020 11:27:53 +0100 (CET)
Message-Id: <20200207.112753.1998862108252137321.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: b53: Always use dev->vlan_enabled in
 b53_configure_vlan()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200206190745.24032-1-f.fainelli@gmail.com>
References: <20200206190745.24032-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Feb 2020 02:27:55 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu,  6 Feb 2020 11:07:45 -0800

> b53_configure_vlan() is called by the bcm_sf2 driver upon setup and
> indirectly through resume as well. During the initial setup, we are
> guaranteed that dev->vlan_enabled is false, so there is no change in
> behavior, however during suspend, we may have enabled VLANs before, so we
> do want to restore that setting.
> 
> Fixes: dad8d7c6452b ("net: dsa: b53: Properly account for VLAN filtering")
> Fixes: 967dd82ffc52 ("net: dsa: b53: Add support for Broadcom RoboSwitch")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied and queued up for -stable.
