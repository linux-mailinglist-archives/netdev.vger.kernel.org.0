Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F248850FCCA
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 14:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349929AbiDZMVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 08:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349916AbiDZMVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 08:21:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9582CE11
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 05:17:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 287BB618CA
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 12:17:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF0EC385AA;
        Tue, 26 Apr 2022 12:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650975438;
        bh=lwhPH8nk22SdqalKEObPnW8jrJ8CMozvr7SYMQDnpUM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WKRlLHOh8hsgnpJipFIbMvHjmRCOsfZN2MIXWQy1XeU4awpDdQAwCkhtAOUv6IMYV
         4hk3kq3mVHAPO7DeoWg5kTdRQNJLRfqFEMJ0FmL/Bwd2s4ChbGUF7Jett/u0hit8WJ
         TRVnY0oscZq2uxwakNjVmGAutwbqZI/tEq3t91FB/M6V9CRZ8FqiLycd5ZMp9azIyy
         DZHHk7gCrf+0RqRavpjI4FaksK/rn7hYRoZmXN8/Zw2IRHmmybIPsu630IE7NffJ+G
         YPHHY3q4KL/mdlXdknauX/ZRS3ZByhRT/jKrYC6HOm8nRJjAiGSvycZQgPCG4Gn61k
         tBDOb3AOPnWNg==
Date:   Tue, 26 Apr 2022 05:17:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     kernel test robot <lkp@intel.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@idosch.org>, Jiri Pirko <jiri@resnulli.us>
Subject: Re: [linux-next:master] BUILD REGRESSION
 e7d6987e09a328d4a949701db40ef63fbb970670
Message-ID: <20220426051716.7fc4b9c1@kernel.org>
In-Reply-To: <6267862c.xuehJN2IUHn8WMof%lkp@intel.com>
References: <6267862c.xuehJN2IUHn8WMof%lkp@intel.com>
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

On Tue, 26 Apr 2022 13:42:04 +0800 kernel test robot wrote:
> drivers/net/ethernet/mellanox/mlxsw/core_linecards.c:851:8: warning: Use of memory after it is freed [clang-analyzer-unix.Malloc]

Hi Ido, Jiri,

is this one on your radar?
