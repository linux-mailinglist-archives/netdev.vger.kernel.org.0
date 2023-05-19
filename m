Return-Path: <netdev+bounces-3909-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6585E709830
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 15:27:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21BA7281C84
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:27:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34899DDB4;
	Fri, 19 May 2023 13:27:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291077C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 13:27:03 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8F212B;
	Fri, 19 May 2023 06:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684502821; x=1716038821;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=21kxhYntrvevXU1LQUOUEJedYStXujm2jMSmAwYvD7g=;
  b=Y68zkcwA9XvuqKKA1T3heGco8zUMDoU9SFk/tErPsrQWOUjdz1lfYPEI
   EjSs0wOOnLz5hBCUjINBSeifb7dBKwwSnHjiUQsKlcDaMY30Dfz4hMJU9
   13A6Egbhtf+W9g0iot5dlZcwh/h/LH0NU2bD7kQnbiEHMHKyDXC827Er0
   +aC0LeUIDgLZovNn1P3aJlyoOL7pVA7rI1SRPj4qLpR7mdPGqK2RPMw3g
   tJ2oXpOiRwnY+dpw6K3das9XwzgUpkeFSI1ffAJkwIo8CMudgs9FfKHOY
   /3aIaiiJRVAC6dyjcLb0hY1is19+tZ7/XjRjv1RpphgZNJ14bSy5yKSjY
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="349883503"
X-IronPort-AV: E=Sophos;i="6.00,176,1681196400"; 
   d="scan'208";a="349883503"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 06:27:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="814727672"
X-IronPort-AV: E=Sophos;i="6.00,176,1681196400"; 
   d="scan'208";a="814727672"
Received: from mylly.fi.intel.com (HELO [10.237.72.160]) ([10.237.72.160])
  by fmsmga002.fm.intel.com with ESMTP; 19 May 2023 06:26:57 -0700
Message-ID: <0e9ac73a-7937-ec04-5be3-44d3f4cd83dd@linux.intel.com>
Date: Fri, 19 May 2023 16:26:57 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v8 2/9] i2c: designware: Add driver support for
 Wangxun 10Gb NIC
Content-Language: en-US
To: Andy Shevchenko <andy.shevchenko@gmail.com>,
 Jiawen Wu <jiawenwu@trustnetic.com>
Cc: netdev@vger.kernel.org, andriy.shevchenko@linux.intel.com,
 mika.westerberg@linux.intel.com, jsd@semihalf.com, Jose.Abreu@synopsys.com,
 andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
 linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
 mengyuanlou@net-swift.com, Piotr Raczynski <piotr.raczynski@intel.com>
References: <20230515063200.301026-1-jiawenwu@trustnetic.com>
 <20230515063200.301026-3-jiawenwu@trustnetic.com>
 <ZGH6TmeiR0icT6Tc@surfacebook>
 <85d058cd-2dd9-2a7b-efd0-e4c8d512ae29@linux.intel.com>
 <018c01d988a1$7f97fe80$7ec7fb80$@trustnetic.com>
 <CAHp75VesUNnBwwccFxRAGTpQ4TcCeg6+tfYuBuSe93uHr=ZC_g@mail.gmail.com>
From: Jarkko Nikula <jarkko.nikula@linux.intel.com>
In-Reply-To: <CAHp75VesUNnBwwccFxRAGTpQ4TcCeg6+tfYuBuSe93uHr=ZC_g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/17/23 12:44, Andy Shevchenko wrote:
> On Wed, May 17, 2023 at 12:26 PM Jiawen Wu <jiawenwu@trustnetic.com> wrote:
>> On Wednesday, May 17, 2023 4:49 PM, Jarkko Nikula wrote:
>>> On 5/15/23 12:24, andy.shevchenko@gmail.com wrote:
>>>> Mon, May 15, 2023 at 02:31:53PM +0800, Jiawen Wu kirjoitti:
>>>>>     dev->flags = (uintptr_t)device_get_match_data(&pdev->dev);
>>>>> +  if (device_property_present(&pdev->dev, "snps,i2c-platform"))
>>>>> +          dev->flags |= MODEL_WANGXUN_SP;
>>>>
>>>> What I meant here is to use device_property_present() _iff_ you have decided to
>>>> go with the _vendor-specific_ property name.
>>>>
>>>> Otherwise it should be handled differently, i.e. with reading the actual value
>>>> of that property. Hence it should correspond the model enum, which you need to
>>>> declare in the Device Tree bindings before use.
>>>>
>>>> So, either
>>>>
>>>>      if (device_property_present(&pdev->dev, "wx,..."))
>>>>              dev->flags |= MODEL_WANGXUN_SP;
>>>>
>>>> or
>>>>
>>>>      if ((dev->flags & MODEL_MASK) == MODEL_NONE) {
>>>>      // you now have to distinguish that there is no model set in driver data
>>>>              u32 model;
>>>>
>>>>              ret = device_property_read_u32(dev, "snps,i2c-platform");
>>>>              if (ret) {
>>>>                      ...handle error...
>>>>              }
>>>>              dev->flags |= model
>>>>
>>> I'm not a device tree expert but I wonder would it be possible somehow
>>> combine this and compatible properties in dw_i2c_of_match[]? They set
>>> model flag for MODEL_MSCC_OCELOT and MODEL_BAIKAL_BT1.
>>
>> Maybe the table could be changed to match device property, instead of relying
>> on DT only. Or device_get_match_data() could be also implemented in
>> software node case?
> 
> This has been discussed [1] and still no visible prototype. Perhaps
> you can collaborate with Vladimir on the matter.
> 
> [1]: https://lore.kernel.org/lkml/20230223203713.hcse3mkbq3m6sogb@skbuf/
> 
Ok, not possible at the moment. Perhaps for now setting model using 
device_property_read_u32() is good enough? I asked above out of 
curiosity rather than demanding perfection. They say "Perfect is the 
enemy of good" :-)

