Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4120F573EEE
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 23:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237458AbiGMVYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 17:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237449AbiGMVYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 17:24:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4437C1F61F;
        Wed, 13 Jul 2022 14:24:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB51BB8215D;
        Wed, 13 Jul 2022 21:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E08C34114;
        Wed, 13 Jul 2022 21:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657747474;
        bh=Ash71LMIDavsJFdmUEcbu+7cEaTspXzRK+dGswfzeIs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ge1+TmrP5VVPysTG6lyvt/etpY0RWg96jNg7PkyhWqm4uj67R+ub92GC1aSzkx1nE
         GyWHa/hdauSk7+g8Xg+WSpdXC+78x89Be4a674ls56XKAqE2onO70ffaltn/I2O1OY
         h6+LSuQeV6y+nctS/8+ULoII67/PkWtZ2QyMHPwEKe6uHFNKAuN0Kpx21CpsZAF3zB
         3JlgP2OMhNfe3XOn7J0DEQ59WlBljpu2lMO1ZTvnAMxl9e9uuPGgIJToWbGuGP7JCw
         GoSiqm3WuYCVX/hllgpjc0BiCPd06tGHRfKuKOw/1Umif/KgSbUFEO9lPTrMZB+J2B
         8ms4Iyu64Z5lw==
Date:   Wed, 13 Jul 2022 14:24:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aleksander Bajkowski <olek2@wp.pl>
Cc:     Eric Dumazet <edumazet@google.com>, hauke@hauke-m.de,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: lantiq_xrx200: use skb cache
Message-ID: <20220713142433.131e5a26@kernel.org>
In-Reply-To: <72d3a578-f321-41aa-858c-9f3a6978a277@wp.pl>
References: <20220712181456.3398-1-olek2@wp.pl>
        <CANn89iLbFYaV9MhYMHAzZOKM=ZKaAPOAuuXec_t9G5s4ypnY6A@mail.gmail.com>
        <72d3a578-f321-41aa-858c-9f3a6978a277@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jul 2022 22:38:37 +0200 Aleksander Bajkowski wrote:
> > If you are changing this code path, what about adding proper error recovery ?
> > 
> > skb can be NULL at this point :/
>
> Good catch. I will try to test the fix on the device tomorrow and send the patch.

Let's defer this patch until we merge the fix, otherwise we'll get 
a conflict. Not a big deal but easily avoidable here.
