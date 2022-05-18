Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF1452BC5C
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 16:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237062AbiERMsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237501AbiERMra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:47:30 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52615F2D;
        Wed, 18 May 2022 05:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652878034; x=1684414034;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=C+uDp9ViGte1K2pQuplvZxWMW9fruTKshZJV0UETFoI=;
  b=O8TorOkVjuTRG/EjzqjbSgvOoiGWiviHf62teg6X+4D19Z2oYnSeTFhi
   baPWR26gvyVq7Mg7LEa19CEpe6Zx3NZQs8Vt6QnMV0yFImSuikAZC+iQd
   UtU8uw+uYBTs36sH84UoE7BPy76d/arfXsV4qqmBdQQGR/9WGHTRv+oZZ
   Kbph7M9r/8d3gcQ7Fqx19Y5bPtyRtEiO/NW66Pyk2ytJkDm5/w0AXpfbc
   8ZjqCxIQARq7mnRAkDZ3XjyEAwacBGDTbWeakP4oEciOpiyurVRqldKpw
   tGpIq+TgdiQFgrPyagzlNZpFOM89Wgq+7mS8J5mu5cKppuvf3iX7g2Y59
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="259222208"
X-IronPort-AV: E=Sophos;i="5.91,234,1647327600"; 
   d="scan'208";a="259222208"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 05:47:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,234,1647327600"; 
   d="scan'208";a="742307112"
Received: from mylly.fi.intel.com (HELO [10.237.72.59]) ([10.237.72.59])
  by orsmga005.jf.intel.com with ESMTP; 18 May 2022 05:47:11 -0700
Message-ID: <2637cf42-b7da-a862-c599-ce418645629b@linux.intel.com>
Date:   Wed, 18 May 2022 15:47:10 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.8.1
Subject: Re: [PATCH net 1/2] Revert "can: m_can: pci: use custom bit timings
 for Elkhart Lake"
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        Chee Hou Ong <chee.houx.ong@intel.com>,
        Aman Kumar <aman.kumar@intel.com>,
        Pallavi Kumari <kumari.pallavi@intel.com>,
        stable@vger.kernel.org
References: <20220513130819.386012-1-mkl@pengutronix.de>
 <20220513130819.386012-2-mkl@pengutronix.de>
 <20220513102145.748db22c@kernel.org>
From:   Jarkko Nikula <jarkko.nikula@linux.intel.com>
In-Reply-To: <20220513102145.748db22c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

Sorry the late response. I was offline a few days.

On 5/13/22 20:21, Jakub Kicinski wrote:
>> Fixes: 0e8ffdf3b86d ("can: m_can: pci: use custom bit timings for Elkhart Lake")
>> Link: https://lore.kernel.org/all/20220512124144.536850-1-jarkko.nikula@linux.intel.com
>> Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
>> Reported-by: Chee Hou Ong <chee.houx.ong@intel.com>
>> Reported-by: Aman Kumar <aman.kumar@intel.com>
>> Reported-by: Pallavi Kumari <kumari.pallavi@intel.com>
>> Cc: <stable@vger.kernel.org> # v5.16+
>> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> nit: the hash in the fixes tag should be:
> 
> Fixes: ea4c1787685d ("can: m_can: pci: use custom bit timings for Elkhart Lake")
> 
> Do you want to respin or is the can tree non-rebasable?

Grr... Looks like I took accidentally linux-stable commit Id. Obviously 
too hurry to vacation :-|

Thanks for fixing it up Marc!
