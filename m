Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0094A4730B4
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 16:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240133AbhLMPj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 10:39:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234728AbhLMPj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 10:39:59 -0500
X-Greylist: delayed 333 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 13 Dec 2021 07:39:58 PST
Received: from smtp-bc0d.mail.infomaniak.ch (smtp-bc0d.mail.infomaniak.ch [IPv6:2001:1600:3:17::bc0d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0B9C06173F
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 07:39:58 -0800 (PST)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4JCQXw17gBzMqH2b;
        Mon, 13 Dec 2021 16:34:24 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4JCQXt3Z4tzlj3w5;
        Mon, 13 Dec 2021 16:34:22 +0100 (CET)
Message-ID: <7ab490d6-ac17-8383-4c84-e4cbcbd7fab0@digikod.net>
Date:   Mon, 13 Dec 2021 16:36:27 +0100
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH 06/12] selftests/landlock: remove ARRAY_SIZE define from
 common.h
Content-Language: en-US
To:     Shuah Khan <skhan@linuxfoundation.org>, catalin.marinas@arm.com,
        will@kernel.org, shuah@kernel.org, keescook@chromium.org,
        davem@davemloft.net, kuba@kernel.org, peterz@infradead.org,
        paulmck@kernel.org, boqun.feng@gmail.com, akpm@linux-foundation.org
Cc:     linux-kselftest@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        linux-mm@kvack.org
References: <cover.1639156389.git.skhan@linuxfoundation.org>
 <e86b9f3a050a919b90a41e42f369e8945210c2fb.1639156389.git.skhan@linuxfoundation.org>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <e86b9f3a050a919b90a41e42f369e8945210c2fb.1639156389.git.skhan@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/12/2021 18:33, Shuah Khan wrote:
> ARRAY_SIZE is defined in several selftests. Remove definitions from
> individual test files and include header file for the define instead.
> ARRAY_SIZE define is added in a separate patch to prepare for this
> change.
> 
> Remove ARRAY_SIZE from common.h and pickup the one defined in
> kselftest.h.
> 
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>

Acked-by: Mickaël Salaün <mic@digikod.net>

> ---
>   tools/testing/selftests/landlock/common.h | 4 ----
>   1 file changed, 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/landlock/common.h b/tools/testing/selftests/landlock/common.h
> index 20e2a9286d71..183b7e8e1b95 100644
> --- a/tools/testing/selftests/landlock/common.h
> +++ b/tools/testing/selftests/landlock/common.h
> @@ -17,10 +17,6 @@
>   
>   #include "../kselftest_harness.h"
>   
> -#ifndef ARRAY_SIZE
> -#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
> -#endif
> -
>   /*
>    * TEST_F_FORK() is useful when a test drop privileges but the corresponding
>    * FIXTURE_TEARDOWN() requires them (e.g. to remove files from a directory
> 
