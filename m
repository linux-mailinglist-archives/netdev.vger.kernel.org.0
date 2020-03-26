Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B210193532
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 02:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727592AbgCZBQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 21:16:26 -0400
Received: from mga06.intel.com ([134.134.136.31]:20899 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727539AbgCZBQZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 21:16:25 -0400
IronPort-SDR: IH2SM44ojr5lpLredMiB/8qdUwxKrosZVsuBwci1aRAgDQLqozqIXxDqDlpb0QJ1gLtgN/gWMO
 Q4mqldTvY/Ig==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 18:16:21 -0700
IronPort-SDR: KBqoU2CdgjTi3EoPkQsp21218k2Dc0wAYAWmKeruFPZAXwAdZqubO+T4SmdUrBfmh0pl0rAl7a
 7m9dZ6VwBmRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,306,1580803200"; 
   d="scan'208";a="282329295"
Received: from cdalvizo-mobl1.amr.corp.intel.com (HELO [10.252.133.80]) ([10.252.133.80])
  by fmsmga002.fm.intel.com with ESMTP; 25 Mar 2020 18:16:20 -0700
Subject: Re: [PATCH] devlink: track snapshot id usage count using an xarray
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
References: <20200324223445.2077900-1-jacob.e.keller@intel.com>
 <20200324223445.2077900-8-jacob.e.keller@intel.com>
 <20200325160832.GY11304@nanopsycho.orion>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <4be7f585-fdaf-a782-7bc1-1760cad60882@intel.com>
Date:   Wed, 25 Mar 2020 18:16:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200325160832.GY11304@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/25/2020 9:08 AM, Jiri Pirko wrote:
> You somehow missed "07/10" from the subject :O

Huh. I sent using git-send-email, so I'm not sure how that happened.
