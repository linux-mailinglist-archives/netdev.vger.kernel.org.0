Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F254F3B7CDF
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 07:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbhF3FOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 01:14:19 -0400
Received: from mga03.intel.com ([134.134.136.65]:23747 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233520AbhF3FOS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 01:14:18 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10030"; a="208329021"
X-IronPort-AV: E=Sophos;i="5.83,311,1616482800"; 
   d="scan'208";a="208329021"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2021 22:11:49 -0700
X-IronPort-AV: E=Sophos;i="5.83,311,1616482800"; 
   d="scan'208";a="476187121"
Received: from mckumar-mobl.gar.corp.intel.com (HELO [10.215.183.107]) ([10.215.183.107])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2021 22:11:47 -0700
Subject: Re: [PATCH net-next 06/10] net: iosm: drop custom netdev(s) removing
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linuxwwan <linuxwwan@intel.com>
References: <20210615003016.477-1-ryazanov.s.a@gmail.com>
 <20210615003016.477-7-ryazanov.s.a@gmail.com>
 <CAHNKnsR5X8Axttk_YX=fpi5h6iV191fLJ6MZqrLvhZvPe==mXA@mail.gmail.com>
 <1d31c18cebf74ff29b5e388c4cd26361@intel.com>
 <CAMZdPi9bqTB8+=xAsx3C6yAJdf3CHx9Z0AUxZpFQ-FFU5q84cQ@mail.gmail.com>
 <e241d0d4-563d-e111-974e-9e47228f5178@intel.com>
 <CAMZdPi_vV1GfY7WUvYJ7F5b6SrkxwtC331NK-JF1tdmPjprx7g@mail.gmail.com>
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
Message-ID: <32682574-cafa-731a-e453-83b266b6df67@intel.com>
Date:   Wed, 30 Jun 2021 10:41:45 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAMZdPi_vV1GfY7WUvYJ7F5b6SrkxwtC331NK-JF1tdmPjprx7g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Loic,

On 6/29/2021 8:59 PM, Loic Poulain wrote:
> Hi Chetan,
> 
> On Tue, 29 Jun 2021 at 16:56, Kumar, M Chetan <m.chetan.kumar@intel.com> wrote:
>>
>> Hi Loic,
>>
>> On 6/29/2021 7:44 PM, Loic Poulain wrote:
>>
>>>>> BTW, if IOSM modems have a default data channel, I can add a separate
>>>>> patch to the series to create a default network interface for IOSM if you tell
>>>>> me which link id is used for the default data channel.
>>>>
>>>> Link id 1 is always associated as default data channel.
>>>
>>> Quick question, Isn't your driver use MBIM session IDs? with
>>> session-ID 0 as the default one?
>>
>> Link Id from 1 to 8 are treated as valid link ids. These ids are
>> decremented by 1 to match session id.
>>
>> In this case link id 1 would be mapped to session id 0. So have
>> requested link id 1 to be set as default data channel.
> 
> Oh ok, but why? it seems quite confusing, that means a user creating a
> MBIM session 0 has to create a link with ID 1?
> It seems to be quite specific to your driver, can't you simply handle
> ID 0 from user? to keep aligned with other drivers.

Thought link id 0 is not a valid id so had considered it from 1 :(

Sure, We will correct it to be intact with other drivers.

Regards,
Chetan
