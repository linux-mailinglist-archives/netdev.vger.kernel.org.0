Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE9FB5C0013
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 16:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiIUOkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 10:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiIUOkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 10:40:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E24227CEA;
        Wed, 21 Sep 2022 07:40:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCE16612BB;
        Wed, 21 Sep 2022 14:40:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733ECC433D7;
        Wed, 21 Sep 2022 14:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663771206;
        bh=SVL/F9n6SXj18vjuw0LCc8zZdX5U7z9hK27fhYg1kMM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JPkcnY7RbprrxzY+4iV4rKb9JYnsAJUrnO2bUj5mLm1nLnXldOs7RHS/0LUcaMoZr
         ZKCZReIdXa1+C3Fp+FY+7VW63U7CAulgephF9dbRHH+a8tcvSp4ozUttnPuRwappzE
         OfSh+iMBdIqOy0nqf0qkGwvA+UCA6pi4Vme4sRUe3stqljKBZIj9Gv0m/5mHAoBwZG
         DaKdeWmYVqRI1QAJMTEQeQRXTNqa3jjAwvKo+v7TGlpzP5FjV2SmhMPQ5GIJngD33m
         FFh56uPwQ8LBueXvFig/2D9o/GB4cGOszneu+v4jkMuDdhqFeq3V90iwBLFfHvc1nu
         kmtJDa1cHp/+Q==
Date:   Wed, 21 Sep 2022 07:40:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     kishon@ti.com, vkoul@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, richardcochran@gmail.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        geert+renesas@glider.be, andrew@lunn.ch,
        linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 0/8] treewide: Add R-Car S4-8 Ethernet Switch support
Message-ID: <20220921074004.43a933fe@kernel.org>
In-Reply-To: <20220921084745.3355107-1-yoshihiro.shimoda.uh@renesas.com>
References: <20220921084745.3355107-1-yoshihiro.shimoda.uh@renesas.com>
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

On Wed, 21 Sep 2022 17:47:37 +0900 Yoshihiro Shimoda wrote:
> Subject: [PATCH v2 0/8] treewide: Add R-Car S4-8 Ethernet Switch support

I think you may be slightly confused about the use of the treewide
prefix. Perhaps Geert or one of the upstream-savvy contractors could
help you navigate targeting the correct trees?
