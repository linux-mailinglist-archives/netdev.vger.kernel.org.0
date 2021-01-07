Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F32C2ED440
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 17:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728726AbhAGQ05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 11:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727983AbhAGQ05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 11:26:57 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94FBC0612F6
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 08:26:16 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id c22so5235917pgg.13
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 08:26:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/1yjBNoxhvE6n74m14AHUACMEo/1fjphFvHRgWhy57E=;
        b=XvRSs/o3TNLU5pLudfMAyFVf8PZ/LjkcfAOkJHCaZj6c3E2Hj/Qny/TDDkp3/iT7FC
         Oo/XVG6ckLA8RtU0Uiu6EIgFdStwJXXB2V9Kzwli0wM14Iii8qvlZV2bMWsiJpi/r35y
         tJbGz/+oxV1sVGo1x7AiDaea0ssmGWWQLmwPXUsz3EEb8uzwQvBgQPM+oDRxaT8HukZE
         CeqhFjwl/B3PUBLLYmHHZZ2XUGvUzWFaSZenv87ToYBirlvGvkOHp24fb0BZpD3TLKL0
         SuwW08n3j5XjQNb9DDrMcI57frgYD8lPJZwGKPSRQUYw0nXlvp++kmN4chablkvYgAqE
         qtjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/1yjBNoxhvE6n74m14AHUACMEo/1fjphFvHRgWhy57E=;
        b=rFbyuvFVvGMhKP0Dk/+whkLnfPDg8SNsEnWl0OoqJxKu3/1+SpnsOTUkLQyVdZer4L
         gvFNAt6xN7ERAHTQtZMA7jD4FUcNpO9t33wgg0mMALZ4xJHzoXx6+Z5oiRqAqsfCh0Fd
         0P7ghYCMK1wFZQ4sbINWMwfhwfi95vhEfJgc2GHUvQjS8P3nw2a04GNYI2a/HDZSs4sq
         ECr3y7ZTrgTSOtNqZOIQesY7T5jX8z7E6Jg4iG88JmnNTnmcnvwHa1VqmnszhUQ8JEp4
         I5foUdpr5ztEEDII4Kqw8/iHfPdfhmAAPPPJlgWymhZxyhINcF9R5xKnWJs5YqHd3fmQ
         jFaw==
X-Gm-Message-State: AOAM530MFAD5PJU8zcePSIn9IVAkRBEd8Gz1KtWrg81PabQXtOl77tN3
        qHHTeoYenrmfoM/+blgNEgTtTg==
X-Google-Smtp-Source: ABdhPJyIhLme3lhSkK6RGVEM4NYI6y3jVpRgv6m9d6GeF8mtSGHD4WI82reFdNVIMJpV3X+zpWNT1A==
X-Received: by 2002:a63:c04b:: with SMTP id z11mr2623949pgi.74.1610036776592;
        Thu, 07 Jan 2021 08:26:16 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id i25sm6108567pfo.137.2021.01.07.08.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 08:26:16 -0800 (PST)
Date:   Thu, 7 Jan 2021 08:26:04 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Roi Dayan <roid@nvidia.com>
Cc:     netdev@vger.kernel.org, Petr Machata <petrm@nvidia.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2 v2 1/1] build: Fix link errors on some systems
Message-ID: <20210107082604.5bf57184@hermes.local>
In-Reply-To: <20210107071334.473916-1-roid@nvidia.com>
References: <20210107071334.473916-1-roid@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Jan 2021 09:13:34 +0200
Roi Dayan <roid@nvidia.com> wrote:

> +#define _IS_JSON_CONTEXT(type) ((type & PRINT_JSON || type & PRINT_ANY) && is_json_context())
> +#define _IS_FP_CONTEXT(type) (!is_json_context() && (type & PRINT_FP || type & PRINT_ANY))

You could fold the comparisons? and why are the two options doing comparison in different order?

#define _IS_JSON_CONTEXT(type) (is_json_context() && (type & (PRINT_JSON | PRINT_ANY))
#define _IS_FP_CONTEXT(type)   (!is_json_context() && (type & (PRINT_FP || PRINT_ANY))
