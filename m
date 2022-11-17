Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31F0862D4D2
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 09:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239503AbiKQILm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 03:11:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239529AbiKQILg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 03:11:36 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02EB725DB
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 00:11:22 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 3558B70;
        Thu, 17 Nov 2022 09:11:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1668672680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iw82gh4heEAlqtjGleUuBsiZQkJAIBrFb6iAw3aOA2M=;
        b=O6XBzQNFI0SgvswgnXedZLo/dbdRHfI8bchZwQVdrDQcGPoFReEIAZKa1BzROLOdBZXh7d
        wSF7nKKZg6BAbOnOvhGYVMZ5D3A/RNDijnxC7ryr1xlilHKy0e9bnBw9OiFCT4+v6jH+7C
        8Rchwv6QT1+q032npFPDUYSANcNn4aRvwX7Sxt2xbNXuNsC+NJTJNbhqUwzq7M0HcHjjAT
        gVQ2lwZi5NqymBL60VmVQn8jmnMinNH8uqK8r8qBTG5M7fTaHSJ3g2DPhQqwtz3BV6uJg8
        ktvBmesyAtJNEtMb0gKWlPyeGcySby3OqUHByTMuOUr5qzDjfFC5eY0zC6j4jA==
From:   Michael Walle <michael@walle.cc>
To:     andrew@lunn.ch, Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, f.fainelli@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org, olteanv@gmail.com,
        pabeni@redhat.com
Subject: Re: [PATCH net] net: dsa: sja1105: disallow C45 transactions on the BASE-TX MDIO bus
Date:   Thu, 17 Nov 2022 09:11:05 +0100
Message-Id: <20221117081105.771993-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <Y3TldORKPxFUgqH/@lunn.ch>
References: <Y3TldORKPxFUgqH/@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

> I have a bit rotting patchset which completely separates C22 and C45,
> i just spend too much time reviewing other code to get my own merged.

I'm still rebasing your patchset to the latest next as I still
need it as a base for my patches regarding the maxlinear/microchip phy
issue :)

-michael
