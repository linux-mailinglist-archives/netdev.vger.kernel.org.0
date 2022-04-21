Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD1A6509E17
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 12:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380390AbiDUK7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 06:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbiDUK7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 06:59:03 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8512128983;
        Thu, 21 Apr 2022 03:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650538575; x=1682074575;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=zFIS0j4pLGZeSZGC4JxB1VOzAz8efnue2qPwuSgIIfg=;
  b=LSA1n2YEVCRws91BHEa7r/aZa9HnWVwzBk7qjFwowfywXT1gaOMyShP0
   +ZlUEqJYeh70D1kZ8kL72nyjfYPfPFgmbKflGEOeDdjrS2JV6gD3nkADb
   lib1qCrSl5oi7iw5LcuRftwp+lVAdK7pDgmSWtSJ/hgqnhTOwu1eOWYjc
   7csE8h+dE7AadJ/uJTNZ0xTtylxP5lvUcPtLH7qjvgqALzeRxCBhvvmsz
   AXopfnfg1GACXai2lN2S4b1+YYwFcKo3zAlb1TkD6gkBLLNt13uXg1wDu
   F2evJfNIy+dFGfoLPoIkNWiWtzHisDaK32CKk03ufnfz08qwtMmIpwveN
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="289428273"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="289428273"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 03:56:14 -0700
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="577162025"
Received: from bpeddu-mobl.amr.corp.intel.com ([10.251.216.95])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 03:56:07 -0700
Date:   Thu, 21 Apr 2022 13:56:05 +0300 (EEST)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        eliot.lee@intel.com, ilpo.johannes.jarvinen@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com, madhusmita.sahu@intel.com
Subject: Re: [PATCH net-next v6 09/13] net: wwan: t7xx: Add WWAN network
 interface
In-Reply-To: <20220407223629.21487-10-ricardo.martinez@linux.intel.com>
Message-ID: <bee4ff3c-d1f-6360-de50-c1d7cf5183c9@linux.intel.com>
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com> <20220407223629.21487-10-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1695390184-1650538573=:1673"
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1695390184-1650538573=:1673
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Thu, 7 Apr 2022, Ricardo Martinez wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> Creates the Cross Core Modem Network Interface (CCMNI) which implements
> the wwan_ops for registration with the WWAN framework, CCMNI also
> implements the net_device_ops functions used by the network device.
> Network device operations include open, close, start transmission, TX
> timeout and change MTU.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Co-developed-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> 
> >From a WWAN framework perspective:
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>

Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

-- 
 i.

--8323329-1695390184-1650538573=:1673--
