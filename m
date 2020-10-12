Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71A328C57D
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 01:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389458AbgJLX6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 19:58:22 -0400
Received: from mga04.intel.com ([192.55.52.120]:48124 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388709AbgJLX6W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 19:58:22 -0400
IronPort-SDR: sKQxAKyKSPxK6JPH2eUobjQj+4DJNXCTBZNKkFVaImm3zCn/uls9nyvXgyS6fAQbR5XeX9jdq2
 wfothbk3Domg==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="163185708"
X-IronPort-AV: E=Sophos;i="5.77,368,1596524400"; 
   d="scan'208";a="163185708"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 16:58:21 -0700
IronPort-SDR: rCuMX6kEIhqaWs1cuhNrPzNtOZwWYtFcb1+VxAmryvg0PLaXBdiM+YmPVqk2jQN5TwDkjpXRo+
 OC2CcB6HEtvw==
X-IronPort-AV: E=Sophos;i="5.77,368,1596524400"; 
   d="scan'208";a="520847968"
Received: from aravindh-mobl.amr.corp.intel.com (HELO ellie) ([10.209.37.143])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 16:58:20 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Murali Karicheri <m-karicheri2@ti.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: ethtool enhancements for configuring IET Frame preemption
In-Reply-To: <8908ab22-a4d0-1a9b-99c6-6ab3c3a69ed3@ti.com>
References: <b7f93fdb-4ad6-a744-056a-6ace37290a8c@ti.com>
 <87lficsy5k.fsf@intel.com> <8908ab22-a4d0-1a9b-99c6-6ab3c3a69ed3@ti.com>
Date:   Mon, 12 Oct 2020 16:58:20 -0700
Message-ID: <87tuuzro83.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Murali,

Murali Karicheri <m-karicheri2@ti.com> writes:

> Hi Vinicius,
>
> On 8/17/20 6:30 PM, Vinicius Costa Gomes wrote:
>> Hi Murali,
>> 
>> I was finally able to go back to working on this, and should have
>> something for review when net-next opens.
>> 
> Do you have anything to share here on this or still work in progress?
>

Your timing was perfect, I just sent an RFC using the new approach :-)



Cheers,
-- 
Vinicius
