Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55DE56BC2DE
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 01:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbjCPAgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 20:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbjCPAfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 20:35:55 -0400
Received: from out-47.mta0.migadu.com (out-47.mta0.migadu.com [IPv6:2001:41d0:1004:224b::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20D5A42D9
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 17:35:23 -0700 (PDT)
Message-ID: <e976396c-0eaa-b7f6-847c-597e68f78815@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1678926829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sl6QEK5a6oRm+4eh3nG+NVuA0empfEEikimQb7aWA9U=;
        b=UCkfxGgdEKXXmJ/1arXM6AkKxBJRXxho+v1k8v2wGxy9oREfOXBRqTWRLfTw8sCxXSvgZr
        ulgWW+59Ha85iSFGFZTo6g2G4h2RcVZY6crTuVYf0D3IZNK02/ThDOEx5TC26pOxlMTXM9
        PviwGnZAAQNNylBUka9qIY21zqO4B48=
Date:   Wed, 15 Mar 2023 17:33:45 -0700
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next 0/2] bpf: Add detection of kfuncs.
Content-Language: en-US
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com, "David S. Miller" <davem@davemloft.net>
References: <20230315223607.50803-1-alexei.starovoitov@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20230315223607.50803-1-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/23 3:36 PM, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Allow BPF programs detect at load time whether particular kfunc exists.

Reviewed-by: Martin KaFai Lau <martin.lau@kernel.org>

