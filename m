Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2FC2FB63F
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 18:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbfKMRUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 12:20:10 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42553 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbfKMRUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 12:20:10 -0500
Received: by mail-pg1-f196.google.com with SMTP id q17so1762256pgt.9
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 09:20:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c61E82i8N2FHBDgrf4J43uTuUTiRPyIXW/cL5Zk6XN8=;
        b=BM9NW0JzNanuQxhseQ1Z+u2dPCYFvhjiBhUpo5iZb3iSydzzdJjE67tH9Hhifl6r05
         I96tvM5NBLgD1HR4mXpZTHRiBoEkq2O1eCzGtpsVu8tWmz95M7VLAhI8bNbVNKQUmZ73
         SVIO0e3wlpeTf4D5zfk5bCF4aMCaxZeyeYGdHWKQji0QSdXUbsdFkB5TxrfJLjEsK8de
         NQZgJdORbTaeYzN87yxA2QHbv+Uf1bOKg9TBhnhQiQPYqBspiILYPtZ0BRsITUip9TOX
         I6hZKDrOjgy8w7bbg6IcXo7Ux+pUtoTmdgaXEP9oklx29Wd60gsuueF+4h5iNlk7RrX3
         jExA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c61E82i8N2FHBDgrf4J43uTuUTiRPyIXW/cL5Zk6XN8=;
        b=kyrNMHbf8W3ySy14q3nc4EnzpgJIfBGYWkIRuLIE5itsfwnxt7ORHzBoeD8SywbtCd
         CzkB7xnE4xQSyKwDP2x/QOcoSAUgJTk8fGWv+XxIh4a2lELQ396L3EzlyeMq7+KF177t
         FOfoXEgBnzONMNgxV9g/su9UXf3M9dtZIcp1ZftCrchW/+RGE3x9pnYR5ebqx6ndYV09
         Smp/q+TyCacm2dMZ2EA7BfTUZJ8J0vStiF/SzrUPlBzPKTqflIrXW0weQHn47yJWY2Eh
         5RQ/LLR1mDHoXHArMwuMa94rMXjhmkHWVsb55q2pqFzJqSn3VZosDtcIv6dDQb5SEZsr
         y+Ig==
X-Gm-Message-State: APjAAAXhVOaTuzOIV51TcTRbG7gD5AvuN9vhCtnSYSi1CeWMTN+wQBPI
        UvBMO9yj9xW3CuTnNF9SwhnaQA==
X-Google-Smtp-Source: APXvYqyNbuAd5R7rs8k8D9M3sG0jl/SmVwDSiu30ouF5+DV5/WMnzn5nRDNHikBpzniDj4pn/0PtyA==
X-Received: by 2002:aa7:9639:: with SMTP id r25mr5662387pfg.17.1573665609607;
        Wed, 13 Nov 2019 09:20:09 -0800 (PST)
Received: from shemminger-XPS-13-9360 (67-207-105-98.static.wiline.com. [67.207.105.98])
        by smtp.gmail.com with ESMTPSA id f59sm6923481pje.0.2019.11.13.09.20.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 09:20:09 -0800 (PST)
Date:   Wed, 13 Nov 2019 09:20:05 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Roi Dayan <roid@mellanox.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>
Subject: Re: [PATCH iproute2 1/5] tc_util: introduce a function to print
 JSON/non-JSON masked numbers
Message-ID: <20191113092005.23695425@shemminger-XPS-13-9360>
In-Reply-To: <20191113101245.182025-2-roid@mellanox.com>
References: <20191113101245.182025-1-roid@mellanox.com>
        <20191113101245.182025-2-roid@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Nov 2019 12:12:41 +0200
Roi Dayan <roid@mellanox.com> wrote:

> +
> +		if (is_json_context()) {
> +			sprintf(namefrm, "\n  %s %%u", name);
> +			print_hu(PRINT_ANY, name, namefrm,
> +				 rta_getattr_type(attr));
> +			if (mask != type_max) {
> +				char mask_name[SPRINT_BSIZE-6];
> +
> +				sprintf(mask_name, "%s_mask", name);
> +				sprintf(namefrm, "\n  %s %%u", mask_name);
> +				print_hu(PRINT_ANY, mask_name, namefrm, mask);

Should use _SL_ to handle single line output format case (instead of \n)
