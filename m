Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE6C509E3B
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 13:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388679AbiDULGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 07:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237007AbiDULGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 07:06:33 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2854229836;
        Thu, 21 Apr 2022 04:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650539024; x=1682075024;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=FUfS+cjz344RiO7VViL69hSO+YTjXxrJyNAl1KpGWyg=;
  b=KiPdbfhC0hbcuiijxBJGl4e02LH4VWLDBMLA45u9nGRiwjmQTidq6V44
   tbls6Z8hRP1kY6MFX1LrSx+K9g7wgbX7bBe1fFa+6LJRlRRIrjmAB5gaM
   w/XszcdpjrXyl01VlOCv1GtRnE68Z3ARZ3DDzncYaQwNSiZJXRtSTBXEh
   hPi54ziK2BeT6i748/uAMhULJJPYDmpCl5zB//jy+Htyk1rBzaVivwhge
   agrcxgw/P7hheKXgXTZJNJ8WaOrf45ZKr6Xq9MWESfH+9nZtKJvv8xQtq
   nFvbj6puubDSEzFqhk4Pnwi1+FzmizQFv7EDVl1eHzMU1EYn/XfQdP0TK
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="264081727"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="264081727"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 04:03:43 -0700
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="577165472"
Received: from bpeddu-mobl.amr.corp.intel.com ([10.251.216.95])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 04:03:37 -0700
Date:   Thu, 21 Apr 2022 14:03:35 +0300 (EEST)
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
Subject: Re: [PATCH net-next v6 11/13] net: wwan: t7xx: Runtime PM
In-Reply-To: <20220407223629.21487-12-ricardo.martinez@linux.intel.com>
Message-ID: <ca87beb2-bd7d-932f-3b3-e573a2f1730@linux.intel.com>
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com> <20220407223629.21487-12-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1590397706-1650539023=:1673"
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

--8323329-1590397706-1650539023=:1673
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Thu, 7 Apr 2022, Ricardo Martinez wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> Enables runtime power management callbacks including runtime_suspend
> and runtime_resume. Autosuspend is used to prevent overhead by frequent
> wake-ups.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Eliot Lee <eliot.lee@intel.com>
> Signed-off-by: Eliot Lee <eliot.lee@intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>

Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

-- 
 i.

--8323329-1590397706-1650539023=:1673--
