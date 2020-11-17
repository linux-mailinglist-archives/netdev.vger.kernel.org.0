Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50AA2B587D
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 04:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgKQDtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 22:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgKQDtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 22:49:16 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C144CC0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 19:49:16 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id 35so5336585ple.12
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 19:49:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=p1wfkYbF5Mpf3xAPmESuehLUjM7efL5pfmZn2uqtG6A=;
        b=tVplDpqtW6fkUtpAYAALu8u6nxEdVxy9RBtXriTFZLMg16pLDOutTddLLR0aqaRMWU
         6tzVWffOUSstjktcuKfg3flfKn9GrbUyYI4pBOn6BRlGDKajU7Ix48BZiZubvmhPgN2K
         xgsLft7VjfgqtOdLwCAKUw5oYd5hJ96p51GPHk6JavXQsmmerKOkzUSgVKGjZbHd4pgA
         4n6VkMlsxyomVj1USXaflDIKWCcGQmGXRcAIknQz0HBTMIdW1uRK7kpeMKxkFHfhxQvd
         8Y/hsN8MYSAYPKQV/h/pWZTw1U4jmxnZJgRrVVVJ6bHb2Rnm0xRDihgeIzWRyqi7s822
         nHmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p1wfkYbF5Mpf3xAPmESuehLUjM7efL5pfmZn2uqtG6A=;
        b=Qp7AcWZqopqQNlFGrw+8ht6BWcT7ZAujYEUAbnaS6p+sGIYs6A7NOw0gAf63xqiwdu
         2ZVq4nf/ZdgBHZLbMyRTyzy12KrwtaWFQz1F63vuLa89fvGH9GJfZmPg6+cCQyxwjuxF
         LVvldH4MUssxFTlZrDEqwB7QnIIz9W2WEnv41et7/0nNWmPaxuwxM5xcDvNPJ/fD0Om5
         Y8IGDDAeMQz0IuGQivLEOuoxu8GottDhdl+bIG52eTta5u0BQQe2iN0Vo9e7iuoxGcqw
         MAjqvYLF5cvmiTZo9BiYJ8wIAfrLa9JDOH4ln17kLXx62oeXTrDCSYChdGgekmTfzYSp
         dpsQ==
X-Gm-Message-State: AOAM5331FTJWfxJgF/GHm5NefyTcgq2PZXU0XBWj8m7XhY22Fn4StyHD
        srjHkiahM/p8QCI8JSjEcwF/5HNJdLI=
X-Google-Smtp-Source: ABdhPJx+sUirwdjxc6VFMPEBcaKDSnLqBlO/ApubxTdrR6DRYhb0Hb+uOx6BKvZoeBLCZgk32r4ObQ==
X-Received: by 2002:a17:902:758d:b029:d6:65a6:c70b with SMTP id j13-20020a170902758db02900d665a6c70bmr14739906pll.30.1605584955870;
        Mon, 16 Nov 2020 19:49:15 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j1sm1016321pji.22.2020.11.16.19.49.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 19:49:15 -0800 (PST)
Subject: Re: [PATCH v3 net-next 3/3] net: dsa: tag_dsa: Use a consistent
 comment style
To:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org
References: <20201114234558.31203-1-tobias@waldekranz.com>
 <20201114234558.31203-4-tobias@waldekranz.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c42c14e3-d06d-fed8-24b6-fe10dcc10737@gmail.com>
Date:   Mon, 16 Nov 2020 19:49:13 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201114234558.31203-4-tobias@waldekranz.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/14/2020 3:45 PM, Tobias Waldekranz wrote:
> Use a consistent style of one-line/multi-line comments throughout the
> file.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
