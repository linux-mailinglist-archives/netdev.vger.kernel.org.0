Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82C50A5C4E
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 20:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfIBSgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 14:36:50 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34762 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726750AbfIBSgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 14:36:50 -0400
Received: by mail-wr1-f66.google.com with SMTP id s18so14955248wrn.1;
        Mon, 02 Sep 2019 11:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4JvqH4dVIZDIO1d0Nq/uUBbGdESQsTM1wf9S0qUQ2TQ=;
        b=DwHuIETS6XKB8Mpy/ynyP37OhTDxGXeSj0D8kEOnlZKZsciiYnva5pfHUrK9kIzgns
         VGtB/7zZH3cOFyjjjADZyFdxzw8fiCDstk/K6pkpLbdxBCrjQ+B+iuaQKvndrqpRfLPi
         zjolKZFlQ0dlm3kzzVvUPlAp6q6Lg6r0JpDTOwEHrZqZrc3vUmb4K9n5xmh9K+PRIna+
         XefAakJ3fJYIsAma3Kc0Rxx/cXf2ym7mFnT9QOjzIQOJkWhe3cHQGs04IZiv5PRemR1N
         LwYq31nceAyULOwMjrFpy6UQHJQWmVrA7vnoJ6J5oGQ8unuColSzSWHB24eQNpNEhncn
         bsKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4JvqH4dVIZDIO1d0Nq/uUBbGdESQsTM1wf9S0qUQ2TQ=;
        b=S6uNfhZP1W+Dgz8RU8iO2G/yjY0MVf17l15Q4TYOuEh1ckWnaGGZ5UhKMuWDy0wO5E
         Ul+148gSCOkotnEyywxxEfrjalqQ0R2Z3pfhH8d27wdgQccLM0ry5jfFuNIkdYE9yZu9
         c+dy+q2zz9U3SzqaW2I8we3WAc/VdXDPGwHBSCai5jZSFL22ClFxwJ0AzioDmABRNWaW
         vjiG4SyyCdZaBuX5AtR1SNfloacP8Ma+Z8QZGPIvipxFQ0hD0jsSJmbWs/cNQoqlomh8
         d7jYjrpiedIxDyPEgF5QhZ43ZeyByzf4NDkA8dQ7jrwb1rffnk+M0JCVcssE9qc2vXO7
         E4XQ==
X-Gm-Message-State: APjAAAVzTLINmhXJni18D8harCa8f691LokzF6uacwKPPkgZab0emZhi
        Voi2myk0Noi8fpzSn4GFfv3JrKgk
X-Google-Smtp-Source: APXvYqwDLZXpr70uabGYy+aBTZfRmSoYBTbNB/DeB4/uF/C6TF3B1U/sRCAgLmpYN6dUr1N6FSQqUA==
X-Received: by 2002:adf:ea08:: with SMTP id q8mr39371547wrm.188.1567449408131;
        Mon, 02 Sep 2019 11:36:48 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:6df2:15:f24:92e2? (p200300EA8F047C006DF200150F2492E2.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:6df2:15:f24:92e2])
        by smtp.googlemail.com with ESMTPSA id z17sm15858827wrw.23.2019.09.02.11.36.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Sep 2019 11:36:47 -0700 (PDT)
Subject: Re: [PATCH net-next] r8152: modify rtl8152_set_speed function
To:     Hayes Wang <hayeswang@realtek.com>, netdev@vger.kernel.org
Cc:     nic_swsd@realtek.com, linux-kernel@vger.kernel.org
References: <1394712342-15778-326-Taiwan-albertk@realtek.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <280e6a3d-c6c3-ef32-a65d-19566190a1d3@gmail.com>
Date:   Mon, 2 Sep 2019 20:36:40 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1394712342-15778-326-Taiwan-albertk@realtek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.09.2019 13:52, Hayes Wang wrote:
> First, for AUTONEG_DISABLE, we only need to modify MII_BMCR.
> 
> Second, add advertising parameter for rtl8152_set_speed(). Add
> RTL_ADVERTISED_xxx for advertising parameter of rtl8152_set_speed().
> Then, the advertising settings from ethtool could be saved.
> 
Seeing all this code it might be a good idea to switch this driver
to phylib, similar to what I did with r8169 some time ago.

> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
>  drivers/net/usb/r8152.c | 196 +++++++++++++++++++++++++++-------------
>  1 file changed, 132 insertions(+), 64 deletions(-)
> 
[...]
