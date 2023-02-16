Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4527D6991BA
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 11:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjBPKh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 05:37:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbjBPKhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 05:37:55 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD92953571;
        Thu, 16 Feb 2023 02:37:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676543848; x=1708079848;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kMqe039yryvLUYwYovR5pXJjnAtYjuHcm0KlQd2w9jk=;
  b=fmxEpsYKr2G1BwvNrkuZ0OvairkA3hSxia6mUZIWTugU+a+AQcRNE7KY
   suSxmXVx0f7OdXbV2+s/9IBmUji6lg/fz8Zx4xdDbTgkYsTBbKwBZWXhs
   ItdLhGUhxa797wfM8FG7DVTxbevcbpGBaplGxTCYdxPDocwlUem7DVC8O
   7AIdqeXeLTao393VuoJ7n1DmxC8oXtokan4UOII7DRMtd1js+CufzYeaj
   4+3hH7H5uLh1X/S2tGmYfmI28eHkDV9FxkX/eKa2UI/Ne8+bARlChLvaF
   39tEZH0OVLaIQ1MxbqDD1GzWfrRpItoOWF/xd/8cROOAh1djh5unvGSvs
   A==;
X-IronPort-AV: E=Sophos;i="5.97,302,1669100400"; 
   d="scan'208";a="212292284"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Feb 2023 03:37:04 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 03:37:04 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Thu, 16 Feb 2023 03:37:04 -0700
Date:   Thu, 16 Feb 2023 11:37:03 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next] net: lan966x: Use automatic selection of VCAP
 rule actionset
Message-ID: <20230216103703.vutn5bba3ovtpiei@soft-dev3-1>
References: <20230214084206.1412423-1-horatiu.vultur@microchip.com>
 <20230215213052.6ecea372@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230215213052.6ecea372@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 02/15/2023 21:30, Jakub Kicinski wrote:

Hi Jakub,

> 
> On Tue, 14 Feb 2023 09:42:06 +0100 Horatiu Vultur wrote:
> > Now the VCAP API automatically selects the action set, therefore is
> > not needed to be hardcoded anymore to hardcode the action in the
> > lan966x. Therefore remove this.
> 
> The commit message needs some attention here.
> While at it - instead of saying "now" could you provide the commit
> reference? E.g. "Since commit $hash ("$title") the VCAP API...".

I will update this in the next version. Thanks for the feedback!

-- 
/Horatiu
