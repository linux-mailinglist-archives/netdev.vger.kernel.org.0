Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774963C3517
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 17:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbhGJPOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 11:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232554AbhGJPOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 11:14:10 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36C5C0613DD
        for <netdev@vger.kernel.org>; Sat, 10 Jul 2021 08:11:24 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id k20so6150532pgg.7
        for <netdev@vger.kernel.org>; Sat, 10 Jul 2021 08:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fpkayEL7aMj2yKKU0Gmd6xpQtFwlwUZLzju6kgRetdU=;
        b=E8BESJu9FAKzsVEbswSaWsz8tjPg2nPCsOck1vdmfNESkmRDFX0FKh8DGbfdY8cVK9
         NtFVSSQUlo2j0YRu34FCjR1lZmbhBqkNa1m1JVNcWpNll2Hpu64fDc1ppa6NZ45zTeT/
         cHsU9Lq8xkf50KwgEYU0iPKRivGlV2tIcgXt+7SRclP2Kr4QKvaVDmUctlLGyqG2HoJM
         1pPfgO46JRq/8qwu1eb3IyoowZoHKPM+GYkuYUU8B+JTd1N9vZ7B/yM2UbgeIH7+qcWf
         I84RwX9Z/4wyqrpf50TTw3UVeVCsmmwWo4bFJqHg5FXHEVjEKFtl733cd8Ir0U0kiBQv
         f5nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fpkayEL7aMj2yKKU0Gmd6xpQtFwlwUZLzju6kgRetdU=;
        b=iqbYhoFgMCOs76/fVTY8y+68mGTJ7m/o84wTx5W+FebxzUgUq8BuV9gSy9uqf5jzwe
         SuRTbjAFlVbI3OI737WuPylV/XurdUY0r0KAA88tRRGoEXv7OrHXQcL4tQs+L5oXqpdb
         tttpjkJzHuFUP6dEG9BRYm5p6y07D+op3kJjoGQtgbBIzEmUZ/RAEQv6KWrv52hIJotq
         EGpDbhzIKxYowIx2xoEZXRXozlk3TfCJ8kwAc0/QdQq9unjYl0fDLNyF0OTGK9dTSh/K
         IFfI5yKEtsaxYiCgDq4mUr4IlFUqZmZ6q8Cj8Vqph2sA4mDkHOdjl8ClQZyVGJRV9rwj
         hyVg==
X-Gm-Message-State: AOAM530F9ZegVaVQh9L7XdR/d7C4txqA1ktNNzA9Oo4QfZsa0lJKVxHA
        gfi1KpK7ucVkANatw8A0/6XoFw==
X-Google-Smtp-Source: ABdhPJwMu5/hWKWFI0LOv9tqLeCzswEJmtynhZCHFcD7bshMqgUtBt4hndpvGjsLzDi+jddHjnHd8w==
X-Received: by 2002:a63:6e84:: with SMTP id j126mr14327645pgc.401.1625929884122;
        Sat, 10 Jul 2021 08:11:24 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id 21sm6244751pfp.211.2021.07.10.08.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jul 2021 08:11:23 -0700 (PDT)
Date:   Sat, 10 Jul 2021 08:11:20 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jian Shen <shenjian15@huawei.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@openeuler.org>
Subject: Re: [RFC net-next] net: extend netdev features
Message-ID: <20210710081120.5570fb87@hermes.local>
In-Reply-To: <1625910047-56840-1-git-send-email-shenjian15@huawei.com>
References: <1625910047-56840-1-git-send-email-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 10 Jul 2021 17:40:47 +0800
Jian Shen <shenjian15@huawei.com> wrote:

> For the prototype of netdev_features_t is u64, and the number
> of netdevice feature bits is 64 now. So there is no space to
> introduce new feature bit.
> 
> I did a small change for this. Keep the prototype of
> netdev_feature_t, and extend the feature members in struct
> net_device to an array of netdev_features_t. So more features
> bits can be used.
> 
> As this change, some functions which use netdev_features_t as
> parameter or returen value will be affected.
> I did below changes:
> a. parameter: "netdev_features_t" to "netdev_features_t *"
> b. return value: "netdev_feature_t" to "void", and add
> "netdev_feature_t *" as output parameter.
> 
> I kept some functions no change, which are surely useing the
> first 64 bit of net device features now, such as function
> nedev_add_tso_features(). In order to minimize to changes.
> 
> For the features are array now, so it's unable to do logical
> operation directly. I introduce a inline function set for
> them, including "netdev_features_and/andnot/or/xor/equal/empty".
> 
> For NETDEV_FEATURE_COUNT may be more than 64, so the shift
> operation for NETDEV_FEATURE_COUNT is illegal. I changed some
> macroes and functions, which does shift opertion with it.
> 
> I haven't finished all the changes, for it affected all the
> drivers which use the feature, need more time and test. I
> sent this RFC patch, want to know whether this change is
> acceptable, and how to improve it.
> 
> Any comments will be helpful.
> 
> Signed-off-by: Jian Shen <shenjian15@huawei.com>

Infrastructure changes must be done as part of the patch that
needs the new feature bit. It might be that your feature bit is
not accepted as part of the review cycle, or a better alternative
is proposed.
