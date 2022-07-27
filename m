Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7AE25824E5
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 12:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbiG0Kzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 06:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiG0Kzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 06:55:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB6E3E764;
        Wed, 27 Jul 2022 03:55:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A04C461868;
        Wed, 27 Jul 2022 10:55:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1148C433D6;
        Wed, 27 Jul 2022 10:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658919336;
        bh=t3wXgiLkH4KbPLTMvnGQGogdvXuHkn5PFcD+Kw3qW6w=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=MWlXeETg3KfYFuEuKnRGxIzLFMBz4pdB/r+ELQIy7Oq2kI2o1AIWFbY9LyR825YwW
         INi529pb89AEO39TMvFErpOKGt8f3liubz1k41vDhjWZqfWQ2aIRmbQsAF10HjJafR
         c5j8t6G+ub8Rsi732LW1dkE64xJ/htsHlI3lj08YJswNJPn3FL8eaM5mhjzw8/vdkV
         2feQVvYt8R0aCpP3vDAgzYNWgnqaN+oj/8HETpYJ32cGmHGH0LFfcvLV90EVpuaXEC
         JVvqAGXs9EZf7HZJf0/BgPqe8EGceC5ojwXTgIFWO0sBbNPweYU+qLoN/k0F6X6IcQ
         izNDMy4eOKeLA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rsi: sdio: Fix typo 'the the' in comment
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220722084417.75880-1-slark_xiao@163.com>
References: <20220722084417.75880-1-slark_xiao@163.com>
To:     Slark Xiao <slark_xiao@163.com>
Cc:     amitkarwar@gmail.com, siva8118@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Slark Xiao <slark_xiao@163.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165891933161.17998.8958601472358253795.kvalo@kernel.org>
Date:   Wed, 27 Jul 2022 10:55:33 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Slark Xiao <slark_xiao@163.com> wrote:

> Replace 'the the' with 'the' in the comment.
> 
> Signed-off-by: Slark Xiao <slark_xiao@163.com>

An identical patch was already submitted:

https://patchwork.kernel.org/project/linux-wireless/patch/20220715050016.24164-1-wangborong@cdjrlc.com/

Patch set to Superseded.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220722084417.75880-1-slark_xiao@163.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

