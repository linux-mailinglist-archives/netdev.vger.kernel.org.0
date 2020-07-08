Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A4E2193B2
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 00:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgGHWmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 18:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgGHWmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 18:42:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720C9C08C5CE;
        Wed,  8 Jul 2020 15:42:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 268451277ED6F;
        Wed,  8 Jul 2020 15:42:02 -0700 (PDT)
Date:   Wed, 08 Jul 2020 15:42:01 -0700 (PDT)
Message-Id: <20200708.154201.1555490900589438795.davem@davemloft.net>
To:     festevam@gmail.com
Cc:     dmurphy@ti.com, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] dt-bindings: dp83867: Fix the type of
 device
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200708212422.7599-1-festevam@gmail.com>
References: <20200708212422.7599-1-festevam@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jul 2020 15:42:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>
Date: Wed,  8 Jul 2020 18:24:21 -0300

> DP83867 is an Ethernet PHY, not a charger, so fix the documentation
> accordingly.
> 
> Fixes: 74ac28f16486 ("dt-bindings: dp83867: Convert DP83867 to yaml")
> Signed-off-by: Fabio Estevam <festevam@gmail.com>

Applied.
