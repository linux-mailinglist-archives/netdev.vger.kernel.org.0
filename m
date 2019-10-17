Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28FF5DB777
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 21:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503520AbfJQT0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 15:26:45 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36485 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393438AbfJQT0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 15:26:44 -0400
Received: by mail-wm1-f66.google.com with SMTP id m18so3733920wmc.1
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 12:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ruf9wkesqWSbNxE7QtIQYwEyv9vJml69voT2wFcml3o=;
        b=YIGu1qnvcTN7p6G5mIBe21BuMhA+YVrZxQ6m/SZa5z3agVfceIV22TVW/t8WodgmOb
         /3NwfuTGEpE6wr8GhRK2lCGQicNJkrqTyLTKCB+nIUMPFFqHycwy+fwG0HEDq9FfFi11
         zSo4mFoWc0s1MU60HYknUUHgkDM+RFA35/s4mRkxvpc5EZk9QAGb6YkWNuzbigwWlMhW
         qtTmLzIAG19FFI5rS1/XFKchulIzKgPvijp5uB97YgVYcfKWWcpgIUkLxAeEMZgo1tST
         yBi5FCUPiPQaZk6tL/gsmCInT2Z6Qw0j6GmkQR+gnTbnvjhHOLSk+QZixwLHY47v7vGZ
         N+xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ruf9wkesqWSbNxE7QtIQYwEyv9vJml69voT2wFcml3o=;
        b=hNKzp33YR0kJ7OZ8LpBDBo5b46XjWAhQrD4dFrHp5eDH8iFoJq7FebmT2ifed7SkRx
         3XYx38AW+Qkady6lbFPg6Rt3i0k3cmP0SXU3yeWVE9FUmWmIVzBZq3PeWgyC1PIkjUW9
         +cz042cX8xU7+wS97b2U9vkayi/71oUjBAEO/8oXLJglYvX4c3m+nGrrDETLEoqDIAxi
         BtK3Y+PA87kEUJKUzS3qZU2DncppoBOlvQr+qxrmpWoxY64k4rVFPrfT90TcZgWVqXyC
         PSYgQD9a1iZqStsXwAnjJ6Fkonge1b7jlvRzBlSwmbW8M04hqthe8ndUWD+Cf3TWoWoL
         d88A==
X-Gm-Message-State: APjAAAUPeNCuqUkvYrwOfWf8d+C2NBQ6HzYwYebbS8Cp9+gnw8/E0zfu
        BU0qY4nwePMPLVAYLJBQ8UCfhfBD
X-Google-Smtp-Source: APXvYqy+0CRtDSGC6ZRQbXBZfuy04/HwZHAZL7j+moIi5xOSJw9ZFBGzdBBtkw9rff2umXWnWmcCtw==
X-Received: by 2002:a7b:cf30:: with SMTP id m16mr4241670wmg.89.1571340402012;
        Thu, 17 Oct 2019 12:26:42 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:405c:5b8a:afd3:d375? (p200300EA8F266400405C5B8AAFD3D375.dip0.t-ipconnect.de. [2003:ea:8f26:6400:405c:5b8a:afd3:d375])
        by smtp.googlemail.com with ESMTPSA id t123sm3946489wma.40.2019.10.17.12.26.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Oct 2019 12:26:41 -0700 (PDT)
Subject: Re: [PATCH net-next] r8169: remove support for RTL8100e
To:     David Miller <davem@davemloft.net>
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
References: <002ad7a5-f1ce-37f4-fa22-e8af1ffa2c18@gmail.com>
 <20191017.151159.1692504406678037890.davem@davemloft.net>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <2b48266a-7fdc-039b-a11d-622da58acf42@gmail.com>
Date:   Thu, 17 Oct 2019 21:26:35 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191017.151159.1692504406678037890.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.10.2019 21:11, David Miller wrote:
> From: Heiner Kallweit <hkallweit1@gmail.com>
> Date: Thu, 17 Oct 2019 20:59:43 +0200
> 
>> It's unclear where these entries came from and also the r8101
>> vendor driver doesn't mention any such chip type. So let's
>> remove these entries.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> Hmmm... does it really hurt anything to keep them in there?
> 
Not really.

> Maybe we think these chips don't exist, but it would be a real
> shame to brake someone's setup when we really didn't need to.
> Indeed, therefore I did my best to find any sign of life of
such a chip version. But there was none. To be on the safe side,
let me check with Realtek directly.
