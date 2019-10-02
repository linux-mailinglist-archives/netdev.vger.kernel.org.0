Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 782A9C935A
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 23:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729428AbfJBVPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 17:15:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:23553 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728981AbfJBVPt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 17:15:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 14:15:49 -0700
X-IronPort-AV: E=Sophos;i="5.67,249,1566889200"; 
   d="scan'208";a="185680165"
Received: from ddalessa-mobl.amr.corp.intel.com (HELO [10.254.204.65]) ([10.254.204.65])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 02 Oct 2019 14:15:47 -0700
Subject: Re: [RFC 20/20] RDMA/i40iw: Mark i40iw as deprecated
To:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-21-jeffrey.t.kirsher@intel.com>
 <20190926174009.GD14368@unreal>
 <9DD61F30A802C4429A01CA4200E302A7AC702BDA@fmsmsx123.amr.corp.intel.com>
 <20190926195517.GA1743170@kroah.com>
 <bc18503dcace47150d5f45e8669d7978e18a38f9.camel@redhat.com>
 <20190928055511.GI14368@unreal>
From:   Dennis Dalessandro <dennis.dalessandro@intel.com>
Message-ID: <64752160-e8cc-5dcd-d0f9-f26f81057324@intel.com>
Date:   Wed, 2 Oct 2019 17:15:45 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190928055511.GI14368@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/2019 1:55 AM, Leon Romanovsky wrote:
> On Fri, Sep 27, 2019 at 04:17:15PM -0400, Doug Ledford wrote:
>> On Thu, 2019-09-26 at 21:55 +0200, gregkh@linuxfoundation.org wrote:
>>> On Thu, Sep 26, 2019 at 07:49:44PM +0000, Saleem, Shiraz wrote:
>>>>> Subject: Re: [RFC 20/20] RDMA/i40iw: Mark i40iw as deprecated
>>>>>
>>>>> On Thu, Sep 26, 2019 at 09:45:19AM -0700, Jeff Kirsher wrote:
>>>>>> From: Shiraz Saleem <shiraz.saleem@intel.com>
>>>>>>
>>>>>> Mark i40iw as deprecated/obsolete.
>>>>>>
>>>>>> irdma is the replacement driver that supports X722.
>>>>>
>>>>> Can you simply delete old one and add MODULE_ALIAS() in new
>>>>> driver?
>>>>>
>>>>
>>>> Yes, but we thought typically driver has to be deprecated for a few
>>>> cycles before removing it.
>>>
>>> If you completely replace it with something that works the same, why
>>> keep the old one around at all?
>>>
>>> Unless you don't trust your new code?  :)
>>
>> I have yet to see, in over 20 years of kernel experience, a new driver
>> replace an old driver and not initially be more buggy and troublesome
>> than the old driver.  It takes time and real world usage for the final
>> issues to get sorted out.  During that time, the fallback is often
>> necessary for those real world users.
> 
> How many real users exist in RDMA world who run pure upstream kernel?

I doubt too many especially the latest bleeding edge upstream kernel. 
That could be interesting, but I don't think it's the reality.

Distro kernels could certainly still keep the old driver, and that makes 
a lot of sense.

-Denny

