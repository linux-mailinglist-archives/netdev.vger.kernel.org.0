Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2333D9C6F
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 06:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbhG2EBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 00:01:35 -0400
Received: from out1.migadu.com ([91.121.223.63]:58655 "EHLO out1.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229485AbhG2EBe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 00:01:34 -0400
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1627531290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l4zsXJLG8PBLt8CZxWxMWv6w5AiWAx+98HcQ2KmFZ54=;
        b=pPmcr6tI+85vQQMQIJXYyOszbPuThZ14+L4G/zTLIZUXpqbDkelVmnqT68KZ7AWk56l7WI
        MiXpxUmEyT1warUSplg3J4oqQLQE65QUC8NtE9K6CCkWWUd5rLgVnFMva2oS5AX0LywSBK
        Eg1vCWzVPV/mOuQS/oVRjlFoUYfsGZg=
Date:   Thu, 29 Jul 2021 04:01:28 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   yajun.deng@linux.dev
Message-ID: <177cd530dcb2c9f4d09a2b23fdbbc71a@linux.dev>
Subject: Re: [PATCH] Revert "net: Get rid of consume_skb when tracing is
 off"
To:     "Herbert Xu" <herbert@gondor.apana.org.au>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <20210728125248.GC2598@gondor.apana.org.au>
References: <20210728125248.GC2598@gondor.apana.org.au>
 <20210728035605.24510-1-yajun.deng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

July 28, 2021 8:52 PM, "Herbert Xu" <herbert@gondor.apana.org.au> wrote:=
=0A=0A> On Wed, Jul 28, 2021 at 11:56:05AM +0800, Yajun Deng wrote:=0A> =
=0A>> This reverts commit be769db2f95861cc8c7c8fedcc71a8c39b803b10.=0A>> =
There is trace_kfree_skb() in kfree_skb(), the trace_kfree_skb() is=0A>> =
also a trace function.=0A>> =0A>> Fixes: be769db2f958 (net: Get rid of co=
nsume_skb when tracing is off)=0A>> Signed-off-by: Yajun Deng <yajun.deng=
@linux.dev>=0A> =0A> Please explain in more detail why your patch is need=
ed. As it=0A> stands I do not understand the reasoning.=0A> =0Aif we don'=
t define CONFIG_TRACEPOINTS, consume_skb() wolud called kfree_skb(), ther=
e have=0Atrace_kfree_skb() in kfree_skb(), the trace_kfree_skb() is also =
a trace function. So we=0Acan trace consume_skb() even if we don't define=
 CONFIG_TRACEPOINTS.=0AThis patch "net: Get rid of consume_skb when traci=
ng is off" does not seem to be effective.=0A=0A> Thanks,=0A> --=0A> Email=
: Herbert Xu <herbert@gondor.apana.org.au>=0A> Home Page: http://gondor.a=
pana.org.au/~herbert=0A> PGP Key: http://gondor.apana.org.au/~herbert/pub=
key.txt
