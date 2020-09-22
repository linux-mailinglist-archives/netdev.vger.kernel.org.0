Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476E42737A4
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 02:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729406AbgIVAmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 20:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729113AbgIVAmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 20:42:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E785C061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 17:42:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6C56C1285B86C;
        Mon, 21 Sep 2020 17:25:19 -0700 (PDT)
Date:   Mon, 21 Sep 2020 17:42:06 -0700 (PDT)
Message-Id: <20200921.174206.1490580836119757887.davem@davemloft.net>
To:     vladimir.oltean@nxp.com
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, UNGLinuxDriver@microchip.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        kuba@kernel.org
Subject: Re: [PATCH net] net: mscc: ocelot: return error if VCAP filter is
 not found
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200922003913.siqemus3x3emjscd@skbuf>
References: <20200921233637.152646-1-vladimir.oltean@nxp.com>
        <20200921.173102.2069908741483449991.davem@davemloft.net>
        <20200922003913.siqemus3x3emjscd@skbuf>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 21 Sep 2020 17:25:19 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Tue, 22 Sep 2020 00:39:13 +0000

> On Mon, Sep 21, 2020 at 05:31:02PM -0700, David Miller wrote:
>> Please repost this with an appropriate Fixes: tag.
> 
> I shouldn't need to do that if you apply the patch using patchwork:
> 
> Fixes: b596229448dd ("net: mscc: ocelot: Add support for tcam")

Patchwork on ozlabs doesn't pick up Fixes: tags automatically.
