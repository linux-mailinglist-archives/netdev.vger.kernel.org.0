Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DED985AFE5C
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 10:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiIGIBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 04:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiIGIBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 04:01:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BC1A98ED;
        Wed,  7 Sep 2022 01:01:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C9E2616EF;
        Wed,  7 Sep 2022 08:01:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1755C433B5;
        Wed,  7 Sep 2022 08:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662537666;
        bh=5rUJz9euJWfUraacEejsgy75afWo8CaSad4gs2Rf/Eg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=hwaBCDpQPNt/rB05iWByzUqQReVvevzT/9QHcZ7ehH+upw7QtNmPEo7zjuycWcJZR
         HvJn6pNGdfWKfD82ALiiBzcvvJIEniSI3IWMNRDk7DHyWRc4SVF5MtaCUk8yFnZ6Hb
         LMCBh/Tenpxz2dzdgOptkehDW4xRJn2dtGNK/Y28+45tVA9RGJ7FAjefLAewlR3537
         cOJKqXUXEgrr0JPKxPUxadsVJOgELngvMWYIrQKnSrKydz2hqvuk9Wd1ujrpWs4EZe
         0QPJ+so8RSBZ59GWCUpg2DWfyiyOI/bgAIQ1vo39uniQ7mLGtVwtPco0CEXN5/+8+T
         6Grtk0hePsVUQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: rtl8xxxu: Simplify the error handling code
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220818073352.3156288-1-zheyuma97@gmail.com>
References: <20220818073352.3156288-1-zheyuma97@gmail.com>
To:     Zheyu Ma <zheyuma97@gmail.com>
Cc:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Zheyu Ma <zheyuma97@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166253766198.23292.4646705960885932905.kvalo@kernel.org>
Date:   Wed,  7 Sep 2022 08:01:03 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zheyu Ma <zheyuma97@gmail.com> wrote:

> Since the logic of the driver's error handling code has changed, the
> previous dead store and checks are not needed.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>

Patch applied to wireless-next.git, thanks.

98d3f063be78 wifi: rtl8xxxu: Simplify the error handling code

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220818073352.3156288-1-zheyuma97@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

