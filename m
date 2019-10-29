Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 870E4E8291
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 08:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfJ2Hg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 03:36:27 -0400
Received: from mga07.intel.com ([134.134.136.100]:50474 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726222AbfJ2Hg1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 03:36:27 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Oct 2019 00:36:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,243,1569308400"; 
   d="scan'208";a="193522562"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.238.129.48]) ([10.238.129.48])
  by orsmga008.jf.intel.com with ESMTP; 29 Oct 2019 00:36:23 -0700
Subject: Re: [RFC 1/2] vhost: IFC VF hardware operation layer
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     mst@redhat.com, jasowang@redhat.com, alex.williamson@redhat.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dan.daly@intel.com, cunming.liang@intel.com, tiwei.bie@intel.com,
        jason.zeng@intel.com, zhiyuan.lv@intel.com
References: <20191016010318.3199-1-lingshan.zhu@intel.com>
 <20191016010318.3199-2-lingshan.zhu@intel.com>
 <20191015190649.54ddc91c@hermes.lan>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <2879733b-8b5f-3740-7b61-3f2043d3eaca@intel.com>
Date:   Tue, 29 Oct 2019 15:36:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191015190649.54ddc91c@hermes.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/16/2019 10:06 AM, Stephen Hemminger wrote:
> On Wed, 16 Oct 2019 09:03:17 +0800 Zhu Lingshan 
> <lingshan.zhu@intel.com> wrote:
>> + IFC_INFO(&dev->dev, "PCI capability mapping:\n" + "common cfg: 
>> %p\n" + "notify base: %p\n" + "isr cfg: %p\n" + "device cfg: %p\n" + 
>> "multiplier: %u\n", + hw->common_cfg, + hw->notify_base, + hw->isr, + 
>> hw->dev_cfg, + hw->notify_off_multiplier); 
> Since kernel messages go to syslog, syslog does not handle multi-line 
> messages very well. This should be a single line. Also, this is the 
> kind of message that should be at the debug level; something that is 
> useful to the driver developers but not something that needs to be 
> filling up every end users log.
Hi Stephen

Thanks for your comments, I have changed them in RFC V2, will send the 
patchset soon.
Thanks,
BR
Zhu Lingshan
