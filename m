Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2461C05F7
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 21:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgD3TLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 15:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgD3TLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 15:11:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADEDC035494;
        Thu, 30 Apr 2020 12:11:36 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 800CD1288B368;
        Thu, 30 Apr 2020 12:11:35 -0700 (PDT)
Date:   Thu, 30 Apr 2020 12:11:34 -0700 (PDT)
Message-Id: <20200430.121134.1918989045654491820.davem@davemloft.net>
To:     robert.marko@sartura.hr
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, agross@kernel.org,
        bjorn.andersson@linaro.org, robh+dt@kernel.org,
        mark.rutland@arm.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v5 0/3] net: phy: mdio: add IPQ40xx MDIO
 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200430090707.24810-1-robert.marko@sartura.hr>
References: <20200430090707.24810-1-robert.marko@sartura.hr>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 12:11:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert Marko <robert.marko@sartura.hr>
Date: Thu, 30 Apr 2020 11:07:04 +0200

> This patch series provides support for the IPQ40xx built-in MDIO interface.
> Included are driver, devicetree bindings for it and devicetree node.

Series applied, thanks.
