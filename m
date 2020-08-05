Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D0F23D446
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 01:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgHEXvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 19:51:42 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:59777 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725969AbgHEXvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 19:51:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596671499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ymAmVIHHL+Dhhj1h1m9JWFZK2nhEhBDWELf2pfbLxZ0=;
        b=gVcEk7MehsVmMU7RE4kh93agO0J2ylBzUtbiufEcoQC3zEG5VkHE6qaIX7ZbXg3FOYt1YB
        5NNIfhytpA0W5DsWfhg3F27Oh7YhOcarDUcbaeDzOGp/RrWt92xnJbT1M3HF9Ol2sqeNFd
        XdQaWjY6GhjFLuhYYPNAXcUSsDVm7Os=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-D-Fj4btsNxCRB5TlqNKSRg-1; Wed, 05 Aug 2020 19:51:25 -0400
X-MC-Unique: D-Fj4btsNxCRB5TlqNKSRg-1
Received: by mail-wm1-f69.google.com with SMTP id v8so3021961wma.6
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 16:51:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ymAmVIHHL+Dhhj1h1m9JWFZK2nhEhBDWELf2pfbLxZ0=;
        b=WeYqqIUynOyMhzl0gId/o+WuX1GHQf4IpZ/ruUi4MKMgu/tO+s6/GZV8l9CpM8zxJh
         Z9wq8xAUgySqLX/X6Tqg7ToyKFjBIV1U/N2SlJ8KlEwXCvH1DWS2Cob0t+W8NgZN6sqk
         aiQoEp5XnUlxXFj5udyuuO7aSKuQWom7ZSDHnwt8eklRsPoXzuVdy5pmeqdzTzb+TxqI
         KCTzDj++q/DjPLkTQahX95QqziTe/X2jjDX4mkKHpTbAwGgLvRjqDDKfHpGSRU/e3JqJ
         vZIZW31nlrAWY640ua7+SvDL5P9radK0+zhLmKYstGJotzNmuXXyfA0O60xzb5y6wrFq
         AJVA==
X-Gm-Message-State: AOAM533iJquJjMG1UBDAvRWsUGhD63lL7zOfYXwd5Vbl6f3a0/a0mcP7
        4SLdVNrViqtdZb/FGHk8QTbCRauYROMWKaiK+BtCP+8tpCKN0cKWqZVStO1sQ+11EmnBt/2vhXo
        o35cmjk9+JQ22EhIh
X-Received: by 2002:a1c:7e44:: with SMTP id z65mr5641568wmc.13.1596671483705;
        Wed, 05 Aug 2020 16:51:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhju1ve0kkpCATUrgTYIgXrE3GBjo7F/ffCZhO4W/DdC3nDfToWjShQ/n9PBezQv2u+xI/jA==
X-Received: by 2002:a1c:7e44:: with SMTP id z65mr5641553wmc.13.1596671483427;
        Wed, 05 Aug 2020 16:51:23 -0700 (PDT)
Received: from redhat.com (bzq-79-177-102-128.red.bezeqint.net. [79.177.102.128])
        by smtp.gmail.com with ESMTPSA id v15sm4525545wrm.23.2020.08.05.16.51.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 16:51:22 -0700 (PDT)
Date:   Wed, 5 Aug 2020 19:51:19 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     kernel test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [vhost:vhost 32/52] include/linux/typecheck.h:12:18: warning:
 comparison of distinct pointer types lacks a cast
Message-ID: <20200805190937-mutt-send-email-mst@kernel.org>
References: <202008060456.M9GRXltb%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202008060456.M9GRXltb%lkp@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 06, 2020 at 04:17:13AM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost
> head:   4c05433bc6fb4ae172270f0279be8ba89a3da64f
> commit: b025584098e621d88894d28e80af686958e273af [32/52] virtio_input: convert to LE accessors
> config: parisc-randconfig-r003-20200805 (attached as .config)
> compiler: hppa-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout b025584098e621d88894d28e80af686958e273af
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=parisc 

Weird. So the following fixes it:


diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index ecb166c824bb..8fe857e27ef3 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -357,10 +357,10 @@ static inline __virtio64 cpu_to_virtio64(struct virtio_device *vdev, u64 val)
  */
 #define virtio_le_to_cpu(x) \
 	_Generic((x), \
-		__u8: (x), \
-		 __le16: le16_to_cpu(x), \
-		 __le32: le32_to_cpu(x), \
-		 __le64: le64_to_cpu(x) \
+		__u8: (u8)(x), \
+		 __le16: (u16)le16_to_cpu(x), \
+		 __le32: (u32)le32_to_cpu(x), \
+		 __le64: (u64)le64_to_cpu(x) \
 		)
 
 #define virtio_cpu_to_le(x, m) \
@@ -400,7 +400,6 @@ static inline __virtio64 cpu_to_virtio64(struct virtio_device *vdev, u64 val)
 		*(ptr) = virtio_le_to_cpu(virtio_cread_v);		\
 	} while(0)
 
-/* Config space accessors. */
 #define virtio_cwrite_le(vdev, structname, member, ptr)			\
 	do {								\
 		typeof(((structname*)0)->member) virtio_cwrite_v =	\


How could this be? le16_to_cpu doesn't return a u16?
I suspect this compiler gets confused by _Generic.
Let's hope it does not also miscompile the code :)


> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>    In file included from include/linux/irqflags.h:15,
>                     from include/asm-generic/cmpxchg-local.h:6,
>                     from arch/parisc/include/asm/cmpxchg.h:89,
>                     from arch/parisc/include/asm/atomic.h:10,
>                     from include/linux/atomic.h:7,
>                     from arch/parisc/include/asm/bitops.h:13,
>                     from include/linux/bitops.h:29,
>                     from include/linux/kernel.h:12,
>                     from include/linux/list.h:9,
>                     from include/linux/module.h:12,
>                     from drivers/virtio/virtio_input.c:2:
>    drivers/virtio/virtio_input.c: In function 'virtinput_probe':
> >> include/linux/typecheck.h:12:18: warning: comparison of distinct pointer types lacks a cast
>       12 |  (void)(&__dummy == &__dummy2); \
>          |                  ^~
>    include/linux/virtio_config.h:405:3: note: in expansion of macro 'typecheck'
>      405 |   typecheck(typeof(virtio_le_to_cpu(virtio_cread_v)), *(ptr)); \
>          |   ^~~~~~~~~
>    drivers/virtio/virtio_input.c:247:3: note: in expansion of macro 'virtio_cread_le'
>      247 |   virtio_cread_le(vi->vdev, struct virtio_input_config,
>          |   ^~~~~~~~~~~~~~~
> >> include/linux/typecheck.h:12:18: warning: comparison of distinct pointer types lacks a cast
>       12 |  (void)(&__dummy == &__dummy2); \
>          |                  ^~
>    include/linux/virtio_config.h:405:3: note: in expansion of macro 'typecheck'
>      405 |   typecheck(typeof(virtio_le_to_cpu(virtio_cread_v)), *(ptr)); \
>          |   ^~~~~~~~~
>    drivers/virtio/virtio_input.c:249:3: note: in expansion of macro 'virtio_cread_le'
>      249 |   virtio_cread_le(vi->vdev, struct virtio_input_config,
>          |   ^~~~~~~~~~~~~~~
> >> include/linux/typecheck.h:12:18: warning: comparison of distinct pointer types lacks a cast
>       12 |  (void)(&__dummy == &__dummy2); \
>          |                  ^~
>    include/linux/virtio_config.h:405:3: note: in expansion of macro 'typecheck'
>      405 |   typecheck(typeof(virtio_le_to_cpu(virtio_cread_v)), *(ptr)); \
>          |   ^~~~~~~~~
>    drivers/virtio/virtio_input.c:251:3: note: in expansion of macro 'virtio_cread_le'
>      251 |   virtio_cread_le(vi->vdev, struct virtio_input_config,
>          |   ^~~~~~~~~~~~~~~
> >> include/linux/typecheck.h:12:18: warning: comparison of distinct pointer types lacks a cast
>       12 |  (void)(&__dummy == &__dummy2); \
>          |                  ^~
>    include/linux/virtio_config.h:405:3: note: in expansion of macro 'typecheck'
>      405 |   typecheck(typeof(virtio_le_to_cpu(virtio_cread_v)), *(ptr)); \
>          |   ^~~~~~~~~
>    drivers/virtio/virtio_input.c:253:3: note: in expansion of macro 'virtio_cread_le'
>      253 |   virtio_cread_le(vi->vdev, struct virtio_input_config,
>          |   ^~~~~~~~~~~~~~~
> 
> vim +12 include/linux/typecheck.h
> 
> e0deaff470900a4 Andrew Morton 2008-07-25   4  
> e0deaff470900a4 Andrew Morton 2008-07-25   5  /*
> e0deaff470900a4 Andrew Morton 2008-07-25   6   * Check at compile time that something is of a particular type.
> e0deaff470900a4 Andrew Morton 2008-07-25   7   * Always evaluates to 1 so you may use it easily in comparisons.
> e0deaff470900a4 Andrew Morton 2008-07-25   8   */
> e0deaff470900a4 Andrew Morton 2008-07-25   9  #define typecheck(type,x) \
> e0deaff470900a4 Andrew Morton 2008-07-25  10  ({	type __dummy; \
> e0deaff470900a4 Andrew Morton 2008-07-25  11  	typeof(x) __dummy2; \
> e0deaff470900a4 Andrew Morton 2008-07-25 @12  	(void)(&__dummy == &__dummy2); \
> e0deaff470900a4 Andrew Morton 2008-07-25  13  	1; \
> e0deaff470900a4 Andrew Morton 2008-07-25  14  })
> e0deaff470900a4 Andrew Morton 2008-07-25  15  
> 
> :::::: The code at line 12 was first introduced by commit
> :::::: e0deaff470900a4c3222ca7139f6c9639e26a2f5 split the typecheck macros out of include/linux/kernel.h
> 
> :::::: TO: Andrew Morton <akpm@linux-foundation.org>
> :::::: CC: Linus Torvalds <torvalds@linux-foundation.org>
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org


