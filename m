Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADF20168F29
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 14:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbgBVNd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 08:33:28 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:37091 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbgBVNd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 08:33:28 -0500
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id DB577230E1;
        Sat, 22 Feb 2020 14:33:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1582378405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ju1sES4dqml8Iarmbh4tFHkRxf0KzZNsexlc5IqJhjQ=;
        b=Y4GkoE5LTskillGNJQ+3bSPxHjSgzvfhF11ANViWaA2IHkC19paRBFoSAbLc5Tp+PM8+rC
        tiAE+03lwzUsUWplX4AZR9/qf+Ce+aTeGExtKyneY9ugm/uvgGZXG1ca1/y9I6gEDMz7PE
        Fs0ui8yxZEk89W6Xs1oH2kgwbjfPqmE=
From:   Michael Walle <michael@walle.cc>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, devicetree@vger.kernel.org, f.fainelli@gmail.com,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com,
        netdev@vger.kernel.org, olteanv@gmail.com, robh+dt@kernel.org,
        shawnguo@kernel.org, vivien.didelot@gmail.com,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH v2 net-next/devicetree 0/5] DT bindings for Felix DSA switch on LS1028A
Date:   Sat, 22 Feb 2020 14:33:13 +0100
Message-Id: <20200222133313.9993-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200219.111213.2304689693183810621.davem@davemloft.net>
References: <20200219.111213.2304689693183810621.davem@davemloft.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++
X-Spam-Level: ****
X-Rspamd-Server: web
X-Spam-Status: No, score=4.90
X-Spam-Score: 4.90
X-Rspamd-Queue-Id: DB577230E1
X-Spamd-Result: default: False [4.90 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[dt];
         MIME_GOOD(-0.10)[text/plain];
         BROKEN_CONTENT_TYPE(1.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         NEURAL_SPAM(0.00)[0.601];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_TWELVE(0.00)[12];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:31334, ipnet:2a02:810c::/31, country:DE];
         FREEMAIL_CC(0.00)[lunn.ch,vger.kernel.org,gmail.com,arm.com,kernel.org,walle.cc]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This series officializes the device tree bindings for the embedded
> Ethernet switch on NXP LS1028A (and for the reference design board).
> The driver has been in the tree since v5.4-rc6.
> 
> As per feedback received in v1, I've changed the DT bindings for the
> internal ports from "gmii" to "internal". So I would like the entire
> series to be merged through a single tree, be it net-next or devicetree.
> If this happens, I would like the other maintainer to acknowledge this
> fact and the patches themselves. Thanks.
> 
> Claudiu Manoil (2):
>   arm64: dts: fsl: ls1028a: add node for Felix switch
>   arm64: dts: fsl: ls1028a: enable switch PHYs on RDB
> 
> Vladimir Oltean (3):
>   arm64: dts: fsl: ls1028a: delete extraneous #interrupt-cells for ENETC
>     RCIE
>   net: dsa: felix: Use PHY_INTERFACE_MODE_INTERNAL instead of GMII
>   dt-bindings: net: dsa: ocelot: document the vsc9959 core

For all patches except 5/5 (because it was tested on a custom board) and
with patch from [1] applied:

Tested-by: Michael Walle <michael@walle.cc>

-michael

[1] https://patchwork.ozlabs.org/patch/1239296/

> 
>  .../devicetree/bindings/net/dsa/ocelot.txt    | 96 +++++++++++++++++++
>  .../boot/dts/freescale/fsl-ls1028a-rdb.dts    | 51 ++++++++++
>  .../arm64/boot/dts/freescale/fsl-ls1028a.dtsi | 85 +++++++++++++++-
>  drivers/net/dsa/ocelot/felix.c                |  3 +-
>  drivers/net/dsa/ocelot/felix_vsc9959.c        |  3 +-
>  5 files changed, 232 insertions(+), 6 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/ocelot.txt

-- 
2.17.1


