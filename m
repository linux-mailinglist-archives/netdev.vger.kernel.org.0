Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D534D5C0D
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 08:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242653AbiCKHO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 02:14:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233144AbiCKHO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 02:14:27 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4C7F463D;
        Thu, 10 Mar 2022 23:13:24 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id CFAAF68AFE; Fri, 11 Mar 2022 08:13:19 +0100 (CET)
Date:   Fri, 11 Mar 2022 08:13:19 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Mingbao Sun <sunmingbao@tom.com>
Cc:     Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        tyler.sun@dell.com, ping.gan@dell.com, yanxiu.cai@dell.com,
        libin.zhang@dell.com, ao.sun@dell.com
Subject: Re: [PATCH 1/3] tcp: export symbol tcp_set_congestion_control
Message-ID: <20220311071319.GA18222@lst.de>
References: <20220311030113.73384-1-sunmingbao@tom.com> <20220311030113.73384-2-sunmingbao@tom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220311030113.73384-2-sunmingbao@tom.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maybe add a kerneldoc comment now that this is an exported API?

Otherwise this looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
