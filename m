Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33D385E720A
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 04:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiIWCoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 22:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiIWCoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 22:44:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A11AE36A8;
        Thu, 22 Sep 2022 19:44:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32D66B829D9;
        Fri, 23 Sep 2022 02:44:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657D9C433C1;
        Fri, 23 Sep 2022 02:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663901040;
        bh=Pi/rMRKwuezca1he83F41VGKAV8gV/ZGoeQEtHJN/zg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DjToNcMG78IfrgD+PbSfLtHNHO4LMQf2h/G+Q3yqtC+D2TngDAd9G4Yv77xY8zb8m
         fjj2IOukuriKVdRfhSaAf23fZ0mNJIrqWP6Sf2f0WozwRicV6qDzQZCI4fLDqcIenT
         Y8MmW0c7sUST6UyG0kEFXFm/hMT4cK29OYzRQAPPA6GEDQuQTvjb1t6U+CrYhn8oiB
         lVP3TXkm7VNrl/HnuF3/lYTaYZQjlo1gIYjAu9SW4OM6DdikIpPhRYNBkeOcPhlxf7
         6RaMmSBWL3Ny8lMx46Tpj0AtMUt2NoKNOrJxLQgUBPwhcpcne/xZyBgnYyXpYlCVuO
         Yon7KUEL8RWVQ==
Date:   Thu, 22 Sep 2022 19:43:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 2/3] net: ethernet: renesas: Add Ethernet Switch
 driver
Message-ID: <20220922194359.3416a6a2@kernel.org>
In-Reply-To: <20220922052803.3442561-3-yoshihiro.shimoda.uh@renesas.com>
References: <20220922052803.3442561-1-yoshihiro.shimoda.uh@renesas.com>
        <20220922052803.3442561-3-yoshihiro.shimoda.uh@renesas.com>
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

On Thu, 22 Sep 2022 14:28:02 +0900 Yoshihiro Shimoda wrote:
> Add Renesas Ethernet Switch driver for R-Car S4-8 to be used as an
> ethernet controller.

Looks like we have a lot of sparse warnings here.

Please try building the module with W=1 C=1 and make sure 
it builds cleanly.

https://sparse.docs.kernel.org/en/latest/

