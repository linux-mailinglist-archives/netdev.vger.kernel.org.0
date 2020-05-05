Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D02481C4CB9
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 05:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgEEDkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 23:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726516AbgEEDkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 23:40:02 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1BBC061A0F
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 20:40:02 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id 59so350453qva.13
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 20:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yBdV5kAut1zlr//MdzQGzUG0AFyhscM5ufrp1CamKR4=;
        b=ih0or63bUd1542nLve37BDBZuv3ohVXAUI8E80w4BFocIDYOEDkocx7iTQ0RHuzKvO
         sWLZttzFSXV2YY59Es1rZhm6vKjUXocepplcMQtPFnXqKoOvevu9EGi8Fb0S7BftC6eh
         gMEdI3IloMt2G+OtFgh0MUkFFcFLJJxjLRHPbyX4j0y97wFAgj7KtOBMaoaILP0s42WC
         jlfThH4u9dVRjiOugfzPoPuQn3OmpAMw3PyAXq/nl76Ip6LzLtn01/gYRk14FBcYA81g
         iQyj8hG84vTI4lu/33BMvdaQEe6txAbfvclNDK8KmNHydh9fS0ek4/XLLrW/SKQzu3be
         TRHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yBdV5kAut1zlr//MdzQGzUG0AFyhscM5ufrp1CamKR4=;
        b=eQRcRegOxRCUTQUCc/K7OU5mZfaliipVWNmrQqCkjvnzjTGiy/9TjNi2v1qD8TnthI
         oxozSXY9hY2+Voy6hCwzv9b2tpszuJWg0ghW9xM1AiZn5oxdIxBHUwPBk7esRqHhoA1G
         xQ+xijwg3Wdb4R2o4ruihFl5m9H4qdW8mFliDkoFpJUF5dqR8299DdNVZN8XlsdHQF9r
         TH3BtxZZ+ejR+vQRMbKKYvPVm01ZMMlTyJXARiHEVqUVIuAKe/gRsslshRV2oiv2PkFx
         8QOJj53XwWU5AekFOl8udCYMp0LKTGlMQ3dOraas/ZPjqRqRfwLmkUbnwXEJ6T5erEOx
         aJqg==
X-Gm-Message-State: AGi0PuZ9zfplqoh0mFM3pIxro+1QbPL5bjHUKwyVddQAfk/VrieAUp2f
        HYPkQqPANK4eACFtC8Xj2mU=
X-Google-Smtp-Source: APiQypIUACeKe0yOH9lKJNm/QB68TtkshCcvY5RPpagdSZzM74tD/vbGjmvUkXOH9QiWxGk7BDqNbA==
X-Received: by 2002:ad4:50c3:: with SMTP id e3mr775579qvq.116.1588650001021;
        Mon, 04 May 2020 20:40:01 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:4fe:5250:d314:f77b? ([2601:282:803:7700:4fe:5250:d314:f77b])
        by smtp.googlemail.com with ESMTPSA id p2sm882796qkm.41.2020.05.04.20.39.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 20:40:00 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 5/5] selftests: net: add fdb nexthop tests
To:     Roopa Prabhu <roopa@cumulusnetworks.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        idosch@mellanox.com, jiri@mellanox.com, petrm@mellanox.com
References: <1588631301-21564-1-git-send-email-roopa@cumulusnetworks.com>
 <1588631301-21564-6-git-send-email-roopa@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9690d866-4dc2-61c5-97e1-81be2f5dae9b@gmail.com>
Date:   Mon, 4 May 2020 21:39:58 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1588631301-21564-6-git-send-email-roopa@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/4/20 4:28 PM, Roopa Prabhu wrote:
> From: Roopa Prabhu <roopa@cumulusnetworks.com>
> 
> This commit adds ipv4 and ipv6 basic fdb tests to fib_nexthops.sh.
> Started with a separate test script for fdb nexthops but seems like
> its better for basic tests to live in fib_nexthops.sh for overall
> nexthop API coverage.
> 
> TODO:
> - runtime vxlan fdb tests: Its best to add test similar
> to the forwarding/vxlan_symmetric.sh test (WIP at the moment. Any
> suggestions welcome. Plan to include it in the non-RFC version)
> 
> Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
> ---
>  tools/testing/selftests/net/fib_nexthops.sh | 77 ++++++++++++++++++++++++++++-
>  1 file changed, 75 insertions(+), 2 deletions(-)
> 

make sure the selftests covers negative tests too in the existing
functional test sets. e.g., fdb nh can not be used with routes, fdb and
blackhole, mixed groups (mpath cannot have a mix of fdb and non-fdb).

