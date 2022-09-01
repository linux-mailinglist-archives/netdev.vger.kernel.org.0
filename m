Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 847155A9063
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 09:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233556AbiIAHeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 03:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233963AbiIAHdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 03:33:11 -0400
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B9011E805;
        Thu,  1 Sep 2022 00:32:41 -0700 (PDT)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 795159B1;
        Thu,  1 Sep 2022 09:32:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1662017559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y4hVSRafU/s0cD83xCpx8qIVQGggUt5n/A5U3dUZg1s=;
        b=bZn4rmA2GWp/T2UCDI+sqNFZQimRRGVNV9D2tGRLh1oaxxwOjsNZjT9tJ5TZwFDejSH4mP
        CH6GAVq4itK+OHgaNWC+rqjGvD5XCTy5W1Oslxjy3xxW5fRcsvtgR9pqPn2wzxsiYuxnvR
        wgf+1dCIfQyYUF86lZAEAq44cPg6lmhKOEZ1wFoWRlau/iSVWu+54iQdamSJj3u4Un8sq7
        vJyI9JPoXeu3/OLOzTZDR/0G3FwthILI6J/Eg1vwu3NBzeuUYzlTjERNgVGMEMAVd+FE31
        v2g27toSAv48M4hEBWJsA43UdlEJRXt5y96ZN1XMr7VvJUh/ZBj5sSn5ekZU1A==
MIME-Version: 1.0
Date:   Thu, 01 Sep 2022 09:32:39 +0200
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 devicetree 2/3] arm64: dts: ls1028a: mark enetc port 3
 as a DSA master too
In-Reply-To: <20220831160124.914453-3-olteanv@gmail.com>
References: <20220831160124.914453-1-olteanv@gmail.com>
 <20220831160124.914453-3-olteanv@gmail.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <5e71b32f2f417e82b660a820556a1995@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-08-31 18:01, schrieb Vladimir Oltean:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The LS1028A switch has 2 internal links to the ENETC controller.
> 
> With DSA's ability to support multiple CPU ports, we should mark both
> ENETC ports as DSA masters.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Michael Walle <michael@walle.cc>
