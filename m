Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD0384D8A96
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 18:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243128AbiCNRO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 13:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243093AbiCNROZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 13:14:25 -0400
Received: from mail2-relais-roc.national.inria.fr (mail2-relais-roc.national.inria.fr [192.134.164.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E2A237CB;
        Mon, 14 Mar 2022 10:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=Xc4eA8rpgoqy7B7cTXuzDix96BTfTFjOoh7vDpL2c1s=;
  b=rlGSQRz366fwbtAv9tN9X9tHyFnowwmmYmU18RXykG3n9zI3m3jFV+qY
   8F0P+1BRtfeCQOvtt/rk70wb0r7LelAWp0+tAiVOXZg6xGv0OG/LEaK3r
   kluh9VEHoAFIQE72zyc3Ntesb8/kHQLwE1rNsZ6gkoD3xp0eBxypJqG20
   A=;
Authentication-Results: mail2-relais-roc.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=julia.lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.90,181,1643670000"; 
   d="scan'208";a="26082786"
Received: from dt-lawall.paris.inria.fr ([128.93.67.65])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 18:13:11 +0100
Date:   Mon, 14 Mar 2022 18:13:10 +0100 (CET)
From:   Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: julia@hadrien
To:     Jakub Kicinski <kuba@kernel.org>
cc:     "David S. Miller" <davem@davemloft.net>,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/30] drivers: net: packetengines: fix typos in
 comments
In-Reply-To: <20220314100630.0ee93704@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <alpine.DEB.2.22.394.2203141812231.2561@hadrien>
References: <20220314115354.144023-1-Julia.Lawall@inria.fr> <20220314115354.144023-13-Julia.Lawall@inria.fr> <20220314100630.0ee93704@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Mon, 14 Mar 2022, Jakub Kicinski wrote:

> On Mon, 14 Mar 2022 12:53:36 +0100 Julia Lawall wrote:
> > Various spelling mistakes in comments.
> > Detected with the help of Coccinelle.
>
> FWIW it would be easier to process the patches if they were posted
> individually, there are no dependencies here.

OK, I hesitated between different options.  If I send more, I will do as
you suggest.

thanks,
julia
