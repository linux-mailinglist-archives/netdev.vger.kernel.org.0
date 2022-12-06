Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 218E3644BE0
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 19:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiLFShz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 13:37:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiLFShx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 13:37:53 -0500
Received: from out-102.mta0.migadu.com (out-102.mta0.migadu.com [91.218.175.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA312B60D
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 10:37:51 -0800 (PST)
Message-ID: <2118324c-a6e6-775d-77c2-75587e69e7ff@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1670351869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=trcvD3B0hq4MGQKVXzoiJdZuDNFozfTXE9wrFL0Zjts=;
        b=TzWF12Atv/bVAgMtcY/2e+ETyBI82KoHWLf9I/1JIc1fgVtVnLH2M4DCm4WHylvHyQNLtV
        oeqVc++jQaJwmTBklLxD6v1SYFer/0iOh4xTtGiUS+G73LHZLwrI2cWCPQtSMk2JGQXwiF
        Rv5riOOhV7CZJpMmISdcDXYZwr7Tb10=
Date:   Tue, 6 Dec 2022 10:37:42 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v2] bpf: Upgrade bpf_{g,s}etsockopt return values
Content-Language: en-US
To:     Ji Rongfeng <SikoJobs@outlook.com>
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        andrii@kernel.org, song@kernel.org, yhs@fb.com, kpsingh@kernel.org,
        sdf@google.com, haoluo@google.com, jolsa@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <DU0P192MB1547FE6F35CC1A3EEA1AFDECD6179@DU0P192MB1547.EURP192.PROD.OUTLOOK.COM>
 <DU0P192MB154719A31758750149418C73D61B9@DU0P192MB1547.EURP192.PROD.OUTLOOK.COM>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <DU0P192MB154719A31758750149418C73D61B9@DU0P192MB1547.EURP192.PROD.OUTLOOK.COM>
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

On 12/6/22 8:35 AM, Ji Rongfeng wrote:
> I have noticed that this patch has been marked as "Changes Requested" for a few 
> days, but there's no comment so far, which is abnormal and confusing.

It is obvious that a test is needed for this change.

