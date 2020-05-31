Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C53801E9AC5
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 01:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgEaXJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 19:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbgEaXJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 19:09:10 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37EAC061A0E
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 16:09:09 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id y1so6367009qtv.12
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 16:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Z+XPw4gCm9T8+SLhfvtD6nlzTLCxbm3tCZDJNq/nXdo=;
        b=b7gM31FYvk5tT76RmHgkGa2lBJ8kagBwM2g3rQVYNNJNJGLstcj/mr4b1JOkzZXz90
         ReEPkICshyHNNsCNs+ZX4JZXM3fJ4Z58w2nxstWw63Ts426JQcT2JTzsF+z7ieEsjfUi
         CoanZpod2jLSTEAQO/A8pafQk3Qnav7w8obrY5AbZumRJwg//Y5oTGAV8/6kVdmkAT5q
         +SbHJb0A/DHm+HpZb3SqZUR46YGzA5T1t9PKIB2re/thrtlOHXJiBcFzZdp6ACbRzOXN
         R1dcKq3Sldro1CCgKRTniTNImpA7I04eRUSFp0aefGnPp6NA6+Q6jvUtVLRbDfbZd+8e
         z+tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z+XPw4gCm9T8+SLhfvtD6nlzTLCxbm3tCZDJNq/nXdo=;
        b=osDJ+U81t7rLPemHiYw4MNz+Gweoy6PAaQh40DEyisv1L7rKYF9P92mrq5ZlxzZFSB
         w3GWqweMx4/x1XFFi1Okm4gGa5KJNU7zYv2dKpTRO+dni0JJMoo8NyMmkFvE1KRebxDH
         EjXnKHNWmJs7fqn0CV6MPkeiLqVwLfwPcled2Maotl2deBi1vliV+ND3xyIdHC5NwDCQ
         dxuDXrgJJgdOSdcrL1JH/9MMbiMAIgpDZa5L3dd3/wYiDfaAeii/8xOn3PjVGUcUpt8i
         rKXS++VpiphBt+XZat/JBS1wVZP8Ctq0kNQXj0ofyk7acO5jhxJDbb0IewEMzaocnx56
         uzlw==
X-Gm-Message-State: AOAM530FUn1Y9aljBSdIvYJxjd1rH/S/UzTAiDrEvbSuML0QTpx2hQNV
        /VSIjpLaHYfwu85POOSmpVI=
X-Google-Smtp-Source: ABdhPJzjLaeFGnZ1COIUeoZqbbFxTJHhs37xmCQQgU2OEw8NHgbpMJHui7CqP9EKhLIvKbMmxjeV3A==
X-Received: by 2002:aed:3889:: with SMTP id k9mr19684095qte.347.1590966549133;
        Sun, 31 May 2020 16:09:09 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:384e:54b7:a663:6db3? ([2601:282:803:7700:384e:54b7:a663:6db3])
        by smtp.googlemail.com with ESMTPSA id j22sm12914841qke.117.2020.05.31.16.09.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 May 2020 16:09:08 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] iproute2: ip addr: Organize flag properties
 structurally
To:     "Ian K. Coolidge" <icoolidge@google.com>, netdev@vger.kernel.org
Cc:     ek@google.com
References: <20200524015144.44017-1-icoolidge@google.com>
 <20200527180346.58573-1-icoolidge@google.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <467c2970-e986-67af-2d19-371b19f8bfbf@gmail.com>
Date:   Sun, 31 May 2020 17:09:07 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200527180346.58573-1-icoolidge@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/27/20 12:03 PM, Ian K. Coolidge wrote:
> This creates a nice systematic way to check that the various flags are
> mutable from userspace and that the address family is valid.
> 
> Mutability properties are preserved to avoid introducing any behavioral
> change in this CL. However, previously, immutable flags were ignored and
> fell through to this confusing error:
> 
> Error: either "local" is duplicate, or "dadfailed" is a garbage.
> 
> But now, they just warn more explicitly:
> 
> Warning: dadfailed option is not mutable from userspace
> ---
>  ip/ipaddress.c | 112 ++++++++++++++++++++++++-------------------------
>  1 file changed, 55 insertions(+), 57 deletions(-)
> 

applied both to iproute2-next. Thanks,
