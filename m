Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0621092DF
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 18:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729139AbfKYRdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 12:33:07 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:45772 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbfKYRdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 12:33:06 -0500
Received: by mail-ot1-f65.google.com with SMTP id r24so13297302otk.12;
        Mon, 25 Nov 2019 09:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gX0tqIXxWieTKMAO9rSOQuivUfU7i6sYCqdqRPHaB+Y=;
        b=APb5rqpA81AcvZ42ukndA5P/YXI+Pmy1ptO8Z3ClrW2O3LMhjfBIkIVEFqu8WqD013
         N4Y5pkPhbpIuw7v7pZE97g1ikmwQZELMQ+JCynZVynWQqD9jp49Wix3uDHUvSIfLVnuF
         USJyOGf23baDm/fwwLKLq31mMzk5V0HrioRWckdGoo88xrYjjA5/QjcC7zt6cbS1sUO3
         8OFaA8Gm3CAmpXDCeB7XdisD8F9Iytvv9M6t153bplsF5hSclqvUUBsM8KIOWTjR39QH
         Fl5Q+7r9jWCQUh+oIHXFX6ab1AXCZOJBYaJIsDtFjWIRQYaCEjLkWZQAM+r6va1PttU+
         +5Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gX0tqIXxWieTKMAO9rSOQuivUfU7i6sYCqdqRPHaB+Y=;
        b=CYb1+5AXltombUQuBBLFt1j0aOzoW0BxOqtd1/kMZwAzmzepMMoMMdhQfvlZQQQoBv
         hEVho34Vdt4nr//tFhqW2u0GS92e4HsHlojSMOlBsn3cRBClDHMAVx7dC+lCPTKvHS2Z
         sLCAw8STR8wv6ABjpbgZckGZW5NunOnLSjXgTHDPyyiG6ViorNcHRYbKI4nN7/5tre6j
         wPzB9TQ+y8tpLnnnGkbexSfPyfp9gUqaotzZqpTAVfTWDYIQkycsw+SgEJfQ4Hjyh+Tx
         mYPCmnYBbYnFlke34TugGfMYemep9OY74Fwcyq2JD4HVEOdjX3l7U66lzjxs1/A5PDam
         dx+w==
X-Gm-Message-State: APjAAAUAJXl4w0FUEKFgiYk4G+4R8Me62NnJdyArytWfq/q2ZcBQvOQ3
        q4/dG7ZK+OwX5G5PhV41hEVDp0cw
X-Google-Smtp-Source: APXvYqwQ9O454n1ui2bWroRW9NRaGQ3bQqo77t05tlcorWt2jErCzMYb32pzXJjeDrK5ZvuGVsWBpA==
X-Received: by 2002:a9d:469d:: with SMTP id z29mr21636318ote.309.1574703185220;
        Mon, 25 Nov 2019 09:33:05 -0800 (PST)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id s25sm2721537oic.13.2019.11.25.09.33.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2019 09:33:04 -0800 (PST)
Subject: Re: [PATCH 3/3] drivers: net: realtek: Fix -Wcast-function-type
To:     Phong Tran <tranmanphong@gmail.com>, jakub.kicinski@netronome.com,
        kvalo@codeaurora.org, davem@davemloft.net,
        luciano.coelho@intel.com, shahar.s.matityahu@intel.com,
        johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        sara.sharon@intel.com, yhchuang@realtek.com, yuehaibing@huawei.com,
        pkshih@realtek.com, arend.vanspriel@broadcom.com, rafal@milecki.pl,
        franky.lin@broadcom.com, pieter-paul.giesberts@broadcom.com,
        p.figiel@camlintechnologies.com, Wright.Feng@cypress.com,
        keescook@chromium.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191125150215.29263-1-tranmanphong@gmail.com>
 <20191125150215.29263-3-tranmanphong@gmail.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <5cbccfd3-bba8-488d-7090-716a4be9c1bc@lwfinger.net>
Date:   Mon, 25 Nov 2019 11:33:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191125150215.29263-3-tranmanphong@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/25/19 9:02 AM, Phong Tran wrote:
> correct usage prototype of callback in tasklet_init().
> Report by https://github.com/KSPP/linux/issues/20
> 
> Signed-off-by: Phong Tran <tranmanphong@gmail.com>
> ---
>   drivers/net/wireless/realtek/rtlwifi/pci.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
> 

I have not yet tested this patch, but it looks to be OK; however, for 
consistency, the subject should be "rtlwifi: ....".

Larry
