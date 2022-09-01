Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A334D5A9D09
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 18:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234531AbiIAQ0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 12:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233480AbiIAQ0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 12:26:44 -0400
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E02E5A2EA;
        Thu,  1 Sep 2022 09:26:42 -0700 (PDT)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id B09552010;
        Thu,  1 Sep 2022 18:26:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1662049599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5gPdcOh3G4Fq/gjmy/s1uDpAvkIPiHNCGi2EGHEAcyY=;
        b=Fofb2XGmbZsoPEktyTm7ZjLRg5BSQN5fYg9SGZPjPaYM3Tk05GsaIIDNquFWhF4hA/Z8g6
        6zId/e4zbLxzIqt6P5s/5YNMRF0gtp4B+/1D2jUVEbj4MM/b7+0fFGcaDgqIENGXRbf7j4
        eDxVq2MNtDbHaPfljkJCVe0c0S9Krnu5y+0SZn+TNuOafbF/sp/Tl1y0be1Y6ofYCz4OyD
        Pjl+ZTgWjpYGVpwBWs5xCbRCn55U/QN/5MQnl/K4UW6EcH6foEKPM3Szkj2i4jasc89jKx
        lLtPodBoFDoh4i5itaaFZsiZ/o2iAPLdHPMI+viYKe+BQgjKyKo/Ys8MrOYpng==
MIME-Version: 1.0
Date:   Thu, 01 Sep 2022 18:26:39 +0200
From:   Michael Walle <michael@walle.cc>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>
Subject: Re: [PATCH v1 01/14] net: add helper eth_addr_add()
In-Reply-To: <20220825214423.903672-2-michael@walle.cc>
References: <20220825214423.903672-1-michael@walle.cc>
 <20220825214423.903672-2-michael@walle.cc>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <1682967feab905d06402d0f8402799a8@walle.cc>
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

Hi netdev maintainers,

Am 2022-08-25 23:44, schrieb Michael Walle:
> Add a helper to add an offset to a ethernet address. This comes in 
> handy
> if you have a base ethernet address for multiple interfaces.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Would it be possible to get an Ack for this patch, so I don't have
to repost this large (and still growing) series to netdev every time?

I guess it would be ok to have this go through another tree?

-michael
