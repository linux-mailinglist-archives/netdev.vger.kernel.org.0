Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1932468DA
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 16:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbgHQOzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 10:55:49 -0400
Received: from mail.intenta.de ([178.249.25.132]:41327 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729153AbgHQOzn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 10:55:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:CC:To:From:Date; bh=aUG46PKjv0gE7e6WG0DGdXAC0aSEZbfuxAPyMwc6Ws8=;
        b=oflBI/ClbjuuMb+F/n8WSAG8rUy4gBU9tgPbSttF4RFW1w0uwOVFy5ZeQyQaREOWpuY1IIi8I5Azd1ptI4mU21ZER2hXpyJq5Er21iWlwo6+FfO5XFBW+HyN1PKfxkc9R3maDTiOsO4OlH6J9a5ZDfHE2LOUdLDbGp7qOBqtdmdilSs51bd9BxcVC4hS+GCKNLye8H5H1AYb6zgKRCNaM2xnMoQ3iyKv/Ovf+adAcNMNFnB8R7Twzs4Nw7CgTHcf4cM8176ljA1MyGNkAbV6MNo99/MHWeHhVfePeKRD4LpYxZA8a+Y02L3c3YQFNbd/k65FICc4U1ckXjqv6y/AwQ==;
Date:   Mon, 17 Aug 2020 16:55:39 +0200
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH v2 3/6] net: dsa: microchip: delete unused member
 ksz_port.force
Message-ID: <2b71497e81f112af7bf0a5847fce5731019196f8.1597675604.git.helmut.grohne@intenta.de>
References: <20200725174130.GL1472201@lunn.ch>
 <cover.1597675604.git.helmut.grohne@intenta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1597675604.git.helmut.grohne@intenta.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ICSMA002.intenta.de (10.10.16.48) To ICSMA002.intenta.de
 (10.10.16.48)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Link: https://lore.kernel.org/netdev/20200721083300.GA12970@laureti-dev/
Signed-off-by: Helmut Grohne <helmut.grohne@intenta.de>
---
 drivers/net/dsa/microchip/ksz_common.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 83247140b784..8e277033bff7 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -32,7 +32,6 @@ struct ksz_port {
 
 	u32 on:1;			/* port is not disabled by hardware */
 	u32 fiber:1;			/* port is fiber */
-	u32 force:1;
 	u32 read:1;			/* read MIB counters in background */
 	u32 freeze:1;			/* MIB counter freeze is enabled */
 
-- 
2.20.1

