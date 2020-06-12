Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB9B1F71CA
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 03:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgFLBhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 21:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgFLBhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 21:37:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B33CC03E96F;
        Thu, 11 Jun 2020 18:37:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 44EDB128B1EE5;
        Thu, 11 Jun 2020 18:37:14 -0700 (PDT)
Date:   Thu, 11 Jun 2020 18:37:13 -0700 (PDT)
Message-Id: <20200611.183713.730561837842023766.davem@davemloft.net>
To:     heiko@sntech.de
Cc:     kuba@kernel.org, robh+dt@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        christoph.muellner@theobroma-systems.com,
        heiko.stuebner@theobroma-systems.com
Subject: Re: [PATCH v2 1/2] net: phy: mscc: move shared probe code into a
 helper
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200609133140.1421109-1-heiko@sntech.de>
References: <20200609133140.1421109-1-heiko@sntech.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 11 Jun 2020 18:37:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiko Stuebner <heiko@sntech.de>
Date: Tue,  9 Jun 2020 15:31:39 +0200

> From: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
> 
> The different probe functions share a lot of code, so move the
> common parts into a helper to reduce duplication.
> 
> Signed-off-by: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
> ---
> changes in v2:
> - new patch as suggested by Andrew

This doesn't apply without rejects to the net GIT tree.
