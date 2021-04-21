Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D767B366ECA
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 17:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243767AbhDUPJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 11:09:16 -0400
Received: from mga04.intel.com ([192.55.52.120]:50173 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243900AbhDUPJG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 11:09:06 -0400
IronPort-SDR: Q7q+rCc+/0RNe+XhOEQ/25EBfm5QB7CNQngAGVRv4msJVnBNcLyNBLGmyemZhlhjWt7o6HrGqf
 0BvdMfRIdHYA==
X-IronPort-AV: E=McAfee;i="6200,9189,9961"; a="193591445"
X-IronPort-AV: E=Sophos;i="5.82,240,1613462400"; 
   d="scan'208";a="193591445"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2021 08:08:33 -0700
IronPort-SDR: 8MtHqa/OKn96QBDwJ+OiVDCw1VgFwWsVXhCjgGYSOcm/df0tFEnJ7/JJiKnZDl+qlPElHzDl0o
 1yx0s0TJmc1Q==
X-IronPort-AV: E=Sophos;i="5.82,240,1613462400"; 
   d="scan'208";a="534899917"
Received: from samudral-mobl.amr.corp.intel.com (HELO [10.212.184.240]) ([10.212.184.240])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2021 08:08:32 -0700
Subject: Re: [net-next 07/15] net/mlx5: mlx5_ifc updates for flex parser
To:     Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20210420032018.58639-1-saeed@kernel.org>
 <20210420032018.58639-8-saeed@kernel.org>
 <f21f0500-2150-9975-cfee-1629766634b8@intel.com>
 <de33839f-0bcc-f999-7348-6ffb54a10e35@nvidia.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Message-ID: <f6ce8bc9-7ccb-036a-7d78-3f6bf052a515@intel.com>
Date:   Wed, 21 Apr 2021 08:08:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <de33839f-0bcc-f999-7348-6ffb54a10e35@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/20/2021 10:07 AM, Yevgeny Kliteynik wrote:
>
> On 20-Apr-21 07:54, Samudrala, Sridhar wrote:
>> External email: Use caution opening links or attachments
>>
>>
>> On 4/19/2021 8:20 PM, Saeed Mahameed wrote:
>>> From: Yevgeny Kliteynik <kliteyn@nvidia.com>
>>>
>>> Added the required definitions for supporting more protocols by flex 
>>> parsers
>>> (GTP-U, Geneve TLV options), and for using the right flex parser 
>>> that was
>>> configured for this protocol.
>> Are you planning to support adding flow rules to match on these protocol
>> specific fields?
>> If so,  are you planning to extend tc flower OR use other interfaces?
>
> Some of these are already supported through tc on DMFS.
> This patch series adds support for SMFS: Geneve options and MPLS
> both through tc and through rdma-core on root table,
> and GTP-U is supported only through rdma-core on root table.

What is the interface for rdma-core to hook into the driver to add these 
rules?
Is there an equivalent of ndo_setup_tc()  that is used with tc interface?

>
> -- YK
>
>>> Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
>>> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>>> ---
>>> �  include/linux/mlx5/mlx5_ifc.h | 32 ++++++++++++++++++++++++++++----
>>> �  1 file changed, 28 insertions(+), 4 deletions(-)
>>>

