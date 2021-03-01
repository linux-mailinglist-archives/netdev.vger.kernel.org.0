Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE12327589
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 01:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhCAARe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 19:17:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbhCAARe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 19:17:34 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C52C06174A
        for <netdev@vger.kernel.org>; Sun, 28 Feb 2021 16:16:54 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id m25so3355987oie.12
        for <netdev@vger.kernel.org>; Sun, 28 Feb 2021 16:16:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wXvXgihuyU3Izq93Og6uIJ0iitlxJzOo3VnP0FEcf6o=;
        b=s8QAzL5e/G0hOHzy4vaYWEx/MtDeDHaPkDHyKrlkaaYC9uB4vpmnltCJaL8tDIsQsd
         nVlkVw8H/NrJS4fUmiBts98YuE9xgY17KLitY/c1Wnykamwrko4ZaejokFO71M930HOB
         wg9EXTAdgEEkUvEzkk+PxDunbu4Web8/6F8ckQ+G8Ke7oXBFEnFiPFFVHryNyoj5smQK
         XgQRkUkjpc1BPeYHq+pkaTgXKeBW6JJFkDiAN62lDtKd/SRGvP488IcauiHGwcuhSCvy
         5lsDXqndmB+ZIk3Vl1mfjJlF3T/bpnBXg6D0xKLJ3qUNPojGK2c5DCTqk+lBT8eg8z43
         kxQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wXvXgihuyU3Izq93Og6uIJ0iitlxJzOo3VnP0FEcf6o=;
        b=tVk9iXcC+SmAuwciDwBPxrq1g9lP3hr6tqCe1dPxFYj5l3AtA/X6ItReTn9D/EnfSO
         hMP0ARIjdePWAcy+wRVreltxxmY3/+oIpr4mM6T6t+jrn9QHD70Ih4u69UqmePJ/8Fjv
         Z2vgite75zzGdtrPlbl75ZQ85n4gOEBt7+eIcFXfwdmEaqGzgGA6WT1tRveMFbDSiMaY
         oZaO1Q73o7crll1BABxRj/+pG1mxymFb6pyWS0Z/dNSoSFrvxgbnLQo15uxdkEKgVuNn
         Vl5e/1dR2Ucbj6o3GZ6+DE5lFDOhOIVb6j8EIQcNuz28TuB2vByFnQ7qbFrttQss+5aD
         WV+Q==
X-Gm-Message-State: AOAM530NOGpdKpKnPSlxPJ1nW39b88vLEe6HOnQ6snHdMqJG8VjL1pHl
        HoBOTthojX+w4MW/gmrwGNE=
X-Google-Smtp-Source: ABdhPJwP7ItcjfkDNzvDCOae9Twcy9dEy4m5DDy/mY9U3Bd1kYbfyz9sO7fQsHi8JFrnDW+ba7gTQg==
X-Received: by 2002:aca:4817:: with SMTP id v23mr9765221oia.25.1614557813413;
        Sun, 28 Feb 2021 16:16:53 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.40])
        by smtp.googlemail.com with ESMTPSA id v9sm3056219oon.11.2021.02.28.16.16.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Feb 2021 16:16:52 -0800 (PST)
Subject: Re: [PATCH iproute2-next] mptcp: add support for port based endpoint
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>, mptcp@lists.01.org,
        Stephen Hemminger <stephen@networkplumber.org>
References: <868cfad6ab2fbd7f4b2ac6522b3ec62fce858fed.1613767061.git.pabeni@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b76abf00-8883-8215-706f-4d1b407b82ef@gmail.com>
Date:   Sun, 28 Feb 2021 17:16:51 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <868cfad6ab2fbd7f4b2ac6522b3ec62fce858fed.1613767061.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/19/21 1:42 PM, Paolo Abeni wrote:
> The feature is supported by the kernel since 5.11-net-next,
> let's allow user-space to use it.
> 
> Just parse and dump an additional, per endpoint, u16 attribute
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  ip/ipmptcp.c        | 16 ++++++++++++++--
>  man/man8/ip-mptcp.8 |  8 ++++++++
>  2 files changed, 22 insertions(+), 2 deletions(-)
> 


applied to iproute2-next. Thanks


