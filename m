Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1884A267BDE
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 21:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbgILTJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 15:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgILTJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 15:09:00 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48FE4C061573;
        Sat, 12 Sep 2020 12:09:00 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id j2so14581959wrx.7;
        Sat, 12 Sep 2020 12:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:subject:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=labASIF6Wre/cXQvKfjYCXDRP6DOsFHpdaYy5v7UYPg=;
        b=Q1o+4R+2XZALoz0FokjaN/JMR8blv2zhs3pByxfj7mgUQnDU3dzAbMoYQAuy3ptWOm
         46udDg564U2qShSyrT1U+tpvpgVIUtgK/8jfc5O5nsmx41/y6cN+QUVw77V6Ct3/LDtA
         ezeQGeXAjJ2fi9hP7olAaLt79F7yjMZrSSBfCjFjL62MkvFzdvPqdnpWhSl7n2gw1slT
         2yfcFR/wcFx7uZj+aUzL/BqVsz8oBx0l31+S4Z/3TRUPf7ezOEme849ZLyqH5di5Uh96
         j+KXzScAmOCfV3HHmaU4muC5S9o6Bp6JBcFj7wh7QfnQ5j0a4dKU8zA6+Q7pkhfq+M64
         yrXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:subject:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=labASIF6Wre/cXQvKfjYCXDRP6DOsFHpdaYy5v7UYPg=;
        b=FyAjuhDqnlex074PDYF32Wq3EGAPAaKAxGzhF0+lIHNioGuIoxgaN7g5IxD+S7t3rw
         jV86rWvwzvWpLshRGgJaI3BosqOUht5AHnHO2K0YvYRnMfOs1RYKwYv72lcwTx5H1xIR
         qT//mwU7bLnUYL9tDwRaWw348x6qBWsdm8AMAfCgTba+CU8tXHk9mkQjuJPkbrZxcQXq
         VZjLqsOT12u4A84J41K7mwexfYoZzMnuDnI3Rebnxe8ZcAzSHfCRkaX1E2SpVkGAPz23
         0tt9MxsgaaN4j0wD6Rh9QueZuMz+lH4hzgb56TN89fGUCWF2niWJDNEVItpj6WWr8G9n
         a3SQ==
X-Gm-Message-State: AOAM531ZaEi2mpozNO/iId8UoVDWqXrzlEB47Yq7pB+vdz9RqAMPKfKL
        lUwjIUtla5eXrj5KKA3sF2dUuc4VMr72UA==
X-Google-Smtp-Source: ABdhPJzVeZr11J9m/o2eTqlqoe8X6rnLyFn7NvmuMyO8uNTtzWvvJb0tCVTFQjLdOYIOc+nWpV/eJw==
X-Received: by 2002:a5d:4d48:: with SMTP id a8mr7778204wru.318.1599937738467;
        Sat, 12 Sep 2020 12:08:58 -0700 (PDT)
Received: from [192.168.0.160] ([93.115.133.118])
        by smtp.gmail.com with ESMTPSA id d18sm11623802wrm.10.2020.09.12.12.08.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Sep 2020 12:08:57 -0700 (PDT)
To:     torvalds@linux-foundation.org
Cc:     akpm@linux-foundation.org, davem@davemloft.net,
        johannes.berg@intel.com, linux-kernel@vger.kernel.org,
        lorenzo.bianconi83@gmail.com, netdev@vger.kernel.org
References: <CA+55aFzZe2buU-LxAktxYNojuvMbUNt64QiKDpGsfFwtrbf+Qg@mail.gmail.com>
Subject: Re: [GIT] Networking
From:   Alejandro Colomar <colomar.6.4.3@gmail.com>
Message-ID: <721c8a69-c697-7e97-6942-e5cb25d598e4@gmail.com>
Date:   Sat, 12 Sep 2020 21:08:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CA+55aFzZe2buU-LxAktxYNojuvMbUNt64QiKDpGsfFwtrbf+Qg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 3, 2015 at 11:31 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:

 >> [-Wsizeof-array-argument]

 > Ahh. Google shows that it's an old clang warning that gcc has recently
 > picked up.

 > But even clang doesn't seem to have any way for a project to say
 > "please warn about arrays in function argument declaration". It *is*
 > very traditional idiomatic C, it's just that I personally think it's
 > one of those bad traditional C things exactly because it's so
 > misleading about what actually goes on. But I guess that in practice,
 > the only thing that it actually *affects* is "sizeof" (and assignment
 > to the variable name - something that would be invalid for a real
 > array, but works on argument arrays because they are really just
 > pointers).

 > The "array as function argument" syntax is occasionally useful
 > (particularly for the multi-dimensional array case), so I very much
 > understand why it exists, I just think that in the kernel we'd be
 > better off with the rule that it's against our coding practices.

 >                   Linus


Hi Linus,

First of all, this is my first message to this mailing list, and I'm
trying to reply to a very old thread, so sorry if I don't know how/if I
should do it.

I have a different approach in my code to avoid that whole class of bugs
relating sizeof and false arrays in function argument declarations.
I do like the sintactic sugar that they provide, so I decided to ban
"sizeof(array)" completely off my code.

I have developed the following macro:

#define ARRAY_BYTES(arr)	(sizeof((arr)[0]) * ARRAY_SIZE(arr))

which compiles to a simple "sizeof(arr)" by undoing the division in
"ARRAY_SIZE()", but with the added benefit that it checks that the
argument is an array (due to "ARRAY_SIZE()"), and if not, compilation
breaks which means that the array is not an array but a pointer.

My rules are:

  - Size of an array (number of elements):
	ARRAY_SIZE(arr)
  - Signed size of an array (normally for loops where I compare against a
  signed variable):
	ARRAY_SSIZE(arr)	defined as: ((ptrdiff_t)ARRAY_SIZE(arr))
  - Size of an array in bytes (normally for buffers):
	ARRAY_BYTES(arr)

No use of "sizeof" is allowed for arrays, which completely rules
out bugs of that class, because I never pass an array to "sizeof", which
is the core of the problem.  I've been using those macros in my code for
more than a year, and they work really nice.

I propose to include the macro "ARRAY_BYTES()" in <linux/kernel.h> just
after "ARRAY_SIZE()" and replace every appearance of "sizeof(array)" in
Linux by "ARRAY_BYTES(array)", and modify the coding style guide to ban
"sizeof(array)" completely off the kernel.

Below are two patches:  one that adds the macro to
<linux/kernel.h>, and another one that serves as an example of usage
for the macro (that one is just as an example).

I don't intend those patches to be applied directly, but instead to
be an example of what I mean.  If you think the change is good, then
I'll prepare a big patch set for all of the appearances of sizeof()
that are unsafe :)


Cheers,

		Alex.

------------------------------------------------------------------------
Please CC me <colomar.6.4.3@gmail.com> in any response to this thread.

 From b5b674d39b28e703300698fa63e4ab4be646df8f Mon Sep 17 00:00:00 2001
From: Alejandro Colomar <colomar.6.4.3@gmail.com>
Date: Sun, 5 Apr 2020 01:45:35 +0200
Subject: [PATCH 1/2] linux/kernel.h: add ARRAY_BYTES() macro

Signed-off-by: Alejandro Colomar <colomar.6.4.3@gmail.com>
---
  include/linux/kernel.h | 6 ++++++
  1 file changed, 6 insertions(+)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 9b7a8d74a9d6..dc806e2a7799 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -46,6 +46,12 @@
   */
  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) +
__must_be_array(arr))

+/**
+ * ARRAY_BYTES - get the number of bytes in array @arr
+ * @arr: array to be sized
+ */
+#define ARRAY_BYTES(arr)	(sizeof(arr) + __must_be_array(arr))
+
  #define u64_to_user_ptr(x) (		\
  {					\
  	typecheck(u64, (x));		\
-- 
2.25.1

------------------------------------------------------------------------
 From 3e7bcf70b708b51a7807c336c5d1b01403989d3b Mon Sep 17 00:00:00 2001
From: Alejandro Colomar <colomar.6.4.3@gmail.com>
Date: Sun, 5 Apr 2020 01:48:17 +0200
Subject: [PATCH 2/2] block, bfq: Use ARRAY_BYTES() for arrays instead of
  sizeof()

Signed-off-by: Alejandro Colomar <colomar.6.4.3@gmail.com>
---
  block/bfq-cgroup.c | 4 +++-
  1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 68882b9b8f11..51ba9b9a8855 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -7,6 +7,7 @@
  #include <linux/blkdev.h>
  #include <linux/cgroup.h>
  #include <linux/elevator.h>
+#include <linux/kernel.h>
  #include <linux/ktime.h>
  #include <linux/rbtree.h>
  #include <linux/ioprio.h>
@@ -794,7 +795,8 @@ void bfq_bic_update_cgroup(struct bfq_io_cq *bic,
struct bio *bio)
  	 * refcounter for bfqg, to let it disappear only after no
  	 * bfq_queue refers to it any longer.
  	 */
-	blkg_path(bfqg_to_blkg(bfqg), bfqg->blkg_path, sizeof(bfqg->blkg_path));
+	blkg_path(bfqg_to_blkg(bfqg), bfqg->blkg_path,
+						ARRAY_BYTES(bfqg->blkg_path));
  	bic->blkcg_serial_nr = serial_nr;
  out:
  	rcu_read_unlock();
-- 
2.25.1
