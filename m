Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A8423B2BA
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 04:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgHDCWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 22:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgHDCWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 22:22:35 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4A8C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 19:22:35 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id g33so3861623pgb.4
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 19:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UPxivY/0ZjoJBDJ7oXIskL69rv4pxXTyWEwM6zOrQb4=;
        b=c81TkE2IAgKMqgtNXjESpQpHFCx7Ct8CMgMa7+d3hDLcjATkjo/Gw9+21VwCvJ+n6i
         5OssuENt4LeODQfw3iIEqVHiiKY6Xq7wpyiOHcaRnKcyuLo1+2F/s8z72UvLzFc38H55
         kr9rbIxvOST66glhk2Mx1BY1V94hT6OI2HUPdVu+zw4XPLqP/43+aA8IJQJ47X6uJG+b
         FruMMsR7NUFr3pR7VA72BKptYd++NhZyjQrqBWzYrQwqWcPsHJZaSl7MbgqW/yFc/kM8
         nbCKQ4mLX4XhW5+Wzxw9T9fakqDkloy0qA1ZTNkKLg6vNrXwU5fabB0puXrdSayHnDu3
         0CPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UPxivY/0ZjoJBDJ7oXIskL69rv4pxXTyWEwM6zOrQb4=;
        b=jGM5tnIxAvN6cyQjAjqsZCq69okvZWinhA1B3GgQNpDL7o+DTuvSA57fgABF5ydfbq
         dZXNqHXAbaN/MBDgL8TK6GF+zlQAYF+JWRRR4j8JMr/1n4UUmz3PUxuqDnFtXB0ujTfn
         AVkbaZTkN1VShlcgKNqVHrvByjKXmW3PIFdXgkpzCrfYmJj9t5vHnRVEETs5SGMXMe4A
         cJ8ojsdwGlPnQrGBJFHQGHcqPnq23ERSJ5vKSK6iqejHDD4Z0LdW2xQyWjyCGf6ssssh
         /dQrFgw23DBG+rbqCK8XpH0/Ip4HOkBJS8dC/IjYHQAh+0koliFQyz51dprjTzDLhMhj
         tIqQ==
X-Gm-Message-State: AOAM533TILWMfj9Mh1x08Oel9BxkNHMClhnNUacfEZ8lQmqDIy8k+pi1
        x83/i+mVox1Nfk2gKIrEaRI=
X-Google-Smtp-Source: ABdhPJxNL/OrbfNrKyYhwIApW/oqyPwAZHvluzz8Kq97PzipgbbBJq++byijfzY7eAzmqZF/f+VPZg==
X-Received: by 2002:a65:490f:: with SMTP id p15mr17465886pgs.412.1596507754690;
        Mon, 03 Aug 2020 19:22:34 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id em20sm707653pjb.37.2020.08.03.19.22.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 19:22:33 -0700 (PDT)
Subject: Re: [PATCH net-next 0/5] net: dsa: loop: Preparatory changes for
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        kuba@kernel.org
References: <20200803200354.45062-1-f.fainelli@gmail.com>
 <20200803.182022.958969303923411212.davem@davemloft.net>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c4f276a6-60df-9765-c851-d432de93bbcb@gmail.com>
Date:   Mon, 3 Aug 2020 19:22:28 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200803.182022.958969303923411212.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/3/2020 6:20 PM, David Miller wrote:
> From: Florian Fainelli <f.fainelli@gmail.com>
> Date: Mon,  3 Aug 2020 13:03:49 -0700
> 
>> These patches are all meant to help pave the way for a 802.1Q data path
>> added to the mockup driver, making it more useful than just testing for
>> configuration. Sending those out now since there is no real need to
>> wait.
> 
> Series applied, I added "a 802.1Q data path" to the subject line I integrated
> into the merge commit for the series as it seems your Subject line here was
> chopped off.

Yes it was, the merge commit looks good to me, thank you.
-- 
Florian
