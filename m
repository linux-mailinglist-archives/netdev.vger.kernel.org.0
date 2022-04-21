Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1581509F3B
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 14:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383111AbiDUMFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 08:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384637AbiDUMFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 08:05:01 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06BF31219;
        Thu, 21 Apr 2022 05:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650542525; x=1682078525;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=AbaOiCK+EAHgbJTLsHwe8buT74HUlzWhaSY+4qLD+hY=;
  b=cEwArfB8p6VHlw6vxbfTGwvttPkmi/RNC95Dcfl+T//m6NaQrjaQhI1g
   +EThdAhLJTHSZ6OfEVUbD2f2bQd74ztwBRh8IdH+JZl8SyyxumVunA7oJ
   +5WzPBhyE+bJRKwfTWZl1WmjnUDtLNZIDaFLpY6xOnGu80tHikj3z2mWG
   SmGEVAiZVwbbYGd9Cx6RheA/4A1L0bpjxFL0tDkIb3rxnY2W0F+LHa8/A
   UdZ6rG+piYvhbZvRqmjuAQvhdad7ewmHgN/8elQ7IojA9VBjrIuKEfW/e
   EdUotN94xysiq7v04M6MK4qKCzTJmJ0L/H7tiELXaQsSb6UQkLMTnvPlr
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="324771944"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="324771944"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 05:01:42 -0700
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="577190611"
Received: from bpeddu-mobl.amr.corp.intel.com ([10.251.216.95])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 05:01:36 -0700
Date:   Thu, 21 Apr 2022 15:01:33 +0300 (EEST)
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
Subject: Re: [PATCH net-next v6 13/13] net: wwan: t7xx: Add maintainers and
 documentation
In-Reply-To: <20220407223629.21487-14-ricardo.martinez@linux.intel.com>
Message-ID: <5f4d426-1966-f78d-c09-55f853f8c21f@linux.intel.com>
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com> <20220407223629.21487-14-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1124358250-1650542501=:1673"
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1124358250-1650542501=:1673
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Thu, 7 Apr 2022, Ricardo Martinez wrote:

> Adds maintainers and documentation for MediaTek t7xx 5G WWAN modem
> device driver.
> 
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> 
> >From a WWAN framework perspective:
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>

Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>


-- 
 i.

--8323329-1124358250-1650542501=:1673--
