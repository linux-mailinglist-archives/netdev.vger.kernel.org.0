Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6D0251007
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 05:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728602AbgHYDgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 23:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbgHYDgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 23:36:24 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2738BC061574;
        Mon, 24 Aug 2020 20:36:24 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id v13so10383122oiv.13;
        Mon, 24 Aug 2020 20:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=aJK4CYpBJPrH1toP8zLPbQR7/OSGwyBsRegpuVoVLfM=;
        b=U3Kxms8nGHG/4Cel6thKiw6GhrtcjVEviQYZYOrBThIqVF1LjLzpMsocDb3ui37Flj
         oBMq07YDPBK89FbhnNeenmJgGg4Q3NEVADr96BcxqGh01I6Oo7qOMyZp9NkZQNwCZKad
         khaeh13gdeYgwrGdTzfeQW9cdR97D3D8Pv++aOVvClcqRcOkjpG/+IpzayqLD6CuNMK9
         dmbFXLz20bCjF1zauTjo0mUY/PgTxuFADrCG/IefnYrK2H5vpxrhv4HeU7PQs6QExccD
         zIYuRhRXwU/ru2mknYkNkUYKJZH9y2od7q9LqQEsBeXLpnVydT1AK/QSxyQNwTIO8BSH
         SkXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aJK4CYpBJPrH1toP8zLPbQR7/OSGwyBsRegpuVoVLfM=;
        b=W3/JnMQOTEkg4xIkI7gv6L54Kn+GS7peGvmbu8gFxhiMQcQ8x2w5Xc/G6aKoQkpBh/
         8SYXiudhn9Oxf1ymJwQ0XkUTOJFpBxnkSaCBWS7HlD99D43OG+CyTb2VglmVK4Ig3GDk
         yEiGMtBFeITdvHep4dA1+Ma1UqWD6bvsjVfeddCK6yZL6SVAL4h3un+hxj6hwKCn0sqn
         DGNXQ5JUwSbfGIoxmf4LBa+rfT26hq1FHu37X9DAp0Mv++kbfWkcGe57a3UIns3I004p
         MPJBxU0pd7av9ZcDmWeP9L+35Fjm+dRo7nHb6bpdOOFj6JbLgRoI6TGXH+7wCjDUMN03
         Zr6w==
X-Gm-Message-State: AOAM530uptShst+tYoX3loVmBlGBduswspp03GA8UgDoSmt2hIPF/QWI
        wo5BlELeRhlugQAlS1nCpN08TOkoKOTNMw==
X-Google-Smtp-Source: ABdhPJxtP6KLYyj5cNr/5kaxw4wmrCX+oW628EQ4RUi1uvc3OHt6U1jaXcmM4/8hxGmG5ugwK+sbtQ==
X-Received: by 2002:aca:adc4:: with SMTP id w187mr1492697oie.153.1598326582277;
        Mon, 24 Aug 2020 20:36:22 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:12c:2110:d2ae:4b39])
        by smtp.googlemail.com with ESMTPSA id 22sm71587oin.26.2020.08.24.20.36.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Aug 2020 20:36:21 -0700 (PDT)
Subject: Re: [PATCH 1/3] libnetlink: add rtattr_for_each_nested() iteration
 macro
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
References: <20200824175108.53101-1-johannes@sipsolutions.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5b6ed1d7-ff05-50e7-2194-3a59b799c014@gmail.com>
Date:   Mon, 24 Aug 2020 21:36:20 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200824175108.53101-1-johannes@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/24/20 11:51 AM, Johannes Berg wrote:
> This is useful for iterating elements in a nested attribute,
> if they're not parsed with a strict length limit or such.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  include/libnetlink.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 

applied to iproute2-next. Thanks, Johannes.

