Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0134223EFDD
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 17:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbgHGPQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 11:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgHGPQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 11:16:17 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11EA9C061756
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 08:16:17 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id e5so1512364qth.5
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 08:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=VKTFLicl6xwpBXqd/t2kPesay6+ziGfwGcxr8GUT7jc=;
        b=HRkXh04ZIlT2QraAFZTl6QfQQW1rkt/XoVa+q7B/9kiD6cmahefid0Fw67WnCaNYUA
         ilqZU62wMaDgjmC4oc4362glWTRiYxZPn0bBt4YpoJAn7VDQTcfkAFE6Tg/zePNsGhWR
         Z+DXedE7uYSkWpscEwdRf9EkGh+SA74YKohrWoGNtDNWb8cmMufN8XqEt7FDq4thmh6r
         Vp6K+JR2JPUvwWjDMQXERBUrKQoJz9whtU+xbHL8r7xzPker8h8TfL+6X+ky8j7HhHXl
         MECFvfFJjYe5HRkCz6Nl6IrfONAJY+w1SgR1MChxM2NIQ2JTHZ2GcDVNJZhUjJKUV3Bq
         37/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=VKTFLicl6xwpBXqd/t2kPesay6+ziGfwGcxr8GUT7jc=;
        b=WZ6Kdu000PNvJRY08QEz+uDiHomHkDbsdCBgs7jDXBlIL0aHCf3TEs7WwBsgFE5fOX
         xj/eQGtWLxw9nbvtgYtHsXLxQSB4hAKUGgwXGSB+WLzgr4DlaEHGmiTBzC5XCx25eU6o
         PabubQS+Amlbxxp1BLFM7r2yEsU3Rol/0gymB6xcWbvDvQfDWnYjJkGzxGO0cB1Y9AX1
         +v7SPumEV3b6rCqAGdmrK22wtrYxQf1PoT2VePBZ//Bex1AukKqw2gBFLPHwFkzNBbUE
         FS2NhedSGGki7RTCR2YiRezB0+Fb8k/FrrIiRGOIOLslseIsJlDLFy7B6CvER/NevQ3p
         Pk0g==
X-Gm-Message-State: AOAM530HxLYjiHKCQaEpkY7At9vzZpYjh1XLjNfhGpaBQMZWDI/8mfCg
        v42INeMMJMMRmrRGwxOmIQ3aH50ARMg=
X-Google-Smtp-Source: ABdhPJxXTY6etxHTH7XFW7OR3v4AVE3iZ0cIUVKLS686H8zoVqHjH5C8Hp8FmZdT1nJVvVjgvwYeBQ==
X-Received: by 2002:ac8:71d6:: with SMTP id i22mr14418420qtp.371.1596813375260;
        Fri, 07 Aug 2020 08:16:15 -0700 (PDT)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-06-184-148-45-213.dsl.bell.ca. [184.148.45.213])
        by smtp.googlemail.com with ESMTPSA id d26sm8168287qtc.51.2020.08.07.08.16.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2020 08:16:14 -0700 (PDT)
To:     Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Subject: rcu build on bug
Message-ID: <bccd2311-79fa-9d88-3c10-067c2438574d@mojatatu.com>
Date:   Fri, 7 Aug 2020 11:16:13 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Made this small change:

------
diff --git a/net/sched/cls_fw.c b/net/sched/cls_fw.c
index ec945294626a..75d43ed10cd8 100644
--- a/net/sched/cls_fw.c
+++ b/net/sched/cls_fw.c
@@ -22,7 +22,7 @@
  #include <net/pkt_cls.h>
  #include <net/sch_generic.h>

-#define HTSIZE 256
+#define HTSIZE 4096

  struct fw_head {
         u32                     mask;
---------

Generated compile errors as follows:

------------
   DESCEND  objtool
   CALL    scripts/atomic/check-atomics.sh
   CALL    scripts/checksyscalls.sh
   CHK     include/generated/compile.h
   CC      net/sched/cls_fw.o
In file included from ./include/linux/export.h:43:0,
                  from ./include/linux/linkage.h:7,
                  from ./include/linux/kernel.h:8,
                  from ./include/linux/list.h:9,
                  from ./include/linux/module.h:12,
                  from net/sched/cls_fw.c:13:
net/sched/cls_fw.c: In function ‘fw_destroy’:
./include/linux/compiler.h:392:38: error: call to 
‘__compiletime_assert_415’ declared with attribute error: BUILD_BUG_ON 
failed: !__is_kfree_rcu_offset(__builtin_offsetof(typeof(*(head)), rcu))
   _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                                       ^
./include/linux/compiler.h:373:4: note: in definition of macro 
‘__compiletime_assert’
     prefix ## suffix();    \
     ^~~~~~
./include/linux/compiler.h:392:2: note: in expansion of macro 
‘_compiletime_assert’
   _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
   ^~~~~~~~~~~~~~~~~~~
./include/linux/build_bug.h:39:37: note: in expansion of macro 
‘compiletime_assert’
  #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                      ^~~~~~~~~~~~~~~~~~
./include/linux/build_bug.h:50:2: note: in expansion of macro 
‘BUILD_BUG_ON_MSG’
   BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
   ^~~~~~~~~~~~~~~~
./include/linux/rcupdate.h:840:3: note: in expansion of macro ‘BUILD_BUG_ON’
    BUILD_BUG_ON(!__is_kfree_rcu_offset(offset)); \
    ^~~~~~~~~~~~
./include/linux/rcupdate.h:875:3: note: in expansion of macro ‘__kfree_rcu’
    __kfree_rcu(&((___p)->rhf), offsetof(typeof(*(ptr)), rhf)); \
    ^~~~~~~~~~~
net/sched/cls_fw.c:151:2: note: in expansion of macro ‘kfree_rcu’
   kfree_rcu(head, rcu);
   ^~~~~~~~~
scripts/Makefile.build:280: recipe for target 'net/sched/cls_fw.o' failed
make[2]: *** [net/sched/cls_fw.o] Error 1
scripts/Makefile.build:497: recipe for target 'net/sched' failed
make[1]: *** [net/sched] Error 2
Makefile:1771: recipe for target 'net' failed
make: *** [net] Error 2
make: *** Waiting for unfinished jobs....

----------------

Gets fixed if i reduce the hash buckets of course.
Looking at include/linux/rcupdate.h I see:

------
/*
  * Does the specified offset indicate that the corresponding rcu_head
  * structure can be handled by kfree_rcu()?
  */
#define __is_kfree_rcu_offset(offset) ((offset) < 4096)

------

I am guessing the hash table got too large.
Smells like hard coded expectation?

How to fix?

cheers,
jamal
