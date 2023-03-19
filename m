Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6A386C0390
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 18:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjCSRpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 13:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjCSRpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 13:45:30 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7E33ABF;
        Sun, 19 Mar 2023 10:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679247927; x=1710783927;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5JuP9/nP/ir9rJn1olix3yRaaoyjhgM9nbdfg9RKNxQ=;
  b=Uvlcm7ebP7YWrjeXll/xp6htK0vt9ysp+WN8Q+khphoCYTUykt4xV40j
   tJTdBJBxSiGfp1hJ8LMa8RtdNc5BNEwbrOdDY6bHrYePe/wRTL0Lxf4lc
   epT6u30GXNEesd/cqVyfTa3RR//aC27Z2LTa7ACUST4n2G9NkaRr5KG4P
   QhnPVHdUdGgRyP6QeFjK8moYQp9Kv0u/uhfN6GBr90CRgunNCyOSFSlXN
   4gDTAuq0ZeInayD+/Fx47UKr7am58M61SyLW6/uGhSX4GK/bcm4ZDqTzz
   2mVcCR9wxNZrPJQD1ugxOSCa97tuwub1Vzzwq9N9nY+DiOxxrjSRDF99a
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,274,1673938800"; 
   d="scan'208";a="206166099"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Mar 2023 10:45:26 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 19 Mar 2023 10:45:25 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Sun, 19 Mar 2023 10:45:25 -0700
Date:   Sun, 19 Mar 2023 18:45:25 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Tom Rix <trix@redhat.com>
CC:     <rajur@chelsio.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <nathan@kernel.org>,
        <ndesaulniers@google.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <llvm@lists.linux.dev>
Subject: Re: [PATCH] net: cxgb3: remove unused fl_to_qset function
Message-ID: <20230319174525.kwhlxme7gh45b3un@soft-dev3-1>
References: <20230319172433.1708161-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230319172433.1708161-1-trix@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 03/19/2023 13:24, Tom Rix wrote:

Hi Tom,

> 
> clang with W=1 reports
> drivers/net/ethernet/chelsio/cxgb3/sge.c:169:32: error: unused function
>   'fl_to_qset' [-Werror,-Wunused-function]
> static inline struct sge_qset *fl_to_qset(const struct sge_fl *q, int qidx)
>                                ^
> This function is not used, so remove it.

Don't forget to mention in the subject which tree is targeting this
patch.
Other than that looks OK.

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  drivers/net/ethernet/chelsio/cxgb3/sge.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/chelsio/cxgb3/sge.c b/drivers/net/ethernet/chelsio/cxgb3/sge.c
> index 62dfbdd33365..efa7f401529e 100644
> --- a/drivers/net/ethernet/chelsio/cxgb3/sge.c
> +++ b/drivers/net/ethernet/chelsio/cxgb3/sge.c
> @@ -166,11 +166,6 @@ static u8 flit_desc_map[] = {
>  #endif
>  };
> 
> -static inline struct sge_qset *fl_to_qset(const struct sge_fl *q, int qidx)
> -{
> -       return container_of(q, struct sge_qset, fl[qidx]);
> -}
> -
>  static inline struct sge_qset *rspq_to_qset(const struct sge_rspq *q)
>  {
>         return container_of(q, struct sge_qset, rspq);
> --
> 2.27.0
> 

-- 
/Horatiu
