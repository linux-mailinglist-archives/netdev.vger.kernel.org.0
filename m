Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 073964AD9C9
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 14:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343671AbiBHN3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 08:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355600AbiBHN2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 08:28:47 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF13C1DCB07
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 05:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644326672; x=1675862672;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=B1tCpjV6un607dxflN6kiqI3AoXBmmpFSZ2Asi0Yp3c=;
  b=dpY+8T/LODHAFpWThq88Y+4pLkN2+WAkIP1b9Ya6HDXrVdlYc7O0MyNZ
   NaXXqnnMIV/Q+XFz9K1TpnX2rVCHGafQJWmFCACYBVo6wMq6x9HOZoGxo
   vJQPis1AGar8CqQ6ATqCLcbFRvNqFAGunj6RAMas7lRKQ3XrWxHxpoKAa
   YvjmEKsPC3u6ml7ybkY/FZmTWfff7aJd+BcjsX6WdRTMOpC880PmXs7A1
   +EsOUvl4ey34SmZUHhokf2xr0fFxPsIbjEA3UqglkV7Znz1FQ5Cxd5oiq
   /24xLEZ7AHI7gGB1xCJ6n04WfHncyQDoKyLRPsAQlnuvOJqo1aOl1aOSj
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10251"; a="249152627"
X-IronPort-AV: E=Sophos;i="5.88,352,1635231600"; 
   d="scan'208";a="249152627"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 05:24:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,352,1635231600"; 
   d="scan'208";a="700841823"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga005.jf.intel.com with ESMTP; 08 Feb 2022 05:24:30 -0800
Received: from strzyga.igk.intel.com (strzyga.igk.intel.com [10.237.112.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 218DOTM4026487;
        Tue, 8 Feb 2022 13:24:29 GMT
From:   Marta Plantykow <marta.a.plantykow@intel.com>
To:     netdev@vger.kernel.org, people@netdevconf.info
Cc:     Marta Plantykow <marta.a.plantykow@intel.com>,
        milena.olech@intel.com, maciekm@nvidia.com
Subject: PTP-optimization code upstreamed
Date:   Tue,  8 Feb 2022 14:23:41 +0100
Message-Id: <20220208132341.10743-1-marta.a.plantykow@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
Together with Maciej Machnikowski <maciej.machikowski@intel.com>
<maciejm@nvidia.com> and Milena Olech <milena.olech@intel.com> we would
like to inform you, that the source code of the script used to prepare the
Netdev 0x15 presentation called “Precision Time Protocol optimization
using genetic algorithm” [0] was recently open sourced. The developed
framework provides an easy-to-use automated methodology of tuning the
Proportional-Integral controller embedded in the linuxptp project. In our
research we’ve reached up to 32% smaller mean squared error returned by
phc2sys test (comparing to default PI controller settings).

The code is available under this link [1] along with a short
documentation. A NIC and a driver that supports 1588 is required to run
this test efficiently. All contributions will be considered for acceptance
through pull requests. Do not hesitate to contact us in case of any
questions or concerns.

Marta

[0] https://netdevconf.info/0x15/session.html?Precision-Time-Protocol-optimization-using-genetic-algorithm
[1] https://github.com/intel/PTP-optimization
