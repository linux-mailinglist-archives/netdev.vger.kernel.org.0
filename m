Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF455360E86
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 17:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234730AbhDOPQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 11:16:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:52544 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236830AbhDOPPS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 11:15:18 -0400
IronPort-SDR: oYtOCuXz0Wv9UD7QBsMJMo7WLn3/0GUzU+vUInlnRKMDsW61/ir/jaaNIO8mzMFMuFdQGhQ11K
 oFGQmuDLYqfw==
X-IronPort-AV: E=McAfee;i="6200,9189,9955"; a="194982116"
X-IronPort-AV: E=Sophos;i="5.82,225,1613462400"; 
   d="scan'208";a="194982116"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 08:11:38 -0700
IronPort-SDR: W1O9h49MtQt5LLXdFhdgpAP2OG2OQTxd8jip3lFVPlYBen1V0+pl2RooGLxlZYja96qF5mjHfQ
 sj2OsSS5uS6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,225,1613462400"; 
   d="scan'208";a="452953652"
Received: from irsmsx605.ger.corp.intel.com ([163.33.146.138])
  by fmsmga002.fm.intel.com with ESMTP; 15 Apr 2021 08:11:36 -0700
Received: from tjmaciei-mobl1.localnet (10.212.211.155) by
 IRSMSX605.ger.corp.intel.com (163.33.146.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 15 Apr 2021 16:11:34 +0100
From:   Thiago Macieira <thiago.macieira@intel.com>
To:     <netdev@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>,
        Oliver Neukum <oneukum@suse.com>
CC:     <linux-usb@vger.kernel.org>
Subject: Re: rtl8152 / power management kernel hang
Date:   Thu, 15 Apr 2021 08:11:30 -0700
Message-ID: <2853970.3CDyD5GulP@tjmaciei-mobl1>
Organization: Intel Corporation
In-Reply-To: <2223fc29fdbd5a37494454d95952c1b9f8373f3e.camel@suse.com>
References: <7261663.lHksN3My1W@tjmaciei-mobl1> <2223fc29fdbd5a37494454d95952c1b9f8373f3e.camel@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [10.212.211.155]
X-ClientProxiedBy: orsmsx603.amr.corp.intel.com (10.22.229.16) To
 IRSMSX605.ger.corp.intel.com (163.33.146.138)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday, 15 April 2021 03:10:58 PDT Oliver Neukum wrote:
> Hi,
> 
> is this device part of a docking station?

Yes, it is. It's a USB-C dock station by Dell, whose product number I can't 
remember (I think "WD40" but that's not an easy Google search). It's one they 
used to offer for sale 4 years ago or so and has an HDMI, a mini-DP, VGA, 
three USB and one network port in the back.

-- 
Thiago Macieira - thiago.macieira (AT) intel.com
  Software Architect - Intel DPG Cloud Engineering



