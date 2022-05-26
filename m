Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43B24534A16
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 07:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243154AbiEZFCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 01:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbiEZFCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 01:02:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3B89156D;
        Wed, 25 May 2022 22:02:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1536761A1D;
        Thu, 26 May 2022 05:02:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C74C385A9;
        Thu, 26 May 2022 05:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653541369;
        bh=ysmqAK3XLcmNL8cIxVtAiDEROYmRKUnpGsVCLEUQBKs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dVrghjk7wfB63tDdjp63TGmVCElsKD0wgy25xpRykuxEA++7F80skC5VuGO2I1P6k
         cI58H3USWjvPWC4j8MpwMs2BLOcjKw2qW85b3e0LPFm1liwkmmqFKbbN+Q4LCgozrj
         seYzSomvSkxkansywAVW3tVS/NxBdUOu6o+yDTHNxpTqejmrhqYvy1tfOjvtBpEY6m
         ceGNiUJEBCFnqhyGARfT1Hz1KWal7EATQK5SSeR8/flg+CgF5i/Qv3V2GIbgzSoAeX
         g4Iys9Go8ZtNLIX4/oZhrn812te211jowEMYXUnzSq9R69yM9zwTiD3Ea6O0r5cqKL
         TuaaZbOdx1S0Q==
Date:   Wed, 25 May 2022 22:02:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     michael.hennerich@analog.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, alexandru.ardelean@analog.com,
        josua@solid-run.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: adin: use YAML block scalar to avoid
 parse issue
Message-ID: <20220525220247.3e7dfc0d@kernel.org>
In-Reply-To: <20220526045740.4073762-1-chris.packham@alliedtelesis.co.nz>
References: <20220526045740.4073762-1-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 May 2022 16:57:40 +1200 Chris Packham wrote:
> YAML doesn't like colons (:) in text. Use a block scalar so that the
> colon in the description text doesn't cause a parse error.
> 
> Fixes: 1f77204e11f8 ("dt-bindings: net: adin: document phy clock output properties")
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>

Got the same fix from Geert already, applying to netdev/net now:

https://lore.kernel.org/all/6fcef2665a6cd86a021509a84c5956ec2efd93ed.1653401420.git.geert+renesas@glider.be/
