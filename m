Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8DB7618B24
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 23:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiKCWJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 18:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiKCWJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 18:09:23 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E039FC28;
        Thu,  3 Nov 2022 15:09:22 -0700 (PDT)
Received: from [10.7.7.5] (unknown [182.253.183.90])
        by gnuweeb.org (Postfix) with ESMTPSA id 55F8480632;
        Thu,  3 Nov 2022 22:09:20 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1667513362;
        bh=wNOq3MiFcUj14NJGygtN4kFjlbY0Nz1cscHKRtA0gZQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=EJ85xoEw44fR/hYgLsIdIDQ0dc41/VkTJVjk+Krx+gfnD6OAfoUDpR8y+7wA9QqGm
         JtRAQh2wvBaytov8zB0l22kXTySTSbnH2B1BqQ9Ik9ELBZtGKJUzEC+l+vyEE+n2pm
         1Z/PGswtgf5Ipb4pSClOQjDdpFJZtAcSI0HXqcnTuM56mesZCMVSGf760hAsjnDViJ
         yFn3i9bgNqUngfC2Y74WXzQqYZU7Y3CsATj1ck8iCaZENrye9zhLVKE4siXdYCMS2d
         pRG9JpxEpDSEOKWxZpRSV/dRwrWQJqhBFP5le0pt037FSyHmERZdFUNvRMvzIyQVbA
         yQ1BWjo380SZw==
Message-ID: <c8387cab-c969-79cb-7e7f-3c8f0b4e7a9c@gnuweeb.org>
Date:   Fri, 4 Nov 2022 05:09:17 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [RFC PATCH v1 1/3] liburing: add api to set napi busy poll
 timeout
To:     Stefan Roesch <shr@devkernel.io>,
        Facebook Kernel Team <kernel-team@fb.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev Mailing List <netdev@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <20221103204017.670757-1-shr@devkernel.io>
 <20221103204017.670757-2-shr@devkernel.io>
Content-Language: en-US
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20221103204017.670757-2-shr@devkernel.io>
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

On 11/4/22 3:40 AM, Stefan Roesch wrote:
> This adds the two functions to register and unregister the napi busy
> poll timeout:
> - io_uring_register_busy_poll_timeout
> - io_uring_unregister_busy_poll_timeout
> 
> Signed-off-by: Stefan Roesch <shr@devkernel.io>

Also, please update the CHANGELOG file if you add a new feature.
Create a new entry for liburing-2.4 release.

Ref: https://github.com/axboe/liburing/discussions/696#discussioncomment-3962770

-- 
Ammar Faizi

