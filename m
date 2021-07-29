Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5403D9C7E
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 06:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233540AbhG2EKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 00:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbhG2EKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 00:10:39 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98746C061757;
        Wed, 28 Jul 2021 21:10:36 -0700 (PDT)
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1627531833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FQIlXJgE77BqjE7g0NB7k8jykh0A2F51tEmTjZlIkXw=;
        b=lLKc/cdby/fJ8bwpA2PkAjCmihLvx4wuTpuMnE/2pSTMHvCwEaYQncfLdJyUhiuP4Yy7hl
        lI6RoPaULrhrK6PjOzQ7Mdx15frwsj2WIUIH0Xo2/XZos3p2T7HJOCk79I82l3oPu7HjA6
        WHTk3DbCNKeRyMF7pjgTH0Ul7OOsjDM=
Date:   Thu, 29 Jul 2021 04:10:33 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   yajun.deng@linux.dev
Message-ID: <fd3ffb7a52925b05455199039bbc32d2@linux.dev>
Subject: Re: [PATCH] Revert "net: Get rid of consume_skb when tracing is
 off"
To:     "Herbert Xu" <herbert@gondor.apana.org.au>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <20210729040303.GA7009@gondor.apana.org.au>
References: <20210729040303.GA7009@gondor.apana.org.au>
 <20210728125248.GC2598@gondor.apana.org.au>
 <20210728035605.24510-1-yajun.deng@linux.dev>
 <177cd530dcb2c9f4d09a2b23fdbbc71a@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

July 29, 2021 12:03 PM, "Herbert Xu" <herbert@gondor.apana.org.au> wrote:=
=0A=0A> On Thu, Jul 29, 2021 at 04:01:28AM +0000, yajun.deng@linux.dev wr=
ote:=0A> =0A>> if we don't define CONFIG_TRACEPOINTS, consume_skb() wolud=
 called kfree_skb(), there have=0A>> trace_kfree_skb() in kfree_skb(), th=
e trace_kfree_skb() is also a trace function. So we=0A>> can trace consum=
e_skb() even if we don't define CONFIG_TRACEPOINTS.=0A>> This patch "net:=
 Get rid of consume_skb when tracing is off" does not seem to be effectiv=
e.=0A> =0A> The point of my patch was to get rid of consume_skb because i=
ts=0A> only purpose is to provide extra information for tracing. If you'r=
e=0A> not tracing then you don't need that extra information (and overhea=
d).=0A> =0AOk, I didn't understand it well. =0A> Cheers,=0A> --=0A> Email=
: Herbert Xu <herbert@gondor.apana.org.au>=0A> Home Page: http://gondor.a=
pana.org.au/~herbert=0A> PGP Key: http://gondor.apana.org.au/~herbert/pub=
key.txt
