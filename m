Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453ED261E4C
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 21:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731887AbgIHTum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 15:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730770AbgIHPuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 11:50:46 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34046C06136E
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 08:40:10 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id w5so7894985ilo.5
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 08:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8f4GNjq3sFtQa3q528YlzlXpnsCrsN0S87sSb3xlPeE=;
        b=p38LS4utmW7wcleP7HyscGe1lG8Tvugjj/UISW0L0JCwdFSoIN4q5mdzs0iiL7/L/O
         nw69sX9MgF7EcD/u6TweVzHxcPMwOptiI+nAqLvpZ72V5pYxaY2SEcQr0p3c+Gv8+FiU
         uODICtR7bHmCbx1xFccHiV+jZyVvTWWoKT5oL3s+s5r/XXm0s5HLWnm3Z46d4JrtP/wQ
         z7mxKDCV8VKIG6bVqvLl5Qp99/FhUC3Vd5cybpt/0nrLo0RGa9Zape/B162ia/f/nCde
         GYkYK2gYGlDAMg0YnhkGnBkjAiZ2tw/ujkdDlQp0pYjzeLq7eSaI3mB0ey+tJXk+vR3L
         IVgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8f4GNjq3sFtQa3q528YlzlXpnsCrsN0S87sSb3xlPeE=;
        b=lff8yS7QgS/ztd719r6GOneyJi3xW/nx+SsrnfR0skVD+Rc/X8V+E7fbLEb9LE3RDE
         ks++rHyssqyN6cM+WIOS+N6g+PEsRta6nX8TV5u+f2qJ0Rr/tvHjdPD9fK8nWMMkGrrK
         r1ipmM6+8hGHu73A51F3/SFjGm3WK7xbd1dKxc3vypaUBp0qeAEednQQlvzyE4NFNcLj
         9vdMI1uyMXLORz1m/bM8yqCLFzqvhHYPgMPBCJAOy9DCzT5YSo9NOeXdxjTYFioJb4eo
         dzo29vVtPebdDOrkQsti8SU83gGQ8b9xfM2MNbNXZAHUv4G49zX2nd0gxxcXoEpHAGae
         lk6g==
X-Gm-Message-State: AOAM531Z/Iud1zLR9R/OYyNub8lwKsB1+AzXVdEmO9NkSP7sKwMNNiPw
        g1MEdxS6zWixK7wpDej2Y8Q=
X-Google-Smtp-Source: ABdhPJyRrLpXz6SlCes92boWV9rzfV4BoOLWESUd6cYLmbdLyLfiEiwLMF9/9gKNXM3dBv/GsHQR9w==
X-Received: by 2002:a92:8e08:: with SMTP id c8mr9145479ild.276.1599579609500;
        Tue, 08 Sep 2020 08:40:09 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:ec70:7b06:eed6:6e35])
        by smtp.googlemail.com with ESMTPSA id t8sm10746867ild.21.2020.09.08.08.40.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 08:40:09 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 21/22] netdevsim: Allow programming routes
 with nexthop objects
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-22-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <177ef239-2e27-ade3-2100-444c8c151e40@gmail.com>
Date:   Tue, 8 Sep 2020 09:40:08 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200908091037.2709823-22-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/20 3:10 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Previous patches added the ability to program nexthop objects.
> Therefore, no longer forbid the programming of routes that point to such
> objects.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  drivers/net/netdevsim/fib.c | 10 ----------
>  1 file changed, 10 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


