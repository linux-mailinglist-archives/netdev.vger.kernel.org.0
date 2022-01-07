Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6631487ABE
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 17:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348369AbiAGQve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 11:51:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348380AbiAGQvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 11:51:31 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08505C06173F
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 08:51:31 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id p14so5295136plf.3
        for <netdev@vger.kernel.org>; Fri, 07 Jan 2022 08:51:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X8+cJJfdQXLtNRcB3mI9esnmjuZMItR3oQnomROQBck=;
        b=d4dXHfRF6T52C6xoaA/u41HrIoTjb2inRlSjx9ZNTyjPkuDCmWUV8FiO7JT4Y7kJJL
         GabidK3QkTRaffp1tuMNSDDEI4qHUCPtaS/Tq2JN3FdaQRcS7wACHaSl9tdtyjXZc+1A
         Esw1U2HRXoXjSipuXjeb9naMm8bHVgNvQa5Se5avBfEVQuG4qh2W3QmWTtLe4/y5QIJL
         hg96eTXvwzF/EjJPJEBaziballyw2D02yOHgLFQJ2x2yDdfV4v74hdUMeg6k48Nn/4Lw
         G5wle5Cr/f7zWdodi7e+VKJFHSW2Xx7Kei7jZci0fmIenaljKM6FSbFckI0KfGvs31+5
         dZeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X8+cJJfdQXLtNRcB3mI9esnmjuZMItR3oQnomROQBck=;
        b=3MlJ6Ki14PfCFEkbCjUCWX/BNN9d6iFSHL237eq3wi3LwkmEHSBwClZ2Vc7MXBe1uv
         F+5UGy5NwS9w2x0MSJwaZ8HBhZZZVR+iN5AUuwuuP+yxz4yUtjkJlyIMBY/Gq+FtNaqF
         6FzmYDESVJkx4SPCUXoo3+NCvS2UUkHqaClRqrAYST0xJYBEQXX5R8UHx9dciF8L9ANa
         H6pZbs5DcaGnYPovyr2J4iQo6lPJP4zZYefHlkjENmPL+YP36nrf+r4e0NHLYiD+S/62
         /p4Xa9uvt4rONPQDbutXf27LkuyjQTTiaUR9gDfDoew+jH1jTQyqbX+7cOMBZb1/yfyz
         VaAg==
X-Gm-Message-State: AOAM530tErq2Rho/HIR10njtYraDCWsGbOA8ZFNCb1AtheDygpbZJdz0
        5M1zxvMtYRfEakDC2BFpr9W45Q==
X-Google-Smtp-Source: ABdhPJwPiABfJj4yJ5z8uMStPXs3cHEdWal0MdjurPePG2BlzvhQQMWexmAUzTGwst0F5s99WgHwZw==
X-Received: by 2002:a17:90a:df04:: with SMTP id gp4mr639120pjb.148.1641574290349;
        Fri, 07 Jan 2022 08:51:30 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id z2sm5038718pge.86.2022.01.07.08.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 08:51:30 -0800 (PST)
Date:   Fri, 7 Jan 2022 08:51:27 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Anton Danilov <littlesmilingcloud@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] ip: Extend filter links/addresses
Message-ID: <20220107085127.0c0172eb@hermes.local>
In-Reply-To: <20220107141736.11147-1-littlesmilingcloud@gmail.com>
References: <20220107141736.11147-1-littlesmilingcloud@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  7 Jan 2022 17:17:38 +0300
Anton Danilov <littlesmilingcloud@gmail.com> wrote:

> +	if (filter.exclude_kind && match_link_kind(tb, filter.exclude_kind, 0) == -1 &&
> +	    !strcmp(filter.exclude_kind, "ether") && ifi->ifi_type == ARPHRD_ETHER)
> +		return -1;
> +	if (filter.exclude_kind && match_link_kind(tb, filter.exclude_kind, 0) == -1 &&
> +	    !strcmp(filter.exclude_kind, "loopback") && ifi->ifi_type == ARPHRD_LOOPBACK)
> +		return -1;
> +	if (filter.exclude_kind && match_link_kind(tb, filter.exclude_kind, 0) == -1 &&
> +	    !strcmp(filter.exclude_kind, "ppp") && ifi->ifi_type == ARPHRD_PPP)
> +		return -1;
> +	if (filter.exclude_kind && !match_link_kind(tb, filter.exclude_kind, 0))
> +		return -1;
> +
> +	if (filter.kind && match_link_kind(tb, filter.kind, 0) == -1 &&
> +	    !strcmp(filter.kind, "ether") && ifi->ifi_type == ARPHRD_ETHER)
> +		;
> +	else if (filter.kind && match_link_kind(tb, filter.kind, 0) == -1 &&
> +		 !strcmp(filter.kind, "loopback") && ifi->ifi_type == ARPHRD_LOOPBACK)
> +		;
> +	else if (filter.kind && match_link_kind(tb, filter.kind, 0) == -1 &&
> +		 !strcmp(filter.kind, "ppp") && ifi->ifi_type == ARPHRD_PPP)
> +		;
> +	else if (filter.kind && match_link_kind(tb, filter.kind, 0))
>  		return -1;

This is complex enough it is getting messy, it should be helper functions.
Also the code has duplications which indicates it should be split as well.
