Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4870636DBA8
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 17:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbhD1PbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 11:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbhD1PbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 11:31:24 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05148C061573
        for <netdev@vger.kernel.org>; Wed, 28 Apr 2021 08:30:36 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id n32-20020a9d1ea30000b02902a53d6ad4bdso3696045otn.3
        for <netdev@vger.kernel.org>; Wed, 28 Apr 2021 08:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ubsOAc3Lpc5cEZa8y/Phzm7LhmWgKV0ogw0iN7TGW0s=;
        b=fCUoqBtHgIXoF1JG0POnjnAEMwyzds9DWbSea6io2N/xE93Nx4yIHhjEP7r1m4ZD30
         CeZCylIR+YvLROrmbWsjRMSFgUu62Rl1UjOzR3IakSiGpr7LgtoMBcXB1uBWfb5zMH1m
         BMyTiJpOyGz3RPQb+RHSYsUh50HdOwjgdXKnmwaXOjNsxC0dDOY98irY8sVJC2dk2Q0L
         lQ39Jg6mvV+8FxylVvicfnvwKE4+NapQkQvjTQl2j8xhe8ap/NI/nJiN7BV94tlze0Ye
         t+o1TtKUkSQlaAjnReEeHESpNOEM8X/aWIaP/nArhVTtV2PVYKfPgI78U54uC25MvVAo
         cklg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ubsOAc3Lpc5cEZa8y/Phzm7LhmWgKV0ogw0iN7TGW0s=;
        b=ToohQLqLYL0MM24BjWdIbZhLZTVMSYiSplrSxD5RY4HgtJcuPX9V8QvxxZRSGLh08e
         in1bkgGU5Hz7mb7j7jJ4BNXBPIWfZ/MiImTo4fnFybNyDIrMMsJJ3ll+F1yciCWuWF1E
         K0+S19sadYf9zp3SUm5VfCJiAg6/kr093KVCQz5aM4Tte95/T6l4bR8ecSzvF4uiJd5p
         vxHEuOx/8bB/Yp+RgfSHobwdW9dEZhv5rg67wi8Svd1JmQpyXU0E3c8A45Sk4P/U/l3a
         XAe5EDHu1Y2cI4JWWeXPP0srt+z7RND6vxbce8/bv5eIeybnbQ/Hfv4s+Vt14d6qpDRd
         +XkA==
X-Gm-Message-State: AOAM530JO3lyYTNUoea/9KlcRGn6T5b9sc+SDeQ0gnTHuIG3Q6isERPv
        ARV6aytajdDSGebTzjk11/U=
X-Google-Smtp-Source: ABdhPJznhdhGDe+eQh8s4mXGgYJgi5O1y9Ql3wI/Pg33/Bnoin52SW7APld6X15kGQV5cDAUIbeJDw==
X-Received: by 2002:a05:6830:1317:: with SMTP id p23mr17555757otq.185.1619623836359;
        Wed, 28 Apr 2021 08:30:36 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id u195sm37098oif.55.2021.04.28.08.30.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 08:30:35 -0700 (PDT)
Subject: Re: [PATCH RESEND net-next] icmp: standardize naming of RFC 8335
 PROBE constants
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, stephen@networkplumber.org, andrew@lunn.ch
References: <20210427153635.2591-1-andreas.a.roeseler@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c81da93b-a23c-67ca-c661-95548238d1e7@gmail.com>
Date:   Wed, 28 Apr 2021 09:30:33 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210427153635.2591-1-andreas.a.roeseler@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/27/21 9:36 AM, Andreas Roeseler wrote:
> The current definitions of constants for PROBE, currently defined only
> in the net-next kernel branch, are inconsistent, with
> some beginning with ICMP and others with simply EXT. This patch
> attempts to standardize the naming conventions of the constants for
> PROBE before their release into a stable Kernel, and to update the
> relevant definitions in net/ipv4/icmp.c.
> 
> Similarly, the definitions for the code field (previously
> ICMP_EXT_MAL_QUERY, etc) use the same prefixes as the type field. This
> patch adds _CODE_ to the prefix to clarify the distinction of these
> constants.
> 
> Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
> ---
>  include/uapi/linux/icmp.h | 28 ++++++++++++++--------------
>  net/ipv4/icmp.c           | 16 ++++++++--------
>  2 files changed, 22 insertions(+), 22 deletions(-)
> 

Acked-by: David Ahern <dsahern@kernel.org>


