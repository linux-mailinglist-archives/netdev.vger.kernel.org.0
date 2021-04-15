Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9D0360FEB
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 18:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233869AbhDOQMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 12:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbhDOQMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 12:12:30 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1229C061574;
        Thu, 15 Apr 2021 09:12:07 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id m11so16370993pfc.11;
        Thu, 15 Apr 2021 09:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bn/FEKI0DUcK5gkZn0WmOvf0JUUXiN80J83XcZr+ujk=;
        b=oOryQzR8VKrd/DGXx1BLcg3o4LZfWGsbKTLCDevZUMPa/eoEfnyeoOj10CSj6Orq7g
         Hoz7O94Dsf8HW0ZvqizYs59gA60XmvhdhIQi/Do9TKcOmBc2e7SBL1Xg6KmDppX88JvH
         LG1/H+XDcRPMJdIV4yadeBdksBDW7CiJIMJ77Cqq5W+d2iqlLrwJOQmHMxhWxNG4QggQ
         hVUsap79lIM2/UB7g+58N9EawerM73hZKTnnDYJpKxUY6wmAp66nUZUacWRh0Uv1rgh3
         rv7K0/TfLrl4V1VWw/kLzvkQGaP/kDiTSxGJeN0uaoF2KYkmaTsA+mC4dx2Eg9B4jnPW
         QKxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bn/FEKI0DUcK5gkZn0WmOvf0JUUXiN80J83XcZr+ujk=;
        b=jtT6SAqbnAAAD5FqKjrUsi6NrpaUSA7Qm7ai1NWd3JH9d0kEA2kgrFXBP9zxIuAMq6
         GrLt9VdGtIo8sqartRQtYuj5MNI4L0JN5ki++2XfX7B4A+rW4ID4LbFkYtloqBwWasQf
         JlaXmTRLBlRmeeYBgN+MxlmjOgGvb794hq+iR4/F0aaYhif8hcDD1lhuAAkqevY87/WW
         iYVdK8W6EEOD7/GdVoyfOixLL/0GJ5RK1yUwJ7vdUDghpn02fIySBXe0MM8hz35jy8z4
         Zn6OrnMRIRh2mgDahfnVJ1vX+vxHpNHCRp57ulbJDhgAa8ZTqRniiZo1sseN+bdLTagG
         b9Zg==
X-Gm-Message-State: AOAM533DNsrLH4sisvOGlvyFYLN2uF6nk7Jb+eGhTf5PYrdRNaEhZMAr
        3qscZO3DTTEE9ZUnDOHaPVPIZEsqg0I=
X-Google-Smtp-Source: ABdhPJwGrQ5hvRYo21bFnDFFBPZu++M38/fB/VpYR9CzwRR8Pd0EHk6mw0VY/hEoLCby8bhep1RuAw==
X-Received: by 2002:a63:dc49:: with SMTP id f9mr4059346pgj.361.1618503126938;
        Thu, 15 Apr 2021 09:12:06 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m11sm3083469pgs.4.2021.04.15.09.12.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 09:12:06 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 1/5] net: dsa: mv88e6xxx: Mark chips with
 undocumented EDSA tag support
To:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
References: <20210415092610.953134-1-tobias@waldekranz.com>
 <20210415092610.953134-2-tobias@waldekranz.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <81d2b72d-7d77-c668-9102-c0d19be54d74@gmail.com>
Date:   Thu, 15 Apr 2021 09:12:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210415092610.953134-2-tobias@waldekranz.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/15/2021 2:26 AM, Tobias Waldekranz wrote:
> All devices are capable of using regular DSA tags. Support for
> Ethertyped DSA tags sort into three categories:
> 
> 1. No support. Older chips fall into this category.
> 
> 2. Full support. Datasheet explicitly supports configuring the CPU
>    port to receive FORWARDs with a DSA tag.
> 
> 3. Undocumented support. Datasheet lists the configuration from
>    category 2 as "reserved for future use", but does empirically
>    behave like a category 2 device.
> 
> So, instead of listing the one true protocol that should be used by a
> particular chip, specify the level of support for EDSA (support for
> regular DSA is implicit on all chips). As before, we use EDSA for all
> chips that fully supports it.
> 
> In upcoming changes, we will use this information to support
> dynamically changing the tag protocol.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
