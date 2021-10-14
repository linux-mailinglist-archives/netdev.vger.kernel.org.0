Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B777142D045
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 04:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbhJNCTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 22:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbhJNCTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 22:19:37 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECDFC061746;
        Wed, 13 Oct 2021 19:17:33 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id 77so4175483qkh.6;
        Wed, 13 Oct 2021 19:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=uYjODK2otjhENlq94KcCox5NIymefYILzXYt5briTNQ=;
        b=VXSubd3P8Zlxs7xirzTORPTzQ9RAuPJP5HV5zIu4Wra5TmHbKJkXGwTHMdq051dM2S
         DEP+pO43fI7JEZKXsGhUMa4ajSOQHebJDPcHu5rYFN3kxxe/sNgDVT+pQNi+Zj8T1znI
         Pwfm7OxCRtrTG+HAVThSUxmD9gJaUo45eksvDthQGiZj1eG7KfTktkQlqvPRKwAOX7Lp
         vm1N655x6swZccD8HOgusEgIgWmGxhj7h6Yz5wjfdPRfGT4DiX70g723EOK0xYwTm2Si
         AjLWIb9Jkt7Mrgg8ir6jNouIdL1r6kMY0dRo2WVg0SAIJNZNzpfzx57WtkNeXKoI61M9
         uIeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uYjODK2otjhENlq94KcCox5NIymefYILzXYt5briTNQ=;
        b=VuLskv2xqF+82z5DxooNWvMPbhirTR4YuPLe5XfwsdAX4N0TqtH3UdC5NRvjL3QgpN
         ABJbKtVt5AUkrGxkLWF3KENj1ooQV+W8oQXulIR8UNKV9VLNwwWbLPS14/QtqPqczxhW
         9l2clzxP0PDYd27uwuwh8vUd25xR5CgoHKOonbZdzWzS5R1fjlK6h70J+PrXxlWKURVh
         1FZMh1k0qNQYrBDurCXdD5OBGbnI4lzyr4U7QncVZkGa+byemib9s++ZhynB1GCWYrAa
         WveUfIeLONOEr9lT6sfdcTPdSgvqSTbCAHL1DTY5HVqKa7tOC78MrsWOGyEkmoL07cJd
         O8jw==
X-Gm-Message-State: AOAM531IJwGrWFlS+BPZ5kU2elnJEEPyyWg0+3a9NzaEsl2D+KWRrPDw
        WB8GFot8wiI4OCUweVX/3A0=
X-Google-Smtp-Source: ABdhPJwQF4ZpOy8Uw59k0B3fZdWm0QJ//Jr0asSgktAW8MHA2O0xZrkNENDoXxLmhb5Wf+CCeOtDtA==
X-Received: by 2002:a37:b1c1:: with SMTP id a184mr2366249qkf.177.1634177852932;
        Wed, 13 Oct 2021 19:17:32 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:c875:f7ef:73a9:7098? ([2600:1700:dfe0:49f0:c875:f7ef:73a9:7098])
        by smtp.gmail.com with ESMTPSA id o14sm486156qtv.91.2021.10.13.19.17.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 19:17:32 -0700 (PDT)
Message-ID: <62295c25-7ff8-47f9-ead2-0592e4eb6696@gmail.com>
Date:   Wed, 13 Oct 2021 19:17:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 net-next 2/6] net: dsa: move NET_DSA_TAG_RTL4_A to
 right place in Kconfig/Makefile
Content-Language: en-US
To:     =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211013145040.886956-1-alvin@pqrs.dk>
 <20211013145040.886956-3-alvin@pqrs.dk>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211013145040.886956-3-alvin@pqrs.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/13/2021 7:50 AM, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> Move things around a little so that this tag driver is alphabetically
> ordered. The Kconfig file is sorted based on the tristate text.
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
