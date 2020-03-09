Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6E9D17E3C4
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 16:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgCIPim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 11:38:42 -0400
Received: from mail-qv1-f42.google.com ([209.85.219.42]:38903 "EHLO
        mail-qv1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbgCIPim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 11:38:42 -0400
Received: by mail-qv1-f42.google.com with SMTP id p60so2538864qva.5
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 08:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0/x8EgKhU0TCapZ+xqwkvCuRMzxILoYRTHqpfSMhQZ4=;
        b=K7uujQOqcc49KC6R19cyCqyxe6PShxocaGlJ54QAvyz8wHi2SssgzN2a0zAVTvhNyM
         ll55KSi6uRbv/toB0nRYtgWOT4sfrgmaK7xTOcayGwEy6RVZo2yxGpShu2CCwM3IiFRn
         GyJlrl4FX+xfWiZW5PpgLDcaRDksCcq/qNkauqPeboFCi5Xkl5pZrdmkbN1577WQ9pEU
         DXFKoG0qORD9CHZzRl4FIFMVcjKxSEWb4VNM/IfXUbDnEEEUPUfLD7WNpzsI4Tt7d/xy
         HtoTvvAAatoq+PYcpNyXn7Npz5vlBjxoHenflYxMZoQezPrRWZ1beHkXOSH3azkTrFIB
         qYrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0/x8EgKhU0TCapZ+xqwkvCuRMzxILoYRTHqpfSMhQZ4=;
        b=C01HIt36Ww1QJfIwX9Pe7qjgpq9+Yojk9LpcITmxkNuxo2UCRcAOj264r5V70v78l/
         /6lZk+9De/NsW9wPQ78hif3N+UYThVbi99Vk56Zsg1ujZ++DU2zI3JSCmhKZKZlTxD6J
         9Durr9QU0JJya5sCOlLI/To53XLsrdQXLR7qlCZDcSdxRG8ZGA/655btACoEzTXYL9Ra
         Kv/hjLBcOrJo94iTvpEKLyBd54Wul4YLXygi0H+/fXH75FMyqdgsIXFTcH6LgJNZDPBj
         Ji1frps+TMtHE0FaqAyxUrXlOkHU0+u25hRfcFhltET/Ll1wiQr24IuCqnCkI5Iy1rb+
         IQUA==
X-Gm-Message-State: ANhLgQ0wC4iXaRR9JBwjGxMkpFFYA0DEYzVKJLPWDF1byQkq6Js+Qteb
        3BPeXdCyBGqhB3p4ZP6c1+c=
X-Google-Smtp-Source: ADFU+vtn+y/sCw2Zz3pEKMyBKajc9g1a289qgVVta43d1/EAxz2CHivEXs0pn5SRJtS8qYwKiZAKqQ==
X-Received: by 2002:ad4:588e:: with SMTP id dz14mr12787821qvb.103.1583768321310;
        Mon, 09 Mar 2020 08:38:41 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c8c4:d4d8:cd2d:6f68? ([2601:282:803:7700:c8c4:d4d8:cd2d:6f68])
        by smtp.googlemail.com with ESMTPSA id j1sm19581584qtd.66.2020.03.09.08.38.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 08:38:40 -0700 (PDT)
Subject: Re: [patch iproute2/net-next] tc: m_action: introduce support for hw
 stats type
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, mlxsw@mellanox.com
References: <20200309152743.32599-1-jiri@resnulli.us>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <39815e7d-7dd5-c5b4-54b7-90f6852a3d08@gmail.com>
Date:   Mon, 9 Mar 2020 09:38:39 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200309152743.32599-1-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/20 9:27 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> introduce support for per-action hw stats type config.

You need to add more here - explaining what this feature is and giving
an example.

> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  include/uapi/linux/pkt_cls.h | 22 +++++++++++++
>  man/man8/tc-actions.8        | 31 ++++++++++++++++++
>  tc/m_action.c                | 61 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 114 insertions(+)
