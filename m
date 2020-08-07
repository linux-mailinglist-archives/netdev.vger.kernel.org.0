Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5A823F022
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 17:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgHGPow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 11:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgHGPow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 11:44:52 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004AAC061756
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 08:44:51 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id w9so1584650qts.6
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 08:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i9MI5WD8QXnjwjuOwIRxNvj1haqFzCmN75Kmzvm18do=;
        b=gnFd/jdXqPNQAkoY1IVtql7gLqMDkKHn+otTkgo04QmwvI1xjhTAfYROY//6ad5Q9a
         vfZfpzoVPkiY5+sKKjplCjjNd+C6BUjiBcLDWMOseT8UvONQD/KTYA+GZPxDG/rKJm0k
         qfo6bLDvggkIxNJWHk6fE6snMn2I/+UnamqAlCxGHiiRsmpqfnb+VQHR3xWMLkFZpjv+
         61/d/0wzFVGo7vKg3W7tybpE37u4GJaDWsd2HvB2oxoUjOkv22vQxPaSC+Sw6hDMmfU3
         j2Xs9qP65GhJu23jJt0y18p6me7v/GjKqDydt0fbqby9lz30Sh5ydmpUHdQkfcA/1iK0
         PfrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i9MI5WD8QXnjwjuOwIRxNvj1haqFzCmN75Kmzvm18do=;
        b=AHqAl9Me8uj9xE/fJcl2RKFmX/+gheYgcm/1+dVNqbjwjpl2qr8WVeoriKGbd+cixE
         grEPQXDjBlt0wkE7MQs+QHoTYgrQo/8ILnQ4OlFDca4zBHRDKUJKsdA9/fGVBez9Sx5F
         gjoSBUH3E4ZWYEF7KlNiMHyzDP5zBVJbeS3kJ54PIGviXXw0vGKBzih3c5xrSbyvFvl7
         QuHuzWAKFEaSRVoBHd8wJJr6OemQdBlO9vb3vPbv+jB0Kr8XkssOCLoZE4di2OsKI54X
         2DDt+ciQewY5anZlYWyQQcj41AZD/p1xPz2q3AC0uyFoj0gNrJbZ5C7wrnPKzIqcf5mV
         6XYg==
X-Gm-Message-State: AOAM532Lb53KIUC6aWxpWysesXHSRFcKYs7nqOaJ32evtgby5REe3TYX
        EH+y1X5pQbFVy7Q+ciSVJdB4+jqAdck=
X-Google-Smtp-Source: ABdhPJzyhhLDXQ+uob/lqGbz3nEeD8rcljSyQarX85FmfnziSQANQo4v9BvYa02xshpodaI+rfuu+w==
X-Received: by 2002:aed:2041:: with SMTP id 59mr15036220qta.225.1596815090989;
        Fri, 07 Aug 2020 08:44:50 -0700 (PDT)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-06-184-148-45-213.dsl.bell.ca. [184.148.45.213])
        by smtp.googlemail.com with ESMTPSA id t127sm7401322qkc.100.2020.08.07.08.44.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2020 08:44:50 -0700 (PDT)
Subject: Re: rcu build on bug
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <bccd2311-79fa-9d88-3c10-067c2438574d@mojatatu.com>
Message-ID: <a98e1686-6212-45b2-8ede-7c7357999d6d@mojatatu.com>
Date:   Fri, 7 Aug 2020 11:44:49 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <bccd2311-79fa-9d88-3c10-067c2438574d@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

More clarification - this:

---
diff --git a/net/sched/cls_fw.c b/net/sched/cls_fw.c
index ec945294626a..06510c8c8281 100644
--- a/net/sched/cls_fw.c
+++ b/net/sched/cls_fw.c
@@ -22,12 +22,12 @@
  #include <net/pkt_cls.h>
  #include <net/sch_generic.h>

-#define HTSIZE 256
+#define HTSIZE 4096

  struct fw_head {
+       struct rcu_head         rcu;
         u32                     mask;
         struct fw_filter __rcu  *ht[HTSIZE];
-       struct rcu_head         rcu;
  };
----

Does not fix it..


cheers,
jamal

On 2020-08-07 11:16 a.m., Jamal Hadi Salim wrote:
> 
> Made this small change:
> 
> ------
> diff --git a/net/sched/cls_fw.c b/net/sched/cls_fw.c
> index ec945294626a..75d43ed10cd8 100644
> --- a/net/sched/cls_fw.c
> +++ b/net/sched/cls_fw.c
> @@ -22,7 +22,7 @@
>   #include <net/pkt_cls.h>
>   #include <net/sch_generic.h>
> 
> -#define HTSIZE 256
> +#define HTSIZE 4096
> 
>   struct fw_head {
>          u32                     mask;
> ---------
> 
> Generated compile errors as follows:
> 
> ------------
>    DESCEND  objtool
>    CALL    scripts/atomic/check-atomics.sh
>    CALL    scripts/checksyscalls.sh
>    CHK     include/generated/compile.h
>    CC      net/sched/cls_fw.o
> In file included from ./include/linux/export.h:43:0,
>                   from ./include/linux/linkage.h:7,
>                   from ./include/linux/kernel.h:8,
>                   from ./include/linux/list.h:9,
>                   from ./include/linux/module.h:12,
>                   from net/sched/cls_fw.c:13:
> net/sched/cls_fw.c: In function ‘fw_destroy’:
> ./include/linux/compiler.h:392:38: error: call to 
> ‘__compiletime_assert_415’ declared with attribute error: BUILD_BUG_ON 
> failed: !__is_kfree_rcu_offset(__builtin_offsetof(typeof(*(head)), rcu))
>    _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>                                        ^
> ./include/linux/compiler.h:373:4: note: in definition of macro 
> ‘__compiletime_assert’
>      prefix ## suffix();    \
>      ^~~~~~
> ./include/linux/compiler.h:392:2: note: in expansion of macro 
> ‘_compiletime_assert’
>    _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>    ^~~~~~~~~~~~~~~~~~~
> ./include/linux/build_bug.h:39:37: note: in expansion of macro 
> ‘compiletime_assert’
>   #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>                                       ^~~~~~~~~~~~~~~~~~
> ./include/linux/build_bug.h:50:2: note: in expansion of macro 
> ‘BUILD_BUG_ON_MSG’
>    BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
>    ^~~~~~~~~~~~~~~~
> ./include/linux/rcupdate.h:840:3: note: in expansion of macro 
> ‘BUILD_BUG_ON’
>     BUILD_BUG_ON(!__is_kfree_rcu_offset(offset)); \
>     ^~~~~~~~~~~~
> ./include/linux/rcupdate.h:875:3: note: in expansion of macro ‘__kfree_rcu’
>     __kfree_rcu(&((___p)->rhf), offsetof(typeof(*(ptr)), rhf)); \
>     ^~~~~~~~~~~
> net/sched/cls_fw.c:151:2: note: in expansion of macro ‘kfree_rcu’
>    kfree_rcu(head, rcu);
>    ^~~~~~~~~
> scripts/Makefile.build:280: recipe for target 'net/sched/cls_fw.o' failed
> make[2]: *** [net/sched/cls_fw.o] Error 1
> scripts/Makefile.build:497: recipe for target 'net/sched' failed
> make[1]: *** [net/sched] Error 2
> Makefile:1771: recipe for target 'net' failed
> make: *** [net] Error 2
> make: *** Waiting for unfinished jobs....
> 
> ----------------
> 
> Gets fixed if i reduce the hash buckets of course.
> Looking at include/linux/rcupdate.h I see:
> 
> ------
> /*
>   * Does the specified offset indicate that the corresponding rcu_head
>   * structure can be handled by kfree_rcu()?
>   */
> #define __is_kfree_rcu_offset(offset) ((offset) < 4096)
> 
> ------
> 
> I am guessing the hash table got too large.
> Smells like hard coded expectation?
> 
> How to fix?
> 
> cheers,
> jamal

