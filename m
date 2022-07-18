Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEEDE578194
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234619AbiGRMHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234593AbiGRMHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:07:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A04F23BF5;
        Mon, 18 Jul 2022 05:07:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C90146145C;
        Mon, 18 Jul 2022 12:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20D2C341C0;
        Mon, 18 Jul 2022 12:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658146032;
        bh=MkDHkSlfkcJ91+BNoi+8C0lZD/bC53v6Sb4q992ApH4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=jjxCjQljo/o4SHf2QRQBjXLPhVt6m+LzROqmARhhtq7CXSYr0qdKfrOhh+k4Y9msR
         s3qzhmZ2StICjhuWTpcXWCrqtWgPjz1E94tRb2LGGZnRKRBHUZ86VdaquEKIk3bJH7
         41/7mPCBd6OJITbdmiJ4FahgZ15sjS5iF5cNqcjdmHlEu30UGrbnwlYatWil9F0TR2
         EmXABJEGmSNRVjJIg+7dbB7foqzB3TLsUXEAMPmhVlFfpOGu2EtOqNx1w9oVfLP+zj
         Dh0TMDDHHAeHgMeNwXehuSizU/6AIjcnlVOr3dqobSyqsZ4LeTCo8qxOsjULwJraTo
         +Rj/C7DhzorPQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: atmel: fix repeated words in comments
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220709132637.16717-1-yuanjilin@cdjrlc.com>
References: <20220709132637.16717-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     simon@thekelleys.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165814602466.32602.18190706420188832956.kvalo@kernel.org>
Date:   Mon, 18 Jul 2022 12:07:09 +0000 (UTC)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jilin Yuan <yuanjilin@cdjrlc.com> wrote:

> Delete the redundant word 'long'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>

Patch applied to wireless-next.git, thanks.

15978ea38d79 wifi: atmel: fix repeated words in comments

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220709132637.16717-1-yuanjilin@cdjrlc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

