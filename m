Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF2F142FF56
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 02:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239180AbhJPAEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 20:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235896AbhJPAEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 20:04:34 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537CCC061570
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 17:02:27 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id e59-20020a9d01c1000000b00552c91a99f7so86541ote.6
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 17:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mdxMrSfSi93F+eMuwuisFo9XelkSP+NYRxW7MaylXBk=;
        b=qcZmhIzWQEYkSTxc0nZoZjxjiA6wtcp+qNvF4B8YVhuslaDmG1ou9RPS/kY8/oyyXe
         t26fMVl8X8WoxdXMKQ/7w9SxoY2OHfWpCNtsQ0SxuojIDeVYW2MvZqHGPl2n5zUryBf/
         WfUgbLIHJ3p37nr9Zh1j7HGS+jsMHvs2wwUXW/+HxZdYrEJEM8Jd6PBcsXZOfEqClL9G
         RV0g/G6i+RGYPfdUTW5MjqfJHW1ygjBVQZrhFLE2bM5NIJJUkHeN8Jj1ErbttIS0HqCm
         3Y3dNXaQTAze8OsImSKHEa0cVhJ5Q3kb/VK9Fb5xSzLy0S81Dj6HIazVP4lJTzFeGf8d
         guYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mdxMrSfSi93F+eMuwuisFo9XelkSP+NYRxW7MaylXBk=;
        b=LnsAGDp3+sefvgAOvFrAXgpPLJi3OpSQI4gU9UA36HjOWAuWhW8VvOLqfkLRz1voaS
         Hmy1YaAQ8XzzmVQ+g9xBRk4r1qwB0erf51q+Z5oy7P9eoGl4bcY1apu4cAr6u++cGXVH
         qyvizBUxP6Ycw/kmyZXCiMjJm45OBeQjC6E+5RYECw+HvlfBhTtzjgvSECgxVkSNchsL
         R2xXVh/mNDnb3ToIHrHRWEpklz65I02XlzLf+qWc1s18cLT2JbZuXNSS7elUELhA1Dpr
         CZ4DwYZYmAdhO5+1yS7VOBZ2x6F8dtYdDw2sm6+41PZc8SEbMVQ0moIw4LKOOxtQwX/E
         o2xg==
X-Gm-Message-State: AOAM530Xjkp93zTDIirVmORh34/tMlxX4A5AU/Xp0zD1pwEFvcf0doaM
        oZWc+6JWm1GBx3gy10171nMCA8RCgmLDMw==
X-Google-Smtp-Source: ABdhPJziGQIPAJg0JiWpnxjtBitBOc09naqlG7LR105nDZQzIuL7R6ghpiM/JbPsCB+X5I6gpbte6w==
X-Received: by 2002:a9d:c47:: with SMTP id 65mr10203211otr.232.1634342546789;
        Fri, 15 Oct 2021 17:02:26 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.34])
        by smtp.googlemail.com with ESMTPSA id s5sm387255ois.55.2021.10.15.17.02.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 17:02:26 -0700 (PDT)
Subject: Re: [PATCH iproute2 v5 0/7] configure: add support for libdir option
From:   David Ahern <dsahern@gmail.com>
To:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, bluca@debian.org, phil@nwl.cc,
        haliu@redhat.com
References: <cover.1634199240.git.aclaudi@redhat.com>
 <e892800e-b914-78c8-f6af-033a5dd2144e@gmail.com>
Message-ID: <75919946-a0e2-ed53-b2d2-02d7a40996d8@gmail.com>
Date:   Fri, 15 Oct 2021 18:02:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <e892800e-b914-78c8-f6af-033a5dd2144e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/15/21 6:02 PM, David Ahern wrote:
> applied to net-next. Thanks for working on this.

sigh. iproute2-next
