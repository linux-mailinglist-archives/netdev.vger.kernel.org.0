Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95E7C21BEC8
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 22:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727971AbgGJUzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 16:55:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:52127 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726832AbgGJUzJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 16:55:09 -0400
IronPort-SDR: oOedK9d6nuVU0kNq60wcPNxFCxhydVy4woRY5vAAnURGq3AK/pBw09Nr+4QEOB0lPXUZBzmLqS
 Vl/v45gXnspA==
X-IronPort-AV: E=McAfee;i="6000,8403,9678"; a="146356297"
X-IronPort-AV: E=Sophos;i="5.75,336,1589266800"; 
   d="scan'208";a="146356297"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2020 13:55:09 -0700
IronPort-SDR: eQvN6ZdlZbGaNZZHb9kBfAmJ3OJbnzWsoQ6qkto76SGhJ9uXCmitQWv38JsJOSMBI8eZvoJOon
 cxiUUJ/xdasQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,336,1589266800"; 
   d="scan'208";a="306666019"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.20.152]) ([10.212.20.152])
  by fmsmga004.fm.intel.com with ESMTP; 10 Jul 2020 13:55:09 -0700
Subject: Re: [RFC v2 net-next] devlink: Add reset subcommand.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Michal Kubecek <mkubecek@suse.cz>, moshe@mellanox.com
References: <1593516846-28189-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200630125353.GA2181@nanopsycho>
 <CAACQVJqxLhmO=UiCMh_pv29WP7Qi4bAZdpU9NDk3Wq8TstM5zA@mail.gmail.com>
 <20200701055144.GB2181@nanopsycho>
 <CAACQVJqac3JGY_w2zp=thveG5Hjw9tPGagHPvfr2DM3xL4j_zg@mail.gmail.com>
 <20200701094738.GD2181@nanopsycho>
 <61c8618e-6a82-d28f-4cab-429e4a90bff6@intel.com>
 <20200710133929.389f1aba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <1ca4c809-b696-3f83-54ca-0c635a66e5db@intel.com>
Date:   Fri, 10 Jul 2020 13:55:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200710133929.389f1aba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/10/2020 1:39 PM, Jakub Kicinski wrote:
> On Fri, 10 Jul 2020 11:16:51 -0700 Jacob Keller wrote:
>>> We already have notion of "a component" in "devlink dev flash". I think
>>> that the reset component name should be in-sync with the flash.
>>
>> Right. We should re-use the component names from devlink dev info here
>> (just as we do in devlink dev flash).
> 
> Let's remember that the SW did not eat the entire world just yet ;)
> 
> There are still HW components which don't have FW (and therefore FW
> component to flash) that folks may want to reset.. that's what the
> ethtool reset API was cut to.
> 

True enough. I was thinking only in terms of resetting to load new
firmware, which is a different but related problem.

Thanks,
Jake
