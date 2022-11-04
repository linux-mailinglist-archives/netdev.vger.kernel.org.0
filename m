Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4251618F49
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 04:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiKDDyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 23:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiKDDyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 23:54:00 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6884918E15;
        Thu,  3 Nov 2022 20:53:59 -0700 (PDT)
Date:   Fri, 4 Nov 2022 11:53:53 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667534037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8nB/E03kl7uOrvaquUmBlRn6qOLu+r8pqOVk2ws5Fok=;
        b=K3vS7a+/YCFhKzg5rIoVLcu42SrLfKYm91sdVGcIX9raOj3LZt8CVE+w8BQzYdOYb+AjaD
        fP+BkVEwz4Z440qs43RgBvQbIcF6baudaYhIKmNK/sZFt4UJ57koN8sx+hvAgAiQpdvuru
        IOkMBHIW9dpU8mKpxJt908Fr/umqghs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Cai Huoqing <cai.huoqing@linux.dev>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        SeongJae Park <sj@kernel.org>,
        Peter Chen <peter.chen@kernel.org>,
        Bin Chen <bin.chen@corigine.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/2] net: hinic: Convert the cmd code from
 decimal to hex to be more readable
Message-ID: <20221104035353.GA10583@chq-T47>
References: <20221101060358.7837-1-cai.huoqing@linux.dev>
 <20221102203640.1bda5d74@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221102203640.1bda5d74@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02 11月 22 20:36:40, Jakub Kicinski wrote:
> On Tue,  1 Nov 2022 14:03:38 +0800 Cai Huoqing wrote:
> > The print cmd code is in hex, so using hex cmd code intead of
> > decimal is easy to check the value with print info.
> 
> You're still removing empty lines making this patch much harder 
> to review. Once again - it should be a pure conversion to dec -> hex.
> Don't make any other changes.
Hi, Jakub 

I fix it, and resend v4
https://lore.kernel.org/lkml/20221103080525.26885-1-cai.huoqing@linux.dev/

Thanks,
Cai
