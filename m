Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B80393C78
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 06:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbhE1EgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 00:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbhE1EgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 00:36:10 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FE0C061574
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 21:31:26 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id u11so3076209oiv.1
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 21:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=KHOXAqasOhstCIvArkUV5oI3QEUwd/Db9afN5UBzyIY=;
        b=aPavgfxTOb8OQBfWw0XXj0WPXLdZifH0Et7bvh1/Q3EtEK9a85Lh+gaSfKU3PVqywZ
         fY9zL7pIDS9H7eLIlItw2kzG+TirFIZaTJHCYdspHNM8eYMrHjOOLH/z6sqhRD7pMySI
         8W5ytseLhoRhtGKsPWDIvI3cuzhzys/k+VLawxqz//GmwClOXVafPf+ksQUkInfzsXSD
         yoCyn9lp1FueYAy1R7cYambyA3mhamo3tUVfKuxld7NThfstD2XG+VUuaNC9s5mN9tnk
         Ssc8wvtKJ1ogFRlK4dOD4jK6YxTh8szqneTMpkRIA64b03/frwjCSzNQDA5CwUek91hY
         DjoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KHOXAqasOhstCIvArkUV5oI3QEUwd/Db9afN5UBzyIY=;
        b=a5/MqXCwsXDDqg6UBMVSTACfl17IX97Ac7iYgIYHiLDBJsTf4lqWBoyhTvjN6Iq5eq
         CnDHTPRdLCQV5ddrC2X8bK6SfWl9WmSUcxS2yzjIunOT9Yv2iIKI4nIpOLg87oSUNSLu
         xZpaC3SzvQtEZC/+HQzH9OJTlpQzxs7UVBOQN3P8+dU+doe4JBZ5gJdv3uTm0hVigDVD
         27tDTJL47ig7Z68qY4u8C0kauBV/y80Qw/7vk21ojblKwU5lMUxq8Rm97LbjdGeXSY3k
         ZE30LcGoVQ3Eqg8WNvHl9+PDgFueLOP9vyjbLrXEjIISL4phSsf4bC7bCnTXZU0OVAOQ
         lTbw==
X-Gm-Message-State: AOAM532SgWzoY1OUz8hZxsiZQcmDjYaFOicVARjxWk4O/QQbSJg0bAdn
        +6/6oJI6AUzIFBaDEC7ii9ZuERRNm8QdaA==
X-Google-Smtp-Source: ABdhPJzaOFH4TKAxNbpxmvAvBi7/tAGTIxLDdv4brDwKBtIpCNNflcszgB+HL3XL4B+z9llueG2FjA==
X-Received: by 2002:a05:6808:d47:: with SMTP id w7mr4707427oik.104.1622176285650;
        Thu, 27 May 2021 21:31:25 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id r124sm931547oig.38.2021.05.27.21.31.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 21:31:25 -0700 (PDT)
Subject: Re: iproute2: ip address add prefer keyword confusion
To:     Norman Rasmussen <norman@rasmussen.co.za>, netdev@vger.kernel.org
References: <CAGF1phaw5pe5y2acaoT2FqtMbZ0KXbzkg9ANAJoH=PVG=zJc7A@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <cee42fde-e171-6484-3091-fba1e65271df@gmail.com>
Date:   Thu, 27 May 2021 22:31:24 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <CAGF1phaw5pe5y2acaoT2FqtMbZ0KXbzkg9ANAJoH=PVG=zJc7A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/27/21 2:58 PM, Norman Rasmussen wrote:
> commit 78d04c7b27cf ("ipaddress: Add support for address metric")
> added "priority" and "preference" as aliases for the "metric" keyword,
> but they are entirely undocumented.
> 
> I only noticed because I was adding addresses with a preferred
> lifetime, but I was using "pref" as the keyword. The metric code was
> added _above_ the lifetime code, so after the change "pref" matches
> "preference", instead of "preferred_lft".
> 
> Is there an existing way to deal with conflicts between keyword
> prefixes? Should "prefer" (or shorter) fail with a clear error
> instead? Should the metric code have been added below the lifetime
> code? Should it be moved or is it too late?
> 

It is in general a known problem with iproute2's use of "matches" to
allow shorthand commands.

The change where "pref" goes to metric vs "preferred_lft" was
unintentional. At this point (3 years after the commit) it would be hard
to revert the change.
