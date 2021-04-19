Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65161364783
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 17:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241891AbhDSPyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 11:54:31 -0400
Received: from mga05.intel.com ([192.55.52.43]:59626 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241648AbhDSPyb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 11:54:31 -0400
IronPort-SDR: q1gW2gfAasQCwWm+j68PgG35K2YwXUkGnP7odxT3PxY4x6729v+5tEPJCxZSOKWyYjaO5JCF2u
 +MG5dl1LAsuA==
X-IronPort-AV: E=McAfee;i="6200,9189,9959"; a="280674782"
X-IronPort-AV: E=Sophos;i="5.82,234,1613462400"; 
   d="scan'208";a="280674782"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2021 08:53:58 -0700
IronPort-SDR: Fz92sTGQyIeGW6RuT0g/MGtHBIiNtp3elmfLr4Mmcpqgfxbi4HlZDVATAOBdH6DNopZtaVCH0k
 B+FsQHu4wWlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,234,1613462400"; 
   d="scan'208";a="385020316"
Received: from irsmsx605.ger.corp.intel.com ([163.33.146.138])
  by orsmga006.jf.intel.com with ESMTP; 19 Apr 2021 08:53:56 -0700
Received: from tjmaciei-mobl1.localnet (10.251.12.226) by
 IRSMSX605.ger.corp.intel.com (163.33.146.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 19 Apr 2021 16:53:54 +0100
From:   Thiago Macieira <thiago.macieira@intel.com>
To:     <netdev@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>,
        Oliver Neukum <oneukum@suse.com>
CC:     <linux-usb@vger.kernel.org>
Subject: Re: rtl8152 / power management kernel hang
Date:   Mon, 19 Apr 2021 08:53:51 -0700
Message-ID: <4365289.qXpdF7q2Ag@tjmaciei-mobl1>
Organization: Intel Corporation
In-Reply-To: <9fd3ff38935e4c9c1d631606adf241d63171cfde.camel@suse.com>
References: <7261663.lHksN3My1W@tjmaciei-mobl1> <2853970.3CDyD5GulP@tjmaciei-mobl1> <9fd3ff38935e4c9c1d631606adf241d63171cfde.camel@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [10.251.12.226]
X-ClientProxiedBy: orsmsx603.amr.corp.intel.com (10.22.229.16) To
 IRSMSX605.ger.corp.intel.com (163.33.146.138)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday, 19 April 2021 03:35:43 PDT Oliver Neukum wrote:
> One of them at least has a systemic issue with power management.
> Please check the upcoming kernel for whether it is your model.

Thanks, Oliver, will do.

For clarification, "upcoming" is 5.12 or 5.13? Tumbleweed is still on 5.11.

-- 
Thiago Macieira - thiago.macieira (AT) intel.com
  Software Architect - Intel DPG Cloud Engineering



