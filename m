Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E93E6452C4
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 04:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiLGD4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 22:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiLGD4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 22:56:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6622A27168;
        Tue,  6 Dec 2022 19:56:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 190CDB81CBE;
        Wed,  7 Dec 2022 03:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9169CC433C1;
        Wed,  7 Dec 2022 03:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670385391;
        bh=u7WuhkfBqj61Ys21ZeBlFuc9EPYmwG3OCdcBZpwxV/k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SG6g7AbM+ylx/ZeHq+UuBDoL+e7c5INlhtYSe6TzsF3YQ3Er+w/Lzow/f5k2yPo5V
         ZiG3cYK13XRMvSFNxZWffXRMPP5r76f7p8hLEljRA/1Uw0gy4Q12TKtd4nopHti027
         F0GdRifMbOU3LQwiRGoOKVqjeUDYELiFxRsU6h7AAtSwdz7tZaOPYPTvYYQAo54G4q
         DbwSPm2hu3QZn167BcAVExL9sQ9dDEX15mh4PxkyQ24VUdNqBnw4qytv3VvtRTGpCo
         ZZvndCodaybqBMPeOf5dEanPA2spYqdjudkiDXGubxYeezJ7VTTDLqoSvR6kPW/ua8
         PADeLPZY1CwWg==
Date:   Tue, 6 Dec 2022 22:56:29 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jacob Keller <jacob.e.keller@intel.com>,
        "David S . Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 09/13] net: loopback: use
 NET_NAME_PREDICTABLE for name_assign_type
Message-ID: <Y5AO7TrYsdeVqyI6@sashalap>
References: <20221206094916.987259-1-sashal@kernel.org>
 <20221206094916.987259-9-sashal@kernel.org>
 <20221206114956.4c5a3605@kernel.org>
 <Y4/4Yts6nwDCqC1q@sashalap>
 <20221206184927.7c43d247@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221206184927.7c43d247@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 06:49:27PM -0800, Jakub Kicinski wrote:
>On Tue, 6 Dec 2022 21:20:18 -0500 Sasha Levin wrote:
>> >Yeah... we should have applied it to -next, I think backporting it is
>> >a good idea but I wish it had more time in the -next tree since it's
>> >a "uAPI alignment" :(
>> >
>> >Oh, well, very unlikely it will break anything, tho, so let's do it.
>>
>> Want me to push it back a week to the next batch? It'll give it two
>> weeks instead of the usual week.
>
>Oh, perfect, I didn't know we can hold for a week. Yes, please!

Ack, you should get another AUTOSEL mail for this patch next week.

-- 
Thanks,
Sasha
