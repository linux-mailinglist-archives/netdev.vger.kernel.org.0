Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 037474FE1D4
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236375AbiDLNOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356807AbiDLNOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:14:10 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C2C26D;
        Tue, 12 Apr 2022 06:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649768526; x=1681304526;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=Wv26hdmHsJIqVT96qESvj6NonkWaymDTIvqM2+U2MAU=;
  b=POt7VMKmxdFK4kovNRSoj3d/hh2hw2yuQVXByWGMUyOF1sLw1VMW0pp9
   9avj2NRqV0iXws0d9HW/HCFAmfzn4JyHZYMpjS53oHGmt4Khf4EE040VL
   IiKuK46s7KizAhZ00AJ3uE5QWwjbn4WVSosx7ijDill0yU64B/LhlabpB
   OA+++kXgk9ftft+1pE00tfSz27GWbSU9lxPhXlPZt7v87xfoL/6Binyqp
   vPq8rDeDMW+MXDrtWUNs/hQBPb+DGxX2GtPzjo+rCo+pe+EhY1csC6rXj
   066ysJFMUng1cdps/PpCr9cpDJbT6QaQQegbIVE2awHYwbdnM6NbK9WC6
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10314"; a="322811985"
X-IronPort-AV: E=Sophos;i="5.90,253,1643702400"; 
   d="scan'208";a="322811985"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 06:02:06 -0700
X-IronPort-AV: E=Sophos;i="5.90,253,1643702400"; 
   d="scan'208";a="551702342"
Received: from rsimofi-mobl1.ger.corp.intel.com ([10.252.45.1])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 06:01:59 -0700
Date:   Tue, 12 Apr 2022 16:01:57 +0300 (EEST)
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
Subject: Re: [PATCH net-next v6 07/13] net: wwan: t7xx: Data path HW layer
In-Reply-To: <20220407223629.21487-8-ricardo.martinez@linux.intel.com>
Message-ID: <eaed2892-5833-ebf3-6f13-fe85292026b6@linux.intel.com>
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com> <20220407223629.21487-8-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-2060216357-1649768525=:1546"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-2060216357-1649768525=:1546
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Thu, 7 Apr 2022, Ricardo Martinez wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> Data Path Modem AP Interface (DPMAIF) HW layer provides HW abstraction
> for the upper layer (DPMAIF HIF). It implements functions to do the HW
> configuration, TX/RX control and interrupt handling.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> 
> >From a WWAN framework perspective:
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>

Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

-- 
 i.

--8323329-2060216357-1649768525=:1546--
