Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCC7E5AC36A
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 10:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbiIDIUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 04:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiIDIUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 04:20:09 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00FF42CCA8;
        Sun,  4 Sep 2022 01:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662279608; x=1693815608;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vUkKqMd+013HwWmzXgAGkD/lAPQSyq4o+Dw/LJBJna8=;
  b=VGOtql+HwvHXobTuwyhVS967CJSEIXF/Ow0QB9elXLUmMxTs9QofsKaB
   o6sO6vlJj2Vkx9KGEHdC84knx50tEUnJItEs3nsHZyoKmcrXtwQszfP1z
   tMkH+sIXsHQvIf7nI5UKXvEqCjXrGpXHPZqPW4FOF/4YyLib5LEDLq2aT
   IQQ8KsVvgYLgFCuusqXkU7dtW7ZGk0aC68S3pCZW+elTPnU1seTVrZoKC
   01wB2jp8J+QXqAY1wk5L1DGIc9tY0Ew9GRBMpS39gSTM9EmPgf88K5TM5
   Nmv+RdwUquFhX6zIlj3petyEVeCCf1RspeIRCu0K8ULV0SE7uFyuZ2pYE
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10459"; a="296225827"
X-IronPort-AV: E=Sophos;i="5.93,288,1654585200"; 
   d="scan'208";a="296225827"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2022 01:19:56 -0700
X-IronPort-AV: E=Sophos;i="5.93,288,1654585200"; 
   d="scan'208";a="643438167"
Received: from naamamex-mobl.ger.corp.intel.com (HELO [10.13.13.50]) ([10.13.13.50])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2022 01:19:54 -0700
Message-ID: <2a31d5cc-63db-9b4a-94ca-264ed5cd2adf@linux.intel.com>
Date:   Sun, 4 Sep 2022 11:19:45 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [Intel-wired-lan] [PATCH v3] drivers/net/ethernet/e1000e: check
 return value of e1e_rphy()
Content-Language: en-US
To:     Li Zhong <floridsleeves@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        davem@davemloft.net
References: <20220830071549.2137413-1-floridsleeves@gmail.com>
From:   "naamax.meir" <naamax.meir@linux.intel.com>
In-Reply-To: <20220830071549.2137413-1-floridsleeves@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/30/2022 10:15, Li Zhong wrote:
> e1e_rphy() could return error value when reading PHY register, which
> needs to be checked.
> 
> Signed-off-by: Li Zhong <floridsleeves@gmail.com>
> ---
>   drivers/net/ethernet/intel/e1000e/phy.c | 20 +++++++++++++++++---
>   1 file changed, 17 insertions(+), 3 deletions(-)
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
