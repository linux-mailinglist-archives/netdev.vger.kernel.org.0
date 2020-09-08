Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28035261164
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 14:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730203AbgIHMb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 08:31:28 -0400
Received: from mga17.intel.com ([192.55.52.151]:46270 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730173AbgIHLvj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 07:51:39 -0400
IronPort-SDR: HXtBUuOkDAc6tMlC4VIcrD9k3IvNMObdZnla9KtNpk1j/B7043z9mTcEXPtGHjOGAuK4IA6NW0
 7/jQDvqsqKpw==
X-IronPort-AV: E=McAfee;i="6000,8403,9737"; a="138159970"
X-IronPort-AV: E=Sophos;i="5.76,405,1592895600"; 
   d="scan'208";a="138159970"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2020 04:43:25 -0700
IronPort-SDR: /KW5xN9tmU+/VP+yjJ+PMtZ4bqPvEQwsINO0yacB5Yo53ixbt1zCcyaO1/L/qDpSkx+PrqXyl6
 dIVPtvcrIJmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,405,1592895600"; 
   d="scan'208";a="284485960"
Received: from pgierasi-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.39.2])
  by fmsmga007.fm.intel.com with ESMTP; 08 Sep 2020 04:43:23 -0700
Subject: Re: [Intel-wired-lan] [PATCH bpf-next 4/4] ixgbe, xsk: use
 XSK_NAPI_WEIGHT as NAPI poll budget
To:     Paul Menzel <pmenzel@molgen.mpg.de>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kuba@kernel.org, intel-wired-lan@lists.osuosl.org,
        magnus.karlsson@intel.com
References: <20200907150217.30888-1-bjorn.topel@gmail.com>
 <20200907150217.30888-5-bjorn.topel@gmail.com>
 <82901368-8e17-a63d-0e46-2434b5777c04@molgen.mpg.de>
 <0fb03a39-d098-8fc9-ba70-e919ef8e091e@intel.com>
 <0b927a07-6fbb-0e5b-e791-9558c9ea8e63@molgen.mpg.de>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <9d488b02-b03f-e1ee-d4c5-12e330d567b1@intel.com>
Date:   Tue, 8 Sep 2020 13:43:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0b927a07-6fbb-0e5b-e791-9558c9ea8e63@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-08 13:20, Paul Menzel wrote:
[...]>> Paul, thanks for the input! The netdev/bpf trees always include the
>> cover letter in the merge commit.
> 
> Yes, for pull/merge requests. But you posted them to the list, so I’d 
> assume they will be applied with `git am` and not merged, or am I 
> missing something. Could you please point me to a merge commit where the 
> patches were posted to the list?
> 

An example: A series is posted to the list [1], and when merged the 
merge commit look like [2].


Thanks,
Björn


[1] 
https://lore.kernel.org/bpf/20200520192103.355233-1-bjorn.topel@gmail.com/
[2] 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=79917b242c3fe0d89e4752bc25ffef4574c2194b
