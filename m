Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A38F4AB809
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 11:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245593AbiBGJyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 04:54:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351929AbiBGJhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 04:37:10 -0500
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532D1C043181;
        Mon,  7 Feb 2022 01:37:08 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R671e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V3q7Wgi_1644226624;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V3q7Wgi_1644226624)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 07 Feb 2022 17:37:04 +0800
Date:   Mon, 7 Feb 2022 17:37:03 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, matthieu.baerts@tessares.net
Subject: Re: [PATCH v2 net-next 3/3] net/smc: Fallback when handshake
 workqueue congested
Message-ID: <YgDoPwMk4o56bHaw@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <cover.1643380219.git.alibuda@linux.alibaba.com>
 <2d3f81193fc7a245c50b30329d0e84ae98427a33.1643380219.git.alibuda@linux.alibaba.com>
 <YfTDjXh8zP3WBAtg@TonyMac-Alibaba>
 <0c4902f4-e744-fe95-1a05-51ae936c4516@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c4902f4-e744-fe95-1a05-51ae936c4516@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 07, 2022 at 03:13:22PM +0800, D. Wythe wrote:
> 
> After some trial and thought, I found that the scope of netlink control is
> too large, we should limit the scope to socket. Adding a socket option may
> be a better choice, what do you think?
> 
It is a good idea to be a socket-level config. Maybe we could consider
netlink as default global behaviour.

Thanks,
Tony Lu
