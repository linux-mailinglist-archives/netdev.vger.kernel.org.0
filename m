Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8200618F40
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 04:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiKDDsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 23:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiKDDsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 23:48:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B12BCB9
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 20:48:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00C66B82B62
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 03:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A07FC433C1;
        Fri,  4 Nov 2022 03:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667533681;
        bh=70NTWhB+8i8eY256Vbx+H6qiYGFUcxSnJk12UqQyk6U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bBiDf6T2WZjggY5wThEh1EHl+po/SMkqq5LmAaVh1f+bHRlrYJ2NPl0qhOJ8jxRxS
         JQLwgeebHThrbs0qzjiltKO8rHobHL8lnF/Mbvvb9gWY9lIgC3Bd5G89/3u0NcSV65
         wYRiUD/MtpAi2bq1gexU01UxRjrjmDfR1GUzTJbW/QAdI5ucg7lD/ZesILtr/x5CEq
         Ilequ+OqCperjavydy8ce0VaCxolvX2W4yok+uNDIJ30UTHf9N3B+hWzR7xKPJx2W6
         ZHldABTKB9lW5ipg9vSO95xIdCBGx3aZQiL+UD3QasF+eidNwHB4Lsqlr5iVkaGOum
         BiEd2WI8YuFVA==
Date:   Thu, 3 Nov 2022 20:48:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Leon Romanovsky <leon@kernel.org>,
        Chentian Liu <chengtian.liu@corigine.com>,
        Huanhuan Wang <huanhuan.wang@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH net-next v3 0/3] nfp: IPsec offload support
Message-ID: <20221103204800.23e3adcf@kernel.org>
In-Reply-To: <20221101110248.423966-1-simon.horman@corigine.com>
References: <20221101110248.423966-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Nov 2022 12:02:45 +0100 Simon Horman wrote:
> It covers three enhancements:
> 
> 1. Patches 1/3:
>    - Extend the capability word and control word to to support
>      new features.
> 
> 2. Patch 2/3:
>    - Add framework to support IPsec offloading for NFP driver,
>      but IPsec offload control plane interface xfrm callbacks which
>      interact with upper layer are not implemented in this patch.
> 
> 3. Patch 3/3:
>    - IPsec control plane interface xfrm callbacks are implemented
>      in this patch.

Steffen, Leon, does this look good to you?
