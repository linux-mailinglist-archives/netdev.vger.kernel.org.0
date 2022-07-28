Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B987F58482D
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 00:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbiG1WXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 18:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiG1WXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 18:23:01 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E98C7969B
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 15:23:00 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-10e634ecfe6so4030715fac.8
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 15:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=kf8Wo1qfu2+CQ1SQGSzPm2rvNZg0Jk9UVDyWQ77rJZ8=;
        b=CkZGKKMzXY/A5DXjoZea5/mne56kl1rkUaM1q00KOFEFgf3OoktXlHpINKfWYnvvOH
         bsl3FzSY34cOpwe9XbRKcnE8jgyPZFOrnO10+sexxUW/2eD3tLdKopiHoZKRUYzoXQNE
         8Qrsm/SOQEr3qUOeYJJ8PCQQMA6RIfHp8aEAEYBn2grqeBrjWDp87Mgh35TJ4wRnC6jP
         S0wO/upn29le6OsETgnG4aRK08643Jqr4grG8XKdpr43ThdD+kFknvHIpGMidMKU3Wap
         3lKaRAxiIHE6ziOIzqCj83QIdon3AP51Lc1zzjMGFvkvvXvBvFyITJ4qJxr0IPEU8pKC
         f0Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kf8Wo1qfu2+CQ1SQGSzPm2rvNZg0Jk9UVDyWQ77rJZ8=;
        b=RW6MHgbJZMc/+Chrq0iFFuK1BGUovu56hl5O/zN9nC6fmtlOYq8oeVDG5LaWQVIUdU
         We0WgHs2bAFT0YMkwaa0h/mHYmNyjd/gScFzKNMwi8QTySJ3Ze8R3raPkU3BOob9RX+5
         A/HSdHAlBAbyjweAkM36bKgWqsQWjlrd9zDc4I3vyYVg9klFhBI50VuHsM4FWehIKgFg
         7iqUiJt85deJqraoukxKVyTSmV0x0c6x10IRMK/5dPjmZwKSMo9AV8MGnoYZZs9ewC0M
         8f1ChBB4x9ZbXu0dan/8RHpkozcKHFS7Ky8HcwzAesGjtpaxjTo+ypWsq2+cTXWFYi2J
         Czqw==
X-Gm-Message-State: AJIora8LINbb0AtZS3YN72Ol2Y9AOK39ew9b/0VCjQfHEMSNF5FF4Ku8
        lfV6drWywomYo5QOUcfQyJ16DW2MTvY=
X-Google-Smtp-Source: AGRyM1vYr+DjAVbUTgJfgvhP753iLwOcOCzu/sT4dxZktXeMoa98Mn4ivrrVShAjX8zyWQxuu3oCbA==
X-Received: by 2002:a05:6870:8914:b0:106:9d06:fe63 with SMTP id i20-20020a056870891400b001069d06fe63mr753807oao.103.1659046979652;
        Thu, 28 Jul 2022 15:22:59 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:b47e:4ea2:2c6e:1224? ([2601:282:800:dc80:b47e:4ea2:2c6e:1224])
        by smtp.googlemail.com with ESMTPSA id m13-20020aca1e0d000000b0033ae9904ad8sm726341oic.54.2022.07.28.15.22.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 15:22:59 -0700 (PDT)
Message-ID: <4cc470f9-cfed-a121-ccd0-0ba8673ad47d@gmail.com>
Date:   Thu, 28 Jul 2022 16:22:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH iproute-next v3 2/3] lib: Introduce ppp protocols
Content-Language: en-US
To:     Wojciech Drewek <wojciech.drewek@intel.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, gnault@redhat.com
References: <20220728110117.492855-1-wojciech.drewek@intel.com>
 <20220728110117.492855-3-wojciech.drewek@intel.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220728110117.492855-3-wojciech.drewek@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/28/22 5:01 AM, Wojciech Drewek wrote:
> diff --git a/include/uapi/linux/ppp_defs.h b/include/uapi/linux/ppp_defs.h
> new file mode 100644
> index 000000000000..0013dc77e3b9
> --- /dev/null
> +++ b/include/uapi/linux/ppp_defs.h
> @@ -0,0 +1,37 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/*
> + * ppp_defs.h - PPP definitions.
> + *
> + * Copyright 1994-2000 Paul Mackerras.
> + *
> + *  This program is free software; you can redistribute it and/or
> + *  modify it under the terms of the GNU General Public License
> + *  version 2 as published by the Free Software Foundation.
> + */
> +
> +/*
> + * Protocol field values.
> + */
> +#define PPP_IP		0x21	/* Internet Protocol */
> +#define PPP_AT		0x29	/* AppleTalk Protocol */
> +#define PPP_IPX		0x2b	/* IPX protocol */
> +#define	PPP_VJC_COMP	0x2d	/* VJ compressed TCP */
> +#define	PPP_VJC_UNCOMP	0x2f	/* VJ uncompressed TCP */
> +#define PPP_MP		0x3d	/* Multilink protocol */
> +#define PPP_IPV6	0x57	/* Internet Protocol Version 6 */
> +#define PPP_COMPFRAG	0xfb	/* fragment compressed below bundle */
> +#define PPP_COMP	0xfd	/* compressed packet */
> +#define PPP_MPLS_UC	0x0281	/* Multi Protocol Label Switching - Unicast */
> +#define PPP_MPLS_MC	0x0283	/* Multi Protocol Label Switching - Multicast */
> +#define PPP_IPCP	0x8021	/* IP Control Protocol */
> +#define PPP_ATCP	0x8029	/* AppleTalk Control Protocol */
> +#define PPP_IPXCP	0x802b	/* IPX Control Protocol */
> +#define PPP_IPV6CP	0x8057	/* IPv6 Control Protocol */
> +#define PPP_CCPFRAG	0x80fb	/* CCP at link level (below MP bundle) */
> +#define PPP_CCP		0x80fd	/* Compression Control Protocol */
> +#define PPP_MPLSCP	0x80fd	/* MPLS Control Protocol */
> +#define PPP_LCP		0xc021	/* Link Control Protocol */
> +#define PPP_PAP		0xc023	/* Password Authentication Protocol */
> +#define PPP_LQR		0xc025	/* Link Quality Report protocol */
> +#define PPP_CHAP	0xc223	/* Cryptographic Handshake Auth. Protocol */
> +#define PPP_CBCP	0xc029	/* Callback Control Protocol */

uapi files are perioodically synced from kernel releases. This is a new
one, so I pulled in the file from the point of last headers sync. The
API file from that sync causes compile errors. Please rebase to top of
iproute2-next tree.
