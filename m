Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2BA9498706
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 18:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244726AbiAXRhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 12:37:04 -0500
Received: from mga04.intel.com ([192.55.52.120]:39507 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244706AbiAXRhC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 12:37:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643045822; x=1674581822;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FUZC/e5xkZGN112lLRWuyS219UiLmaVqnCFLWTG+TYk=;
  b=ZpKhtT2BS1GKl/bG+HYZIzDBFCS6B0JESRkcbABNc7fEP/EVKDcR1WKT
   sr0Sl1EsxfmBe7DsVqcQXPz+Jo8AE/KMNB1lC2bJM4Z1Zm2BWmug409K4
   y4KFQwLbyqQm9dmHvd6HS3Ya9nYRgtXSxXKrph/iCgi7OCBhTbfz82mj/
   YeNH4StPne/l/0BdQa5AT/vA4henhvkcWHeJq9ZaFKBXBHcufUfRKhAab
   GFPwdr+XP3JVxlqzqAd+SFSDcA5T+UjjrpRpT5XU6c/yBv4ZwsEmTgDtT
   i1VBmDXysXsqe19hVWYljy8pyHWsxeM3LPhlL3txmoLU0LURpLGAsgTNG
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="244936597"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="244936597"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 09:37:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="673697723"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga001.fm.intel.com with ESMTP; 24 Jan 2022 09:36:59 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 20OHawV0011179;
        Mon, 24 Jan 2022 17:36:58 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: ice: Add support for inner etype in switchdev
Date:   Mon, 24 Jan 2022 18:35:19 +0100
Message-Id: <20220124173519.739323-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124173116.739083-6-alexandr.lobakin@intel.com>
References: <20220124173116.739083-1-alexandr.lobakin@intel.com> <20220124173116.739083-6-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alexandr.lobakin@intel.com>
Date: Mon, 24 Jan 2022 18:31:16 +0100

> From: Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@intel.com>
> 
> Enable support for adding TC rules that filter on the inner
> EtherType field of tunneled packet headers.
> 
> Signed-off-by: Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@intel.com>
> Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>

That one was included by mistake, sorry :c

> ---
>  drivers/net/ethernet/intel/ice/ice_protocol_type.h |   2 +
>  drivers/net/ethernet/intel/ice/ice_switch.c        | 272 ++++++++++++++++++++-
>  drivers/net/ethernet/intel/ice/ice_tc_lib.c        |  15 +-
>  3 files changed, 277 insertions(+), 12 deletions(-)
> 

--- 8< ---

> -- 
> cgit 1.2.3-1.el7

Thanks,
Al
