Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F4040598637
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 16:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245603AbiHROna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 10:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245095AbiHROn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 10:43:28 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657DA55A9
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 07:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660833806; x=1692369806;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=JzUFa9YldVMdLaPygK6tHVrioF1m7gNGQI7xZePx82M=;
  b=SnbEwaDor/79KEUbGh/U4zc0BCW5VQeqeWs5CL7oIOWYz5ojQa4zIJN2
   WCO5T2VRKi6ZF+jnV1RDuFxS5B1zxVow2VOWtjVyEJefpT9HIkm3RndY1
   jYhTYduWXXKN8X7EKG2fv7ChJVuVPd5DZ4YDJjsehiwECW+aGsSTSWsmh
   X3PB7TPjlmlBQ79mViZtm6uTwdpQkUamXZdMuc2NZXCRN2Dv0et3W5+TZ
   Jw/nFFUmgHGJK9ybyUkRfE2LQSTX9ADe7Zif3ZjAJ4ox7UoSlPdG81/Ey
   v3CidZMxgRV6yECKo60f0a/oNiQtcNZnbG2po0GPFgNdhR3St/D6f5nku
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="292771538"
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="292771538"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 07:43:25 -0700
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="668131283"
Received: from dursu-mobl1.ger.corp.intel.com ([10.249.42.244])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 07:43:22 -0700
Date:   Thu, 18 Aug 2022 17:43:20 +0300 (EEST)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     m.chetan.kumar@intel.com
cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, krishna.c.sudi@intel.com,
        m.chetan.kumar@linux.intel.com, linuxwwan@intel.com,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
Subject: Re: [PATCH net-next 5/5] net: wwan: t7xx: Devlink documentation
In-Reply-To: <20220816042417.2416988-1-m.chetan.kumar@intel.com>
Message-ID: <fd6e3c45-e074-122b-53c7-d622a337fbd@linux.intel.com>
References: <20220816042417.2416988-1-m.chetan.kumar@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Aug 2022, m.chetan.kumar@intel.com wrote:

> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> 
> Document the t7xx devlink commands usage for fw flashing &
> coredump collection.
> 
> Refer to t7xx.rst file for details.
> 
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> Signed-off-by: Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
> ---

> +``t7xx`` driver uses fastboot protocol for fw flashing. In the fw flashing
> +procedure, fastboot command's & response's are exchanged between driver

Using 's here seems incorrect.

> +and wwan device.

> +Note: component "value" represents the partition type to be programmed.

"value" is hard to understand here. I'd just say "component selects the 
partition type to be programmed."

> +      - The detailed modem components log are captured in this region

"components log are" seems inconsistent.


-- 
 i.
