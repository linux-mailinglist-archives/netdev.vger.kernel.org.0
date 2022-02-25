Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5987D4C4440
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 13:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240291AbiBYMGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 07:06:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiBYMGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 07:06:39 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ADBA75219;
        Fri, 25 Feb 2022 04:06:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645790765; x=1677326765;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=ObLS9kfOGZVIFMNgWuztsjFtRrNrQBhB48oXlLwHkwc=;
  b=e4uO08I03y6Bv9/Y6lTLLgq70APSXsSicJ621kKMN2PtxZwXG3JW5qwO
   pG6jw627b27pwgaNZ11TUI2t2sh6WQCOOcmQkc1CBueVD0eJmw6rypjtl
   TQqPUCUTy03yx2i6IzY2b053028HiSAlxHnAuvwKTTADf7Z75JPpa/0aF
   gyJmqCY+Tod/6JSY0qT5qObWJDqo4MBJotqAhLbzImbf5c2ymxi1by3ks
   uMKF5SunPBbBl02SEOKsjyz9MNVbSRDE4LeJw3wv06qa2W74lmqJHqkFg
   WxQtG15KoPN6OemSd0MSlJGZ3PZ2EcOg4FM/SBl+PFsUyrS4mh7JFECx6
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="251312578"
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="251312578"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 04:06:03 -0800
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="549236149"
Received: from grossi-mobl.ger.corp.intel.com ([10.252.47.60])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 04:05:57 -0800
Date:   Fri, 25 Feb 2022 14:05:56 +0200 (EET)
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
Subject: Re: [PATCH net-next v5 05/13] net: wwan: t7xx: Add control port
In-Reply-To: <20220223223326.28021-6-ricardo.martinez@linux.intel.com>
Message-ID: <8b203e9-d7f5-cea8-db97-f5506c9f16e@linux.intel.com>
References: <20220223223326.28021-1-ricardo.martinez@linux.intel.com> <20220223223326.28021-6-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1991548370-1645790763=:1607"
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1991548370-1645790763=:1607
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Wed, 23 Feb 2022, Ricardo Martinez wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> Control Port implements driver control messages such as modem-host
> handshaking, controls port enumeration, and handles exception messages.
> 
> The handshaking process between the driver and the modem happens during
> the init sequence. The process involves the exchange of a list of
> supported runtime features to make sure that modem and host are ready
> to provide proper feature lists including port enumeration. Further
> features can be enabled and controlled in this handshaking process.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> 
> >From a WWAN framework perspective:
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
> ---

> @@ -412,6 +651,7 @@ static struct t7xx_modem *t7xx_md_alloc(struct t7xx_pci_dev *t7xx_dev)
...
>  	md->core_md.ready = false;
> +	md->core_md.handshake_ongoing = false;

These assignments are not needed with mem from kzalloc.

Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>


-- 
 i.

--8323329-1991548370-1645790763=:1607--
