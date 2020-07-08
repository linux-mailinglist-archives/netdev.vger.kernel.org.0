Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1C42193B3
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 00:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgGHWni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 18:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgGHWmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 18:42:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09EFEC08C5DC;
        Wed,  8 Jul 2020 15:42:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A1CE51277ED6F;
        Wed,  8 Jul 2020 15:42:06 -0700 (PDT)
Date:   Wed, 08 Jul 2020 15:42:06 -0700 (PDT)
Message-Id: <20200708.154206.1827082065636639374.davem@davemloft.net>
To:     festevam@gmail.com
Cc:     dmurphy@ti.com, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] dt-bindings: dp83869: Fix the type of
 device
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200708212422.7599-2-festevam@gmail.com>
References: <20200708212422.7599-1-festevam@gmail.com>
        <20200708212422.7599-2-festevam@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jul 2020 15:42:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>
Date: Wed,  8 Jul 2020 18:24:22 -0300

> DP83869 is an Ethernet PHY, not a charger, so fix the documentation
> accordingly.
> 
> Fixes: 4d66c56f7efe ("dt-bindings: net: dp83869: Add TI dp83869 phy")
> Signed-off-by: Fabio Estevam <festevam@gmail.com>

Applied.
