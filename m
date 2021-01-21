Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D04D2FF87C
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 00:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbhAUXMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 18:12:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbhAUXKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 18:10:49 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2CFDC0613D6
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 15:10:08 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id i30so3357020ota.6
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 15:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=06DY7mYXHfi0VtZyhIfEVzK/bk5gR29kod5jnxsgkqU=;
        b=g2n9w0XGiGGkZErakXcRcJTJqZKHYEPSr1h08vheKz75v7aU3KBPHbVc6/Aau36nTV
         HFGVy3bhwbHU7Sbu8FREzn8+AndfdlIbvgtQML/+P6FXQAipzxFBLWt7G76ov7t8YfXy
         mQXs4VbpybQp+IVIUojj+bx8uz/egghuUkZeaoIEYfwqYhkHsT0VsBN4r0u8959saecm
         SVv/E7FH5zQa6Y6ZMU+vGUbzuNFAjCtDqIdWJtX37TeTOcPQBG8VU91CXhEJXeAxgsd/
         TAeyVwzh7YOqoXcjol10ja2pRuboiGMq5qbDDPZE13WUaQly0MWKUp50AdmjQFAYvP4Y
         SxQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=06DY7mYXHfi0VtZyhIfEVzK/bk5gR29kod5jnxsgkqU=;
        b=ZhV0+Wb8e/tGIju6L7k+xs/gbW3toI5/WqbIgxTMRy1OpPY7UYsWwp5O2PTIWVuzml
         uM4vx9cOJVhQLzd2HIcSuzhhoG24MzAWiFgNTeuVbzm0RYieWz4g/bhwh/76bEUTp26E
         X6xLXszp/AwjqqxaHUjDQjycCh6wV6uiOk5B0amD9FGTHEwIUYxOo3TdWYzJxCZkk5Jr
         6wZ6/6tSytOkCpkKsTWrmEHQvUsZIdLgmuZcscMsvh2ee74L3FyRnTdJbyQRQ3NfErZR
         HXqY+H0gxTJnPAWT6qvm9ltvwZF9M3OBL9hFY9AiBo0+FyjriWxPc9s4AxM4FeHwM0c1
         IfDg==
X-Gm-Message-State: AOAM5329Gj29wdcP2n+TvWTMFdY8SkBpblQxO8YjxUvWandPJVP8Hvnv
        Be9DiJxw9uOe/7Y1Z1uUl7s=
X-Google-Smtp-Source: ABdhPJxFg6SsfJ9AlVXIgx/MADH14ANz2OvPAGQObxxPF73JF3M1KvVnHVHq1prwPTl3Prck2J6BVw==
X-Received: by 2002:a05:6830:1e69:: with SMTP id m9mr1110390otr.234.1611270608173;
        Thu, 21 Jan 2021 15:10:08 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id d10sm1266942ooh.32.2021.01.21.15.10.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jan 2021 15:10:07 -0800 (PST)
Subject: Re: [PATCH iproute2] man: tc-taprio.8: document the full offload
 feature
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vedang Patel <vedang.patel@intel.com>
References: <20210121214708.2477352-1-olteanv@gmail.com>
 <20210121215719.fimgnp5j6ngckjkl@skbuf>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <229d141f-2335-7e6d-838d-6ff7cd3723a0@gmail.com>
Date:   Thu, 21 Jan 2021 16:10:06 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210121215719.fimgnp5j6ngckjkl@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/21/21 2:57 PM, Vladimir Oltean wrote:
> On Thu, Jan 21, 2021 at 11:47:08PM +0200, Vladimir Oltean wrote:
>> +Enables the full-offload feature. In this mode, taprio will pass the gate
>> +control list to the NIC which will execute cyclically it in hardware.
> 
> Ugh, I meant "execute it cyclically" not "execute cyclically it".
> David, could you fix this up or do I need to resend?
> 

I'll fix up
