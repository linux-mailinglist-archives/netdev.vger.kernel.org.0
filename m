Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5944DC5A4
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 13:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233486AbiCQMSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 08:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbiCQMSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 08:18:16 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667491E0168;
        Thu, 17 Mar 2022 05:16:59 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id E09242223A;
        Thu, 17 Mar 2022 13:16:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1647519417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nYMhHPhImbGmncfZA0BDCxrEi2EzUvhWOv6MK8y6l3g=;
        b=ZsJxUVXxkDrneOP9jtEYdAsDE7Z77AsQg6cSR9lhil0PcmpwxymOzeGT1kOLW1RTjp69l9
        47VLUBTM9FouGOxSlb4y9us4tSiLxg9C0h37k7SDAQ3pPZOEZ68CPnvXn1Z7U79VIRTV7n
        9XuX3ZzRRBtmBKT2uw1Ti6ZrD38mJ+I=
From:   Michael Walle <michael@walle.cc>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Divya.Koppera@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, davem@davemloft.net, devicetree@vger.kernel.org,
        hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        madhuri.sripada@microchip.com, manohar.puri@microchip.com,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        robh+dt@kernel.org
Subject: Re: [PATCH net-next 0/3] Add support for 1588 in LAN8814
Date:   Thu, 17 Mar 2022 13:16:50 +0100
Message-Id: <20220317121650.934899-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <164639821168.27302.1826304809342359025.git-patchwork-notify@kernel.org>
References: <164639821168.27302.1826304809342359025.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: patchwork-bot+netdevbpf@kernel.org

> Here is the summary with links:
>   - [net-next,1/3] net: phy: micrel: Fix concurrent register access
>     https://git.kernel.org/netdev/net-next/c/4488f6b61480
>   - [net-next,2/3] dt-bindings: net: micrel: Configure latency values and timestamping check for LAN8814 phy
>     https://git.kernel.org/netdev/net-next/c/2358dd3fd325
>   - [net-next,3/3] net: phy: micrel: 1588 support for LAN8814 phy
>     https://git.kernel.org/netdev/net-next/c/ece19502834d

I'm almost afraid to ask.. but will this series be reverted (or
the device tree bindings patch)? There were quite a few remarks, even
about the naming of the properties. So, will it be part of the next
kernel release or will it be reverted?

-michael
