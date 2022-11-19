Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 350E1630E37
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 12:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbiKSLJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 06:09:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiKSLJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 06:09:31 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5236B9E9;
        Sat, 19 Nov 2022 03:09:30 -0800 (PST)
Received: from [10.7.7.5] (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id 44785815E0;
        Sat, 19 Nov 2022 11:09:27 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1668856169;
        bh=j+m61TK/yxtBvtP647lDqnkwPW5elOaPKTqX2bOU5bs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ehHi7/JJPodykPdq221KIXj4y60XKLZwgcPuxjom3yAEM92uyfmcWwDIsKNTWr/Vr
         X4GkWU75UljFfEcNbGOS/yQEzM7P+w4cqNpMaPhCVnxa+RVAxHuwV6Q4d+sMUNSoIP
         N7LttdgGRk8GgfMgugkmpLuj2NIH4/EE0hvmihkClB8DaS1RFc/aWj7Lgy/yHOSIsx
         Jbn6No0ZmH8LmL22VX9z4Lm0goX5tJcaho3YTqQTLDIhSyvvL6CZIFlNt1XCak3Jmf
         VzzixCWjIAzKYejP3Jm/Ax3+3SdtU+AHNfUhNuRlPRCdHTwzm5ohjI8zaYBjofXGsG
         QF2C6GORdJUNw==
Message-ID: <c5ac425d-48e2-0a6d-3f56-c6154d3ac81f@gnuweeb.org>
Date:   Sat, 19 Nov 2022 18:09:24 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [RFC PATCH v4 1/4] liburing: add api to set napi busy poll
 settings
Content-Language: en-US
To:     Stefan Roesch <shr@devkernel.io>,
        Facebook Kernel Team <kernel-team@fb.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Olivier Langlois <olivier@trillion01.com>,
        netdev Mailing List <netdev@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20221119041149.152899-1-shr@devkernel.io>
 <20221119041149.152899-2-shr@devkernel.io>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20221119041149.152899-2-shr@devkernel.io>
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
> +
> +int io_uring_register_napi(struct io_uring *ring, struct io_uring_napi *napi)
> +{
> +	return __sys_io_uring_register(ring->ring_fd,
> +				IORING_REGISTER_NAPI, napi, 0);
> +}
> +
> +int io_uring_unregister_napi(struct io_uring *ring, struct io_uring_napi *napi)
> +{
> +	return __sys_io_uring_register(ring->ring_fd,
> +				IORING_REGISTER_NAPI, napi, 0);
> +}

The latter should be IORING_UNREGISTER_NAPI instead of IORING_REGISTER_NAPI?
Or did I miss something?

-- 
Ammar Faizi

