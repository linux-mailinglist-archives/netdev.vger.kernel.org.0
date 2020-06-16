Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A151FA572
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 03:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgFPBM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 21:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726564AbgFPBM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 21:12:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BACC061A0E;
        Mon, 15 Jun 2020 18:12:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D78D91235822C;
        Mon, 15 Jun 2020 18:12:25 -0700 (PDT)
Date:   Mon, 15 Jun 2020 18:12:25 -0700 (PDT)
Message-Id: <20200615.181225.2016760272076151342.davem@davemloft.net>
To:     heiko@sntech.de
Cc:     kuba@kernel.org, robh+dt@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        christoph.muellner@theobroma-systems.com,
        heiko.stuebner@theobroma-systems.com
Subject: Re: [PATCH v3 1/3] net: phy: mscc: move shared probe code into a
 helper
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200615.181129.570239999533845176.davem@davemloft.net>
References: <20200615144501.1140870-1-heiko@sntech.de>
        <20200615.181129.570239999533845176.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Jun 2020 18:12:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, 15 Jun 2020 18:11:29 -0700 (PDT)

> Because you removed this devm_kzalloc() code, vsc8531 is never initialized.

You also need to provide a proper header posting when you repost this series
after fixing this bug.
