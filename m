Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDA46D1786
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 08:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbjCaGga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 02:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbjCaGgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 02:36:22 -0400
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE3E1CB99;
        Thu, 30 Mar 2023 23:36:10 -0700 (PDT)
Received: by mail-wm1-f41.google.com with SMTP id l37so12255334wms.2;
        Thu, 30 Mar 2023 23:36:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680244569; x=1682836569;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wVRK28F8t66eQgzQiWFaFHlySiQxtbYnfLhXT4Nm2bM=;
        b=5TeWYmTnUH5KPGkI7eGI+qPG+2Le9Y9BDOcBwcuUu3cFsuSjisuuYrMR9PfiGgcPY5
         p0JpERJJES9QgILDRDxyjZbouPRlcvaExtq07PQ9hk4/30XgADmW54PIVEFfb0U4HBEH
         j8pgbNb1QOuMt07V93wp7x6Nc4yfk/y0/Prtggf73TG+KVKOR4gVLOX+7JIYZjP5KAvm
         aJ3IXEGFEl9f+4l+mhsaZFQhRjqf4PF+y1HCH6Xlrd1TlV2XdatAtQ+71Q2CDk6VZ0ps
         2voTbPdvcDDFebAhkfZ+78OxB5KLg+BQ913wtWfCFV/cvyomuboUt7ljOYkTvArezVmW
         StJg==
X-Gm-Message-State: AAQBX9fLqkSWsSk79DjpEfMnZZ1ajXuKP4dcS62WcD54WK+OhDi+VS2/
        uV7JPurTiiVrrs8iU5XbRSc=
X-Google-Smtp-Source: AKy350akYslvfHinvqz0Lgx86UhTRwU0uCecW4U6pRonrAA7yO3WnSFBVQ6u6iVP8uNRzZHmW3Nzbg==
X-Received: by 2002:a1c:6a10:0:b0:3ef:63f9:c40d with SMTP id f16-20020a1c6a10000000b003ef63f9c40dmr15150696wmc.40.1680244568708;
        Thu, 30 Mar 2023 23:36:08 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:49? ([2a0b:e7c0:0:107::aaaa:49])
        by smtp.gmail.com with ESMTPSA id r16-20020a05600c35d000b003ee9f396dcesm8666159wmq.30.2023.03.30.23.36.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Mar 2023 23:36:08 -0700 (PDT)
Message-ID: <b26331de-da68-afd2-b895-14dd219902e3@kernel.org>
Date:   Fri, 31 Mar 2023 08:36:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] net: wwan: t7xx: do not compile with -Werror
Content-Language: en-US
To:     kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@linux.intel.com>,
        Liu Haijun <haijun.liu@mediatek.com>,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
References: <20230330232717.1f8bf5ea@kernel.org>
 <20230331063515.947-1-jirislaby@kernel.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20230331063515.947-1-jirislaby@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It should have been [PATCH v2] in the subject. Do you want me to resend?

On 31. 03. 23, 8:35, Jiri Slaby (SUSE) wrote:
> When playing with various compilers or their versions, some choke on
> the t7xx code. For example (with gcc 13):
>   In file included from ./arch/s390/include/generated/asm/rwonce.h:1,
>                    from ../include/linux/compiler.h:247,
>                    from ../include/linux/build_bug.h:5,
>                    from ../include/linux/bits.h:22,
>                    from ../drivers/net/wwan/t7xx/t7xx_state_monitor.c:17:
>   In function 'preempt_count',
>       inlined from 't7xx_fsm_append_event' at ../drivers/net/wwan/t7xx/t7xx_state_monitor.c:439:43:
>   ../include/asm-generic/rwonce.h:44:26: error: array subscript 0 is outside array bounds of 'const volatile int[0]' [-Werror=array-bounds=]
> 
> There is no reason for any code in the kernel to be built with -Werror
> by default. Note that we have generic CONFIG_WERROR. So if anyone wants
> -Werror, they can enable that.
> 
> Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
> Link: https://lore.kernel.org/all/20230330232717.1f8bf5ea@kernel.org/
> Cc: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Cc: Intel Corporation <linuxwwan@intel.com>
> Cc: Chiranjeevi Rapolu <chiranjeevi.rapolu@linux.intel.com>
> Cc: Liu Haijun <haijun.liu@mediatek.com>
> Cc: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> Cc: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Cc: Loic Poulain <loic.poulain@linaro.org>
> Cc: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: netdev@vger.kernel.org
> ---
> 
> Notes:
>      [v2] delete the line completely
> 
>   drivers/net/wwan/t7xx/Makefile | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/net/wwan/t7xx/Makefile b/drivers/net/wwan/t7xx/Makefile
> index 268ff9e87e5b..2652cd00504e 100644
> --- a/drivers/net/wwan/t7xx/Makefile
> +++ b/drivers/net/wwan/t7xx/Makefile
> @@ -1,7 +1,5 @@
>   # SPDX-License-Identifier: GPL-2.0-only
>   
> -ccflags-y += -Werror
> -
>   obj-${CONFIG_MTK_T7XX} := mtk_t7xx.o
>   mtk_t7xx-y:=	t7xx_pci.o \
>   		t7xx_pcie_mac.o \

-- 
js

