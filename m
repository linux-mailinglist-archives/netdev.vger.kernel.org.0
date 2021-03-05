Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC09832EBC4
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 14:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbhCENAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 08:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhCEM7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 07:59:53 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954A0C061756
        for <netdev@vger.kernel.org>; Fri,  5 Mar 2021 04:59:53 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id 2so1610603qtw.1
        for <netdev@vger.kernel.org>; Fri, 05 Mar 2021 04:59:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yasENDD7zbA4FMKVPyHza6cSklZikxEtfBF1Xaa+1NA=;
        b=Xke4rpqHH7QF0plKZC4DbzGXx930n7F0EYmwDaVQzJH9TnNW9/b/FQK+Of7XHqG6R/
         Kct0TGyDPV730OWdEOHStfVxy2qdBbG3PnpuPIIKYJr1bM1mMIx0/WJAfVomVPmhpZcd
         QgvTkOZ84iUsmk8+NeHbAOVRfaJcVPT9Y67p5wykIIKuRBb63NehzFsMBKIPPBwJChu5
         okXmTQwe8mb/T0bRqcTtJHN/rr5m3+00lM/kBLD6tvTgR7jA7Hxv0tTkgvCIbJ1FD1V1
         WZGwBXA7/pA2i3YdHh+O+ZCKLWdEEGtHSHNCIGqMQcCGLS0uRrW1RU0hjB97YWeb8w0f
         AU+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yasENDD7zbA4FMKVPyHza6cSklZikxEtfBF1Xaa+1NA=;
        b=Xp2MbXhiluZ1CaboxVvMZDTF5AgA38TsgDS0Gn1H0UG0aGcmAWCkWROnRdHOsTbhN2
         DyIBn+gSWoKW43feLKsmwa91gOUOiKHmysOoerj1pjSyI0NN5NPQJzv3kOGKu92bBcf2
         1nKlQfNnvHiugR3oaD0dMHqh2trbCSElgQhBG8AJuKNVfOsguvWbkie7+jfpRgSkpwA3
         wsOwzZfOF8+Vz+mnYmKNjMgc99YxX1k5erhDfmYzLZv0SfjXw7LZ4gTNj6yk7aSra/Yg
         XrB8OX6pJ/zg7yhNrps31UxUX+5+oGx5QSJpC7GbDMQLwT4U4kweB1gRmYfI/1oBFNm2
         5IFQ==
X-Gm-Message-State: AOAM533UZ1Y7QnESSRfD+l4A51KBBupVpixhpN+mMRNzfHR6g+wL0XPb
        NDXI8I8fQRgmvsum53vuRq6pACLKD7zldQ==
X-Google-Smtp-Source: ABdhPJzeXJ1cRu4ixBm8McLCT/hXc8EIKetIfsE1+WJq7AwmYT6zV5VzMsm9CVncrbspTfzAp1qXhw==
X-Received: by 2002:aed:2e63:: with SMTP id j90mr7867751qtd.241.1614949191996;
        Fri, 05 Mar 2021 04:59:51 -0800 (PST)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id z7sm1642518qkf.136.2021.03.05.04.59.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Mar 2021 04:59:51 -0800 (PST)
Subject: Re: [PATCH net-next 6/6] net: qualcomm: rmnet: don't use C bit-fields
 in rmnet checksum header
To:     kernel test robot <lkp@intel.com>, subashab@codeaurora.org,
        stranche@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     kbuild-all@01.org, sharathv@codeaurora.org,
        bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org
References: <20210304223431.15045-7-elder@linaro.org>
 <202103051434.KSZRphLE-lkp@intel.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <2bcbefab-7c4d-dd36-01f8-9759ba4b2bdf@linaro.org>
Date:   Fri, 5 Mar 2021 06:59:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <202103051434.KSZRphLE-lkp@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/5/21 12:22 AM, kernel test robot wrote:
> Hi Alex,
> 
> I love your patch! Perhaps something to improve:
> 
> [auto build test WARNING on net-next/master]

Well that's embarrassing.  It explains why I had to make
a change or two after testing though.

I will fix this so the bit fields are defined in host
byte order, and will fix the encoding calls to use
u32_encode_bits() instead of be32_encode_bits().

I will redo my testing (for all of the patches) and
will then submit version 2 of the series.

					-Alex

> 
> url:    https://github.com/0day-ci/linux/commits/Alex-Elder/net-qualcomm-rmnet-stop-using-C-bit-fields/20210305-064128
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git d310ec03a34e92a77302edb804f7d68ee4f01ba0
> config: riscv-randconfig-s031-20210305 (attached as .config)
> compiler: riscv64-linux-gcc (GCC) 9.3.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # apt-get install sparse
>         # sparse version: v0.6.3-245-gacc5c298-dirty
>         # https://github.com/0day-ci/linux/commit/dba638b67dff001926855ed81e35e52bd54880ea
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Alex-Elder/net-qualcomm-rmnet-stop-using-C-bit-fields/20210305-064128
>         git checkout dba638b67dff001926855ed81e35e52bd54880ea
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' ARCH=riscv 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> 
> "sparse warnings: (new ones prefixed by >>)"
>>> drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:208:13: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned short [usertype] val @@     got restricted __be16 @@
>    drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:208:13: sparse:     expected unsigned short [usertype] val
>    drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:208:13: sparse:     got restricted __be16
>>> drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:210:21: sparse: sparse: invalid assignment: |=
>>> drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:210:21: sparse:    left side has type unsigned short
>>> drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:210:21: sparse:    right side has type restricted __be16
>    drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:211:13: sparse: sparse: invalid assignment: |=
>    drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:211:13: sparse:    left side has type unsigned short
>    drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:211:13: sparse:    right side has type restricted __be16
>    drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:247:13: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned short [usertype] val @@     got restricted __be16 @@
>    drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:247:13: sparse:     expected unsigned short [usertype] val
>    drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:247:13: sparse:     got restricted __be16
>    drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:249:21: sparse: sparse: invalid assignment: |=
>    drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:249:21: sparse:    left side has type unsigned short
>    drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:249:21: sparse:    right side has type restricted __be16
>    drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:250:13: sparse: sparse: invalid assignment: |=
>    drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:250:13: sparse:    left side has type unsigned short
>    drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:250:13: sparse:    right side has type restricted __be16
> 
> vim +208 drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> 
>    195	
>    196	static void
>    197	rmnet_map_ipv4_ul_csum_header(void *iphdr,
>    198				      struct rmnet_map_ul_csum_header *ul_header,
>    199				      struct sk_buff *skb)
>    200	{
>    201		struct iphdr *ip4h = iphdr;
>    202		u16 offset;
>    203		u16 val;
>    204	
>    205		offset = skb_transport_header(skb) - (unsigned char *)iphdr;
>    206		ul_header->csum_start_offset = htons(offset);
>    207	
>  > 208		val = be16_encode_bits(1, MAP_CSUM_UL_ENABLED_FMASK);
>    209		if (ip4h->protocol == IPPROTO_UDP)
>  > 210			val |= be16_encode_bits(1, MAP_CSUM_UL_UDP_FMASK);
>    211		val |= be16_encode_bits(skb->csum_offset, MAP_CSUM_UL_OFFSET_FMASK);
>    212	
>    213		ul_header->csum_info = htons(val);
>    214	
>    215		skb->ip_summed = CHECKSUM_NONE;
>    216	
>    217		rmnet_map_complement_ipv4_txporthdr_csum_field(iphdr);
>    218	}
>    219	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> 

