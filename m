Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91B516DB869
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 04:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbjDHC7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 22:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjDHC7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 22:59:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0735630EF;
        Fri,  7 Apr 2023 19:59:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92A6165314;
        Sat,  8 Apr 2023 02:59:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC26C433EF;
        Sat,  8 Apr 2023 02:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680922740;
        bh=QR6uHfzuisUXovI1sotT1uTbJ90ylkmyAK+TtrMTJk8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JcnJBOLeVpTpPWA66GyVa2E486o1qQJFAOsymgPN8yVCSL4v8bBaWTrW+JAbnvIeM
         6wyTqTmuuIUZ1lFCsv1sNXZces2E7WIQFfj9UwE0Wdy/d7x7TYa6oDrpNb9tpc2Q0X
         DnKsbf8n95yMegSVB+AymAACgwy8a5/oiyEvdOXjGsA+uj58czaAfbtj/aPZlDYFwg
         5T+S2d9Elz4IysD0FIQ1OQ6RWDCmm6Hm+b0r6RTdphskjL5/XLUr2XS5GfLmbXzrJa
         wUgW7ATVJQzL8fnNXdOMNhHyj4reCqdUv+RGi1w0pVL0S1q3JSr52II8rSJNnQLn5n
         QZvDPNoWlKIaA==
Date:   Fri, 7 Apr 2023 19:58:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <willemdebruijn.kernel@gmail.com>,
        <andrew@lunn.ch>, <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <naveenm@marvell.com>, <edumazet@google.com>, <pabeni@redhat.com>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <maxtram95@gmail.com>
Subject: Re: [net-next Patch v6 3/6] octeontx2-pf: qos send queues
 management
Message-ID: <20230407195858.70172474@kernel.org>
In-Reply-To: <20230406102103.19910-4-hkelam@marvell.com>
References: <20230406102103.19910-1-hkelam@marvell.com>
        <20230406102103.19910-4-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Apr 2023 15:51:00 +0530 Hariprasad Kelam wrote:
> Current implementation is such that the number of Send queues (SQs)
> are decided on the device probe which is equal to the number of online
> cpus. These SQs are allocated and deallocated in interface open and c
> lose calls respectively.
> 
> This patch defines new APIs for initializing and deinitializing Send
> queues dynamically and allocates more number of transmit queues for
> QOS feature.

I'm getting sparse errors from missing/misplaced __iommu markings 
I think, when buildings this.

Please make sure that no new warnings are added in a W=1 C=1 build.
