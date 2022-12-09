Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDC66484F5
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 16:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbiLIPX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 10:23:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbiLIPXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 10:23:53 -0500
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3785A7D076;
        Fri,  9 Dec 2022 07:23:52 -0800 (PST)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id D04FF92009D; Fri,  9 Dec 2022 16:23:48 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id C95EE92009C;
        Fri,  9 Dec 2022 15:23:48 +0000 (GMT)
Date:   Fri, 9 Dec 2022 15:23:48 +0000 (GMT)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Jiri Pirko <jiri@resnulli.us>
cc:     Yongqiang Liu <liuyongqiang13@huawei.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        Ralf Baechle <ralf@linux-mips.org>, jeff@garzik.org,
        Andrew Morton <akpm@linux-foundation.org>,
        zhangxiaoxu5@huawei.com
Subject: Re: [PATCH net] net: defxx: Fix missing err handling in dfx_init()
In-Reply-To: <Y5Cb4EMML3f0Ivdx@nanopsycho>
Message-ID: <alpine.DEB.2.21.2212091521450.29744@angie.orcam.me.uk>
References: <20221207072045.604872-1-liuyongqiang13@huawei.com> <Y5Cb4EMML3f0Ivdx@nanopsycho>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Dec 2022, Jiri Pirko wrote:

> >Fixes: e89a2cfb7d7b5 ("[TC] defxx: TURBOchannel support")
> >Signed-off-by: Yongqiang Liu <liuyongqiang13@huawei.com>
> 
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

 I only got at this change now.  Thank you both for taking care of this 
issue.

Acked-by: Maciej W. Rozycki <macro@orcam.me.uk>

  Maciej
