Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 416E3331471
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 18:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbhCHRTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 12:19:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbhCHRSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 12:18:51 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C361C06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 09:18:51 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id a4so6812950pgc.11
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 09:18:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dogVZn3EAju1zigyNIbuZCBZ4mlvvklyF71jldf5t+I=;
        b=resRGOh9QzADGbQkh4V3DCflJrIcGlLCpkMYwb6OeZXTqa04BD+vuUush6RUHlCk24
         kdfMqb1WBlYmxX0DlFQoIs3yhzog5q5Yom1uIk93otYez9KcSS9DH6OQB0jNAspv6Yh3
         QRVWxbjXeFtNXapufgDlffNSsCHOItnTUAc6JR+KTT5RoHG2kPMkLBHWZUyHe4LQGi32
         Pll29STdoBbE+UP4JNRCFAc0xrwD3tF8b6WcQe8tXGCUN4vXzDceDWpRZeBO/Y29Fc57
         D/gDsSsm9jCmlnIeEE2gE2PjseLzgtyHGJs41bFuRE2Tpfx1eB6OePbpV+y8Tq5EdXE4
         MUdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dogVZn3EAju1zigyNIbuZCBZ4mlvvklyF71jldf5t+I=;
        b=O3CdBKGi7uwMBSoS5eCDsKTJ+oaegLhYua7S11HciUveQLoYvWwkI5i4tzLiigkib4
         biPosCozbPcTi5GxznE3AYgCaWmMc2npnze6PQlToWTWXU5TWG8JazEdN3NZilJWw9DG
         uomexBKWpnRYcddTCTxXmujJMHS/ZzUl3pODIGW/h24zjA+4eGvVqM/wbdJbwew+UqIc
         VaAbsf4K8INZrueJK+NLZ+QqD3rGbAXzFE0LSBHKmCmBk8r+pB5b5Kw/uCVjPuE1DGR7
         EPXgXKJRPho6EXHOfciZYX1MkT72I4dgIEGMePro5LUgpHAo7il7d4dfEFYPYM27zanD
         q1vg==
X-Gm-Message-State: AOAM533GXWnHzQcj6U4Bd8mkp0ye8XGAWBKwBLc8iuy1WxE7+sy+aZGC
        cuEmZZBWWcDWVFwghkkPHQcS8w==
X-Google-Smtp-Source: ABdhPJyTZeUc8l+FqJogcvduLARftoNrsBAujdIQlFATgYe8UX1OfFvqbf3KF+YBm9jRNHUUMjZUhQ==
X-Received: by 2002:a63:40c2:: with SMTP id n185mr21007776pga.280.1615223930649;
        Mon, 08 Mar 2021 09:18:50 -0800 (PST)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id w84sm5154030pfc.142.2021.03.08.09.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 09:18:50 -0800 (PST)
Date:   Mon, 8 Mar 2021 09:18:41 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        Paul Wouters <pwouters@redhat.com>
Subject: Re: [PATCH iproute2] ip: xfrm: add NUL character to security
 context name before printing
Message-ID: <20210308091841.5d572cf1@hermes.local>
In-Reply-To: <11af39932b3896cf1a560059bcbd24194e7f33bd.1613473397.git.sd@queasysnail.net>
References: <11af39932b3896cf1a560059bcbd24194e7f33bd.1613473397.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Feb 2021 17:50:58 +0100
Sabrina Dubroca <sd@queasysnail.net> wrote:

> +static void xfrm_sec_ctx_print(FILE *fp, struct rtattr *attr)
> +{
> +	struct xfrm_user_sec_ctx *sctx;
> +	char buf[65536] = {};
> +
> +	fprintf(fp, "\tsecurity context ");
> +
> +	if (RTA_PAYLOAD(attr) < sizeof(*sctx))
> +		fprintf(fp, "(ERROR truncated)");
> +
> +	sctx = RTA_DATA(attr);
> +
> +	memcpy(buf, (char *)(sctx + 1), sctx->ctx_len);
> +	fprintf(fp, "%s %s", buf, _SL_);
> +}

The copy buffer is not needed. Use the printf precision as
a mechanism instead.

         fprintf(fp, "%.*s %s", sctx->ctx_len, (char *)(sctx + 1));

