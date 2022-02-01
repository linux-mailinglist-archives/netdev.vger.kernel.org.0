Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84FF4A59B8
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 11:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236433AbiBAKOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 05:14:01 -0500
Received: from mga12.intel.com ([192.55.52.136]:58482 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236383AbiBAKOB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 05:14:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643710441; x=1675246441;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=lOAvbYE3sL78n6LKkl3Jnq6VII8YMYqCafxektEyS/8=;
  b=f3EZfZuG0Lg6cEWNfNn94Pk+tHXdofcsc1cA9GawNSvWYqNN+Wm6jhaz
   kI6oURYx54FZxhcyeelgj5L8O1QUehaUjKHwUeWYxX9DB05CbLC/bxojf
   t+0z8BO4j5Dk0BrOjYzsI3rEpiRI5g0e9QiDVA/zFjlxaRaFKVbrxVXUo
   RcgTGmav0JRMzXO8Ly/lBuHiIfBswr/nbD53Z7uXdjVUYbcXfJQ/QE+pz
   fIatzZLWeslxO+VsVhOk6ypITpKnrnjY9zVbXSbVNJpYtdC5bTwkc/VuN
   oePgOuFMwOrkhrLGnbMKJz1ksCGR1JOMLgsndTK/3h8zKW6CiVlY+Y2UK
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="227633487"
X-IronPort-AV: E=Sophos;i="5.88,333,1635231600"; 
   d="scan'208";a="227633487"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 02:13:58 -0800
X-IronPort-AV: E=Sophos;i="5.88,333,1635231600"; 
   d="scan'208";a="537745893"
Received: from mbechagg-mobl.ger.corp.intel.com ([10.249.44.42])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 02:13:52 -0800
Date:   Tue, 1 Feb 2022 12:13:50 +0200 (EET)
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
        sreehari.kancharla@intel.com
Subject: Re: [PATCH net-next v4 07/13] net: wwan: t7xx: Data path HW layer
In-Reply-To: <8593f871-6737-7f85-5035-b1b2d5d312e@linux.intel.com>
Message-ID: <391da589-5256-3b28-646c-56d87d9ebd@linux.intel.com>
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com> <20220114010627.21104-8-ricardo.martinez@linux.intel.com> <8593f871-6737-7f85-5035-b1b2d5d312e@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-389357996-1643710437=:1678"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-389357996-1643710437=:1678
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Tue, 1 Feb 2022, Ilpo Järvinen wrote:

> On Thu, 13 Jan 2022, Ricardo Martinez wrote:
> 
> > From: Haijun Liu <haijun.liu@mediatek.com>
> > 
> > Data Path Modem AP Interface (DPMAIF) HW layer provides HW abstraction
> > for the upper layer (DPMAIF HIF). It implements functions to do the HW
> > configuration, TX/RX control and interrupt handling.
> > 
> > Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> > Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> > Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> > Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> > ---

> > +enum dpmaif_hw_intr_type {
> > +	DPF_INTR_INVALID_MIN,
> > +	DPF_INTR_UL_DONE,
> > +	DPF_INTR_UL_DRB_EMPTY,
> > +	DPF_INTR_UL_MD_NOTREADY,
> > +	DPF_INTR_UL_MD_PWR_NOTREADY,
> > +	DPF_INTR_UL_LEN_ERR,
> > +	DPF_INTR_DL_DONE,
> > +	DPF_INTR_DL_SKB_LEN_ERR,
> > +	DPF_INTR_DL_BATCNT_LEN_ERR,
> > +	DPF_INTR_DL_PITCNT_LEN_ERR,
> > +	DPF_INTR_DL_PKT_EMPTY_SET,
> > +	DPF_INTR_DL_FRG_EMPTY_SET,
> > +	DPF_INTR_DL_MTU_ERR,
> > +	DPF_INTR_DL_FRGCNT_LEN_ERR,
> > +	DPF_INTR_DL_Q0_PITCNT_LEN_ERR,
> > +	DPF_INTR_DL_Q1_PITCNT_LEN_ERR,
> > +	DPF_INTR_DL_HPC_ENT_TYPE_ERR,
> > +	DPF_INTR_DL_Q0_DONE,
> > +	DPF_INTR_DL_Q1_DONE,
> > +	DPF_INTR_INVALID_MAX
> > +};
> > +
> > +#define DPF_RX_QNO0			0
> > +#define DPF_RX_QNO1			1
> > +#define DPF_RX_QNO_DFT			DPF_RX_QNO0
> > +
> > +struct dpmaif_hw_intr_st_para {
> > +	unsigned int intr_cnt;
> > +	enum dpmaif_hw_intr_type intr_types[DPF_INTR_INVALID_MAX - 1];
> > +	unsigned int intr_queues[DPF_INTR_INVALID_MAX - 1];
> 
> Off-by-one errors?
> 
> In addition, I think there's some other problem related to these as
> there are 20 values in enum (of which two are named "INVALID") but
> t7xx_dpmaif_set_intr_para seems to be called only with 17 of them
> (DPF_INTR_DL_DONE not among the calls). This implies intr_cnt will
> likely be too small to cover the last entry when it is being used
> in 08/13 for a for loop termination condition.

Nevermind this one. I misread the code (I somehow got into thinking that 
the type would be used for indexing which isn't true).

-- 
 i.

--8323329-389357996-1643710437=:1678--
