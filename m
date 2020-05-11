Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 215BD1CE833
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 00:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgEKWhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 18:37:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:50897 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbgEKWhZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 18:37:25 -0400
IronPort-SDR: lRoeHpRZLYdh6c3YR3dLloPzcqwRso6gE1LxU78TCq4x7TM/P8Wj9uE5wIlJSetlvjA//Ttyc+
 1TN8UzzvRhHA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2020 15:37:24 -0700
IronPort-SDR: Hgj4v5qHUgTrp3DVFUW65MZLDUajFdTscGdZnTXhQpveNelzK+sV5FPjPEJck4QaDBcZ4NkJlm
 tS9BFAcrx8yA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,381,1583222400"; 
   d="scan'208";a="261912343"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.102.114]) ([10.212.102.114])
  by orsmga003.jf.intel.com with ESMTP; 11 May 2020 15:37:22 -0700
Subject: Re: [RFC v2] current devlink extension plan for NICs
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, parav@mellanox.com,
        yuvalav@mellanox.com, jgg@ziepe.ca, saeedm@mellanox.com,
        leon@kernel.org, andrew.gospodarek@broadcom.com,
        michael.chan@broadcom.com, moshe@mellanox.com, ayal@mellanox.com,
        eranbe@mellanox.com, vladbu@mellanox.com, kliteyn@mellanox.com,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        tariqt@mellanox.com, oss-drivers@netronome.com,
        snelson@pensando.io, drivers@pensando.io, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, grygorii.strashko@ti.com,
        mlxsw@mellanox.com, idosch@mellanox.com, markz@mellanox.com,
        valex@mellanox.com, linyunsheng@huawei.com, lihong.yang@intel.com,
        vikas.gupta@broadcom.com, sridhar.samudrala@intel.com
References: <20200501091449.GA25211@nanopsycho.orion>
 <20200510144557.GA7568@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <cae23153-f6b2-ee33-5bb7-f39db23947f3@intel.com>
Date:   Mon, 11 May 2020 15:37:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200510144557.GA7568@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/10/2020 7:45 AM, Jiri Pirko wrote:
> Hello guys.
> 
> Anyone has any opinion on the proposal? Or should I take it as a silent
> agreement? :)

I am still reading through this whole thing. I haven't given feedback
yet because it is a lot to process.

-Jake
