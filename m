Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7346E2EC41A
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 20:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbhAFToQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 14:44:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbhAFToQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 14:44:16 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086C6C061575
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 11:43:36 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id u26so3854776iof.3
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 11:43:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=524gIBiBelpD0qVg3o3Q7JLZEZj0p1hawMdE5gf7waw=;
        b=eP8b0H3VGQgO/CbJSqyjNpvLjYHWsGT0OgHv8bwe0QWInLdZWPy+zGTmpaFNrW9NK/
         WlrFdhbOXdL9mLcBqg7+bZuvRlRWmpMD4wrBPyqpAdjcdEITT0sHWov7Vidc481cCzu1
         Yg7JJYMCa0/ViEed1YgqR/9lGEg150XH8PKQhVdUGUyPm9Ox4LUKRu4AJTDqgf55jWKy
         p5dsWmkIYMKgbfFpZRiUhHIbgYoin0qPYeZikb+QZAH5Ir9ZjOFPYNeE2L3BTp6JRDDw
         7tFHfboyli2aeRSNeAjQOD6oSzxXa+TG6RXeBGvGOyztWkpb0ZXjf1j5oR5nd8mJh7Ox
         3T0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=524gIBiBelpD0qVg3o3Q7JLZEZj0p1hawMdE5gf7waw=;
        b=Wl+yu6hk77r9WhHnCk0J+RBQJnvJ73bgJAl+S1KIPDIpJ8KnX2TnQ1pjQycYA/nzft
         GMEsPvox2BqgnjxPDRt0DOCBCP9/CBzDox4q9qQnYK5ZG2QX6duvfqk+v+8hWIZe+niG
         wPhALpeXYLjR6zkbRqEYEMk/wYgjo+Qfb7M74b/+gsG1bfwx4LbaJQ8T4knflbNz61dE
         9raX1rfh/PYrDmTFgTrPZkDtymrTSDxkHY2DZcTzVmHIq8M4GaKavL4Henk8UDFFzkmu
         iKYsyKqIAbn+f6agPv7beDLNTFUltqQzvMeqL3Q061fe+TEIXaEuJr3CDnfCN0IfiE93
         i5Yw==
X-Gm-Message-State: AOAM531Wdw77+eTO9HkJAe5bSOt2+onDG95TWeaGWnUvMXfoLvkDLmNO
        TrYiQUEY01yDahQg51m9YYzafg==
X-Google-Smtp-Source: ABdhPJytrFAlmLACDe11EIEFbqIGPudN3OKMfauAq8qSvwF16irVTIPHrkJQgKKkl+56cEaJDRyIew==
X-Received: by 2002:a05:6602:13c5:: with SMTP id o5mr4053115iov.46.1609962215326;
        Wed, 06 Jan 2021 11:43:35 -0800 (PST)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id 8sm2286400ill.13.2021.01.06.11.43.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 11:43:34 -0800 (PST)
Subject: Re: [PATCH net-next 3/3] net: ipa: support COMPILE_TEST
To:     kernel test robot <lkp@intel.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     kbuild-all@lists.01.org, bjorn.andersson@linaro.org,
        agross@kernel.org, ohad@wizery.com, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <20210106023812.2542-4-elder@linaro.org>
 <202101061555.DTUUlbsx-lkp@intel.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <d2f55352-b774-8ce2-0693-3d7eb39ac43c@linaro.org>
Date:   Wed, 6 Jan 2021 13:43:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <202101061555.DTUUlbsx-lkp@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/6/21 1:34 AM, kernel test robot wrote:
> Hi Alex,
> 
> I love your patch! Perhaps something to improve:
> 
> [auto build test WARNING on net-next/master]

I think I just need to define at the top of "gsi_trans.h":
    struct page;

I'll submit v2 of this series, with this one change
(assuming it's the correct fix).  I will incorporate
Bjorn's review tags on the first two patches.

					-Alex

> url:    https://github.com/0day-ci/linux/commits/Alex-Elder/net-ipa-support-COMPILE_TEST/20210106-104149
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 3db1a3fa98808aa90f95ec3e0fa2fc7abf28f5c9
> config: alpha-allyesconfig (attached as .config)
> compiler: alpha-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/0day-ci/linux/commit/7ab1759d9336e95f4de013bb171246b66f94e2f4
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Alex-Elder/net-ipa-support-COMPILE_TEST/20210106-104149
>         git checkout 7ab1759d9336e95f4de013bb171246b66f94e2f4
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=alpha 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>    In file included from drivers/net/ipa/ipa_gsi.c:10:
>>> drivers/net/ipa/gsi_trans.h:170:56: warning: 'struct page' declared inside parameter list will not be visible outside of this definition or declaration
>      170 | int gsi_trans_page_add(struct gsi_trans *trans, struct page *page, u32 size,
>          |                                                        ^~~~
> 
> 
> vim +170 drivers/net/ipa/gsi_trans.h
> 
> 9dd441e4ed5755c Alex Elder 2020-03-05  149  
> 9dd441e4ed5755c Alex Elder 2020-03-05  150  /**
> 9dd441e4ed5755c Alex Elder 2020-03-05  151   * gsi_trans_cmd_add() - Add an immediate command to a transaction
> 9dd441e4ed5755c Alex Elder 2020-03-05  152   * @trans:	Transaction
> 9dd441e4ed5755c Alex Elder 2020-03-05  153   * @buf:	Buffer pointer for command payload
> 9dd441e4ed5755c Alex Elder 2020-03-05  154   * @size:	Number of bytes in buffer
> 9dd441e4ed5755c Alex Elder 2020-03-05  155   * @addr:	DMA address for payload
> 9dd441e4ed5755c Alex Elder 2020-03-05  156   * @direction:	Direction of DMA transfer (or DMA_NONE if none required)
> 9dd441e4ed5755c Alex Elder 2020-03-05  157   * @opcode:	IPA immediate command opcode
> 9dd441e4ed5755c Alex Elder 2020-03-05  158   */
> 9dd441e4ed5755c Alex Elder 2020-03-05  159  void gsi_trans_cmd_add(struct gsi_trans *trans, void *buf, u32 size,
> 9dd441e4ed5755c Alex Elder 2020-03-05  160  		       dma_addr_t addr, enum dma_data_direction direction,
> 9dd441e4ed5755c Alex Elder 2020-03-05  161  		       enum ipa_cmd_opcode opcode);
> 9dd441e4ed5755c Alex Elder 2020-03-05  162  
> 9dd441e4ed5755c Alex Elder 2020-03-05  163  /**
> 9dd441e4ed5755c Alex Elder 2020-03-05  164   * gsi_trans_page_add() - Add a page transfer to a transaction
> 9dd441e4ed5755c Alex Elder 2020-03-05  165   * @trans:	Transaction
> 9dd441e4ed5755c Alex Elder 2020-03-05  166   * @page:	Page pointer
> 9dd441e4ed5755c Alex Elder 2020-03-05  167   * @size:	Number of bytes (starting at offset) to transfer
> 9dd441e4ed5755c Alex Elder 2020-03-05  168   * @offset:	Offset within page for start of transfer
> 9dd441e4ed5755c Alex Elder 2020-03-05  169   */
> 9dd441e4ed5755c Alex Elder 2020-03-05 @170  int gsi_trans_page_add(struct gsi_trans *trans, struct page *page, u32 size,
> 9dd441e4ed5755c Alex Elder 2020-03-05  171  		       u32 offset);
> 9dd441e4ed5755c Alex Elder 2020-03-05  172  
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> 

