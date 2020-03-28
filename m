Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFCDF1964E0
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 10:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgC1Jw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 05:52:29 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:39128 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbgC1Jw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 05:52:29 -0400
Received: by mail-wr1-f43.google.com with SMTP id p10so14677512wrt.6
        for <netdev@vger.kernel.org>; Sat, 28 Mar 2020 02:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3QnYpNESFt9Zo3NWhHkTh2ayMgHaWIUmuF+v5Ua1t3Y=;
        b=s0QOxt0Zp3NhLKWKtsGZEohiE/70iXDQBgHiOH8MsNUOcANQxc5/XmC/IzCvUy17b2
         32zPznRcUAuwMUP5jcBLcYfS8bVTaIvzsIBE/6F33GwL+tuXrQ41KN3L6iUUNsv0ltrx
         Io2Vfn5eOkSBbBc/SQaI/gouZF2SoiZhTSQNWiRPbkIGpwyHgHD/jZ3ayVhslAgmo82m
         RCzl19I3X7pf1uZjXWQJpfJQ9FNsA+GdC8rjynXUH1e8E7yxWSrx6eGY/xzh2NYbSF5u
         lh7zrgu087eDBPJg/HaOoTls2ehnX1H0flcR7L3qFuGgC40AQiZysNtzeRgHDcWXJzU8
         P+oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3QnYpNESFt9Zo3NWhHkTh2ayMgHaWIUmuF+v5Ua1t3Y=;
        b=GSMS7quYz8gjnhdTDgTve95GMvNGGZXysjCHTX8N4FNbxHW5E/0x4uKIaTQMIXzSRZ
         DiyJu+ULweetOj06rfElPX534IvhQJwjU1Xg5VhbPXHejMKbzUojXpbJH6xjAukskSDt
         jSCI9JbZ089ApbRTx9vJ4NQ7lVixZjZ//fjrYHvcCe0+szipaXs6xwYrseaNPoIEBhIV
         7HufLiOEbUroHcZZczn9z5Smz8af1BpJiIWfFr+r/1lsAdq57/7Hj5TbGHm/x5Sfafjm
         agHfPehJrqbzTlRH8o73Pxz7zT59HRlzKX7y4v7ncJNzgd0DCBP3k7bcvjrrXLuE+XHJ
         ci1Q==
X-Gm-Message-State: ANhLgQ1j8ncWOLDdPwl5w0XcTKpYxx6zRA3mfWqRaJnEO0YA1ZScz7ff
        S+B8bjWFZzSLdIjnT/HZioZPEQMO
X-Google-Smtp-Source: ADFU+vv6uqWg/lYNRjYu91Uf8CAL97i58GEnFDNmplPjdN8R6eefTgLn+5Bl9uKq85a6vTCu8CYLSQ==
X-Received: by 2002:a5d:4602:: with SMTP id t2mr4427011wrq.347.1585389146380;
        Sat, 28 Mar 2020 02:52:26 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:3cb6:ce6c:878c:aeb2? (p200300EA8F2960003CB6CE6C878CAEB2.dip0.t-ipconnect.de. [2003:ea:8f29:6000:3cb6:ce6c:878c:aeb2])
        by smtp.googlemail.com with ESMTPSA id b11sm12133080wrq.26.2020.03.28.02.52.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Mar 2020 02:52:25 -0700 (PDT)
Subject: Re: issue with 85a19b0e31e2 on 4.19 -> revert
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     David Miller <davem@davemloft.net>, nic_swsd@realtek.com,
        cwhuang@android-x86.org, netdev@vger.kernel.org
References: <40373530-6d40-4358-df58-13622a4512c2@gmail.com>
 <20200327.155753.1558332088898122758.davem@davemloft.net>
 <d2a7f1f1-cf74-ab63-3361-6adc0576aa89@gmail.com>
 <20200327.162400.1906897622883505835.davem@davemloft.net>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <05d53fd2-f210-1963-96d1-2dc3d0a3a8c7@gmail.com>
Date:   Sat, 28 Mar 2020 10:52:19 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200327.162400.1906897622883505835.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.03.2020 00:24, David Miller wrote:
> From: Heiner Kallweit <hkallweit1@gmail.com>
> Date: Sat, 28 Mar 2020 00:10:57 +0100
> 
>> Somehow that change made it to -stable. See e.g. commit
>> 85a19b0e31e256e77fd4124804b9cec10619de5e for 4.19.
> 
> This is a serious issue in that it seems that the people maintaining
> the older stable release integrate arbitrary patches even if they
> haven't been sent to v5.4 and v5.5
> 
> And I don't handle -stable backport submissions that far back anyways.
> 
> Therefore, I'm not going to participate in that ongoing problem, so
> feel free to contact the folks who integrated those changes into
> -stable and ask them to revert.
> 
> Thanks.
> 
Greg,

commit 85a19b0e31e2 ("r8169: check that Realtek PHY driver module is loaded")
made it accidentally to 4.19 and causes an issue with Android/x86.
Could you please revert it?

Thanks, Heiner
