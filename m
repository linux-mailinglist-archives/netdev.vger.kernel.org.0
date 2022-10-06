Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71DC25F71B8
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 01:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbiJFXY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 19:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJFXY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 19:24:27 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E83340010;
        Thu,  6 Oct 2022 16:24:26 -0700 (PDT)
Message-ID: <aa0ab727-0bee-d23d-d334-2347c42bec29@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1665098664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lojoLorjPRPfXiabWZUFqIHakN0idfGQ6ntbYK4clK4=;
        b=xces/Wu8Zz6GWFrlA3TWAA6ZlFBvqtyjtfYQLvmbHB+0I5cpZ+tvq3T6m5lVAjjN+k17d1
        w88nVAwBDIN89QqO/pwz6xEwwpkjdM7KGkxuqzKpOfemW9/RaMgtDbxLVvISGoefbrFoJ4
        ukhFlXiH0fmnhQlU3WvI349V5in5PU8=
Date:   Thu, 6 Oct 2022 16:24:21 -0700
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next 05/10] bpf: Implement link detach for tc BPF link
 programs
Content-Language: en-US
To:     Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org
Cc:     razor@blackwall.org, ast@kernel.org, andrii@kernel.org,
        john.fastabend@gmail.com, joannelkoong@gmail.com, memxor@gmail.com,
        toke@redhat.com, joe@cilium.io, netdev@vger.kernel.org
References: <20221004231143.19190-1-daniel@iogearbox.net>
 <20221004231143.19190-6-daniel@iogearbox.net>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20221004231143.19190-6-daniel@iogearbox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/4/22 4:11 PM, Daniel Borkmann wrote:
> Add support for forced detach operation of tc BPF link. This detaches the link
> but without destroying it. It has the same semantics as auto-detaching of BPF
> link due to e.g. net device being destroyed for tc or XDP BPF link. Meaning,
> in this case the BPF link is still a valid kernel object, but is defunct given
> it is not attached anywhere anymore. It still holds a reference to the BPF
> program, though. This functionality allows users with enough access rights to
> manually force-detach attached tc BPF link without killing respective owner
> process and to then introspect/debug the BPF assets. Similar LINK_DETACH exists
> also for other BPF link types.

Reviewed-by: Martin KaFai Lau <martin.lau@kernel.org>

