Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C61337919
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 17:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbhCKQT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 11:19:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234515AbhCKQTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 11:19:41 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C97C061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 08:19:41 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id e45so1972164ote.9
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 08:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j027tr0NZjHXVtvyMMIzHtP2uwdhDIC1S0bh0OXjCiU=;
        b=LOS0ISiMwt/q73TYoflr5LSbA5G+9vRZspXgjPQUkYwHlx4U723cG/aAFhY3IEJ4gy
         JEkbISyFos7SuY1mEzENtHCv7jDSAQhV8cZJWc7BcngcUPzu5AiyY/2NENKZE+v5e4YD
         4tcdVcXE0o//VMKigX8ye27EZ7UqC4eFPg35/WJpDASYYXDWeIZ3Rw1cp6Dg39oDat9T
         /Srn7fNPYtostNlK+XbSM93Vpl1Y72OMNtBk/ESxJz9E5FkCeKZu+tHqbuuZWHAJIoTD
         IVBflOA78Nt/GOA5TOspUcWuqT399R3+KiQgq9bho0VihHJQbty/+ss2v8TKvU7P32u3
         TbTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j027tr0NZjHXVtvyMMIzHtP2uwdhDIC1S0bh0OXjCiU=;
        b=OJR0ZVdR2jkS3JmULRTJlM4s4ptWfigwoXpslOC3RTFFDAhGap3/VOVaujEAcyOjOr
         Zqit7DtQ+xcvWBfZ/sHk1ZHviLgXQqml5lCAYYv9fLI/uP/rQeQ+KB8yMkUggbNptX4R
         O9aAAT7vafL1Q4HJx3DuKJjKVtLj/LIqS+zBFVqr6EVcakcjMh1hJgqjJidgfwxWoCnW
         1tZRCs0vki9yxgTg1rf041CxAb6JFD7le9aeA3jerGD4EpGIDNt8L00YVfZsAkNYQ+dW
         Gt8yISnDn8YoBK4hcnUXcseIYVbhku6uDNX3iRjhwPfQBWHt8xxnuPa1SILl6c62e3fq
         LUgw==
X-Gm-Message-State: AOAM533NBisdc4zKcIgNmTpYnnG4fMqKbFolVT9gQI+WiGmIhUql81ox
        HnEaUpMOnHbx8OaRH3+jiaY=
X-Google-Smtp-Source: ABdhPJwJmTKNV6JVw+1MnzveuI67VdANm2COYi40cOV6q2cnq/du3z4IwnS3LHONVQBoJA00NJ19kQ==
X-Received: by 2002:a9d:3b45:: with SMTP id z63mr7320185otb.1.1615479581054;
        Thu, 11 Mar 2021 08:19:41 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id 70sm163677oie.38.2021.03.11.08.19.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 08:19:40 -0800 (PST)
Subject: Re: [PATCH net-next 12/14] nexthop: Add netlink handlers for bucket
 get
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <cover.1615387786.git.petrm@nvidia.com>
 <85186adc516de72219b72d0dbfb957554371eed8.1615387786.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <851666b5-cad9-3e64-e7a4-d46ab3a44a48@gmail.com>
Date:   Thu, 11 Mar 2021 09:19:37 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <85186adc516de72219b72d0dbfb957554371eed8.1615387786.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/21 8:03 AM, Petr Machata wrote:
> Allow getting (but not setting) individual buckets to inspect the next hop
> mapped therein, idle time, and flags.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
> 
> Notes:
>     v1 (changes since RFC):
>     - u32 -> u16 for bucket counts / indices
> 
>  net/ipv4/nexthop.c | 110 ++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 109 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


