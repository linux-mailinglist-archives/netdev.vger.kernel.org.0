Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA3A534B909
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 20:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbhC0TDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 15:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbhC0TDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 15:03:34 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CBB5C0613B1
        for <netdev@vger.kernel.org>; Sat, 27 Mar 2021 12:03:32 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id z2so8801636wrl.5
        for <netdev@vger.kernel.org>; Sat, 27 Mar 2021 12:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bSncet/8RHkgrnab12cqnkiwl1ZOqzg9Hl1nEKshnrI=;
        b=dcqiCVyF64q9ljzNd52x9MbQMczDEDIpkETArtC4A5flmquTfJAWbST3ksPVE0OU0G
         CZhKaK+WnRrk1bI4m7I1PXW6mVTpePUURp067x49az7Eyv8K6pXAVWXXTUeoQ7VJKC4V
         1fKfCXyi257BEdVb50Ck65o2oHUjK+2atT5TtlEdqv7P/41mmbQQu9ifCzAQntNvygs3
         dtF9teLSTQ/0bnGnwouagKhy02H5IHrV7BL3nM5kkD9JZVffYxj8IqgQSUu9JC8pkxQU
         A9dGd9g9IGuA/8MQDQtjltOYFS7hv+LO2vYzBqSBWfUg5LPx54vS5zYPjuHmzsSbnp01
         TO5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bSncet/8RHkgrnab12cqnkiwl1ZOqzg9Hl1nEKshnrI=;
        b=dkJ6ivcQ1hmB2i/+Yq/U2YCtClO6dehjWQ5C92oDu5zL8tPH5ml2xEGkLYBYT5eh36
         MXsQveKZ0gr5NLlelbUu2v9gxGNc4fRdrMiTmEbYaWiKdQtcyDL+99+tDeWhFWhL5NpN
         ha2R9EewC6bDLWTWakYY69BSwi1jXI4vCP+ZGXpAoXi3Fj22I7XwyvsPP1utIBcse0aO
         pA/Q5aUnYgchRp3inCnXJVusN4oX11+4TDXcoMU/gvf/dwsl0SrEX6+MSdMjPtUb2kr2
         0Aq3Zr9UTPcETPRc6UaBppY+Yemp+cVjX715PHGEzqxSh0LeL6XpK/SUs9IRGeL/mUyG
         j5Pw==
X-Gm-Message-State: AOAM533nt8SgCysfpZpAV7I+0Qr9sJL4lN1rzb4Ob1NK5nKakPqLT4eY
        2+YugpysOV/IRHHOCr2ca5g=
X-Google-Smtp-Source: ABdhPJwMawM8UhpxIiCTYW3oQjxxu/cnehZCS4gmheggxGvC55m+N+N+98/of2RtN0O5+HO6EB9OvQ==
X-Received: by 2002:adf:fec5:: with SMTP id q5mr19919774wrs.43.1616871811131;
        Sat, 27 Mar 2021 12:03:31 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:49e8:7ec3:df7c:48f1? (p200300ea8f1fbb0049e87ec3df7c48f1.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:49e8:7ec3:df7c:48f1])
        by smtp.googlemail.com with ESMTPSA id r16sm14489609wrx.75.2021.03.27.12.03.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Mar 2021 12:03:30 -0700 (PDT)
Subject: Re: Upgrade from linux-lts-5.10.25 to linux-lts 5.10.26 breaks
 bonding.
To:     james@nurealm.net, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
References: <41a8809b-efd5-4d5f-d5bb-9e0d2f2e7eb4@nurealm.net>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <4a229745-9c3a-4ece-9212-aecc450b0807@gmail.com>
Date:   Sat, 27 Mar 2021 20:03:23 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <41a8809b-efd5-4d5f-d5bb-9e0d2f2e7eb4@nurealm.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.03.2021 19:32, James Feeney wrote:
> 
>> Downgrading the kernel resolves the problem, but I don't see any bonding commits between linux-lts-5.10.25 and linux-lts 5.10.26.
> 
> My mistake - 9392b8219b62b0536df25c9de82b33f8a00881ef *was* included in 5.10.26.  Thus the "Invalid argument" message.
> 
>  https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-rolling-lts&id=9392b8219b62b0536df25c9de82b33f8a00881ef
> 

The same author submitted several other patches based on a dumb robot showing mainly false positives.
Most of them fortunately could be NACKed, but some obviously were applied and need to be reverted.

> 
> James
> 

