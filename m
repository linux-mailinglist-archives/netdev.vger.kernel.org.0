Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D550164B069
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 08:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234656AbiLMHak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 02:30:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234538AbiLMHai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 02:30:38 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41391AF26;
        Mon, 12 Dec 2022 23:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670916638; x=1702452638;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=T/4fTI8XAOxsvA34xrnPsv9rjRhIMMEqFu1gCstvong=;
  b=TxygkzsTjypPM5BTr4NwbAk6NKd2/gFJSG47zqkKIYkBxgaNVKmnDIzr
   /0FfjKgG+We4cBnmtOsjTkfY43xsW5Eu1glLPiEMZJpdfXWftbkT+ZueD
   t2/OuRgvL9ga3Q7FgsAgl/o9NvliCG1oKoUoVaGs2VKcH03CWQp9KLbzG
   b5KB+GFcHy/+qBtu9nfGThOXumaPWCfet2eDu/oV7BC8Yok31aRx3AqgT
   GlgonEpZfOh5DfW3ExDJq2mjAEdYt6XBl4oCKGI6d0BmmIw3O7k5BfvqJ
   2tpWvgfV0rUMrXmHAm1XT/uoZHk2KyWjbCCcoLQ9/q0AsUecSgEXJAYfd
   g==;
X-IronPort-AV: E=Sophos;i="5.96,240,1665471600"; 
   d="scan'208";a="192833257"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Dec 2022 00:30:37 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 13 Dec 2022 00:30:37 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Tue, 13 Dec 2022 00:30:36 -0700
Date:   Tue, 13 Dec 2022 08:35:45 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <lars.povlsen@microchip.com>, <UNGLinuxDriver@microchip.com>,
        kernel test robot <lkp@intel.com>,
        "Dan Carpenter" <error27@gmail.com>
Subject: Re: [PATCH net-next] net: microchip: vcap: Fix initialization of
 value and mask
Message-ID: <20221213073545.vuel5l6k7cej6xk6@soft-dev3-1>
References: <20221209120701.218937-1-horatiu.vultur@microchip.com>
 <20221212130224.19bf695f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221212130224.19bf695f@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 12/12/2022 13:02, Jakub Kicinski wrote:
> 
> On Fri, 9 Dec 2022 13:07:01 +0100 Horatiu Vultur wrote:
> >       case VCAP_FIELD_U128:
> > +             value = data->u128.value;
> > +             mask = data->u128.value;
> 
> If setting both to value is intentional - please mention in the commit
> message. Otherwise this looks odd.

It should not be both set to value. Will fix this in th next version.

-- 
/Horatiu
