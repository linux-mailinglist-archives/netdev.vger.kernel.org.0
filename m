Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E60461420E
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 01:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiKAADr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 20:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiKAADq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 20:03:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 254E712ADA
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 17:03:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B476060EA6
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 00:03:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A49C433B5;
        Tue,  1 Nov 2022 00:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667261025;
        bh=z11+vwPjBu5VwR/4w8x7oyEAYEtzz2gANdmd/aGDM3g=;
        h=Date:From:To:Subject:In-Reply-To:References:From;
        b=jW0jozg3mOa8jBE3eDKw0BcgB9/2jxgEkZ+db+hV0uy1t6dADAbxTBIx+xVCf1s6u
         7BY/i7pwu0k/5N3rMOx9BN+6GYaDpS2/JaZoCZup5rtazUUgW3lvo+Tn0DqSvX5uvd
         Kq7dgUFL/5rv2DBhxoZBNY4gpElLiAyDBidGIxs30N3EkExHlaKfA8LBKlvhZJbaSs
         WVPkoA+5UDjjril6hcVbANhUneatgBaqwkisE49/E0t0Q/qjLA3sAEZdRIUljACary
         yxaKlZdtECK3Rprg6C3mOydE0H38eeIBWxD7osPT0bBNSzCfGATkuDWz87vslUW4OG
         fpk6TFgIFGT9A==
Date:   Mon, 31 Oct 2022 17:03:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] dt-bindings: net: constrain number of 'reg' in ethernet
 ports
Message-ID: <20221031170344.07542bf5@kernel.org>
In-Reply-To: <20221028140326.43470-2-krzysztof.kozlowski@linaro.org>
References: <20221028140326.43470-1-krzysztof.kozlowski@linaro.org>
        <20221028140326.43470-2-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Oct 2022 10:03:25 -0400 Krzysztof Kozlowski wrote:
> 'reg' without any constraints allows multiple items which is not the
> intention for Ethernet controller's port number.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

There was some slightly confusing co-posting going on in the thread 
(this patch is a reply to patch 1/2?) so given Rob's questions / nits
I'll drop this from networking pw. Abundance of caution.
