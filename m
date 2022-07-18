Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4285781B1
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234819AbiGRMJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234767AbiGRMJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:09:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486AA24086;
        Mon, 18 Jul 2022 05:09:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AA24B8124B;
        Mon, 18 Jul 2022 12:08:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07361C341C0;
        Mon, 18 Jul 2022 12:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658146136;
        bh=tKM9/Uj59KAomE1YP2kSHnC86PtSNJLxrgPIt+uKGEA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=c/3drqH/kMICFyphN6FZG/xCI2jcvo4FJO/Q99kT9t/28AgQKHVK7SXxN/hcy8HKU
         kgMCwyRJr/nqUUdVDFWUOcPOQAEgKVU7mDzB6Aszt1xVonDCDGsDt4qUu9ZC7RXf8B
         0IUriAiVUXbd2mp8Spse3PLUvbQkrKHskqvN96XKz6ln1EaGm09pDkNjG7C89l54Cl
         EpR2L9N+QqpQ96YdxDGEsZWZHV+THDtmP3DDGHitWgLmUTZnnfkVOG22Vr9YJh65qx
         8kbRKgmGfddQH8Fz9Ri6PI5Rq6nBMZ3ziAUMjXDlziFMCxCkOJ4IAOy84XdOF6AhGV
         39kSXjhbFI/jQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: iwlegacy: fix repeated words in comments
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220709135316.41425-1-yuanjilin@cdjrlc.com>
References: <20220709135316.41425-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, stf_xl@wp.pl, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165814613225.32602.3235787073669802560.kvalo@kernel.org>
Date:   Mon, 18 Jul 2022 12:08:53 +0000 (UTC)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jilin Yuan <yuanjilin@cdjrlc.com> wrote:

> Delete the redundant words 'to' and 'if'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>

Patch applied to wireless-next.git, thanks.

f29c21516268 wifi: iwlegacy: fix repeated words in comments

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220709135316.41425-1-yuanjilin@cdjrlc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

