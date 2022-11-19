Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A10A631150
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 23:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234411AbiKSW7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 17:59:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbiKSW7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 17:59:30 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240B312AFA;
        Sat, 19 Nov 2022 14:59:29 -0800 (PST)
Received: from [10.7.7.2] (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id A329281677;
        Sat, 19 Nov 2022 22:59:26 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1668898769;
        bh=ELv0R4eAXKLlkRiLo8oW8LQ1dCLBNj04pBy8+2JS+Wo=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=LdgW39jINt/dvHALfU/KJTGFGEU7Qc/MrZyfLb54PzpvSBrPqdDDYo8vnrcaS69Me
         LJyTxbRX1BQ7uOMmhay1SeAgCLVbv1KTesKYpeNamUABAZPJKBBTbDp6lavU4Co1QX
         cjLaaESscaVqPvmDq1GrrGeJIeRIGZmJPf1WME+uYkpa70V94SIiuQSwQTLTu8oJCx
         YdkfhbQIbwAnn56/UmDq0yfWTRZ7Ts5PF1MCflqp1BNe9FE/nNiO2xFAB22caDUlR3
         g3ta9VvvyqdE7l2bWdXGEzRknsGYajHaFiBxSPw1zIMqVSPawfOjWgHnW5zmFqq3ni
         Az6k91eBzssIg==
Message-ID: <a9fc8e9c-97d7-2744-7300-bf283a720c54@gnuweeb.org>
Date:   Sun, 20 Nov 2022 05:59:23 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-Language: en-US
To:     Stefan Roesch <shr@devkernel.io>,
        Facebook Kernel Team <kernel-team@fb.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Olivier Langlois <olivier@trillion01.com>,
        netdev Mailing List <netdev@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20221119041149.152899-1-shr@devkernel.io>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: Re: [RFC PATCH v4 0/4] liburing: add api for napi busy poll
In-Reply-To: <20221119041149.152899-1-shr@devkernel.io>
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
> This adds two new api's to set/clear the napi busy poll settings. The two
> new functions are called:
> - io_uring_register_napi
> - io_uring_unregister_napi
> 
> The patch series also contains the documentation for the two new functions
> and two example programs. The client program is called napi-busy-poll-client
> and the server program napi-busy-poll-server. The client measures the
> roundtrip times of requests.
> 
> There is also a kernel patch "io-uring: support napi busy poll" to enable
> this feature on the kernel side.

BTW Stefan, I got:

    "[RFC PATCH v4 0/4] liburing: add api for napi busy poll"

patchset twice. Both are identical. But I don't get a v4 kernel patchset
that adds this feature.

Maybe you were going to send the kernel and liburing patchset, but you
accidentally sent the liburing patchset twice?

-- 
Ammar Faizi

