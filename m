Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662DA582507
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 12:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbiG0K7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 06:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbiG0K7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 06:59:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F0B48E99;
        Wed, 27 Jul 2022 03:59:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2596BB82015;
        Wed, 27 Jul 2022 10:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3167AC433C1;
        Wed, 27 Jul 2022 10:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658919547;
        bh=vW6cSkOp4/7zf8XCInlICCJzylE/b2kproYiXL3qFgU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=gvajeK0SXhi49E7yIicHLQ7y2JwRmU14BqpW0kd4XAV5OAhLWdTpoKNXaoSU7B148
         eB9kSqRbItteP055AvTlu0qTYwoQMjGv5+UAx5cBxE1oMJ2eU6QmCQL86e7moFh63G
         QfWxkmIANdlZCcLDfT4MRAGJ3exYdSAGdsUW1/wwdYVkj2QlWVFyPbxy6pwpWfcGXa
         bJNC1oONRzv7uWDWqOdfW2pfnswxOu6BXsqyfDoUumL0HVl4PRc0sjteexD3TdHa7r
         Eg6uqDF72gNhEe48k1Iqvd9rzY8amAC8jvn0xRBOvUEnCmGVLZNfV68FX/hRSJPGHf
         C9E80+VLGW8ug==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: brcmsmac: Fix typo 'the the' in comment
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220722083031.74847-1-slark_xiao@163.com>
References: <20220722083031.74847-1-slark_xiao@163.com>
To:     Slark Xiao <slark_xiao@163.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        Slark Xiao <slark_xiao@163.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165891954346.17998.13709968594700541654.kvalo@kernel.org>
Date:   Wed, 27 Jul 2022 10:59:05 +0000 (UTC)
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

Patch applied to wireless-next.git, thanks.

61afad44f9e9 wifi: mwifiex: Fix comment typo

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220722083031.74847-1-slark_xiao@163.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

