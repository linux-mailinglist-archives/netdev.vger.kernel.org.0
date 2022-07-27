Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08D785824DB
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 12:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbiG0KxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 06:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiG0KxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 06:53:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C3C3F33C;
        Wed, 27 Jul 2022 03:53:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82D81618B3;
        Wed, 27 Jul 2022 10:53:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F82C433D6;
        Wed, 27 Jul 2022 10:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658919189;
        bh=anf0cVEeLF157hyyBzTQ/+T/RZR/0Fmu/Sg4B7bLU2Q=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=NY/0ZqMlkqxFbcmmGsurnLtAsu3xIOvNa0rm3WLHt7vvcmK1Yjd4tvrYdVQjv8cRM
         VqrZ8O6iYjlg8Zr77ZB3t3LmuaPtgU2SwEnLWd0q96mKcJ2/I8SgM7IXsy7zjMEql2
         XwtTfqC4h3Dlsh0v13JzDLpmBFc3tFpfarpG5JXbFjiTYTy948iqnw5dtVgey/zjKK
         hbMfKtR72AbYwtWjIhQlsXglq13IFR3wu2Ril7oEpU/mh2KZ90bb35HgCLOyfA1gF+
         vjXR5aLvs7wmRtHuHL6TH0EPcdJTEEla7ds8DwGPUGwzysI0ngO37R+VXq3QjHcRC0
         Ms6L7JbPvCcUg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mwifiex: Fix typo 'the the' in comment
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220722083932.75388-1-slark_xiao@163.com>
References: <20220722083932.75388-1-slark_xiao@163.com>
To:     Slark Xiao <slark_xiao@163.com>
Cc:     amitkarwar@gmail.com, ganapathi017@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Slark Xiao <slark_xiao@163.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165891918438.17998.11200120428134644122.kvalo@kernel.org>
Date:   Wed, 27 Jul 2022 10:53:07 +0000 (UTC)
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

There's already an identical patch submitted:

https://patchwork.kernel.org/project/linux-wireless/patch/20220715050053.24382-1-wangborong@cdjrlc.com/

Patch set to Superseded.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220722083932.75388-1-slark_xiao@163.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

