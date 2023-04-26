Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 795E16EEF44
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 09:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239466AbjDZHXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 03:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239552AbjDZHXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 03:23:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2261E71
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 00:22:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E81FA633E9
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 07:22:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85EB2C433EF;
        Wed, 26 Apr 2023 07:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682493742;
        bh=DDWDWliv6mDKy28TD4XMMFEDVHnrHYN+J/o/DYBEkJY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nQaJBNwPdNP29B/8hmkZuL1ZBOC5S5zS+oCU70jeQU4tOqQTv8eSpaVl8bhqk7OO/
         /MPAN7AxeC2J6+SoBJ/rFnNv7/hfEtUD/KDJte6h3xsOl2tup59rXgkX5mGDWNCyyY
         nW0YX9P/mehuh+FDC0et8gWXoK5I/fyA6phLqV3nnD7ryTcKEo+Plbgg5KsfkfcatJ
         5hGfYxhyBfsYdTnwMNcmWVsGW6qin2Gi1Hk8Bq3Mn0XLu1XeoOtF7eBy3ankNTVjNk
         RsaHIgu366B0KSmSKkWzF6J1qBReV4/hyMcZQfGvCXQMDKoKTk7jrhYXzn2BFXTHOL
         vjtfvym5csyFw==
Date:   Wed, 26 Apr 2023 10:22:17 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Zahari Doychev <zahari.doychev@linux.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, hmehrtens@maxlinear.com,
        aleksander.lobakin@intel.com, simon.horman@corigine.com,
        idosch@idosch.org, Zahari Doychev <zdoychev@maxlinear.com>
Subject: Re: [PATCH net-next v4 0/3] net: flower: add cfm support
Message-ID: <20230426072217.GM27649@unreal>
References: <20230425211630.698373-1-zahari.doychev@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425211630.698373-1-zahari.doychev@linux.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 11:16:27PM +0200, Zahari Doychev wrote:
> From: Zahari Doychev <zdoychev@maxlinear.com>
> 
> The first patch adds cfm support to the flow dissector.
> The second adds the flower classifier support.
> The third adds a selftest for the flower cfm functionality.
> 
> iproute2 changes will come in follow up patches.

## Form letter - net-next-closed

The merge window for v6.3 has begun and therefore net-next is closed
for new drivers, features, code refactoring and optimizations.
We are currently accepting bug fixes only.

Please repost when net-next reopens after May 8th.

RFC patches sent for review only are obviously welcome at any time.

Thanks
