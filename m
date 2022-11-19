Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22AA9630ECB
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 13:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiKSMsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 07:48:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiKSMsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 07:48:07 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84638627EB;
        Sat, 19 Nov 2022 04:48:06 -0800 (PST)
Received: from [10.7.7.5] (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id 634BA815E0;
        Sat, 19 Nov 2022 12:48:02 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1668862086;
        bh=TCsHKwezR+S42w4SWd8H0zDYsXa1+0+jBl9KKLDSblg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=gxzbZ9y2ty6ibT6jmIxp94wv181bqOq41asJPR7xMGV1kJs8/vUhQ4UFW9z2QfBhE
         3gNk12UT4bVKSAsWLri2I9iBG8Fu3hETw6rfKgf5AL7kfmYGDp1AbsaT9vZAbzQbKc
         M3Osw7LsrEWF7gVlcyS61g6lvf5WrD0MEpHQ2zsP4yt9am7eDjNkhty2m2yJUeHG7M
         JRiAHaf2WrhmGEARTC7NwbbEY0RBUrPXF+mg4iyB82arSWOyXUdp+kfurej2nNiPcb
         fVpcmWq8QItvxxJgXwywp0Ubjbl1qSdaWZ/RdtjqIwVZqy21nKPTG/V5/SjT5RQ7Do
         HHfSPThqPQNPA==
Message-ID: <b1ad8fb5-fe95-f344-f691-dae6c5114810@gnuweeb.org>
Date:   Sat, 19 Nov 2022 19:47:57 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [RFC PATCH v4 3/4] liburing: add example programs for napi busy
 poll
Content-Language: en-US
To:     Stefan Roesch <shr@devkernel.io>,
        Facebook Kernel Team <kernel-team@fb.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Olivier Langlois <olivier@trillion01.com>,
        netdev Mailing List <netdev@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20221119041149.152899-1-shr@devkernel.io>
 <20221119041149.152899-4-shr@devkernel.io>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20221119041149.152899-4-shr@devkernel.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/19/22 11:11 AM, Stefan Roesch wrote:
> +void recordRTT(struct ctx *ctx)
> +{
> +    struct timespec startTs = ctx->ts;
> +
> +    // Send next ping.
> +    sendPing(ctx);
> +
> +    // Store round-trip time.
> +    ctx->rtt[ctx->rtt_index] = diffTimespec(&ctx->ts, &startTs);
> +    ctx->rtt_index++;
> +}

Use tabs for indentation, not spaces.

-- 
Ammar Faizi

