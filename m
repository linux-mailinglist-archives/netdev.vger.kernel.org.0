Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A45064C568
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 10:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237531AbiLNJAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 04:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237856AbiLNJAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 04:00:48 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F258262C1
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 01:00:45 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id E6C2B19FE;
        Wed, 14 Dec 2022 10:00:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1671008444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+wd7ratQfAEiqqTX+p1BWRGSY99t0y1e70BmFAAgt6U=;
        b=zp46H94QG34ih0fuYvY4oB/ZWyCgtwMaTBHSTv0GHG7WE47nZstJ6FkRS+/hEA7iHb/j54
        3bAw3RXMRlk/8WRk+W4AdHyqo3HpWwmtsYKHE54wGrYLymXkq2GY7dMRwi2zBzDvqVBzqv
        tVsnB3ARu9BTA1nai4SB8RK+2DLp/yCMCyf7BoFcuQSqWKNA/GdGeurTm6WucAyAN4iArB
        8tqOyTOmUe4ELbEk6jF/qE2HUVGgUkyUIWCXPAo+2SSOY7KL562JRoRRZ0XE5MhE19ireP
        0Q7mnNlNYmgEVuS7IlFIEFlQ4m8Qy2Rno6l1DBbTmaplKi0oP5LUXqkVO43QXA==
From:   Michael Walle <michael@walle.cc>
To:     lxu@maxlinear.com
Cc:     andrew@lunn.ch, davem@davemloft.net, hkallweit1@gmail.com,
        hmehrtens@maxlinear.com, kuba@kernel.org, linux@armlinux.org.uk,
        mohammad.athari.ismail@intel.com, netdev@vger.kernel.org,
        tmohren@maxlinear.com, vee.khee.wong@linux.intel.com,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH] net: phy: enhance Maxlinear GPY loopback disable function
Date:   Wed, 14 Dec 2022 10:00:37 +0100
Message-Id: <20221214090037.383118-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221214082924.54990-1-lxu@maxlinear.com>
References: <20221214082924.54990-1-lxu@maxlinear.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subject is missing the correct target, "net" in this case.

> GPY need 3 seconds to switch out of loopback mode.

What does that mean, what goes wrong with the current 100ms?
Could you elaborate a bit more and update the commit message
and the comment? Is this true for any GPY PHY supported by
this driver?

This probably needs a Fixed tag then.

-michael
