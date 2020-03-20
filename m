Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA0818D484
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 17:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbgCTQeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 12:34:07 -0400
Received: from mail-qv1-f49.google.com ([209.85.219.49]:45025 "EHLO
        mail-qv1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727163AbgCTQeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 12:34:07 -0400
Received: by mail-qv1-f49.google.com with SMTP id w5so3264902qvp.11
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 09:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KohRZac6UCstoNqis+HDAtJgk+6j4Y3RiB4OaJrGVbo=;
        b=aVTX3J5o3MYuKvd0DXl4fHsBt5tohqqHN0irgIe0R+tziOfcNrZ63k8YHkvfV5tJ50
         Tn2AGZ9TtOLGDsu+XAskescN7aBiqQuP224DAlOMUZ/ojyntGMBTVvpsNsmbKbQfknm/
         vJgfBUoMPQRnQ7aMvY40695RliVVGr6vN5Frrc2+8xHiOgEm6hDRoKliBVMcknAKJwW0
         eKqLeSVLypBivRqqNK0tpKfLj65/zoxxBTXRkDmU1ENd3J+8lkuy/jKJj0SGQ031gmMX
         LLDFbSUIK1RgbPa0lMaBmqyYqAgzqtOqE8cqmy2QzPaiGQnbqY96nBiLpua9QcCn78ln
         qq6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KohRZac6UCstoNqis+HDAtJgk+6j4Y3RiB4OaJrGVbo=;
        b=qLNZeUt/koeDuQhMYHOehYZPYRWCuRR6WhbqobfUfhiWHcj2B2zimCJiXI2i+N00oY
         XA0aLgAjTML2s25t4INzrTBBXvagzpXM5QyHr8B5Ir6RtPwfHLjElqxDC2/oCn3x42+0
         qxi2/sSc6TeELY9/CHUQZBe/kekDM9FInSXeqyBTRW3dKPciFitw3oebHl9hG7MIWQQO
         KWM/mr2C5kCMiHn3md0/G9FZRU3nXiHPOMQD8dc4rwgmEd4uKRSDvU5t4ODRdFNu35ha
         B+NoT2WATusN5zOLdDhJhBpn+3x55zHkkdlM3bq6hEAh/iaco+OTFxwVBioHSs1Vgi5z
         A/Tg==
X-Gm-Message-State: ANhLgQ1CrRg5wCtrCQ+wRBPUv/zBEjvTDpJm8ClO0CJnIjrEIGHlCAfA
        VkplNqFz8q2GzEaBTpX/0P4YB76b
X-Google-Smtp-Source: ADFU+vtZC3qHAWt9hrWMEEnEGjlhj5tmu4FaRsPNz+SKGFvxCUUUWwT9YbO3XPuZij+L42bel8iSDg==
X-Received: by 2002:a05:6214:7e8:: with SMTP id bp8mr8943260qvb.243.1584722046384;
        Fri, 20 Mar 2020 09:34:06 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:e9f2:4948:e013:782b? ([2601:282:803:7700:e9f2:4948:e013:782b])
        by smtp.googlemail.com with ESMTPSA id n46sm5236506qtb.48.2020.03.20.09.34.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2020 09:34:05 -0700 (PDT)
Subject: Re: [patch iproute2/net-next v5] tc: m_action: introduce support for
 hw stats type
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, mlxsw@mellanox.com
References: <20200314092548.27793-1-jiri@resnulli.us>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ef67d2db-47a0-a725-5a9a-33986bcc07b4@gmail.com>
Date:   Fri, 20 Mar 2020 10:34:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200314092548.27793-1-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/14/20 3:25 AM, Jiri Pirko wrote:
> @@ -200,6 +208,29 @@ which indicates that action is expected to have minimal software data-path
>  traffic and doesn't need to allocate stat counters with percpu allocator.
>  This option is intended to be used by hardware-offloaded actions.
>  
> +.TP
> +.BI hw_stats " HW_STATS"
> +Speficies the type of HW stats of new action. If omitted, any stats counter type

Fixed the spelling and applied to iproute2-next.



