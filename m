Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD4E4577949
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 03:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbiGRBeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 21:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbiGRBeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 21:34:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396BE38BA;
        Sun, 17 Jul 2022 18:34:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC61461037;
        Mon, 18 Jul 2022 01:34:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA9BC341C0;
        Mon, 18 Jul 2022 01:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658108054;
        bh=1ihfpbcsyMcCB87E74Q1HD9BPqKPvsmbP7lNVwsxin0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hzzD1/6JYDUjHjQVe5OvTEIqCaDeVUcOtQ6oQdq+E0aCB+Lt+uA9EQS1DPwQltF+d
         yB1pDzmucM02vDG2fYZpXAQ6OfXeTfhdrdKuXwpk1xsgAekM3DULrU9sjYxFkxAL2Z
         2YQbmmUtBbqNMH+orYfxnwMhPmUBKBc/7YeJ8Q8j7V6Wf6u/vyv+ZiAFpqM97EtG6D
         kiCEcoutRP7PRE5VrET1XNxE57tYimTcerLjUKuG6IOrESP4GycvDeizsmYP4fVAxZ
         xoyIKnLnDf92oJA7L0NacXeH+ii1xJw2FyLLIVvdQeD30ISh0Vht7T0pShl+HPdzQf
         0K7pghQO2zt0g==
Date:   Sun, 17 Jul 2022 21:34:12 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, wireguard@lists.zx2c4.com,
        netdev <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.18 39/41] wireguard: selftests: use virt
 machine on m68k
Message-ID: <YtS4lPL9qb1M5KP/@sashalap>
References: <20220714042221.281187-1-sashal@kernel.org>
 <20220714042221.281187-39-sashal@kernel.org>
 <CAMuHMdWumKeJmsOsd7_=F-+8znY=0YtH-CbeLN7knSJ1LDOR_w@mail.gmail.com>
 <YtSUwWn1SK+B83v5@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YtSUwWn1SK+B83v5@sashalap>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 17, 2022 at 07:01:21PM -0400, Sasha Levin wrote:
>On Thu, Jul 14, 2022 at 09:08:49AM +0200, Geert Uytterhoeven wrote:
>>Hi Sasha,
>>
>>On Thu, Jul 14, 2022 at 6:29 AM Sasha Levin <sashal@kernel.org> wrote:
>>>From: "Jason A. Donenfeld" <Jason@zx2c4.com>
>>>
>>>[ Upstream commit 1f2f341a62639c7066ee4c76b7d9ebe867e0a1d5 ]
>>>
>>>This should be a bit more stable hopefully.
>>>
>>>Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
>>>Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>>
>>Thanks for your patch!
>>
>>>--- a/tools/testing/selftests/wireguard/qemu/arch/m68k.config
>>>+++ b/tools/testing/selftests/wireguard/qemu/arch/m68k.config
>>>@@ -1,10 +1,7 @@
>>> CONFIG_MMU=y
>>>+CONFIG_VIRT=y
>>
>>The m68k virt machine was introduced in v5.19-rc1, so this patch
>>must not be backported to v5.18 and earlier.
>
>I'll drop it, thanks!

I've clicked the wrong button and still queued it by mistake, now really
removed :)

-- 
Thanks,
Sasha
