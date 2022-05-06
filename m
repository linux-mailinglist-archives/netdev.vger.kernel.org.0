Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51B8B51D1A9
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 08:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386581AbiEFG5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 02:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242356AbiEFG5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 02:57:00 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E6866C8E;
        Thu,  5 May 2022 23:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651819998; x=1683355998;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=JrBAjiYntkmoyrBTc5kNh82dNxzchxP8XLy4GDyPicA=;
  b=oAh4psqHkgG7kYnHcbTbngGM8yTia0EGPOPU4GFXmfaeXccHep+hHINm
   gYnjz4eiQ3xiEqdCsHi9GrzihOCqqAOGCG6HFfVGl//N3Cc01QBtd0t9K
   BzK2MKiqOybZJ2IQ74fwaj0cy/3RrsRJ1Ux/drCPwt2e5wydqts0ID9ee
   jOQeBdkcJLPJ+rEsgBUEwUcuA3J3W+1evcBV84PkQx9jwgvj++dkT5S7n
   X30rMHbb2zA5m/3IToq5nrhWHW97LWRLAy0pwtTS8kuk36rByiiFD9D1R
   LOCRNeiNBgCqvh3DTh4SamKtVyaCAyMW67WLokJkpje7I7zBnsCyWx8la
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248278130"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="248278130"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 23:53:18 -0700
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="585814876"
Received: from psierako-mobl.ger.corp.intel.com ([10.252.32.230])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 23:53:12 -0700
Date:   Fri, 6 May 2022 09:53:05 +0300 (EEST)
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
Subject: Re: [PATCH net-next v7 07/14] net: wwan: t7xx: Add AT and MBIM WWAN
 ports
In-Reply-To: <20220506011616.1774805-8-ricardo.martinez@linux.intel.com>
Message-ID: <54c9b34a-37db-f8a9-5b3a-8679d6fa1eb@linux.intel.com>
References: <20220506011616.1774805-1-ricardo.martinez@linux.intel.com> <20220506011616.1774805-8-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-2009634474-1651819997=:1550"
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-2009634474-1651819997=:1550
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Thu, 5 May 2022, Ricardo Martinez wrote:

> From: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> 
> Adds AT and MBIM ports to the port proxy infrastructure.
> The initialization method is responsible for creating the corresponding
> ports using the WWAN framework infrastructure. The implemented WWAN port
> operations are start, stop, and TX.
> 
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
> Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>

Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

-- 
 i.

--8323329-2009634474-1651819997=:1550--
