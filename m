Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 922FA5778B2
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 01:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbiGQXB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 19:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiGQXB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 19:01:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D03120BB;
        Sun, 17 Jul 2022 16:01:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45FB0B80EA5;
        Sun, 17 Jul 2022 23:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF23EC3411E;
        Sun, 17 Jul 2022 23:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658098882;
        bh=qvKpwS2oAz58xErVnVqqeNlH1V1bOLYcNo9RbFb07e8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G7yuCSMHtGjZZKlXxN4KUsT20AvUEHjAm1L1hgW1tcRVsYd9aVugALSYRtxJgfTYt
         /wXithn7iS/GJz0ArUttX4eO4a8UeWnr4Svp7wIzmR+NsvJS7Z6xiMeZA8dNCqkWhu
         h+pnz7nDPCANZd2pUTW3d+M8CatYMNmnal5rD8i7uUpxX59QN9ug+8tT6GpT4vDSOO
         kh49GdtL4Z7v3fGO6VqZvQTphXA8u2yLUfluKUMcYSafBzFz9sqffAvNQx1RRPv8KS
         GXpXKQSeLV46Av+uPTHWOCxYbqRATTXsAOuqJ+UsVD/8nLXeIbxF0Ki8Ewtvfp2xC4
         1cVhAccOVyPIw==
Date:   Sun, 17 Jul 2022 19:01:21 -0400
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
Message-ID: <YtSUwWn1SK+B83v5@sashalap>
References: <20220714042221.281187-1-sashal@kernel.org>
 <20220714042221.281187-39-sashal@kernel.org>
 <CAMuHMdWumKeJmsOsd7_=F-+8znY=0YtH-CbeLN7knSJ1LDOR_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAMuHMdWumKeJmsOsd7_=F-+8znY=0YtH-CbeLN7knSJ1LDOR_w@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 14, 2022 at 09:08:49AM +0200, Geert Uytterhoeven wrote:
>Hi Sasha,
>
>On Thu, Jul 14, 2022 at 6:29 AM Sasha Levin <sashal@kernel.org> wrote:
>> From: "Jason A. Donenfeld" <Jason@zx2c4.com>
>>
>> [ Upstream commit 1f2f341a62639c7066ee4c76b7d9ebe867e0a1d5 ]
>>
>> This should be a bit more stable hopefully.
>>
>> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Thanks for your patch!
>
>> --- a/tools/testing/selftests/wireguard/qemu/arch/m68k.config
>> +++ b/tools/testing/selftests/wireguard/qemu/arch/m68k.config
>> @@ -1,10 +1,7 @@
>>  CONFIG_MMU=y
>> +CONFIG_VIRT=y
>
>The m68k virt machine was introduced in v5.19-rc1, so this patch
>must not be backported to v5.18 and earlier.

I'll drop it, thanks!

-- 
Thanks,
Sasha
