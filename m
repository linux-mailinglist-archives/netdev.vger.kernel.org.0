Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54DCB4E57B3
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 18:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245162AbiCWRjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 13:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237353AbiCWRjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 13:39:55 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A639FD2C
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 10:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648057105; x=1679593105;
  h=message-id:date:mime-version:subject:cc:references:from:
   to:in-reply-to:content-transfer-encoding;
  bh=xb2ash3QyjsdxeY1io12OmLXhZtU8Z36q39iIKBI5UI=;
  b=BvaqOYQhe88egtt8zplAGQO8CQZvdd40nHRMVSxIVQF3h47RRluGBmgK
   5cATQSoHKCQPFBJMEGkZIM7jMKVURry0xHxxYYncwse74eo9m2w7Qe41s
   kdUCZGRVSAmVnyqEZLq/q4BBONqyJaPJZ+EU4nLi+/xiC2NZXLZd9vuXu
   cNIBH/BvETGIeUDfYpQvOXnSasVJSbhAjlXFi4/9ZDZCdIIz5c4OtA4y+
   fCLmphb2g01gE+b359r85/XqnOt33hu31gwdXJWJ7qSUafsEYsztpLJah
   +OERxfKClDOaGVxa9SCqe53ONDP/vfJq2idyGZPxOxfzHAXg0voUPf39u
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10295"; a="240346269"
X-IronPort-AV: E=Sophos;i="5.90,204,1643702400"; 
   d="scan'208";a="240346269"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 10:37:01 -0700
X-IronPort-AV: E=Sophos;i="5.90,204,1643702400"; 
   d="scan'208";a="561011437"
Received: from mckumar-mobl1.gar.corp.intel.com (HELO [10.215.128.237]) ([10.215.128.237])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 10:36:59 -0700
Message-ID: <6590efa9-8fcd-5d77-9dff-6f2d1244cdb0@linux.intel.com>
Date:   Wed, 23 Mar 2022 23:06:55 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: net: wwan: ethernet interface support
Content-Language: en-US
Cc:     Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Sudi, Krishna C" <krishna.c.sudi@intel.com>,
        Intel Corporation <linuxwwan@intel.com>
References: <1eb3d9e6-2adf-7f6c-4745-481451813522@linux.intel.com>
 <CAHNKnsQMFDdRzjAGW8+KHJrJUnganM0gi8AWmBnF1h_M2RSLeg@mail.gmail.com>
 <CAMZdPi_veiVaQYBcu9o0GqbmUcYtkL4NawOo2AGPKxfmaNrdhg@mail.gmail.com>
From:   "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
To:     "loic.poulain@linaro.org >> Loic Poulain" <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>
In-Reply-To: <CAMZdPi_veiVaQYBcu9o0GqbmUcYtkL4NawOo2AGPKxfmaNrdhg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/23/2022 10:36 PM, Loic Poulain wrote:
> On Sat, 19 Mar 2022 at 19:34, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>>
>> Hello,
>>
>> On Sat, Mar 19, 2022 at 6:21 PM Kumar, M Chetan
>> <m.chetan.kumar@linux.intel.com> wrote:
>>> Release16 5G WWAN Device need to support Ethernet interface for TSN requirement.
>>> So far WWAN interface are of IP type. Is there any plan to scale it to support
>>> ethernet interface type ?
>>
>> What did you mean when you talked about supporting interfaces of Ethernet type?
>>
>> The WWAN subsystem provides an interface for users to request the
>> creation of a network interface from a modem driver. At the moment,
>> all modem drivers that support the WWAN subsystem integration create
>> network interfaces of the ARPHRD_NONE or ARPHRD_RAWIP type. But it is
>> up to the driver what type of interface it will create. At any time,
>> the driver can decide to create an ARPHRD_ETHER network interface, and
>> it will be Ok.
> 
> Agree, WWAN does not require a specific type, so you can do whatever
> you want in the newlink callback.
> 
> Should a modem/driver be able to expose mixed interface types (e.g. ip
> + eth), in that case we probably need to add extra param to newlink.

The wwan device which is complaint to 3GPP release16 specification (TSN 
supported) will have to create both the types of interfaces ARPHRD_RAWIP/ 
ARPHRD_NONE to carry default IP traffic and ARPHRD_ETHER for carrying TSN 
specific traffic.

Since both can co-exist can we consider this extra param added to newlink to 
distinguish
1> Ethernet interface creation from ip interface
2> Ethernet interface to session id mapping.

Kindly provide your inputs.
