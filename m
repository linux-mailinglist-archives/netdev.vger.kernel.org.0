Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEC75BD121
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 17:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiISPf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 11:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiISPf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 11:35:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2783725C56
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 08:35:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA930B81645
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 15:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06944C433C1;
        Mon, 19 Sep 2022 15:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663601753;
        bh=+okUnkkB/EF7NxBjU5q8a7IrodYClW1V8KOcU5H3Fak=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QYCnyeZ95KEmQs4FCG+Vmv9WdQQH0xC3eeQHzNEaL4xZSennGuz7+3Lrs/BfriHzj
         CqJYOzvVm2A77wGv6tiP1VxoPbbfeXCiWbC5E2MtYwbH7I5WTCz4F7xWwCQ1lCZfQC
         7zev9wBIUMNjAtb5Ne+FyrjwulWf9we/C8LPXngI5p9heDLQWBi28EEN7hCVEdUgay
         8FsKQh+SGdxRlwNV3s14d/BCu71bYh9PRlGkGUvauUJoDUZQEDyYSTjKqv4mPKJbWp
         kDCUaXV+bVTS8tk9XwHmn6R93Z39o87lBFa4M8/XCcjx2iybeFDybHF8JBQkp/++ek
         1GSCmf72+rKLA==
Date:   Mon, 19 Sep 2022 08:35:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gavin Li <gavinl@nvidia.com>
Cc:     stephen@networkplumber.org, davem@davemloft.net,
        jesse.brandeburg@intel.com, alexander.h.duyck@intel.com,
        sridhar.samudrala@intel.com, jasowang@redhat.com,
        loseweigh@gmail.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        virtio-dev@lists.oasis-open.org, mst@redhat.com, gavi@nvidia.com,
        parav@nvidia.com
Subject: Re: [virtio-dev] [PATCH v5 0/2] Improve virtio performance for 9k
 mtu
Message-ID: <20220919083552.60449589@kernel.org>
In-Reply-To: <76fca691-aff5-ad9e-6228-0377e2890a05@nvidia.com>
References: <20220901021038.84751-1-gavinl@nvidia.com>
        <76fca691-aff5-ad9e-6228-0377e2890a05@nvidia.com>
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

On Wed, 7 Sep 2022 10:57:01 +0800 Gavin Li wrote:
> Hi Dave/Jakub, Michael,
> 
> Sorry for the previous email formatting.
> Should this 2-patch series merge through virtio tree or netdev tree?

netdev seems appropriate, sorry for the delay
