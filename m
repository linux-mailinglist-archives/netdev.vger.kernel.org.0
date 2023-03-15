Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B62D46BAFC3
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 13:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbjCOMAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 08:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbjCOMAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 08:00:52 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0CC24732;
        Wed, 15 Mar 2023 05:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678881652; x=1710417652;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xvpCIVJIeu4ZIm/FbqSI4upuLqHv8hDiajWcFPM3La4=;
  b=f+74gAgCNzSa+OTYM4e57JAQqLk9kxSuG1fRMR4pkCEJRVsfzb12GFA6
   dQERHPC8TLjStXvyECMq1z/Q+4H+UWLKjQftnykXhPPjjeWMvV1u3YsQU
   OWfhbET/SQR14SulnDTO0FUlZf1Y8rFml/HhUVmdGx7BpJS80pcE3AkUo
   OqOn7LhO0HxoSLqeVqSiFRzFyUquxFskKSIDtOZr9/t0leV/MrKJz3ihO
   cBXF6b02de2+qKIVQFftuVvac03ZV+VzkmC6uYt2rqE/cfB+MPAlupU1J
   OGOlL10rB+NaAeBIjlemS8VRMapAj1AYHgBhuIo6QpFwdP9ndtaO51ROT
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="318075565"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="318075565"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 05:00:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="672709559"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="672709559"
Received: from naamamex-mobl.ger.corp.intel.com (HELO [10.13.12.17]) ([10.13.12.17])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 05:00:48 -0700
Message-ID: <0d77dd8b-a740-ea96-20db-e6c01d466d31@linux.intel.com>
Date:   Wed, 15 Mar 2023 14:00:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [Intel-wired-lan] [PATCH 21/28] e1000e: Remove unnecessary aer.h
 include
Content-Language: en-US
To:     Bjorn Helgaas <helgaas@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
References: <20230307181940.868828-1-helgaas@kernel.org>
 <20230307181940.868828-22-helgaas@kernel.org>
From:   "naamax.meir" <naamax.meir@linux.intel.com>
In-Reply-To: <20230307181940.868828-22-helgaas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/7/2023 20:19, Bjorn Helgaas wrote:
> From: Bjorn Helgaas <bhelgaas@google.com>
> 
> <linux/aer.h> is unused, so remove it.
> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
> Cc: intel-wired-lan@lists.osuosl.org
> ---
>   drivers/net/ethernet/intel/e1000e/netdev.c | 1 -
>   1 file changed, 1 deletion(-)
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
