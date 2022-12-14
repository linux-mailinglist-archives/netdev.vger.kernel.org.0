Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C31064C212
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 03:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236997AbiLNCCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 21:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiLNCCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 21:02:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4B913D41;
        Tue, 13 Dec 2022 18:02:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2A7EB815FC;
        Wed, 14 Dec 2022 02:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C203EC433D2;
        Wed, 14 Dec 2022 02:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670983338;
        bh=83ob3N1he1MIOrIIbkVJFs5buErAmrdJMCOKfKXHqb0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bDLXc0RuV61tWZ2TmhA1zZ/K9nn8vhh9b8wz9mlGGOgLzL72MNBrv3mH5M0aHf5I3
         hYs6hOT0gCeh5AF+RryYv8T3742g9igNINX2g//Q0TC+McJ349jyIEVzFAxIZPfX4E
         N1Ms8QVMLpeyMvw3A726E4yHJiEUK7ovU2FeXBOiFb6EcuxkjSe2oj3T7gyQfQB65W
         ihdnMMbu247K8HnVN4q4MpH7jWLJ/OHVUsz/8nMUgIWNMVcXMMGXDkb0I18prIFwR2
         XONm4gCX+VRwbHTKJW+zbxU6oFygYoN5Fou0uk2HBKR4zgxK7mI9PN+4YcjW2MZ5LE
         +IzwIELTfXT8g==
Date:   Tue, 13 Dec 2022 18:02:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        sumit.semwal@linaro.org, christian.koenig@amd.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH v2] net: ksz884x: Remove some unused functions
Message-ID: <20221213180216.34f1826f@kernel.org>
In-Reply-To: <20221213035707.118309-1-jiapeng.chong@linux.alibaba.com>
References: <20221213035707.118309-1-jiapeng.chong@linux.alibaba.com>
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

On Tue, 13 Dec 2022 11:57:07 +0800 Jiapeng Chong wrote:
> These functions are defined in the ksz884x.c file, but not called
> elsewhere, so delete these unused functions.
> 
> drivers/net/ethernet/micrel/ksz884x.c:2212:20: warning: unused function 'port_cfg_force_flow_ctrl'.
> 
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3418
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

# Form letter - net-next is closed

We have already submitted the networking pull request to Linus
for v6.2 and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 6.2-rc1 is cut.

RFC patches sent for review only are obviously welcome at any time.
