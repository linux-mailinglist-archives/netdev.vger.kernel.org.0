Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868F8214DB2
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 17:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgGEPq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 11:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726975AbgGEPq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 11:46:58 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8467C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 08:46:57 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id w27so4214368qtb.7
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 08:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3Mkaj8dw5Ks6gcilFEI7x07yBjMd5m1ufQzhFKQ3OLU=;
        b=PLeniAy9KpvyePVwt/Y7UyUPgMudnXNZ+mgVEaVX6qUcouZ98mz3b0PD7SYDQvjGPn
         mVDHs3+kjnp7rIsdN913jdewb6qWPjh6E+gBpjLld8bvy1KIzQ1pemnGNexRzMr3pULz
         +OZJkjjbZOiaKnhPJe1WwvxOh1Z1Qrhc7WgDL712cUiyCluM4xA3Hc5Q6UwXZaGROttm
         L2mH49fENaLhH48w4A5ITZv1Ifb9rc7xP0BvWmUOjVnE0qHBHPo5kschdftgYjqmruF2
         3ox+Jhq1sHivK4Gjk0SVFmSNBn48q5VcPRDiZlCCuGstge7HWWMrnMzX5kArfDzivPUG
         ZQSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3Mkaj8dw5Ks6gcilFEI7x07yBjMd5m1ufQzhFKQ3OLU=;
        b=W54uCW/JCqnToZeKmssirOAEw8/+JbETMbW8CH/stcs0qsXYcXISFYjqUnZl4gKOMs
         2YpEIsuB4VfRjtsgGWHgcDFWgNszVB8RXQBIi3UQr99uvjseP0yX8RtlZ2z1wE+ApXiZ
         0UNY3XOyB90KpyTIZjfXQlOiTPwUno7uCe9EcNBteeb09CVVIXHCigwYX5x9E/0cnq0/
         I9DrStvqGH121Jc4cBEAzYotHNwOKM9BWX6G2BOygBJuZ25ykkF1UkLwcPDN0U2GHxtE
         7SxDbGIGEjNLKEwhz145ijSLM+G/Y0h/Ix15A1F1O9Efc6pjcJ8CRsj4aUGYvCIUT4Pg
         10tQ==
X-Gm-Message-State: AOAM530zltMQz5nrqfFXNSKqwplCqac8UQ48WmQZYCoQecxi2Eb/UYso
        m4qWfV92oFuduXmDS2F0q98=
X-Google-Smtp-Source: ABdhPJx7liLK8bwib3XRpVSeewIcYig7dWP93FQt4I0V5G5MkjTigWrX+pfRJ29oH1gLWDScNNQDvg==
X-Received: by 2002:ac8:45d1:: with SMTP id e17mr47285391qto.159.1593964016919;
        Sun, 05 Jul 2020 08:46:56 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:f517:b957:b896:7107? ([2601:282:803:7700:f517:b957:b896:7107])
        by smtp.googlemail.com with ESMTPSA id x14sm15624960qki.65.2020.07.05.08.46.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 08:46:56 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2 0/4] Support qevents
To:     Petr Machata <petrm@mellanox.com>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
References: <cover.1593509090.git.petrm@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9137c1db-39b2-e739-db93-74990a5a3860@gmail.com>
Date:   Sun, 5 Jul 2020 09:46:55 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1593509090.git.petrm@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/30/20 4:14 AM, Petr Machata wrote:
> To allow configuring user-defined actions as a result of inner workings of
> a qdisc, a concept of qevents was recently introduced to the kernel.
> Qevents are attach points for TC blocks, where filters can be put that are
> executed as the packet hits well-defined points in the qdisc algorithms.
> The attached blocks can be shared, in a manner similar to clsact ingress
> and egress blocks, arbitrary classifiers with arbitrary actions can be put
> on them, etc.
> 
> For example:
> 
> # tc qdisc add dev eth0 root handle 1: \
> 	red limit 500K avpkt 1K qevent early_drop block 10
> # tc filter add block 10 \
> 	matchall action mirred egress mirror dev eth1
> 
> This patch set introduces the corresponding iproute2 support. Patch #1 adds
> the new netlink attribute enumerators. Patch #2 adds a set of helpers to
> implement qevents, and #3 adds a generic documentation to tc.8. Patch #4
> then adds two new qevents to the RED qdisc: mark and early_drop.
> 

applied to iproute2-next. Thanks
