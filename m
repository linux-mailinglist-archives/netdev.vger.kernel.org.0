Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA00558589E
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 06:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbiG3EiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 00:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbiG3EiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 00:38:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A32266B92
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 21:38:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B48FB81092
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 04:38:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2330C433C1;
        Sat, 30 Jul 2022 04:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659155896;
        bh=byUaj68VUOTwYaYYCbWjzO+0VovHAwFUab03gY2+/mg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vAcQcAnPYYMUK/eUY2OQH7ZeSjdh+t6LRnNdTAsi2OKu4w21V+Jv6PlE+cckm3cVs
         bUChX41j/EM3ZBHF18vvcYyZbgrBz/Erg8E7PsjR35irXj386vfC2RtpBOW+SYx5MO
         Ij4F3MuhSjhwb6r1FDORuexRSoixJ/uPEpuA5+EujegwIrDgIIJEEug/iiQIhO7juM
         NB6j0voFKMFbM48IWfpZGdT8B7rJyc6yS6Q9+8tNN5hufgM1dFfWDK8cCBYAKx8d3M
         bM/n/UqdzsMHj6CeRltPXGFItawJZ0Kxj/4cwixuxDP1J3udxwevuVlX7AGxKWKySl
         2fEihxLKeGuaQ==
Date:   Fri, 29 Jul 2022 21:38:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: Re: Is it time to remove decnet support from the kernel?
Message-ID: <20220729213814.7aed45d2@kernel.org>
In-Reply-To: <20220729211258.52c3ab81@hermes.local>
References: <20220729211258.52c3ab81@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jul 2022 21:12:58 -0700 Stephen Hemminger wrote:
> We removed decnet support from iproute2 several years ago.
> Seriously doubt anyone is still using decnet on Linux except in a computer history museum.
> 
> Like IPX, propose it gets moved to staging in next LTS?

I'd just delete it. But the cost to benefit of keeping it in stable 
for a while is subjective (and the considerations theoretical given 
how little experience we have deleting stuff) -- so whichever way you
prefer.
