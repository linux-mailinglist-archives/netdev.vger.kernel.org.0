Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 075565BFE0C
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 14:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiIUMiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 08:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiIUMiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 08:38:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AADD979EE;
        Wed, 21 Sep 2022 05:37:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADBB6B80C83;
        Wed, 21 Sep 2022 12:37:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBBCFC433D6;
        Wed, 21 Sep 2022 12:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663763876;
        bh=EXRtrHjfnkFVKB3DwKQBmZOIiR3e5xiNkQZjLQ+tXvs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YUytHvcmw1gC96wqBM1ReEGGb7ThQ537ZJobc/IpgkgcFe/m3sP04D6FsjzAd9KdP
         CxTFUWScE7eals96P22c2vXBagQmi7dox1FmsKmP8fB3kg4ip8oi1qlvobsZDDEYXk
         O9BX8iMzVCLH1Z/sSPL9jNs//PM242Zh3KUBM3OeDpN4uQJYhdPRTjvNrToJmovZJr
         nl7F3COLw1YXVxc2uTB5+ZNU6bB2ebByDD/EPmH1WcxDGINA+lEcocQPhzjg5zzZRN
         DX1IRQ4VrYCTick8n8YappKthLwTGD9SY9JGD3UEG5vZyV2M05MGXDQT6LofJOMjYV
         TKmOVX1KdZObg==
Date:   Wed, 21 Sep 2022 05:37:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "huangguangbin (A)" <huangguangbin2@huawei.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <lanhao@huawei.com>,
        <shenjian15@huawei.com>
Subject: Re: [PATCH net-next 0/4] net: hns3: updates for -next
Message-ID: <20220921053755.60e9e6f3@kernel.org>
In-Reply-To: <c5627413-d3e6-a29f-14a7-41a18b8ed6f4@huawei.com>
References: <20220916023803.23756-1-huangguangbin2@huawei.com>
        <c5627413-d3e6-a29f-14a7-41a18b8ed6f4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Sep 2022 10:59:35 +0800 huangguangbin (A) wrote:
> Gentle ping. Any comment or suggestion is appreciated. Thanks!

Sorry we had been away, and I have to double check your DSCP vs PCP
knobs because there's ongoing work in the area and I haven't seen
any comments from folks involved.

I'll get to it today, thanks for the patience.
