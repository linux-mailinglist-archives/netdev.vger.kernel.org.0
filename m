Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7F35E57F6
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 03:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbiIVBUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 21:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbiIVBUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 21:20:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D409598D00;
        Wed, 21 Sep 2022 18:20:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C24BB81DDD;
        Thu, 22 Sep 2022 01:20:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46437C433C1;
        Thu, 22 Sep 2022 01:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663809627;
        bh=S0pYd9pePfNLzzjVw6IuGapX4viErIn2aDKs7zQI7sk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pIz2g6kZKroSipINZM8ZZQRKYDYMbEa3HrRUVklPcOxwUrcJZ7hzQeu+9kSW+AvgT
         SpMhMWc2HAJgDVKl76WXRmU1dZhSIMpESDAJLtbNETL/UkeQhTnqks+Ee34pzkb49x
         jSRuDwCggPqsQwK/s1fvTyNIzlTnvmEPghRtB5NSTU+iRGaaTHNbCTGq30O+4uvU2A
         DVplYGsjtJVRU6uGaWKVDJmYiPVulw71rZQJ15MakJuHmZZBpzecA+2gQo8aCSaTCp
         SoBg8Syd2YXIn5pNG3Ny0DzBJKr7NoStjWn/fxNfq7HwRE3F6tz0SCSaFGskxJdHqW
         mwb7gZLS4Ttzw==
Date:   Wed, 21 Sep 2022 18:20:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Couzens <lynxis@fe80.eu>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 0/2] net: mt7531: pll & reset fixes
Message-ID: <20220921182024.27e33b09@kernel.org>
In-Reply-To: <20220917000734.520253-1-lynxis@fe80.eu>
References: <20220917000734.520253-1-lynxis@fe80.eu>
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

On Sat, 17 Sep 2022 02:07:32 +0200 Alexander Couzens wrote:
> v1 -> v2:
>  - commit message: add Fixes: tag
>  - add missing target branch in subject

Landen, DENG, Sean - please review.
