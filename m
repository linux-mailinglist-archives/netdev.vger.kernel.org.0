Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1D10622003
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 00:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbiKHXFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 18:05:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbiKHXFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 18:05:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE61464A24;
        Tue,  8 Nov 2022 15:05:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DF80B81CAB;
        Tue,  8 Nov 2022 23:05:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B438C433B5;
        Tue,  8 Nov 2022 23:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667948731;
        bh=RBLgHBB0Z3W4Iw18n+o0/QOG1f2tnCKMfYYaH7jkj5w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dlEmXrcMPbRbe/ejLgWCGuZYEdN5+BzhVdEgBqTnyEFcJZEC3qBZKrz9TSUcsJtWp
         ohTRXgXqws+b0TPDebnTHVR2HS5qbPIA4pZw6wQvtiZYa4cR4OQliZneH4ISeQx9S/
         7lcdiMi9DhUxUoBgSqpXH9PBOeki/JsJEWECl76yZWI2/wOsHdZxFdjtIAINFvVVhQ
         qAYN1XBb+Jbu6s0AqqFtDX7Xxx1rcCcBxHw7bmShnWLy4D+a0eFMTdLbO+yPdIdttB
         pg6DGnEYo5/U8h3zpITxXE7Gj/u/TPGSTI9fIAGK80NK6SavCJm2qo+bN63z+oMWFy
         ctoevZsKQPbRw==
Date:   Tue, 8 Nov 2022 15:05:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
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
Message-ID: <20221108150529.764b5ab8@kernel.org>
In-Reply-To: <Y2qqq9/N65tfYyP0@unreal>
References: <1667502990-2559-1-git-send-email-longli@linuxonhyperv.com>
        <Y2qqq9/N65tfYyP0@unreal>
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

On Tue, 8 Nov 2022 21:14:51 +0200 Leon Romanovsky wrote:
> Can you please ACK/comment on eth part of this series? And how should
> we proceed? Should we take this driver through shared branch or apply
> directly to RDMA tree?

LGTM. Is it possible to get patches 1-11 thry a shared branch and then
you can apply 12 directly to RDMA? That seems optimal to me.
