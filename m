Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4CF9685ECD
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 06:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbjBAFSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 00:18:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbjBAFSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 00:18:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D3D16321
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 21:18:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9D3C60A49
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 05:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2291C433EF;
        Wed,  1 Feb 2023 05:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675228695;
        bh=xZBqJnBicOf1jN4XyD0xUrCZpWhzUdRETJHLlMZuuCQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l2D+hiz7bJkVirs09DLCjZ3yEgRtIQg0beQS1fpias46cVsereb8doKHq23Q+GOfB
         JjIbeP9bFcVswdrGm3N7oQQKTK2ESxbcQjInlReQjRiL55OcCfp3dgM5EnigwmxBBc
         L27j5G0NSAFqNXoPRjIGowKS3jj/tf/pXkAdI0YmPIj318QV0jfOHobkHm2s5dLw6s
         UWjP9m1QXdTSKoZhr8lrm9hq1nU2WLjvO71acFU6/k25ggmogysciINiJudBBL8VqJ
         jXFO804zCd3o0YQVvtB4d8/k73kAwYInWKjGP5scQWJ1qe7xBx61wsH1/YhjCT/gyb
         XZFjGy+siT9GQ==
Date:   Tue, 31 Jan 2023 21:18:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, jacob.e.keller@intel.com
Subject: Re: [patch net-next 0/3] devlink: trivial names cleanup
Message-ID: <20230131211813.61210f75@kernel.org>
In-Reply-To: <20230131090613.2131740-1-jiri@resnulli.us>
References: <20230131090613.2131740-1-jiri@resnulli.us>
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

On Tue, 31 Jan 2023 10:06:10 +0100 Jiri Pirko wrote:
> This is a follow-up to Jakub's devlink code split and dump iteration
> helper patchset. No functional changes, just couple of renames to makes
> things consistent and perhaps easier to follow.

What's the weakest form of ack?

Seen-by: Jakub Kicinski <kuba@kernel.org> 

? ;)
