Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1868DF0C3C
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 03:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730839AbfKFCwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 21:52:54 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:44462 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730788AbfKFCwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 21:52:54 -0500
Received: by mail-io1-f66.google.com with SMTP id w12so25292437iol.11;
        Tue, 05 Nov 2019 18:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=V9TFXSNg1PnqiSa0W8b3K6KzJ4CVaOtLJm+ofNDNOlw=;
        b=tsHAMjbVU387wMY074BhmXPnCdIv8k2XcWSJlZCPNlaVV68C9tfAmhfYe/LcK10Hb3
         IxBisasFCKGzXtYgXuZ2Wf1Zz5+pRxvLzEO1kujgA68DVLJJzJHAftA8HXBgH9GRSIPe
         CB+WKcQR6jYIhsU9CqjMiXxJhYly1CYyU2mGDSso1KxK9QcgRJ8Ybbj5h2ImgBuvhkr1
         ycweR7AFusF8u2CwKFDlB6Rmymgs2PrTVGkKSPiC5LoCOqPUq0X88PFcowfgcDSFBKqZ
         J//yJVI+4po8dhtAJrmjO9jsRxpItff7Kmk3TsTXhuOkYZ8jSKPWVw2wa0ng2SiqWuNJ
         NEkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V9TFXSNg1PnqiSa0W8b3K6KzJ4CVaOtLJm+ofNDNOlw=;
        b=IUxaoFwZwwGOrAP3y5Pi6DkyPOX+m6mrvG+/3GpkgTnMRuylG+DC8NGI55SofhM3tS
         U3LqwtYZshovsAfPQEe/Q8dBUjsqBCJOgNY9yNHK7vgAAcv/qo/CwK9y3KHATKXww5Cx
         pfVtRFJ+yP8tt3jtST0bPSq5PQBAmj1UHJ6cYpXxSpaASLo1ZBfPrT/XR+6449fTJf1Q
         NodB5rqEsOCMz0FeF1EiAIC0+SWkk7nmXb7+XOntqPNVmUo96YiDqWy/OUvdWsMcFLev
         +/xsnC69d2RipMGoa+DzNI0wpuS9CQWs+KORNtlN+6OXUabRb4AYY0/8ioZ10DYggu1Y
         FamQ==
X-Gm-Message-State: APjAAAV9ARRMPyfpSHtn7vsXtljo/LMJF/l/wUUYlKTbJO6TJeW5IY4U
        /If244cOjrwOUFfkcp2TrGusZndM
X-Google-Smtp-Source: APXvYqzPXdBhnV0BTFQVpgXO5b8+4GkgQsQJJDuDkyEnzqNV/Qsja4xRQLVxskuLP3KQe3UKwxB3yg==
X-Received: by 2002:a02:b710:: with SMTP id g16mr3998158jam.111.1573008773188;
        Tue, 05 Nov 2019 18:52:53 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:478:1274:6c4f:a04c])
        by smtp.googlemail.com with ESMTPSA id x64sm3055467ill.75.2019.11.05.18.52.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2019 18:52:52 -0800 (PST)
Subject: Re: [PATCH net-next v2] selftest: net: add some traceroute tests
To:     Francesco Ruggeri <fruggeri@arista.com>, davem@davemloft.net,
        shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <20191105224835.D134F95C0C6F@us180.sjc.aristanetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <885186a6-cdd3-e397-e00a-c3f168430b2a@gmail.com>
Date:   Tue, 5 Nov 2019 19:52:50 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191105224835.D134F95C0C6F@us180.sjc.aristanetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/5/19 3:48 PM, Francesco Ruggeri wrote:
> Added the following traceroute tests.
> 
> IPV6:
> Verify that in this scenario
> 
>        ------------------------ N2
>         |                    |
>       ------              ------  N3  ----
>       | R1 |              | R2 |------|H2|
>       ------              ------      ----
>         |                    |
>        ------------------------ N1
>                  |
>                 ----
>                 |H1|
>                 ----
> 
> where H1's default route goes through R1 and R1's default route goes
> through R2 over N2, traceroute6 from H1 to H2 reports R2's address
> on N2 and not N1.
> 
> IPV4:
> Verify that traceroute from H1 to H2 shows 1.0.1.1 in this scenario
> 
>                    1.0.3.1/24
> ---- 1.0.1.3/24    1.0.1.1/24 ---- 1.0.2.1/24    1.0.2.4/24 ----
> |H1|--------------------------|R1|--------------------------|H2|
> ----            N1            ----            N2            ----
> 
> where net.ipv4.icmp_errors_use_inbound_ifaddr is set on R1 and
> 1.0.3.1/24 and 1.0.1.1/24 are respectively R1's primary and secondary
> address on N1.
> 
> v2: fixed some typos, and have bridge in R1 instead of R2 in IPV6 test.
> 
> Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
> ---
>  tools/testing/selftests/net/Makefile      |   2 +-
>  tools/testing/selftests/net/traceroute.sh | 322 ++++++++++++++++++++++
>  2 files changed, 323 insertions(+), 1 deletion(-)
>  create mode 100755 tools/testing/selftests/net/traceroute.sh
> 

Looks great. Thank you for adding this test script.

Reviewed-by: David Ahern <dsahern@gmail.com>


