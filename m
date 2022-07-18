Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3182E5781B9
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234727AbiGRMLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234719AbiGRMLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:11:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDF91BF;
        Mon, 18 Jul 2022 05:11:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 691BEB81244;
        Mon, 18 Jul 2022 12:11:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B1DC341C0;
        Mon, 18 Jul 2022 12:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658146262;
        bh=N5rmU2UK1a0egDYxW9iuiG0ucNC3ixCSP33Y0SkdVgk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=cE2pvjhXiUBM/NeORjb1KrRaalUFYsW7N5A+Kg3JtfV3L4VhocYd1Ppg2i3B6hIE0
         Fo2rU5XeJvWW8r2xW1UdqTmzA1NIHg53urEneCAfbkhS6vJxuXKdOQi3D/udohNefH
         96xj0kR0hwXfyCGkVqGUQM8nEuAnDayRBAsf7E0Yz58Fs+bu4TZqjQo+lGnHzRwbvx
         Qwv0ue7SMgc/xX5/HIiSMPdueLSAIuylE14tJdAl7j4mEhVjPvq0Km0rmxuYT5FXHC
         ocbpMhA5cQtst6XDwxS+LSFUNRty4MW7kP6Nd04W+t70h9mxICMWaDEQ7b7ndhWPu3
         Em5De3e+CpomQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: rt2x00: fix repeated words in comments
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220710041442.16177-1-yuanjilin@cdjrlc.com>
References: <20220710041442.16177-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     stf_xl@wp.pl, helmut.schaa@googlemail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165814625813.32602.3882279420287601048.kvalo@kernel.org>
Date:   Mon, 18 Jul 2022 12:10:59 +0000 (UTC)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jilin Yuan <yuanjilin@cdjrlc.com> wrote:

> Delete the redundant words 'is' and 'with'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>

Patch applied to wireless-next.git, thanks.

a319b7f0794c wifi: rt2x00: fix repeated words in comments

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220710041442.16177-1-yuanjilin@cdjrlc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

