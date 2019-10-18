Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 833BFDCDFB
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 20:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505669AbfJRSbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 14:31:40 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35959 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2505600AbfJRSbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 14:31:39 -0400
Received: by mail-wm1-f67.google.com with SMTP id m18so7034807wmc.1
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 11:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DSnowx3keJnjQeJwi6XYTCzSgNWLN6YD6aazgV2Bf7E=;
        b=qxXAS+S4Ff84TDGOFLxq/Xcp/sAwng+zARlFcgNNWB/RMA4iGnhrYwspw5I6RjL7NL
         FO9FQVvOINhrxfW3y096/X6YoQlmdokPCg/dWUrcYwgjiPX27euhkzoGb0LVALhW2zgu
         JWkwtnt8sOOfdJI2o/+10glswelGbyP7bdgq2wgn3XrvXxFRov4Vb3eqRgMKUGyAz6mO
         OqImkzEZL+J+URvNxNuUfb0GOw0BOHfyJQXkgPydqLoR+Dh1WZWh/Z/VycAjkvIJHswS
         kRbdSdC+Jj6Q3hulhJ9vAEPR2oym2zXEmAGHaakwKqwabEv3xh+IoWxvw8JdRoK0puAI
         cigA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DSnowx3keJnjQeJwi6XYTCzSgNWLN6YD6aazgV2Bf7E=;
        b=GJ36dsiEyCmh8eX6ul0x/+yPVLTH7WyzfH7IhKm5mqowZm2foFf/xHntAqlbicHtRt
         Sr3vmkZQoNJqyklixIs2GVGyEErkgIkoHXSa70xMtcABYPkqItS0lNtZiwdIL1a4rP64
         R/qcLOdl2Xd+gwU8jby8Ye8r8RyDpYa+rACHJARgyNWlCOxCCtXdNzs5M69zMKpnO1j0
         HjRRyAgKV66N+ndRFb6x/+79VKbq55sT7vrQGTbbs5N9QRFFdoPZVtAzhzy9OkAsM7fd
         Bz+omdlYQwlzbWbi1nrQwZOfsEudepKJjR0u78mELfzzkv2WewlrzbSK0YAuhFN6XVVk
         qvcA==
X-Gm-Message-State: APjAAAUsKjZ/kbOsSSGiRfKEKbzJ9LZOsNWh85BT/+3/4QXcYobifP2W
        Y5VoJMjol6UZMbufqb46RNBrV2Hq
X-Google-Smtp-Source: APXvYqyV+a0NVHCy3XvHuO0XEMGLCQRmV3gb080BtdMWjQ3CI8Mz9KTHhjkKC1uD3Gd64Itx8rnXGQ==
X-Received: by 2002:a05:600c:2207:: with SMTP id z7mr9067505wml.149.1571423498382;
        Fri, 18 Oct 2019 11:31:38 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:8c30:515f:fd0f:9c6f? (p200300EA8F2664008C30515FFD0F9C6F.dip0.t-ipconnect.de. [2003:ea:8f26:6400:8c30:515f:fd0f:9c6f])
        by smtp.googlemail.com with ESMTPSA id d4sm8205991wrc.54.2019.10.18.11.31.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Oct 2019 11:31:37 -0700 (PDT)
Subject: Re: [PATCH net-next] r8169: remove support for RTL8100e
To:     David Miller <davem@davemloft.net>
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
References: <002ad7a5-f1ce-37f4-fa22-e8af1ffa2c18@gmail.com>
 <20191017.151159.1692504406678037890.davem@davemloft.net>
 <2b48266a-7fdc-039b-a11d-622da58acf42@gmail.com>
 <20191017.154014.1196156125754339202.davem@davemloft.net>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <80d28162-65fa-eb1a-2042-ae98f8f28260@gmail.com>
Date:   Fri, 18 Oct 2019 20:31:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191017.154014.1196156125754339202.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.10.2019 21:40, David Miller wrote:
> From: Heiner Kallweit <hkallweit1@gmail.com>
> Date: Thu, 17 Oct 2019 21:26:35 +0200
> 
>> To be on the safe side, let me check with Realtek directly.
> 
> That's a great idea, let us know what you find out.
> 
Realtek suggested to keep the two chip definitions.
Supposedly RTL_GIGA_MAC_VER_15 is the same as RTL_GIGA_MAC_VER_12,
and RTL_GIGA_MAC_VER_14 is the same as RTL_GIGA_MAC_VER_11.
So let's keep it as it is.
