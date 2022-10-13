Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB285FCF2C
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 02:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiJMAHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 20:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiJMAHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 20:07:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A749D9949;
        Wed, 12 Oct 2022 17:07:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8C08B810D9;
        Thu, 13 Oct 2022 00:07:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF10C433D6;
        Thu, 13 Oct 2022 00:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665619620;
        bh=hw3ArxzkcBb5t83e1dD2UIOeKC+T0IyQL7basvIVqvc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eUuOsm5/gcCw/w5iXzHv5GpEtLRWr27EsYueQKY3Zpdbkmxzq2N70yRIfmp+8lFJ2
         g188vnetRxTA/wqo/6tWzrLS5jFpqO1lgSU+3Ws+nq9JH8JrprTZGMNDjNpctPflGK
         yC6cvNxxV4qebKDxzR91930sKswSeh3+DVqFuRhl7Y+D2JbA2b/Zo53Z2ftjgJWZTW
         5OrmVBO6xgIwtimrvfawjGldlSazdiCKVovjO8BJpg7kyyMdUTtP5G7eMK0YxBGppu
         Kbx5a/kixgkhVcz/SdWKTQEzetY6EDyjnEAPn5pzXA1bz+7EkaJB+xX6XPxH21G+pI
         n/gbf5k/Qz+Vw==
Date:   Wed, 12 Oct 2022 17:06:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Kitt <steve@sk2.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        George McCollister <george.mccollister@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/dsa: use simple i2c probe
Message-ID: <20221012170658.4f99e85f@kernel.org>
In-Reply-To: <20221012175506.3938001-1-steve@sk2.org>
References: <20221012175506.3938001-1-steve@sk2.org>
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

On Wed, 12 Oct 2022 19:55:06 +0200 Stephen Kitt wrote:
> All these drivers have an i2c probe function which doesn't use the
> "struct i2c_device_id *id" parameter, so they can trivially be
> converted to the "probe_new" style of probe with a single argument.

Hold these off until after the merge window, please, net-next is closed
until rc1 is cut.
