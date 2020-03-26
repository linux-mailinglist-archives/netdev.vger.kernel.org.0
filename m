Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34E81194D67
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 00:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbgCZXjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 19:39:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:59957 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727345AbgCZXjd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 19:39:33 -0400
IronPort-SDR: uL80L+lkiyLF/D8zkpzQgUUkEWsCwI673uAwunU2Oot8VMGIRJmPxEOJF5iQYHEBH+VoORaz8m
 VZ48E2g6YRMg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 16:39:32 -0700
IronPort-SDR: 6lgoHJDYGsFfhjxgrfwsexag49dV9jxl1Bu2io+iKrVUge7/tPOp4NHuqRNAJeG0CsyjzGnEcL
 54AccPhT0WXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,310,1580803200"; 
   d="scan'208";a="358322410"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.254.179.43]) ([10.254.179.43])
  by fmsmga001.fm.intel.com with ESMTP; 26 Mar 2020 16:39:31 -0700
Subject: Re: [PATCH v3 net-next 1/5] devlink: Add macro for "fw.api" to
 info_get cb.
To:     Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>
References: <1585224155-11612-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <1585224155-11612-2-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200326134025.2c2c94f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CACKFLimJORgp2kmRLgZHWLY9E1DsbD8CSf+=9A-_DQhQG8kbqg@mail.gmail.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <582ed17d-8776-2f83-413c-37cf132c5e59@intel.com>
Date:   Thu, 26 Mar 2020 16:39:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CACKFLimJORgp2kmRLgZHWLY9E1DsbD8CSf+=9A-_DQhQG8kbqg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/26/2020 4:09 PM, Michael Chan wrote:
> On Thu, Mar 26, 2020 at 1:40 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Thu, 26 Mar 2020 17:32:34 +0530 Vasundhara Volam wrote:
>>> Add definition and documentation for the new generic info "fw.api".
>>> "fw.api" specifies the version of the software interfaces between
>>> driver and overall firmware.
>>>
>>> Cc: Jakub Kicinski <kuba@kernel.org>
>>> Cc: Jacob Keller <jacob.e.keller@intel.com>
>>> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
>>> Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
>>> Signed-off-by: Michael Chan <michael.chan@broadcom.com>
>>> ---
>>> v1->v2: Rename macro to "fw.api" from "drv.spec".
>>
>> I suggested "fw.mgmt.api", like Intel has. What else those this API
>> number covers beyond management? Do you negotiated descriptor formats
>> for the datapath?
> 
> To us, "management" firmware usually means firmware such as IPMI that
> interfaces with the BMC.  Here, we're trying to convey the API between
> the driver and the main firmware.  Yes, this main firmware also
> "manages" things such as rings, MAC, the physical port, etc.  But
> again, we want to distinguish it from the platform management type of
> firmware.
> 

Documentation for "fw.mgmt":

fw.mgmt
-------

Control unit firmware version. This firmware is responsible for house
keeping tasks, PHY control etc. but not the packet-by-packet data path
operation.

To me, platform management would need a new name, as the term "fw.mgmt"
has already been used by multiple drivers.

Thanks,
Jake
