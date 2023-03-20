Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1F0F6C22AD
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 21:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbjCTUaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 16:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbjCTUaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 16:30:10 -0400
Received: from out-41.mta1.migadu.com (out-41.mta1.migadu.com [95.215.58.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23905166E2
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 13:29:47 -0700 (PDT)
Message-ID: <2b3b7e9c-8ed6-71b5-8002-beb5520334cc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679344185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T3uBVw/h2UV64VZwG+oyYlYBS7117PYK5aua10Zy3q4=;
        b=ZxR6BQ9fujrEhgAqy8OeHlC8tapIYhvaKaTPuD6nI3QyFPY9mVTjqeuh1zofIcwAayFvmA
        XGmGzWiK3wlRS92HLc95lvXD3MBpD5DOInaNpV/ywlSD+9OvP6kAvFsZFYKRl8c2Vu/1TX
        ZxtQMhEXnjx4FpI4pCIOc+1XhWbr/oM=
Date:   Mon, 20 Mar 2023 13:29:39 -0700
MIME-Version: 1.0
Subject: Re: [Patch net-next v3] sock_map: dump socket map id via diag
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
References: <20230319191913.61236-1-xiyou.wangcong@gmail.com>
 <CAKH8qBtoYREbbRaedAfv=cEv2a5gBEYLSLy2eqcMYvsN7sqE=Q@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <CAKH8qBtoYREbbRaedAfv=cEv2a5gBEYLSLy2eqcMYvsN7sqE=Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/20/23 11:13 AM, Stanislav Fomichev wrote:
> One thing I still don't understand here: what is missing from the
> socket iterators to implement this? Is it all the sk_psock_get magic?
> I remember you dismissed Yonghong's suggestion on v1, but have you
> actually tried it?
would be useful to know what is missing to print the bpf map id without adding 
kernel code. There is new bpf_rdonly_cast() which will be useful here also.
