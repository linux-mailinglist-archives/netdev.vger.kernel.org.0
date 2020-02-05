Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17A6415307C
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 13:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgBEMWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 07:22:43 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38627 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbgBEMWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 07:22:43 -0500
Received: by mail-wr1-f67.google.com with SMTP id y17so2484918wrh.5
        for <netdev@vger.kernel.org>; Wed, 05 Feb 2020 04:22:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LR1dADKbZstR9fdZq2tvypSj5rs7exlyFx0sY6Ljn5o=;
        b=SvKxjQ6VCDMZRK0nDqOrnT6jrEVbOO8l932HtaxfMRAjExwzP62yIAmSvCC2bqlmAA
         uWF/aFkRljPdZFscHrSScACrFmJGcjj0r5Ci4KtiV8hGjzGLwnIuwcb0xMmPzrNC1KIF
         t4sP1Tj1s3DizhnOCs4nvZvFAoD8gWBHCVB6JjPI3JPzgBqVkyMpQp+bvih57uD9F/vz
         boO/qEXlyIpy2fP5bE8Z7vBbmqei5CekYXsSkGEAwpzR72HbF7xDny2lva5/NvTWJS+g
         +hWShTrkpw2CjxPZ8VI1dhyc248oSugkjubLuhPxCtE3urVdU/L6af4H/yXODhmEwx0R
         thmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LR1dADKbZstR9fdZq2tvypSj5rs7exlyFx0sY6Ljn5o=;
        b=lSpcgx6tjE3Nc9y1I97L5CEWNgLxUugtXWUTgRxPXQDNhU81xKWjFepw8XxnulPbgg
         SHv1ozSu5mrTE7a669g0Zk/mU6vEJ9uO4J6xjkPQtMFGnuWDktd3X2JfW4NpAncs2CCl
         ++J4Ff8MinPBJwjjEraHb9TmMO3AIAe8Jb0ZQ/Ck7ltWMbEA0K1mTHcTa6dLt1Gqcuva
         2MmxbkNrh+YMihm30jAsjLSt/d1cwwmYQIQh6izbXgfyCRn0iEAJegv6gYatOCM3rFLu
         A3DPky/uD5XDqJ+IylyNRftoEd9Y0tEh6ajbYrmdzRtlB/yxH7nnBsUI88jI99Qdryya
         k1xQ==
X-Gm-Message-State: APjAAAX6K2D7IfuAGQ0HbjWzpKIUnmtfNcgVIjKOB2f+QHMP6cygNqE1
        NThgupYZJS53OJ2q7KrYObapyA==
X-Google-Smtp-Source: APXvYqzz6G6QEG3Bewbi3dObxjvmQ2SPmRAVAJDy5HFED4OtGNUXspsHf77zIh6imhUb1DOMlMeRuw==
X-Received: by 2002:a5d:568a:: with SMTP id f10mr30003426wrv.180.1580905361915;
        Wed, 05 Feb 2020 04:22:41 -0800 (PST)
Received: from shemminger-XPS-13-9360 ([212.187.182.163])
        by smtp.gmail.com with ESMTPSA id x132sm9023495wmg.0.2020.02.05.04.22.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 04:22:41 -0800 (PST)
Date:   Wed, 5 Feb 2020 04:22:39 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>
Subject: Re: [PATCH iproute2-next 2/7] iproute_lwtunnel: add options support
 for vxlan metadata
Message-ID: <20200205042239.322cc844@shemminger-XPS-13-9360>
In-Reply-To: <85a6a30aac8eeab7c408fdadfa5419dc1596cf5d.1580708369.git.lucien.xin@gmail.com>
References: <cover.1580708369.git.lucien.xin@gmail.com>
        <93e7cebfeda666b17c6a1b2bb8b5065bdab4814c.1580708369.git.lucien.xin@gmail.com>
        <85a6a30aac8eeab7c408fdadfa5419dc1596cf5d.1580708369.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  3 Feb 2020 13:39:53 +0800
Xin Long <lucien.xin@gmail.com> wrote:

> +static void lwtunnel_print_vxlan_opts(struct rtattr *attr, char *opt)
> +{
> +	struct rtattr *tb[LWTUNNEL_IP_OPT_VXLAN_MAX + 1];
> +	__u32 gbp;
> +
> +	parse_rtattr(tb, LWTUNNEL_IP_OPT_VXLAN_MAX, RTA_DATA(attr),
> +		     RTA_PAYLOAD(attr));
> +	gbp = rta_getattr_u32(tb[LWTUNNEL_IP_OPT_VXLAN_GBP]);
> +	sprintf(opt, "%x", gbp);
> +	print_string(PRINT_FP, "enc_opt", "\n  vxlan_opts %s ", opt);

You need to handle single line mode and JSON.

Proper way is something like:

	print_nl();
	print_0xhex(PRINT_ANY, "enc_opt", "  vxlan_opts %#x", gpb);

Also, why the hex format, this is a an opaque user interface?

