Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 513BD643D02
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 07:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbiLFGJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 01:09:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbiLFGJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 01:09:14 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB1F23162
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 22:09:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670306953; x=1701842953;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=v1f0QP6eLsDtOQBfWJefeEHgWgMbNxNPvk4gr1EhYRI=;
  b=DoPjtuqj9J7R/qxeF8y7OkZeKzu7Orjztztf914+p0GWwtilaUPwjfOD
   hvvIlTGnaL16fo8KRF5LNitIdIp0zl3Mgny/rEUVrFc8hDTHMaPtXamQ+
   PtcrQZUaRHSHn14Saflsvob+G49ym/ikZV52NsDnLOQhRv2NnqOt0wT3N
   hftysfJ3iRTsyME6Jz3U4vgCPOCJZFOSWmO02Kq/amacIHfXKgFYmgea7
   sApO93XeQ9KeDKhZ++ph0NUwMT3a6uy04ItkH6//3FcNzXe5u0h0Qg8OV
   YFXfRPmRm2AA+TysMYs0Q6ZaXmM5sa0479+qdw6FksRYwD3Xcu6Kl95e0
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="318403684"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="318403684"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 22:09:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="770612462"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="770612462"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga004.jf.intel.com with ESMTP; 05 Dec 2022 22:09:10 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 38776F4; Tue,  6 Dec 2022 08:09:37 +0200 (EET)
Date:   Tue, 6 Dec 2022 08:09:37 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, michael.jamet@intel.com,
        YehezkelShB@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
Subject: Re: [PATCH net v2] net: thunderbolt: fix memory leak in tbnet_open()
Message-ID: <Y47coXHk7f5ejvww@black.fi.intel.com>
References: <20221206010646.3552313-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221206010646.3552313-1-shaozhengchao@huawei.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 09:06:46AM +0800, Zhengchao Shao wrote:
> When tb_ring_alloc_rx() failed in tbnet_open(), it doesn't free ida.
> 
> Fixes: 180b0689425c ("thunderbolt: Allow multiple DMA tunnels over a single XDomain connection")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
