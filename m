Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1E1B77881
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 13:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728839AbfG0LvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 07:51:20 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:32871 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfG0LvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 07:51:20 -0400
Received: by mail-pf1-f194.google.com with SMTP id g2so25743697pfq.0;
        Sat, 27 Jul 2019 04:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=i8GuTXVr9WWsDy7xmOlSHK3JnLYni7YF8DESUAMuRRE=;
        b=FL0GaRGd+ddhv6Zl4tN/3EqAoU4fTSKBmZZklZtCOspIhC4nY78wsia2ORaX5cejbi
         p+QyY7RiSoc6Xr5xahvQZ0BTgnFvahvLx3znIvuNUOPab5tcVF7JXV8BlO+dnTk/W9L6
         Tc38N7mNZ0ffaoT1oyHskfnEHIDcRd3GQT9ygE15GXwlpnZ2XbNhNgZbx4lZi18I0LW8
         P3+19FSCgpH7+XEZ/OxPxWxoihlVgXwxp+L9otLTCbP+jeAcfHQu3+fhF4/jN5Gyfcld
         MAT05Gl+FHsWw8omlgS3y0GquX8l9k3S3vI4HM9e+EacqAS2kpEdmYE7iPgnJkb4fuMu
         wRig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=i8GuTXVr9WWsDy7xmOlSHK3JnLYni7YF8DESUAMuRRE=;
        b=OkmF9mu66enfL4n5JO0GWUuapyrQIhA/UjI3AbMhcUQDLZ4SUrwIJv/wVhci3O4nrc
         +cHJkaoOd3l/ddUiNnrqhJ9Lk0dayFUDDuG2EyreRJiyj0wyztF6hVnPPNyr+wUgi0eJ
         oo/ifPhASG65x7dp3/B95tlQzMWlvu5mLKlcX5lV0jR96cyL5tr9k7OPgwwRk4vjV5bN
         DQXNzqZD17k9K2np/yTT0PmJNYVaIxXuRm5VC1UcQiAYiKyP5PcToIZimLxx0dalSw/n
         Ax2lhOqsWAtAc95sCp2HMzQkbOetEaTY3jA0p47x2TbY48wPY7gOYB62/3XPQdiB5jnX
         QNUA==
X-Gm-Message-State: APjAAAVm9LfCAHhyJW9Le5uKAx5URshpA3x+eSI0LzG4PIXVgzqJH2Cf
        FQObXKLDfqd/D+FTnLlkrzY=
X-Google-Smtp-Source: APXvYqzTbcrT3kuFfgzA+VCEZgArno03apGQuK6wmQ0ufm1Fe4rykeTWak7DhKFTTXP651/tvKw7Lg==
X-Received: by 2002:a17:90a:33c4:: with SMTP id n62mr105446625pjb.28.1564228279211;
        Sat, 27 Jul 2019 04:51:19 -0700 (PDT)
Received: from ?IPv6:2405:205:c906:e9d:e9fc:f9a6:f2b7:2864? ([2405:205:c906:e9d:e9fc:f9a6:f2b7:2864])
        by smtp.gmail.com with ESMTPSA id 67sm19455517pfd.177.2019.07.27.04.51.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 27 Jul 2019 04:51:18 -0700 (PDT)
Subject: Re: [PATCH] hv_sock: use HV_HYP_PAGE_SIZE instead of PAGE_SIZE_4K
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@01.org, mikelley@microsoft.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, sashal@kernel.org,
        davem@davemloft.net, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Himadri Pandya <himadri18.07@gmail.com>
References: <20190725051125.10605-1-himadri18.07@gmail.com>
 <201907271302.tDRkl9uU%lkp@intel.com>
From:   Himadri Pandya <himadrispandya@gmail.com>
Message-ID: <3f425a25-8ecc-6fbd-31d5-d26d28d56cde@gmail.com>
Date:   Sat, 27 Jul 2019 17:20:33 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <201907271302.tDRkl9uU%lkp@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/27/2019 10:50 AM, kbuild test robot wrote:
> Hi Himadri,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on linus/master]
> [cannot apply to v5.3-rc1 next-20190726]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

This patch should be applied to linux-next git tree.

Thank you.

- Himadri

>
> url:    https://github.com/0day-ci/linux/commits/Himadri-Pandya/hv_sock-use-HV_HYP_PAGE_SIZE-instead-of-PAGE_SIZE_4K/20190726-085229
> config: x86_64-allyesconfig (attached as .config)
> compiler: gcc-7 (Debian 7.4.0-10) 7.4.0
> reproduce:
>          # save the attached .config to linux build tree
>          make ARCH=x86_64
>
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
>
> All error/warnings (new ones prefixed by >>):
>
>>> net/vmw_vsock/hyperv_transport.c:58:28: error: 'HV_HYP_PAGE_SIZE' undeclared here (not in a function); did you mean 'HV_MESSAGE_SIZE'?
>      #define HVS_SEND_BUF_SIZE (HV_HYP_PAGE_SIZE - sizeof(struct vmpipe_proto_header))
>                                 ^
>>> net/vmw_vsock/hyperv_transport.c:65:10: note: in expansion of macro 'HVS_SEND_BUF_SIZE'
>       u8 data[HVS_SEND_BUF_SIZE];
>               ^~~~~~~~~~~~~~~~~
>     In file included from include/linux/list.h:9:0,
>                      from include/linux/module.h:9,
>                      from net/vmw_vsock/hyperv_transport.c:11:
>     net/vmw_vsock/hyperv_transport.c: In function 'hvs_open_connection':
>>> include/linux/kernel.h:845:2: error: first argument to '__builtin_choose_expr' not a constant
>       __builtin_choose_expr(__safe_cmp(x, y), \
>       ^
>     include/linux/kernel.h:921:27: note: in expansion of macro '__careful_cmp'
>      #define max_t(type, x, y) __careful_cmp((type)(x), (type)(y), >)
>                                ^~~~~~~~~~~~~
>>> net/vmw_vsock/hyperv_transport.c:390:12: note: in expansion of macro 'max_t'
>        sndbuf = max_t(int, sk->sk_sndbuf, RINGBUFFER_HVS_SND_SIZE);
>                 ^~~~~
>>> include/linux/kernel.h:845:2: error: first argument to '__builtin_choose_expr' not a constant
>       __builtin_choose_expr(__safe_cmp(x, y), \
>       ^
>     include/linux/kernel.h:913:27: note: in expansion of macro '__careful_cmp'
>      #define min_t(type, x, y) __careful_cmp((type)(x), (type)(y), <)
>                                ^~~~~~~~~~~~~
>>> net/vmw_vsock/hyperv_transport.c:391:12: note: in expansion of macro 'min_t'
>        sndbuf = min_t(int, sndbuf, RINGBUFFER_HVS_MAX_SIZE);
>                 ^~~~~
>>> include/linux/kernel.h:845:2: error: first argument to '__builtin_choose_expr' not a constant
>       __builtin_choose_expr(__safe_cmp(x, y), \
>       ^
>     include/linux/kernel.h:921:27: note: in expansion of macro '__careful_cmp'
>      #define max_t(type, x, y) __careful_cmp((type)(x), (type)(y), >)
>                                ^~~~~~~~~~~~~
>     net/vmw_vsock/hyperv_transport.c:393:12: note: in expansion of macro 'max_t'
>        rcvbuf = max_t(int, sk->sk_rcvbuf, RINGBUFFER_HVS_RCV_SIZE);
>                 ^~~~~
>>> include/linux/kernel.h:845:2: error: first argument to '__builtin_choose_expr' not a constant
>       __builtin_choose_expr(__safe_cmp(x, y), \
>       ^
>     include/linux/kernel.h:913:27: note: in expansion of macro '__careful_cmp'
>      #define min_t(type, x, y) __careful_cmp((type)(x), (type)(y), <)
>                                ^~~~~~~~~~~~~
>     net/vmw_vsock/hyperv_transport.c:394:12: note: in expansion of macro 'min_t'
>        rcvbuf = min_t(int, rcvbuf, RINGBUFFER_HVS_MAX_SIZE);
>                 ^~~~~
>     net/vmw_vsock/hyperv_transport.c: In function 'hvs_stream_enqueue':
>>> include/linux/kernel.h:845:2: error: first argument to '__builtin_choose_expr' not a constant
>       __builtin_choose_expr(__safe_cmp(x, y), \
>       ^
>     include/linux/kernel.h:913:27: note: in expansion of macro '__careful_cmp'
>      #define min_t(type, x, y) __careful_cmp((type)(x), (type)(y), <)
>                                ^~~~~~~~~~~~~
>     net/vmw_vsock/hyperv_transport.c:681:14: note: in expansion of macro 'min_t'
>        to_write = min_t(ssize_t, to_write, HVS_SEND_BUF_SIZE);
>                   ^~~~~
>
> vim +58 net/vmw_vsock/hyperv_transport.c
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
