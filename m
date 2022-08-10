Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC6458E7E4
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 09:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbiHJHg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 03:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiHJHg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 03:36:28 -0400
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCCB06A4B8;
        Wed, 10 Aug 2022 00:36:27 -0700 (PDT)
Received: by mail-wm1-f41.google.com with SMTP id a11so7356695wmq.3;
        Wed, 10 Aug 2022 00:36:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=eJBkzOrmLOIDc79l2XYc3mJAo9MM8wnZ1YSqg5TWx9o=;
        b=oIOQ0bKPExWnUNtP3lcpXyP7kn2UFnNx7cr5Pw8obZCPvWs/kh3gEQVarasX78LBMa
         wHf53uiERT/niEl36koz3VcV5qUcvx16Oli/QjF73YQGhmPFVBo2teB0Uah1MAhiwE/H
         j6Mti1zZefsOOiBJS0mM00dCez0/+Kc7uXb00iM+MvbKaC7HNjNSwZzVpXFDYCYQfGQG
         774BzLZYwtSj61VktpdADx+GJv6sW9j2pjzRl+Ggu8Z2g0dLoAIwQ3hFRizxZ8mu/mF5
         pihzhahUZahuCjs6uidpyJWjMfXJEd35JgkhJkKctCopOlzGtKjUoQ+cNctJ5fw8USH/
         foGA==
X-Gm-Message-State: ACgBeo3HoQ6z8DRMjPsHfmT0xrIwJt0LAuAfs/cnA7Y6fFsgBbbm423F
        Xo34wy+bx2UPIKT8LGaHRNo=
X-Google-Smtp-Source: AA6agR6ylREFulxvOxgaDyFkAmvie2x1L33dS/ekhMOxj4MO3YvHtCuJRDWsjpmkPh/ogLm0hwQn7w==
X-Received: by 2002:a05:600c:1d0b:b0:3a5:5035:28a8 with SMTP id l11-20020a05600c1d0b00b003a5503528a8mr1474658wms.114.1660116986315;
        Wed, 10 Aug 2022 00:36:26 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id g6-20020a5d5406000000b0021e491fd250sm15691631wrv.89.2022.08.10.00.36.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 00:36:25 -0700 (PDT)
Message-ID: <8576aef3-37e4-8bae-bab5-08f82a78efd3@kernel.org>
Date:   Wed, 10 Aug 2022 09:36:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH net-next 3/6] net: atm: remove support for ZeitNet ZN122x
 ATM devices
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org, arnd@arndb.de
References: <20220426175436.417283-1-kuba@kernel.org>
 <20220426175436.417283-4-kuba@kernel.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220426175436.417283-4-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26. 04. 22, 19:54, Jakub Kicinski wrote:
> This driver received nothing but automated fixes in the last 15 years.
> Since it's using virt_to_bus it's unlikely to be used on any modern
> platform.
...
>   delete mode 100644 include/uapi/linux/atm_zatm.h

This unfortunately breaks linux-atm:
zntune.c:18:10: fatal error: linux/atm_zatm.h: No such file or directory

The source does also:
ioctl(s,ZATM_SETPOOL,&sioc)
ioctl(s,zero ? ZATM_GETPOOLZ : ZATM_GETPOOL,&sioc)
etc.

So we should likely revert the below:

> --- a/include/uapi/linux/atm_zatm.h
> +++ /dev/null
> @@ -1,47 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> -/* atm_zatm.h - Driver-specific declarations of the ZATM driver (for use by
> -		driver-specific utilities) */
> -
> -/* Written 1995-1999 by Werner Almesberger, EPFL LRC/ICA */
> -
> -
> -#ifndef LINUX_ATM_ZATM_H
> -#define LINUX_ATM_ZATM_H
> -
> -/*
> - * Note: non-kernel programs including this file must also include
> - * sys/types.h for struct timeval
> - */
> -
> -#include <linux/atmapi.h>
> -#include <linux/atmioc.h>
> -
> -#define ZATM_GETPOOL	_IOW('a',ATMIOC_SARPRV+1,struct atmif_sioc)
> -						/* get pool statistics */
> -#define ZATM_GETPOOLZ	_IOW('a',ATMIOC_SARPRV+2,struct atmif_sioc)
> -						/* get statistics and zero */
> -#define ZATM_SETPOOL	_IOW('a',ATMIOC_SARPRV+3,struct atmif_sioc)
> -						/* set pool parameters */
> -
> -struct zatm_pool_info {
> -	int ref_count;			/* free buffer pool usage counters */
> -	int low_water,high_water;	/* refill parameters */
> -	int rqa_count,rqu_count;	/* queue condition counters */
> -	int offset,next_off;		/* alignment optimizations: offset */
> -	int next_cnt,next_thres;	/* repetition counter and threshold */
> -};
> -
> -struct zatm_pool_req {
> -	int pool_num;			/* pool number */
> -	struct zatm_pool_info info;	/* actual information */
> -};
> -
> -#define ZATM_OAM_POOL		0	/* free buffer pool for OAM cells */
> -#define ZATM_AAL0_POOL		1	/* free buffer pool for AAL0 cells */
> -#define ZATM_AAL5_POOL_BASE	2	/* first AAL5 free buffer pool */
> -#define ZATM_LAST_POOL	ZATM_AAL5_POOL_BASE+10 /* max. 64 kB */
> -
> -#define ZATM_TIMER_HISTORY_SIZE	16	/* number of timer adjustments to
> -					   record; must be 2^n */
> -
> -#endif

thanks,
-- 
js
suse labs

