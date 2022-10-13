Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61FD15FD493
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 08:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiJMGPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 02:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiJMGPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 02:15:04 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04AB476F4;
        Wed, 12 Oct 2022 23:15:03 -0700 (PDT)
Date:   Thu, 13 Oct 2022 14:14:53 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1665641702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D9N9aQZY5hwhVciJW5Zu2oNUPk7yeNY2skVsGmPPofo=;
        b=j7TVOLW7jgyZsnyRKRcxFzUJMK1eOQ5hYA0aEBgy2lucQR3MKHo9PE38ZFum6SmLRdSkEh
        kI6XLwahiEjZVoK/Ahazb3DALwRbHe0kGxkpoykNUkiz9vyQwGxWMkWbKw1mNRkQTaUj8p
        cIzG4rVyJTsuDXQzLONc/S7LMtOUJKA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Cai Huoqing <cai.huoqing@linux.dev>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     leonro@nvidia.com, caihuoqing <caihuoqing@baidu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Qiao Ma <mqaio@linux.alibaba.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: hinic: Update the range of MTU from 256 to 9600
Message-ID: <20221013061453.GA7603@chq-T47>
References: <20221012082945.10353-1-cai.huoqing@linux.dev>
 <20221012084909.0e5bce48@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221012084909.0e5bce48@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12 10月 22 08:49:09, Jakub Kicinski wrote:
> On Wed, 12 Oct 2022 16:29:40 +0800 Cai Huoqing wrote:
> > Hinic hardware only support MTU from 256 to 9600, so set
> > the max_mtu and min_mtu.
> 
> Sounds like a bug fix so please add a Fixes tag so that the patch gets
Hi Jakub,
    Not a bug fix, after v2 reverse the value of max_mtu for Shao's comments,
this patch just simplify the code.
v2 patch here:
https://lore.kernel.org/lkml/20221013060723.7306-1-cai.huoqing@linux.dev/

Thanks,
> backported to stable releases.
