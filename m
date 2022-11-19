Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53B0A63114A
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 23:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234462AbiKSWqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 17:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234247AbiKSWq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 17:46:28 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDA05F7B;
        Sat, 19 Nov 2022 14:46:28 -0800 (PST)
Received: from [10.7.7.2] (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id 408B881678;
        Sat, 19 Nov 2022 22:46:25 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1668897987;
        bh=KjUIpC9lI8CZA/mPZEi+hOUGYtnk6RMijGwK1w3sWhE=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=r29PS174tLe+eF7Gu9wiDwRXP6ax6q7B8OMJ3fhgLXwin/aIpIf6KhlNZKOhKCKqf
         UIU5p2yHRwY4flfSPSjRf6DOlg5vQtvDw/iOYHZdKy0bZazKzNyLkMuzJadTYauDCq
         lF9dWsecFlRIEJT/MeJ4LEjooyXqTx8IlAwf65lAKKIybq3k36bqivsDbfPuPQD7b+
         DHyrrF12B1xWJmsid7XcIS6yT+sG4be867k6oJSAdPMlDSrTxkzMBAU9ymRzAwiHcK
         C5vLYwnIF42ikU5dHNm4LaQXu//nljUARiVstt8aNB/qN//Ijk0bgmTfDSli9nndeg
         FPD5WIoq7QnxQ==
Message-ID: <24e5c8a3-faba-2e1a-eb9f-69bcbc2b28cd@gnuweeb.org>
Date:   Sun, 20 Nov 2022 05:46:22 +0700
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
 <20221119041149.152899-3-shr@devkernel.io>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: Re: [RFC PATCH v4 2/4] liburing: add documentation for new napi busy
 polling
In-Reply-To: <20221119041149.152899-3-shr@devkernel.io>
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
> This adds two man pages for the two new functions:
> - io_uring_register_nap

Typo:

    s/io_uring_register_nap/io_uring_register_napi/

> +.SH RETURN VALUE
> +On success
> +.BR io_uring_register_napi_prefer_busy_poll (3)
> +return 0. On failure they return
> +.BR -errno .
> +It also updates the napi structure with the current values.

io_uring_register_napi_prefer_busy_poll() no longer exists in this version.

> +.SH RETURN VALUE
> +On success
> +.BR io_uring_unregister_napi_busy_poll_timeout (3)
> +return 0. On failure they return
> +.BR -errno .
> +It also updates the napi structure with the current values.

io_uring_unregister_napi_busy_poll_timeout() no longer exists in this version.

-- 
Ammar Faizi

