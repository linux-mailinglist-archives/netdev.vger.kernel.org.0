Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 264A934943F
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 15:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhCYOhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 10:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbhCYOhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 10:37:02 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464CCC06174A;
        Thu, 25 Mar 2021 07:37:02 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id i81so2330227oif.6;
        Thu, 25 Mar 2021 07:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5HYasr7IY/8XwHx1NlRobjOS/dHG1ecTWNThYkY5xdo=;
        b=RchW1oa4U2bmklzvmAePB3oIvCNx+VRLxY3aTJZ6Av5cva9DwsX0ZWS1//ivB+g2LG
         /qi3D2OpGyVtbv3hI0N31XieorACdAuqxLj779OHBAhMHcaf+Ln5I13glWxw5c0+Wm6s
         oB4uLRVD79z6pFk9LQhPgiXNjy2dU8msfT8rlENbhPfivi89LKPZJqtkWXiL8KkIZu59
         TsjfRf4Wf8bqQMVOKPLheJC1zuiYat9grDwor+C2DJYRv18m6w6LhnlsfToyaJUjicvU
         XKiRNK2tu9q+SC7sosOxiFFdCqTiDjLNHGtXEvcpSiWXmRaHuHpMnSh4bAxltpEexz4G
         eGSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5HYasr7IY/8XwHx1NlRobjOS/dHG1ecTWNThYkY5xdo=;
        b=t7FPlekqHXLCRhDFG8+E8E5qV9OV+yMZw7o0EYz41mR/cvag1jUEboljaDMPVII6eB
         7odLVUp7+DY7/RMQoIR0eSfZa9jIoNvbljBQsfT1Mm1+QwhxCrIxppu34QBhcZgNQ19l
         0BGyq3A2qKND12M9YT9FU7Q+17pmln/oZbeZoGKcItv1Ajv0wX6F2EUmd3sHuvUva/hK
         2P2TQYXw2M0UtMX9xnhBcOMyzMnKjDlKehiaTBGxGbXl15GMWbxqUpaNj2ET140O6QUc
         T9C4m120VDUVivmQb2MpNFnRs9V8XAza/mIe8XTjfLDICBItJ6QKmT/sZnqo+7fCpmGg
         zl/w==
X-Gm-Message-State: AOAM533538x18vnrDVL5b8tSOxmjZYoFmf4Sujf4EZAXHXn71SZO/IP9
        VTOebjjZNMqHeUq2btC9BO9OKd+cQ6w=
X-Google-Smtp-Source: ABdhPJwXnulTzZPmpN1ewdsD543fhZiWwBETUe2aYs9K4NTvlq1n5iV+JyBmgMXXKolWxezolAWPHw==
X-Received: by 2002:a05:6808:3d9:: with SMTP id o25mr6456812oie.4.1616683021762;
        Thu, 25 Mar 2021 07:37:01 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id i25sm1403371otf.37.2021.03.25.07.37.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 07:37:01 -0700 (PDT)
Subject: Re: [PATCH 2/2] net: ipv4: route.c: Remove unnecessary if()
To:     Yejune Deng <yejune.deng@gmail.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yejune@gmail.com
References: <20210324031057.17416-1-yejune.deng@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <53746589-33fa-e5bd-037e-952f9c2d9cc3@gmail.com>
Date:   Thu, 25 Mar 2021 08:36:59 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210324031057.17416-1-yejune.deng@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/23/21 9:10 PM, Yejune Deng wrote:
> negative_advice handler is only called when dst is non-NULL hence the
> 'if (rt)' check can be removed. 'if' and 'else if' can be merged together.
> And use container_of() instead of (struct rtable *).
> 
> Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
> ---
>  net/ipv4/route.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 


Reviewed-by: David Ahern <dsahern@kernel.org>
