Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41FDD4B7EE3
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 04:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244268AbiBPDx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 22:53:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiBPDx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 22:53:58 -0500
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F24CFBB1;
        Tue, 15 Feb 2022 19:53:46 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V4bW4u._1644983624;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V4bW4u._1644983624)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 16 Feb 2022 11:53:44 +0800
Date:   Wed, 16 Feb 2022 11:53:43 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] net/smc: Add autocork support
Message-ID: <20220216035343.GD41938@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20220216034903.20173-1-dust.li@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216034903.20173-1-dust.li@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 11:49:03AM +0800, Dust Li wrote:

Sorry for forgetting to change the --subject-prefix !

This patch is based on net-next, and is targeted to net-next.

Many thanks!
