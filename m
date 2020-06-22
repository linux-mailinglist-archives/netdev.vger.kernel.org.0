Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F548204464
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 01:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731186AbgFVXYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 19:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727061AbgFVXYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 19:24:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB87C061573;
        Mon, 22 Jun 2020 16:24:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DF175129714E8;
        Mon, 22 Jun 2020 16:24:30 -0700 (PDT)
Date:   Mon, 22 Jun 2020 16:24:29 -0700 (PDT)
Message-Id: <20200622.162429.585862651883881701.davem@davemloft.net>
To:     martin.blumenstingl@googlemail.com
Cc:     netdev@vger.kernel.org, linux-amlogic@lists.infradead.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/2] prepare dwmac-meson8b for G12A specific
 initialization
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200620192641.175754-1-martin.blumenstingl@googlemail.com>
References: <20200620192641.175754-1-martin.blumenstingl@googlemail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jun 2020 16:24:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Sat, 20 Jun 2020 21:26:39 +0200

> Some users are reporting that RGMII (and sometimes also RMII) Ethernet
> is not working for them on G12A/G12B/SM1 boards. Upon closer inspection
> of the vendor code for these SoCs new register bits are found.
> 
> It's not clear yet how these registers work. Add a new compatible string
> as the first preparation step to improve Ethernet support on these SoCs.

Series applied to net-next, thanks Martin.
