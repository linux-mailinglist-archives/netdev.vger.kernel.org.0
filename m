Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB0406AE72A
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 17:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbjCGQsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 11:48:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbjCGQrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 11:47:21 -0500
Received: from out-43.mta0.migadu.com (out-43.mta0.migadu.com [IPv6:2001:41d0:1004:224b::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC36279B1
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 08:44:17 -0800 (PST)
Message-ID: <f1e87004-4654-8204-2771-32ed13467202@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1678207455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VLmMu45eHTgRA2yeO3gHfTmY8V1bfviU/uVTqAvNcUA=;
        b=GvyfmtZQWNSCthxrhD63hW+gV7A3MNUcBly5koI+MEKf8juOsdCwio2QhImfOFKQzzRSMF
        t8u2xqktnvhOXcXK8J+iVAyB1O28oeQ6SrmXXoqHhhp8g2JYuA5l+M7oJUUmhMQdZP/hPE
        2ahlq6bjc4FG4nUhUYfXRrLhUCKV7IA=
Date:   Tue, 7 Mar 2023 08:44:10 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v4 0/4] net/smc: Introduce BPF injection
 capability
Content-Language: en-US
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org, kgraul@linux.ibm.com, wenjia@linux.ibm.com,
        jaka@linux.ibm.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
References: <1677602291-1666-1-git-send-email-alibuda@linux.alibaba.com>
 <25cee0eb-a1f9-9f0b-9987-ca6e79e6b752@linux.alibaba.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <25cee0eb-a1f9-9f0b-9987-ca6e79e6b752@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/6/23 7:05 PM, D. Wythe wrote:
> I wondering if there are any more questions about this PATCH, This patch seems 
May be start with the questions on v2 first.

> to have been hanging for some time.
> 
> If you have any questions, please let me know.
> 
> 
> Thanks,
> 
> D. Wythe
> 
> 
> Do you have any questions about this PATCH?  If you have any other questions, 
> please let me know.
> 

