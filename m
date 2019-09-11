Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 221B7AFEB7
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 16:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727659AbfIKO2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 10:28:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44070 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbfIKO2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 10:28:04 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 810C71543709D;
        Wed, 11 Sep 2019 07:28:02 -0700 (PDT)
Date:   Wed, 11 Sep 2019 16:28:01 +0200 (CEST)
Message-Id: <20190911.162801.1734673602480231321.davem@davemloft.net>
To:     alexandru.ardelean@analog.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@st.com
Subject: Re: [PATCH 1/2] net: stmmac: implement support for passive mode
 converters via dt
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190906130256.10321-1-alexandru.ardelean@analog.com>
References: <20190906130256.10321-1-alexandru.ardelean@analog.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Sep 2019 07:28:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Ardelean <alexandru.ardelean@analog.com>
Date: Fri, 6 Sep 2019 16:02:55 +0300

> In-between the MAC & PHY there can be a mode converter, which converts one
> mode to another (e.g. GMII-to-RGMII).
> 
> The converter, can be passive (i.e. no driver or OS/SW information
> required), so the MAC & PHY need to be configured differently.
> 
> For the `stmmac` driver, this is implemented via a `mac-mode` property in
> the device-tree, which configures the MAC into a certain mode, and for the
> PHY a `phy_interface` field will hold the mode of the PHY. The mode of the
> PHY will be passed to the PHY and from there-on it work in a different
> mode. If unspecified, the default `phy-mode` will be used for both.
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Applied to net-next.
