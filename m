Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A69E26223A9
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 07:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiKIGGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 01:06:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKIGGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 01:06:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B211F2FA;
        Tue,  8 Nov 2022 22:06:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5228BB81C5A;
        Wed,  9 Nov 2022 06:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3640CC433D6;
        Wed,  9 Nov 2022 06:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667973975;
        bh=ipBLspvEuvIBMBZEznZgff6zQAxZ7WdkSixtfJsK26s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zkc8e5Tzu+LQjSIIM6qShKbnL4tnRXFLkf6jXklM3DlwsdW65/TLZjRKTGFpXMY2o
         PmjsGLnYAh9BkSS2JDWxhhmQUpQEiREuhzZjj02pTTfG/u9SW9zlQ4wPhuL9GWYv9r
         j2Wqpj78JLb+F0KsQ+VIjYHbPF9/uX2RzenH7meSjNliYk/bOX+puFcLi8chV5foGn
         rU3MKVP2vwaYRTeqQ4AIDvsMW28GmhHJiObVbA56YORoDEz6jUSoK2oiAxxKM59h7L
         m8Mp0QzkP0e9S6GttU2GP5lmg3xGQIqT54ogy/c5VNkPMtJ7qP24gAzApk3OZe9RI9
         hibU6WtX0McwA==
Date:   Wed, 9 Nov 2022 08:06:09 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, edumazet@google.com,
        longli@microsoft.com, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, shiraz.saleem@intel.com,
        Ajay Sharma <sharmaajay@microsoft.com>,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [Patch v10 00/12] Introduce Microsoft Azure Network Adapter
 (MANA) RDMA driver
Message-ID: <Y2tDUXt3C9KPgI2z@unreal>
References: <1667502990-2559-1-git-send-email-longli@linuxonhyperv.com>
 <Y2qqq9/N65tfYyP0@unreal>
 <20221108150529.764b5ab8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108150529.764b5ab8@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 03:05:29PM -0800, Jakub Kicinski wrote:
> On Tue, 8 Nov 2022 21:14:51 +0200 Leon Romanovsky wrote:
> > Can you please ACK/comment on eth part of this series? And how should
> > we proceed? Should we take this driver through shared branch or apply
> > directly to RDMA tree?
> 
> LGTM. Is it possible to get patches 1-11 thry a shared branch and then
> you can apply 12 directly to RDMA? That seems optimal to me.

Of course.

Thanks
