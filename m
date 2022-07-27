Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20C8D582575
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 13:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbiG0Ldm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 07:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbiG0Ldk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 07:33:40 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043F1491F2;
        Wed, 27 Jul 2022 04:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658921620; x=1690457620;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IeBX7LmCL0VI09++8r3L+Vz4FW+/T20asT8Sfkt+BSw=;
  b=MQFPmWLjeYweqpxtQuNaf63Gg9Mt8Lqka1yL/GAc504ex4tcTGGdLbPj
   IHrp8M5urAG1wsb3Vl+yE3flE6L9X7j8Il1bI3+JB+90CN/Bp5EcBHrj/
   abK+I4CU4OGhX/U5GyChurGK9h5h1pkf+yqVRdWczHXX0y2rbMjap9UDX
   DS27QoVX8/Ep3G3Ena9HA1LcTV2Db6XxklfDdEMPMhKwRBfIwzf5G8hUE
   d4kATzIDlUQK/eKEDh4iBytuatZn2u3VisiQ2skt58PPT5XIWgHbG9Iia
   nAFUbzlZ69hZ5OR+mjO+eYuoBL/JvccRFxsLcacuAcy9McKrU22dgMyRO
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="374509802"
X-IronPort-AV: E=Sophos;i="5.93,195,1654585200"; 
   d="scan'208";a="374509802"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 04:33:39 -0700
X-IronPort-AV: E=Sophos;i="5.93,195,1654585200"; 
   d="scan'208";a="689838477"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 04:33:34 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oGfIB-001cWH-0m;
        Wed, 27 Jul 2022 14:33:31 +0300
Date:   Wed, 27 Jul 2022 14:33:30 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org, sean.wang@mediatek.com,
        Landen.Chao@mediatek.com, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, hkallweit1@gmail.com,
        gjb@semihalf.com, jaz@semihalf.com, tn@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, upstream@semihalf.com
Subject: Re: [net-next: PATCH v3 5/8] device property: introduce
 fwnode_find_parent_dev_match
Message-ID: <YuEiipCihzWbQkmO@smile.fi.intel.com>
References: <20220727064321.2953971-1-mw@semihalf.com>
 <20220727064321.2953971-6-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727064321.2953971-6-mw@semihalf.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 08:43:18AM +0200, Marcin Wojtas wrote:
> This patch adds a new generic routine fwnode_find_parent_dev_match

"This patch..."

> that can be used e.g. as a callback for class_find_device().
> It searches for the struct device corresponding to a
> struct fwnode_handle by iterating over device and
> its parents.

-- 
With Best Regards,
Andy Shevchenko


