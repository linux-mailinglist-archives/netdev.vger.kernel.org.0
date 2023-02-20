Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D651469D270
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 18:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbjBTR7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 12:59:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjBTR7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 12:59:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3173729E;
        Mon, 20 Feb 2023 09:59:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D605960EFB;
        Mon, 20 Feb 2023 17:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA946C433EF;
        Mon, 20 Feb 2023 17:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676915950;
        bh=mOYr6Avk2SxtiVgeq7SulCefbJpu6ZXbRx04zv0iAgM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=osn1p6OS7zKw62KDMmgqZx22HraPYGn2VPVW4YiahjyWG0sZvq+WM9c4YKdn6I2XC
         ByHw+f+j+/+Kg9cJMIPDq5tVyc+mwgxRu0VbiTXbHRFtwSm5dQ7aIcCNd3GX7muskO
         UkhVUWVo6WEWm2bgISc6J6fRucs/RzNnDP9AJphB3WjfSQHLdx5X4ufSEcSFrKYAPF
         J7RMlwM9ku0wdVEWEfHOd03frAZVv9xJoPfxE1D8FyxEkBW2icTc4Ew0AATBZNRZr4
         3HHWUfBMEnwCiMcNpAbxMxHDmPKChdQdRjAQv2T7X+u8NOX14Eask5Ln7RG/51vQaT
         ir/JSpaVONpZg==
Date:   Mon, 20 Feb 2023 09:59:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan v2 0/6] ieee802154: Scan/Beacon fixes
Message-ID: <20230220095908.7b6946d5@kernel.org>
In-Reply-To: <736c9250-ecfc-f9ce-7367-bd79e930f5c3@datenfreihafen.org>
References: <20230214135035.1202471-1-miquel.raynal@bootlin.com>
        <20230217101058.0bb5df34@xps-13>
        <736c9250-ecfc-f9ce-7367-bd79e930f5c3@datenfreihafen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 18 Feb 2023 18:20:22 +0100 Stefan Schmidt wrote:
> I just reviewed and tested them and have no problem to take them in. For 
> patches 1 and 2 I would prefer an ack from Jakub to make sure we covered 
> all of this review feedback before. 

Sorry I was away, yes, patches 1 and 2 LGTM!
