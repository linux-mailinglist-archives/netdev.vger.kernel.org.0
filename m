Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC4B8509E2F
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 13:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388642AbiDULEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 07:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242691AbiDULEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 07:04:34 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F3D1582C;
        Thu, 21 Apr 2022 04:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650538904; x=1682074904;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=n4R2iOAvKoL+enYbdjbKQwxCRq/SFb/AoLYd2iZw23Q=;
  b=FgLWOfAJ7HLziesSIZkPnyg5XRdCxtbz/e5O1VCOnaRQcMLrPdPNAWUl
   4GpdOJkQCJrHiZxNLz/GFbLWzS177oPCaq5xQDCSTAUYq2u4AC+s5RHY5
   qP7u02DBM+Eko+58pnhoqTkzpPIo4Kjb/gjpmzus23O0aap1AmbVERVPl
   A9NRd9vnLNPOZ1TLEIHAfMwf+NvvTZ+Sza/BVmMu6C8JW56asqgMJVoHg
   l2eHClkT8KF4jq/BrGo8+ltqrbPWxIEsOf4KnrNyd7GFwTe0c78oqdvKN
   gcVzUh+F6ptbiKQzspEmXK20ojEKWbwtamRh/omFXk6SU5nAn8OC1oLvD
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="264081290"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="264081290"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 04:01:44 -0700
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="577164681"
Received: from bpeddu-mobl.amr.corp.intel.com ([10.251.216.95])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 04:01:38 -0700
Date:   Thu, 21 Apr 2022 14:01:35 +0300 (EEST)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
cc:     Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com, madhusmita.sahu@intel.com
Subject: Re: [PATCH net-next v6 10/13] net: wwan: t7xx: Introduce power
 management
In-Reply-To: <20220407223629.21487-11-ricardo.martinez@linux.intel.com>
Message-ID: <bd70df1c-3721-c0f6-5c0-32d6cf9536ae@linux.intel.com>
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com> <20220407223629.21487-11-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-963031988-1650538903=:1673"
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-963031988-1650538903=:1673
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Thu, 7 Apr 2022, Ricardo Martinez wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> Implements suspend, resumes, freeze, thaw, poweroff, and restore
> `dev_pm_ops` callbacks.
> 
> >From the host point of view, the t7xx driver is one entity. But, the
> device has several modules that need to be addressed in different ways
> during power management (PM) flows.
> The driver uses the term 'PM entities' to refer to the 2 DPMA and
> 2 CLDMA HW blocks that need to be managed during PM flows.
> When a dev_pm_ops function is called, the PM entities list is iterated
> and the matching function is called for each entry in the list.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>

Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

-- 
 i.

--8323329-963031988-1650538903=:1673--
