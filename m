Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9305FDD42
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 17:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiJMPgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 11:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiJMPgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 11:36:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B41BC472;
        Thu, 13 Oct 2022 08:36:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 704036185F;
        Thu, 13 Oct 2022 15:36:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5675FC433C1;
        Thu, 13 Oct 2022 15:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665675359;
        bh=b7rN1J1tkmNTBaVm+VFtuhtzYVEUyyLIPomIdeoSKwM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=burXVONUjzxwp1H+KuY3jpHCs6y2HJCo+fsLhdUylaeNgjeNTGUFEcyqM7WBvJzPC
         0uPe5bTJcnsPp2e1s3tuiFC/Oh5iyzGYOyH8G+81Zn9FQJgTHWyRYQey9QycbojslT
         gw9v7CjZX78YG7HA4APOvnDQAGQUCHHdRWBh+M6pmvjugHNGah9DY0Ubd6tgaoRHGS
         5ISbuZUAg+Z8GcEU86FbYBPZ1zmmJ47EGUGJBlTeB8n/uj4u0z+JLTaZVf6+zuIAvK
         f89nW0OSK3SNMjPjiRV1MWuDuf8V+C1/9YTTKEAd5/hgV1ftkOyOBP45a60ytMlzZZ
         glIpft+lgs9Pg==
Date:   Thu, 13 Oct 2022 08:35:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cai Huoqing <cai.huoqing@linux.dev>
Cc:     shaozhengchao@huawei.com, caihuoqing <caihuoqing@baidu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Qiao Ma <mqaio@linux.alibaba.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: hinic: Set max_mtu/min_mtu directly to simplify
 the code.
Message-ID: <20221013083558.110621be@kernel.org>
In-Reply-To: <20221013060723.7306-1-cai.huoqing@linux.dev>
References: <20221013060723.7306-1-cai.huoqing@linux.dev>
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

On Thu, 13 Oct 2022 14:07:08 +0800 Cai Huoqing wrote:
> From: caihuoqing <caihuoqing@baidu.com>
> 
> Set max_mtu/min_mtu directly to avoid making the validity judgment
> when set mtu, because the judgment is made in net/core: dev_validate_mtu,
> so to simplify the code.
> 
> Signed-off-by: caihuoqing <caihuoqing@baidu.com>

Alright, if it's just a cleanup then you'll need to wait a few days
(-rc1 will be this Sunday):

# Form letter - net-next is closed

We have already sent the networking pull request for 6.1
and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 6.1-rc1 is cut.

RFC patches sent for review only are obviously welcome at any time.
