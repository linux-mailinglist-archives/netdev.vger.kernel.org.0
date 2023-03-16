Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE52F6BC62E
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 07:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjCPGhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 02:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjCPGhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 02:37:17 -0400
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515F7AA263;
        Wed, 15 Mar 2023 23:37:07 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0Vdz.tvy_1678948624;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0Vdz.tvy_1678948624)
          by smtp.aliyun-inc.com;
          Thu, 16 Mar 2023 14:37:04 +0800
Date:   Thu, 16 Mar 2023 14:37:03 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kai <KaiShen@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, jaka@linux.ibm.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v4] net/smc: Use percpu ref for wr tx reference
Message-ID: <ZBK5D2os+51qEK8G@TONYMAC-ALIBABA.local>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20230313060425.115939-1-KaiShen@linux.alibaba.com>
 <20230315003440.23674405@kernel.org>
 <ZBGBWafISbzBapnq@TONYMAC-ALIBABA.local>
 <20230315134045.2daeffa4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315134045.2daeffa4@kernel.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 01:40:45PM -0700, Jakub Kicinski wrote:
> On Wed, 15 Mar 2023 16:27:05 +0800 Tony Lu wrote:
> > > You're missing a --- separator here, try to apply this patch with 
> > > git am :/  
> > 
> > There is another commit ce7ca794712f ("net/smc: fix fallback failed
> > while sendmsg with fastopen") that has been merged that also has this
> > problem. Maybe we can add some scripts to check this?
> 
> Good idea, checkpatch is probably the right place to complain?

Agree with you.

> A check along the lines of "if Sign-off-by: has been seen, no
> empty lines are allowed until ---"?

Yes.

> Would you be willing to try to code that up and send it to the
> checkpatch maintainer? If they refuse we can create a local
> check just for networking in our on scripts.

Sure, I will do it.

Thanks,
Tony Lu
