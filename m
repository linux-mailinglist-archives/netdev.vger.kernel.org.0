Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B46E760D133
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 18:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbiJYQAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 12:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiJYQAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 12:00:47 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29A316F411
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 09:00:45 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0E6B768B05; Tue, 25 Oct 2022 18:00:40 +0200 (CEST)
Date:   Tue, 25 Oct 2022 18:00:39 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Aurelien Aptel <aaptel@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, leon@kernel.org, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, smalin@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: Re: [PATCH v7 00/23] nvme-tcp receive offloads
Message-ID: <20221025160039.GA26372@lst.de>
References: <20221025135958.6242-1-aaptel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025135958.6242-1-aaptel@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 25, 2022 at 04:59:35PM +0300, Aurelien Aptel wrote:
> The feature will also be presented in netdev this week
> https://netdevconf.info/0x16/session.html?NVMeTCP-Offload-%E2%80%93-Implementation-and-Performance-Gains

That seems to miss slides.

> Currently the series is aligned to net-next, please update us if you will prefer otherwise.

Please also point to a git tree for a huge series with a dependency
on some tree, otherwise there's no good way to review it.
