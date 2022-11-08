Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBC9620ADB
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 09:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233365AbiKHIEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 03:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233087AbiKHIEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 03:04:52 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261BBCC8;
        Tue,  8 Nov 2022 00:04:47 -0800 (PST)
Received: from [10.7.7.5] (unknown [182.253.88.158])
        by gnuweeb.org (Postfix) with ESMTPSA id 58533814AD;
        Tue,  8 Nov 2022 08:04:44 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1667894686;
        bh=vomnaEZy1ZEXq9x5DCPq6ZVKLyeHXK4TXpCPrElK50A=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=Qk34evKsXyOTIApsn6nH+TBuLiVDExGb+IlN66dJ2yYTd2CN6/Wh6v7ObLDkuQhVA
         inr6H6B7yEfn3vb/x+JTjxu+mpbVACRtoMelqH1dSXVs1G6iO9LjXPG25WL9FhLLsm
         5oEXbX5DxxU8CxsffI34btxf1DYB4700W9Ri6V/fTQjhhaPfepRz5PqQKpBYQ1Uqkz
         dWYe6DQ5RQH5N48Qm01ffijPYJtBJo+53JKE2/pp9AaYLV1b0isj/7tvcYmMMW0R8E
         6HYp9xZCFYfEWf4CRY+cc/5men6W9/zLSVdnL0IyGzJ8jmvJCfpT/XEcHT2b8JfYGH
         kmSil4OTPl+fg==
Message-ID: <7a6b630e-5863-fa0e-8520-fe687271f809@gnuweeb.org>
Date:   Tue, 8 Nov 2022 15:04:41 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     Stefan Roesch <shr@devkernel.io>,
        Facebook Kernel Team <kernel-team@fb.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Olivier Langlois <olivier@trillion01.com>,
        netdev Mailing List <netdev@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20221107175357.2733763-1-shr@devkernel.io>
 <20221107175357.2733763-3-shr@devkernel.io>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: Re: [RFC PATCH v2 2/4] liburing: add documentation for new napi busy
 polling
In-Reply-To: <20221107175357.2733763-3-shr@devkernel.io>
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

On 11/8/22 12:53 AM, Stefan Roesch wrote:
> +.TH io_uring_register_napi_busy_poll_timeout 3 "November 1, 2022" "liburing-2.3" "liburing Manual"
[...]
> +.TH io_uring_unregister_napi_busy_poll_timeout 3 "November 1, 2022" "liburing-2.3" "liburing Manual"

liburing-2.3 has already been released. These two should go to liburing-2.4.

See:

    https://github.com/axboe/liburing/tags

for the liburing version list.

-- 
Ammar Faizi

