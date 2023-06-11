Return-Path: <netdev+bounces-9939-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6B0272B34C
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 19:42:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BB28281105
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 17:42:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DABAE556;
	Sun, 11 Jun 2023 17:42:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432A68498
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 17:42:03 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5691B7
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 10:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686505321; x=1718041321;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GrxuPrukoPU0phCfmXQzQLYc5IAADVbwsS/X+iSrVVE=;
  b=aTxX4GBYX7vBMKxmDIvMXlSHK5KbYPmzvYe+k0WSTaaBSNs7GiKWbY+F
   jiYSUGxIZoZFZWAlCW0YGAcfUyRRc29wie1q1KmdhNyGCFR3T2wZUXMLD
   5pqtclVQD5nVxkb/DJ8xJImLW9euvmAGZ3NNvFT6NuPLgMP6o0T5Gq1Qp
   QocGWkzUvoWWEM5omQG6J83De3jtR4LtT4nIp+l1klFVIkDTZZYsOSDNQ
   IS+meHxVMzhDyECONKM0bgwxStHetDbOkvdQJDj77SFvgYVwXEifwtV5M
   CTUXlER/Nw2l5LxWnPP+Y0kTepZHM9jupV/Kcw71SopSFLYalae5z57Ie
   A==;
X-IronPort-AV: E=Sophos;i="6.00,234,1681196400"; 
   d="scan'208";a="156487325"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Jun 2023 10:42:00 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 11 Jun 2023 10:41:53 -0700
Received: from DEN-LT-70577 (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Sun, 11 Jun 2023 10:41:51 -0700
Date: Sun, 11 Jun 2023 17:41:51 +0000
From: Daniel Machon <daniel.machon@microchip.com>
To: Dave Ertman <david.m.ertman@intel.com>
CC: <intel-wired-lan@lists.osuosl.org>, <simon.horman@corigine.com>,
	<netdev@vger.kernel.org>
Subject: Re: [PATCH iwl-next v4 00/10] Implement support for SRIOV + LAG
Message-ID: <20230611174151.j4is455hv542igqf@DEN-LT-70577>
References: <20230609211626.621968-1-david.m.ertman@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230609211626.621968-1-david.m.ertman@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hmm. v4 series does not apply. Seems like patch #3 is causing some
trouble.

> Implement support for SRIOV VF's on interfaces that are in an
> aggregate interface.
> 
> The first interface added into the aggregate will be flagged as
> the primary interface, and this primary interface will be
> responsible for managing the VF's resources.  VF's created on the
> primary are the only VFs that will be supported on the aggregate.
> Only Active-Backup mode will be supported and only aggregates whose
> primary interface is in switchdev mode will be supported.
> 
> Additional restrictions on what interfaces can be added to the aggregate
> and still support SRIOV VFs are:
> - interfaces have to all be on the same physical NIC
> - all interfaces have to have the same QoS settings
> - interfaces have to have the FW LLDP agent disabled
> - only the primary interface is to be put into switchdev mode
> - no more than two interfaces in the aggregate
> 
> Changes since v1:
> Fix typo in commit message
> Fix typos in warning messages
> Fix typo in function header
> Use correct bitwise operator instead of boolean
> 
> Changes since v2:
> Rebase on current next-queue
> Fix typos in commits
> Fix typos in function headers
> use %u for unsigned values in debug message
> Refactor common code in node moves to subfunction
> 
> Changes since v3:
> Fix typos in warning messages
> move refactor of common code to earlier patch
> expand use of refactored code
> move prototype and func call into patch that defines func
> 
> Dave Ertman (9):
>   ice: Add driver support for firmware changes for LAG
>   ice: changes to the interface with the HW and FW for SRIOV_VF+LAG
>   ice: implement lag netdev event handler
>   ice: process events created by lag netdev event handler
>   ice: Flesh out implementation of support for SRIOV on bonded interface
>   ice: support non-standard teardown of bond interface
>   ice: enforce interface eligibility and add messaging for SRIOV LAG
>   ice: enforce no DCB config changing when in bond
>   ice: update reset path for SRIOV LAG support
> 
> Jacob Keller (1):
>   ice: Correctly initialize queue context values
> 
>  drivers/net/ethernet/intel/ice/ice.h          |    5 +
>  .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   53 +-
>  drivers/net/ethernet/intel/ice/ice_common.c   |   56 +
>  drivers/net/ethernet/intel/ice/ice_common.h   |    4 +
>  drivers/net/ethernet/intel/ice/ice_dcb_nl.c   |   50 +
>  drivers/net/ethernet/intel/ice/ice_lag.c      | 1812 ++++++++++++++++-
>  drivers/net/ethernet/intel/ice/ice_lag.h      |   34 +-
>  drivers/net/ethernet/intel/ice/ice_lib.c      |    2 +-
>  drivers/net/ethernet/intel/ice/ice_lib.h      |    1 +
>  drivers/net/ethernet/intel/ice/ice_main.c     |   26 +-
>  drivers/net/ethernet/intel/ice/ice_sched.c    |   37 +-
>  drivers/net/ethernet/intel/ice/ice_sched.h    |   21 +
>  drivers/net/ethernet/intel/ice/ice_switch.c   |   88 +-
>  drivers/net/ethernet/intel/ice/ice_switch.h   |   29 +
>  drivers/net/ethernet/intel/ice/ice_type.h     |    2 +
>  drivers/net/ethernet/intel/ice/ice_virtchnl.c |    2 +
>  16 files changed, 2092 insertions(+), 130 deletions(-)
> 
> --
> 2.40.1
>

