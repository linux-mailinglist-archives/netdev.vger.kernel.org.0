Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F5B20BBF7
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 23:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbgFZV4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 17:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgFZV4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 17:56:12 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137F4C03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 14:56:12 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 67so1122274pfg.5
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 14:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=HUhhFwfkhGkqkjX8NGzTXm9ABVvSJ1ODsrNUh5Xx3k0=;
        b=uj4B+vBKQ+l6LW+AQjPO4BMIbq+JwLQiGax7I23FffY/qnKMEIT8JOPMPAPTfv9SxH
         y+Nj9CZyfgCiidRJGcMaZK2i+9m5woX38VcEj9rx/oQeaUx5/b2mrFxHyJ6JsB/J7BF/
         rk7KBJG02SyAPoxiUD3GAZqBt2WIBtg0t2xf4gezIx1otWH27OCQr1yqjySR3QXhfCf7
         YclfolV7fAnfXUqchA5m5Az1eTu3F1E+nVONpCFIUoa78qkVGuDYVgjy2G/ZkWOMD553
         rsQ7MiYflTajgxjp9A4dvNWEeBkLnwsKXU04Y3hHoIxavkaZGH3oTTE2vZ8pTa7SceEK
         OX8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=HUhhFwfkhGkqkjX8NGzTXm9ABVvSJ1ODsrNUh5Xx3k0=;
        b=bVoEJB423OP925heOeylAhzjHl0+8+OhZxKaXsx6e3UIqtfqkCCfi55DSop1qYWkTN
         LrF0CEcXpWG3iFIRhTqm4dSveyb3wkP+WmcpICttgbYiolGDW3HzykYxLOpSupYC8zaG
         AZUVgQTIoXAKBIDjOxpTP2D7ySsZ9ZS8uCUfzN6RUDRZqOcVdkhcZsP/2XSnGq7ITRLj
         CqI79Zt8Lmdygbfaj9qPHHt1iMHVbNs0Cop4beQ+VzVekyTjqlJxKVD5YuVrkqNazYOt
         MTEJSXf7JOZQkrVNzN2C82TahiU7cMuHAKsvYnUwDfmXXuVC7jRWwGiN1J2OdUKzarjo
         7ETA==
X-Gm-Message-State: AOAM533W1korOJ7Fgh5ILQCjTD7wRLn0iFwe7NpmePyrt5rJCHuv0ANd
        PlVBmKStdLv953NMP9g2sLyxyw==
X-Google-Smtp-Source: ABdhPJwmw/etw7KAVVAxjoBO9/Me3YabqZf5sAKurrkpoQOTlEzGPdBMougtIPpCE2sR0nvlRXDWnQ==
X-Received: by 2002:a63:fa4d:: with SMTP id g13mr754725pgk.26.1593208571579;
        Fri, 26 Jun 2020 14:56:11 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id w203sm16890417pfc.128.2020.06.26.14.56.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2020 14:56:10 -0700 (PDT)
Subject: Re: [PATCH net-next 1/8] docs: networking: reorganize driver
 documentation again
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, klassert@kernel.org, akiyano@amazon.com,
        irusskikh@marvell.com, ioana.ciornei@nxp.com, kys@microsoft.com,
        saeedm@mellanox.com, jdmason@kudzu.us,
        GR-Linux-NIC-Dev@marvell.com, stuyoder@gmail.com,
        jeffrey.t.kirsher@intel.com, sgoutham@marvell.com,
        luobin9@huawei.com, csully@google.com, kou.ishizaki@toshiba.co.jp,
        peppe.cavallaro@st.com, chessman@tux.org
References: <20200626172731.280133-1-kuba@kernel.org>
 <20200626172731.280133-2-kuba@kernel.org>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <225cb411-ba2b-9e79-f4c6-774f18ae5b2f@pensando.io>
Date:   Fri, 26 Jun 2020 14:56:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200626172731.280133-2-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/26/20 10:27 AM, Jakub Kicinski wrote:
> Organize driver documentation by device type. Most documents
> have fairly verbose yet uninformative names, so let users
> first select a well defined device type, and then search for
> a particular driver.
>
> While at it rename the section from Vendor drivers to
> Hardware drivers. This seems more accurate, besides people
> sometimes refer to out-of-tree drivers as vendor drivers.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>

Acked-by: Shannon Nelson <snelson@pensando.io>

for the Pensando/ionic changes.
Thanks, Jakub.

