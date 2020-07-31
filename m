Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E3A234C57
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 22:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728411AbgGaUfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 16:35:42 -0400
Received: from mga12.intel.com ([192.55.52.136]:23725 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727093AbgGaUfm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 16:35:42 -0400
IronPort-SDR: 8JsOVhb91R45gzWYQNp93DIsb/kl+hP+XSBjNkE0SgJXHEeKOC1F8c8/tAftaMaNpECo5J1Y4o
 ie1UGzp3itAA==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="131434062"
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="131434062"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 13:35:42 -0700
IronPort-SDR: lhx96rGdJqOCwom91slBWtBIi8VaYo/xrfXVxKxcZ0dYlsiGuZ2krZe/BW9sd54szFbR8ANQUT
 mX7RGkhVkdBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="491605482"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.156.194]) ([10.212.156.194])
  by fmsmga005.fm.intel.com with ESMTP; 31 Jul 2020 13:35:41 -0700
Subject: Re: [net-next 0/4] devlink flash update overwrite mask
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
References: <20200730232008.2648488-1-jacob.e.keller@intel.com>
 <20200730173928.676a7a29@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <b148961d-317e-b995-5caa-a1cae44789c0@intel.com>
Date:   Fri, 31 Jul 2020 13:35:41 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <20200730173928.676a7a29@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/30/2020 5:39 PM, Jakub Kicinski wrote:
> LGTM,
> 
> minor suggestions:
>  - could you add opt-in support flags to struct devlink_ops, a'la
>    ethtool_ops->supported_coalesce_params so that you don't have to
>    modify all drivers to reject unsupported things?

Sure that makes sense.

>  - could you split patch 2 into an ice change and a devlink core
>    change?
> 

Yep.
