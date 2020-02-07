Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6B0C1555A9
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 11:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbgBGK2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 05:28:05 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40722 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbgBGK2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 05:28:04 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CB54D15A3287E;
        Fri,  7 Feb 2020 02:28:03 -0800 (PST)
Date:   Fri, 07 Feb 2020 11:28:02 +0100 (CET)
Message-Id: <20200207.112802.922838045824356286.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: bcm_sf2: Only 7278 supports 2Gb/sec IMP
 port
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200206192352.19939-1-f.fainelli@gmail.com>
References: <20200206192352.19939-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Feb 2020 02:28:04 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu,  6 Feb 2020 11:23:52 -0800

> The 7445 switch clocking profiles do not allow us to run the IMP port at
> 2Gb/sec in a way that it is reliable and consistent. Make sure that the
> setting is only applied to the 7278 family.
> 
> Fixes: 8f1880cbe8d0 ("net: dsa: bcm_sf2: Configure IMP port for 2Gb/sec")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Also applied and queued up for -stable.
