Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E73A1E4B07
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731026AbgE0Qwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbgE0Qwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 12:52:41 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014AEC05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:52:41 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id s1so95388qkf.9
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Gwj8deMO/Qv5qb/IQMjF6UI5Wjj5jOBp8csy+7RokB0=;
        b=L1n1cpo9SsmUcfcaEs2tWiND0B9jD5r3QiOeYIICz6diQ92sUvs2jcE10Ff+3MND+a
         bNQFUKpW+/UjhQa1BWtE1feHvkRYUxqZW8up1wyOmvbRxGKqG/ua0L/FugEt3iaAendr
         wcxfV/PAzARrUYm6E3yYZlHOTNM3hbT3p1hn6A5eZdL4xIBNUvqa5EBjdF2jRxiWHODf
         E9pBSqEfZHGLRhJDeZJmT3scgQudRpx49syWsiYQHxEPmSLqdiL/jBnF584c8Py19XrJ
         ONahCpAvYjt3Uy/+EcWb7cWyQm2mm9sj79Uls10lCBmz0/XIaYluVBiRMDPihiFL4Qtt
         JMSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gwj8deMO/Qv5qb/IQMjF6UI5Wjj5jOBp8csy+7RokB0=;
        b=a42H7JcvIDquSGbVal2XJutLjcu1jhOYfOnR4Bhoc0y8lA4C9DZ7QUlO0S7l5qeE2s
         vCQXPLklN5/M+VNGl4Yf4IwvqCfZ9JLCzyr+cwjDUSprz0xwChbDB3I1e+fKxisohMrv
         47DIZzEy4QSra2iinwVHOLaibQ+PdEZ6sBggk+nLp8MimKqSKjZKOxQ6goIwLisZ2fJ2
         VphZXrC0+gztBg1WwtatlUNYp5hFwMBy3TyngjPG7z9q3maGuz+gIUuUklGVDiP5gWne
         L/5/OoZdFNRYjWZodQDUsjUue1+byisAsQSEbneetFEbbehD8g+Pen5/Xo2a7G/0J5ZG
         Lc4w==
X-Gm-Message-State: AOAM533239meK+Frkfu5mfy3o6prCDQy2H3eh4tR00RTbd/nO6zDTD1P
        adGm8SGRfSyWfCLiSbzzU62M/+wFIsU=
X-Google-Smtp-Source: ABdhPJyHTxKKhMkFvvLs79G2HOLParZQRcXd3BY1Q8v/Jm48SLap4XEOJqIIXhneB5G3Zzre/qDt/Q==
X-Received: by 2002:ae9:e10f:: with SMTP id g15mr5176175qkm.285.1590598360289;
        Wed, 27 May 2020 09:52:40 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:2840:9137:669d:d1e7? ([2601:282:803:7700:2840:9137:669d:d1e7])
        by smtp.googlemail.com with ESMTPSA id s4sm2696221qkh.120.2020.05.27.09.52.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 09:52:39 -0700 (PDT)
Subject: Re: [PATCH v2 net-next] net: add large ecmp group nexthop tests
To:     Stephen Worley <sworley@cumulusnetworks.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, sworley1995@gmail.com
References: <20200527164142.1356955-1-sworley@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ead48ba1-0262-d70c-30d1-209bf4298075@gmail.com>
Date:   Wed, 27 May 2020 10:52:38 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200527164142.1356955-1-sworley@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/27/20 10:41 AM, Stephen Worley wrote:
> Add a couple large ecmp group nexthop selftests to cover
> the remnant fixed by d69100b8eee27c2d60ee52df76e0b80a8d492d34.
> 
> The tests create 100 x32 ecmp groups of ipv4 and ipv6 and then
> dump them. On kernels without the fix, they will fail due
> to data remnant during the dump.
> 
> Signed-off-by: Stephen Worley <sworley@cumulusnetworks.com>
> ---
>  tools/testing/selftests/net/fib_nexthops.sh | 84 ++++++++++++++++++++-
>  1 file changed, 82 insertions(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>

Stephen: normally you summarize changes between versions. In this case
you only rebased so the summary would be:

v2
- rebased to top of net-next




