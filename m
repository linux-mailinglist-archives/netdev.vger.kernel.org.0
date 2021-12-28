Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77E91480765
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 09:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235642AbhL1IbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 03:31:13 -0500
Received: from mga17.intel.com ([192.55.52.151]:55153 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231670AbhL1IbM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Dec 2021 03:31:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640680272; x=1672216272;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8Ssk9PkU1lCaW+X3QfKqSrqg8kbgcpFLOWTB2Ryx3Rk=;
  b=AVDJhQiDnQed0H13sM4PVb9nWVToFGd61SnWg4dYabaXTl2GXj46RUrc
   KalqfmNWENyK/IKxdFsGW2Q9y7e0PSirpUmz/KAkITjNhMbZ7Qe8fFTmR
   YE0Lily1uFuzkr61c/mPaPxu5pB5B1OopGF/NyywJxdk6IGg1ELhmV7E3
   BgaCNpmTi1A7h5dOk0mmAWrnkCDYm28jgFnGFQx7MJMMP83psBjnMawXi
   O5lqCyu/TxeT+zd2+cdEevgpvp+AogSXAqmx+UAEySNfGuGauqsgbHfL9
   7cWsQiXZf3TCQ+v8WcfRS/dExc/st1CTheWKNt5UcKd5ATm+4qOtQMMPX
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10210"; a="222007271"
X-IronPort-AV: E=Sophos;i="5.88,242,1635231600"; 
   d="scan'208";a="222007271"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2021 00:31:12 -0800
X-IronPort-AV: E=Sophos;i="5.88,242,1635231600"; 
   d="scan'208";a="510113012"
Received: from krausnex-mobl.ger.corp.intel.com (HELO [10.13.8.81]) ([10.13.8.81])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2021 00:31:06 -0800
Message-ID: <b9fdc714-ce83-23fc-cde4-b53e02565ae3@linux.intel.com>
Date:   Tue, 28 Dec 2021 10:31:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [Intel-wired-lan] [PATCH net v3] igc: Fix TX timestamp support
 for non-MSI-X platforms
Content-Language: en-US
To:     James McLaughlin <james.mclaughlin@qsc.com>, davem@davemloft.net,
        kuba@kernel.org, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-kernel@vger.kernel.org
References: <20211217234933.740942-1-james.mclaughlin@qsc.com>
From:   "Kraus, NechamaX" <nechamax.kraus@linux.intel.com>
In-Reply-To: <20211217234933.740942-1-james.mclaughlin@qsc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/18/2021 01:49, James McLaughlin wrote:
> Time synchronization was not properly enabled on non-MSI-X platforms.
> 
> Fixes: 2c344ae24501 ("igc: Add support for TX timestamping")
> 
> Signed-off-by: James McLaughlin <james.mclaughlin@qsc.com>
> Reviewed-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---
> 
> Still same work email client issues.  Apologies, mis-titled it again.
> v2->v3 fixed title
> 
>   drivers/net/ethernet/intel/igc/igc_main.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>

