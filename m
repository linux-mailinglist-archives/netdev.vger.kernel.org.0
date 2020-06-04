Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBFB81EDBFD
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 06:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbgFDEBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 00:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgFDEBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 00:01:22 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A587C03E96D
        for <netdev@vger.kernel.org>; Wed,  3 Jun 2020 21:01:21 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 185so2920832pgb.10
        for <netdev@vger.kernel.org>; Wed, 03 Jun 2020 21:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y1oGYZ2zZn598cmqPQo9i+WUpwfjZaqhgrgwtMbcl0U=;
        b=QGA0+vnf4LuH/xrAhQrDJAFD8XHav8GwIAlpUGVjUYq0iQ/SW6ft1bXf9D8RqxwA9G
         xbNnCYnSO7RaKTuSFkIs0B6GWjQYOHzYT4mwgwqo1qymAzI6nREfBcKMfdNqZ6LJuYAy
         uL9Ulc9PzzQ+2/w2OnkWPDUd1oEwfnimgA7g3uwUs7uv7Mw2aa239j5O3MhBSSCOhbxQ
         HTrTMzvqM5wMq//Cx3vZhYEvL/bAIpU8+ojkCknEKDDLXiaUsP8QYDp7Frvh1sweQBx5
         zlrOzLe9mZ/7HQiq+BYatMOWdcljMSKS+AGHQER+lNHb2muidgBF9HedcqOqNXbJHBnQ
         eGzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y1oGYZ2zZn598cmqPQo9i+WUpwfjZaqhgrgwtMbcl0U=;
        b=l0Id2LQ9Cb0ViYylCUCvM+t4BTquABqmMBUHzJzDMohLTNpJJXtcprrTPCJnVDPQL4
         2sKinwpxxM4CC0ThRwjpJrpX+iqTPS0jXNb/fpWTjrkXaPU4cB6ztXnrAsoBv+R7c77W
         M1Qx675hYg6FMuChQNzUQn3WzxK57AynaGxZO2P8lSqp4RqmujxptyuILOOXWvSyWK/Q
         pIpJjxLXuI8v6AkRN16KWfRr8lB0XtoA/yzYAg7wU6S63vYCUV2bMj0NOTwZsfLScszd
         b3Y+vR+hj1CGSlvzLxm55+V8g2PkO1vST+nE8lTB41d7McS3O6nMfkghGpk/hvtLFlrf
         Tqnw==
X-Gm-Message-State: AOAM53019tf9OmlS2cjktrtpVoLo5TeWbnK0Wa6F8nQQtIqNaw2DseNx
        yoPQMODLoK87CF6jXgPJ9e0=
X-Google-Smtp-Source: ABdhPJwVORW3CYYi/gij3fURaE5qIT88N/uY6XWk3P30fCAxT66cmursEnSY3NerTnBa954XSHpm5Q==
X-Received: by 2002:a63:2043:: with SMTP id r3mr2344127pgm.299.1591243280669;
        Wed, 03 Jun 2020 21:01:20 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h13sm3117135pfk.25.2020.06.03.21.01.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2020 21:01:19 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 8/8] selftests: net: Add port split test
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Danielle Ratson <danieller@mellanox.com>, netdev@vger.kernel.org,
        davem@davemloft.net, michael.chan@broadcom.com,
        jeffrey.t.kirsher@intel.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com, snelson@pensando.io,
        drivers@pensando.io, andrew@lunn.ch, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Petr Machata <petrm@mellanox.com>
References: <20200602113119.36665-1-danieller@mellanox.com>
 <20200602113119.36665-9-danieller@mellanox.com>
 <619b71e5-57c2-0368-f1b6-8b052819cd22@gmail.com>
 <20200603201638.608cfdb0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0a5ac09d-ea4d-fddf-fc58-9a42b7e086f8@gmail.com>
Date:   Wed, 3 Jun 2020 21:01:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200603201638.608cfdb0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/3/2020 8:16 PM, Jakub Kicinski wrote:
> On Wed, 3 Jun 2020 11:12:51 -0700 Florian Fainelli wrote:
>> Any reason why this is written in python versus shell?
> 
> Perhaps personal preference of the author :) 
> 
> I'd be curious to hear the disadvantages, is python too big for
> embedded targets?

The uncompressed root filesystem (buildroot based) we use is 37MB
without it and becomes 55MB with python3. Compressed, we are looking at
a 16MB vs 22MB kernel+initramfs, this is a sizable increase, but still
within reason.

NFS mounting when testing network is not such a great idea unless you
have a dedicated port that you can reserve which you sometimes do not
have, that makes extending your program base a bit harder.

In general there appears to be no direction from kernel maintainers
about what scripting language is acceptable for writing selftests. My
concern over time is that if we all let our preferences pick a scripting
language, we could make it harder for people to actually run these tests
when running non mainstream systems and we could start requiring more
and more interpreters or runtime environments over time.

If there is no strong technical reason for using python, which at first
glance there does not appear to be, could we consider shell?
-- 
Florian
