Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F1323DD6D
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 19:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730170AbgHFRJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 13:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730029AbgHFRGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 13:06:01 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C80EC0A3BD0;
        Thu,  6 Aug 2020 10:00:28 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id 2so41464103qkf.10;
        Thu, 06 Aug 2020 10:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1Z5fSMAgfU80dT8D8hmuYu346Oxtx8DJQl6whGIjWhw=;
        b=Os3fgVnJ6scXpj5/EgxXOxGBSpATTMOfUmm03Cec1/fiQgpB9j138nicy3/BghB2Zl
         dNDMlGxmMpCu7eC73KpiVbkhCQL6x2IuV9bN24sicJ/SBchboHxOjw3T8+zUZ1tW5ZZr
         Qgykli1ZUhQaEXca1VLv6c/Y8bZJExU5tEnSCXdDfrMgHfW8ugZdUXGNrqcJCokt9eox
         k+UAPtuAdqHtKQhCDYRcwMH+mCBNeLVX2LPGuAZkXw6PF5ige3jNg8DUVZHxDpzVRhRa
         JYZpU94c3ZKgd8ILNPJRWCcQCheE1Dv8lAvPdViMqqU+VWuBSo6Qzm0uOfvQfJqt+H9s
         NbLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1Z5fSMAgfU80dT8D8hmuYu346Oxtx8DJQl6whGIjWhw=;
        b=EZIJFnOBOooYVEaJor2z+/7NPfV3bYWZhOFn+mT7xQuV7G/H/XiUun9ctYwglVE1IH
         wan9vuTtnJQkBluK8oNiHMAZmvTcXsO6aNXTJOJS+51R0Na/JqosXr4EtuOgdZbYGbVO
         kET1tdxevk39wAvtUqxFl7neEsKaBlskhzhMeUQ8C1QjuTDU50vaSxmKykrafLLAP1UV
         P66hjqWXlr3LLYGhM/A+u68C/P+HzB+cYy+J2jfOklcbKZkEKJVRQbJmW91CCDMTRaM8
         MZXB8TXSJDxUSTSZdN57YD0K8Y3zgQllVvs883awJMYSCc0an6xkbRIzjHEJQpX4YNeb
         LW1w==
X-Gm-Message-State: AOAM531xuuHf7MYkyuLqyaD0xx1rsvgjf512B2ubw5is3HBamcyS5rVI
        9cGULELGOCgYNQh3ry//LE76a/wG
X-Google-Smtp-Source: ABdhPJwS8XEe4hwORTMLv+asnKNIB0/3Z3hbF6JNKH4+0bzy8ImZQfKV5yV86CKSqU60CbT1mJZBlQ==
X-Received: by 2002:a05:620a:20ca:: with SMTP id f10mr9352219qka.0.1596733227427;
        Thu, 06 Aug 2020 10:00:27 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:7c83:3cd:b611:a456? ([2601:282:803:7700:7c83:3cd:b611:a456])
        by smtp.googlemail.com with ESMTPSA id a21sm4222575qkg.54.2020.08.06.10.00.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 10:00:26 -0700 (PDT)
Subject: Re: [RFC PATCH 1/3] selftests: Add VRF icmp error route lookup test
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Ahern <dsa@cumulusnetworks.com>
Cc:     linux-kernel@vger.kernel.org,
        Michael Jeanson <mjeanson@efficios.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20200729211248.10146-1-mathieu.desnoyers@efficios.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <42cb74c8-9391-cf4c-9e57-7a1d464f8706@gmail.com>
Date:   Thu, 6 Aug 2020 11:00:24 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200729211248.10146-1-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/29/20 3:12 PM, Mathieu Desnoyers wrote:
> From: Michael Jeanson <mjeanson@efficios.com>
> 
> The objective is to check that the incoming vrf routing table is selected
> to send an ICMP error back to the source when the ttl of a packet reaches 1
> while it is forwarded between different vrfs.
> 
> The first test sends a ping with a ttl of 1 from h1 to h2 and parses the
> output of the command to check that a ttl expired error is received.
> 
> [This may be flaky, I'm open to suggestions of a more robust approch.]
> 
> The second test runs traceroute from h1 to h2 and parses the output to check
> for a hop on r1.
> 
> Signed-off-by: Michael Jeanson <mjeanson@efficios.com>
> Cc: David Ahern <dsa@cumulusnetworks.com>

Update the address to dsahern@kernel.org


> Cc: David S. Miller <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> ---
>  tools/testing/selftests/net/Makefile          |   1 +
>  .../selftests/net/vrf_icmp_error_route.sh     | 461 ++++++++++++++++++
>  2 files changed, 462 insertions(+)
>  create mode 100755 tools/testing/selftests/net/vrf_icmp_error_route.sh
> 

Test seems fine to me. you copied icmp_redirect.sh which is fine but
please clean up comments and functions not needed for this test.
