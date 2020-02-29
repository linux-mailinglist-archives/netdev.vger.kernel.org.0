Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF481743E4
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 01:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgB2Aq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 19:46:29 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35639 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgB2Aq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 19:46:28 -0500
Received: by mail-qt1-f193.google.com with SMTP id 88so3487147qtc.2;
        Fri, 28 Feb 2020 16:46:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cR46upTIlMw4m1ibbUgQeLhbQZz5s7gR2n5yBhhWrXs=;
        b=H/42vYqI6C3+3XRVOf3VGnWuxr6yyr21mW/CUAR1hrJvPoeKdgznQT/ZPFUYm4+Qe3
         mvGVmD+I0VLujYQippY8S9DjMkWuR12S6nvEAcfVsS47RUHnkijZYa/csFS/CdMGwTMP
         xIATsDIFWRl23sqoSvTxOWp1VSPNXEIs277w++JkIx9cape8CVo30aDlwGKnHCss1qIU
         NFk2urDObs6vSTkC7j9JIN3JJlSTTtdiCnCY60Jl59+yZuQf3SRBGv/137DdYkTDtQCT
         ommmnDpnmSuR/VrmM5LRPPKGHkLNlZ8efeBrj/ZVhehJ9FVw6m+zcwdLchoSt4elnxSn
         DD/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cR46upTIlMw4m1ibbUgQeLhbQZz5s7gR2n5yBhhWrXs=;
        b=haULqDBsLQ9zgSpGhXreWs8KHK+oLCcJ3OrMTOgJ+/MNKoxT+LKolgbuIXQ0tDOYHL
         3gA7HO9XF8XeA2WuhQR16imm6x1mNpT4maVc3+BxWLjZD4uC41mE/DPBax+9Q3fN0AcJ
         RjUPh+dWwS7S98XzueLjqe3oEOAIc7xbeltlH8X8gOHuZU2bYrD5zhgRyX7LighnQQHn
         465jeg7N5REpvxe2xCDaEbOrDDTbFPytswzfEwdwrOROglNwTOAUP4JUZM70XftZuAQn
         ARIOEsazwz3jmMuvNw8D6DXdz5P4e8VwK914Oz5BNCtwZHEj2M/J4d00i+xmJ7Ayt/x2
         rU5g==
X-Gm-Message-State: APjAAAWuh/rirzfGwZSKiC3QJUujSAZZXem8DzYcTsWIML6HlwQNKoiz
        kTUvyqYFdshbz2bQmaC37KzcvP11
X-Google-Smtp-Source: APXvYqx3DvammNkJlU4SIisD6lc7n9lMg/yWmHgbXByDRt8zoiyYS7gjWJnMvZsQIlkxoFw8DUy0Bw==
X-Received: by 2002:ac8:4d9b:: with SMTP id a27mr5587377qtw.369.1582937187385;
        Fri, 28 Feb 2020 16:46:27 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:29b4:b20:7e73:23f9? ([2601:282:803:7700:29b4:b20:7e73:23f9])
        by smtp.googlemail.com with ESMTPSA id y49sm6382939qtk.53.2020.02.28.16.46.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2020 16:46:26 -0800 (PST)
Subject: Re: [PATCH][next] net: nexthop: Replace zero-length array with
 flexible-array member
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200229001411.GA7580@embeddedor>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a7b747a2-2490-70a2-68a6-05b829eabb2f@gmail.com>
Date:   Fri, 28 Feb 2020 17:46:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200229001411.GA7580@embeddedor>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/28/20 5:14 PM, Gustavo A. R. Silva wrote:
> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:
> 
> struct foo {
>         int stuff;
>         struct boo array[];
> };
> 
> By making use of the mechanism above, we will get a compiler warning
> in case the flexible array does not occur last in the structure, which
> will help us prevent some kind of undefined behavior bugs from being
> inadvertently introduced[3] to the codebase from now on.
> 
> Also, notice that, dynamic memory allocations won't be affected by
> this change:
> 
> "Flexible array members have incomplete type, and so the sizeof operator
> may not be applied. As a quirk of the original implementation of
> zero-length arrays, sizeof evaluates to zero."[1]
> 
> This issue was found with the help of Coccinelle.
> 
> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> [2] https://github.com/KSPP/linux/issues/21
> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  include/net/nexthop.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>

