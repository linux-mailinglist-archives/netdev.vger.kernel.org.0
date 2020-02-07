Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93D2C155947
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 15:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbgBGO0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 09:26:21 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43020 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726936AbgBGO0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 09:26:20 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 922CF15AD71D9;
        Fri,  7 Feb 2020 06:26:18 -0800 (PST)
Date:   Fri, 07 Feb 2020 15:26:12 +0100 (CET)
Message-Id: <20200207.152612.4277694123629112.davem@davemloft.net>
To:     Codrin.Ciubotariu@microchip.com
Cc:     andrew@lunn.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Woojung.Huh@microchip.com,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, razvan.stefanescu@microchip.com
Subject: Re: [PATCH v2] net: dsa: microchip: enable module autoprobe
From:   David Miller <davem@davemloft.net>
In-Reply-To: <479af7b8-fc94-2d01-744f-b93ed31388ce@microchip.com>
References: <20200207104643.1049-1-codrin.ciubotariu@microchip.com>
        <20200207133214.GB14393@lunn.ch>
        <479af7b8-fc94-2d01-744f-b93ed31388ce@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Feb 2020 06:26:20 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <Codrin.Ciubotariu@microchip.com>
Date: Fri, 7 Feb 2020 14:21:32 +0000

> I thought about it, but I wasn't sure this patch is a fix.  And now that 
> it includes aliases for all the variants, it might be tricky to add a 
> Fixes tag since not all the variants were added at the same time. But I 
> can split it into multiple patches, each with its Fixes, if you want me to.

You can put multiple Fixes: tags into a single patch and that would work
for this situation.

Please do that.

Thank you.
