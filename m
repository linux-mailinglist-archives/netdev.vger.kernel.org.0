Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC5D27379F
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 02:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729370AbgIVAlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 20:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729332AbgIVAlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 20:41:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD9FC0613CF
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 17:41:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B02961285B867;
        Mon, 21 Sep 2020 17:24:19 -0700 (PDT)
Date:   Mon, 21 Sep 2020 17:41:06 -0700 (PDT)
Message-Id: <20200921.174106.690680814827980871.davem@davemloft.net>
To:     vladimir.oltean@nxp.com
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, UNGLinuxDriver@microchip.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        kuba@kernel.org
Subject: Re: [PATCH net 0/3] Fix broken tc-flower rules for mscc_ocelot
 switches
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200921225638.114962-1-vladimir.oltean@nxp.com>
References: <20200921225638.114962-1-vladimir.oltean@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 21 Sep 2020 17:24:20 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Tue, 22 Sep 2020 01:56:35 +0300

> All 3 switch drivers from the Ocelot family have the same bug in the
> VCAP IS2 key offsets, which is that some keys are in the incorrect
> order.

Series applied, thank you.
