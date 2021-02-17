Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65BF431DDF6
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 18:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234369AbhBQRJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 12:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234291AbhBQRJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 12:09:15 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9B9C061574
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 09:08:34 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id 18so15710023oiz.7
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 09:08:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=rTiZJmJpnBx+QEmTW+5dg14+sfV1C0crqACCRCXWPSI=;
        b=f5wLd0BcE4qPBF/YVnZltaa3sRBC8j1KIpZkgb0HStWzOFmxO3Pfja83FhEqIZH0f2
         3CNUdo9oUsockIQCjnr6dy5E7Wq5PvhuSp9s69rNNjgWN4sNFNcmM9mZtWSVb8XMMqkS
         v2g2rTThRD9a1ZC8KJU3SOAGMzR5XZsXJNbvj3JSZcLLKnv166HtJtimwAsRBwPTfEt7
         11dEJz3+70fmmq6Br8ViXp2+q63qYfgC4g+0BEr5YSRZdbtFh0ESYl+hSkV6f1RDXBpp
         qD3jeLMU/UGIZRjFzqsRS1BvsXj9HKrxEj9QmSaBjPc3X4eTLhyqEllOj5ZfCILkvK0d
         obDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rTiZJmJpnBx+QEmTW+5dg14+sfV1C0crqACCRCXWPSI=;
        b=ZuTwiZR7wkRjzy+OPe1VpfRv+h0Txof3kRG5SFr8LyWwAs+Bk+EnvFP+C5FhoRoa9k
         4H8iodfk/RlP2BiPEnqQtVdWOgfbIiFn/L0I5E+fVlS5ajflQjtz79zvskzu4eOOQ5dZ
         SVCfdqH35cbuX7LAXVOOXSvYOBGCS/8CaRgPAZyheKgx616SAQmLsoWzhlw5lqI6gS/n
         sCJzt21ykvUTipBN6nn6njs24JWiIRWhpg1h+QWrQB5XTU45AY97+i8WW5Gr56mztumm
         pBh9b9B7oswHseWRjHatn2sOukiADjj2RPudhXwcq6mYXFEUub/30rv9vrOWlHQus8Fh
         1tkQ==
X-Gm-Message-State: AOAM533jYoPobsWms3/uwHbBfSGPLsMu44hAm+7Nq0FaijQgaabzv2qd
        qoHJMxoN2g95K3hz8hpVCr/K0J5jgFQ=
X-Google-Smtp-Source: ABdhPJyH5XQIR0IFKVLEgUyiFZy52luM1oiPYmyAV4g11drv1PglVQ7OR2JmOHE5D190Yu0vPLTpWw==
X-Received: by 2002:aca:b1c1:: with SMTP id a184mr6155965oif.117.1613581713543;
        Wed, 17 Feb 2021 09:08:33 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id r15sm495852otq.77.2021.02.17.09.08.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Feb 2021 09:08:33 -0800 (PST)
Subject: Re: null terminating of IFLA_INFO_KIND/IFLA_IFNAME
To:     =?UTF-8?B?0JzRg9GA0LDQstGM0LXQsiDQkNC70LXQutGB0LDQvdC00YA=?= 
        <amuravyev@s-terra.ru>, netdev@vger.kernel.org
References: <baea7ed0-ba32-3cc0-3885-7b77a72cb409@s-terra.ru>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7ef2a1a7-5aa3-3762-85ae-c8e7b77915b3@gmail.com>
Date:   Wed, 17 Feb 2021 10:08:32 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <baea7ed0-ba32-3cc0-3885-7b77a72cb409@s-terra.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/17/21 9:06 AM, Муравьев Александр wrote:
> Hi
> 
> A noob question that I haven't found an answer.
> 
> Just wanted to clarify a piece of iproute2 code.
> 
> ip/iplink.c:
> 
>> 1058         addattr_l(&req.n, sizeof(req), IFLA_INFO_KIND, type,
>> 1059              strlen(type));
> 
> also ip/iplink.c:
> 
>> 1115         addattr_l(&req.n, sizeof(req),
>> 1116               !check_ifname(name) ? IFLA_IFNAME : IFLA_ALT_IFNAME,
>> 1117               name, strlen(name) + 1);
> My question is why we skip terminating null character for IFLA_INFO_KIND
> (the first case) and don't skip it for IFLA_IFNAME (the second case)? I
> mean "strlen(type)" and "strlen(name) + 1".
> 

I think it is just different coders at different points in time. Kernel
side both use nla_strscpy which handles the string terminator (or
missing terminator).
