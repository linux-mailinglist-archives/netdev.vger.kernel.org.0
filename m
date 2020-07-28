Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986B6230FEA
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 18:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731526AbgG1Qhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 12:37:38 -0400
Received: from mga14.intel.com ([192.55.52.115]:13313 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731443AbgG1Qhi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 12:37:38 -0400
IronPort-SDR: HLFXi22vSCuNG1ChQN99setDP08TzXmbgC9RWpEtC6cxa7ImK8QIRnQQGvBUB+BDpHneAQpiEr
 SmjcJ6Loo0nA==
X-IronPort-AV: E=McAfee;i="6000,8403,9696"; a="150427062"
X-IronPort-AV: E=Sophos;i="5.75,406,1589266800"; 
   d="scan'208";a="150427062"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 09:37:27 -0700
IronPort-SDR: qgNctiPNbBK1fZbDeaC/j6G6gp0dpgqsDtkxPQR4rAFgk+k8WziK7SEVKRnZxcE39PF6Vsy0oe
 g4R+/s/U1zBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,406,1589266800"; 
   d="scan'208";a="434379202"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.32.199]) ([10.212.32.199])
  by orsmga004.jf.intel.com with ESMTP; 28 Jul 2020 09:37:26 -0700
Subject: Re: [PATCH net-next RFC 00/13] Add devlink reload level option
To:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <326163fb-ed79-62ea-ed2d-cb3b7700db54@intel.com>
Date:   Tue, 28 Jul 2020 09:37:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/27/2020 4:02 AM, Moshe Shemesh wrote:
> Introduce new option on devlink reload API to enable the user to select the
> reload level required. Complete support for all levels in mlx5.
> The following reload levels are supported:
>   driver: Driver entities re-instantiation only. 

So, this is the current support. Ok.

>   fw_reset: Firmware reset and driver entities re-instantiation. 


This would include firmware update? What about differing levels of
device/firmware reset? I.e. I think some of our HW has function level
reset, device wide reset, as well as EMP reset. For us, only EMP reset
would trigger firmware update.

>   fw_live_patch: Firmware live patching only.

This is for update without reset, right?
