Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3FC3172C
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 00:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfEaWZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 18:25:58 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:50209 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbfEaWZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 18:25:57 -0400
Received: by mail-it1-f195.google.com with SMTP id a186so18374398itg.0
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 15:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jNO29A3eBJvwf2Vu9Oyg5E4jjTlIZetGj3NF5CjfGMc=;
        b=Hlmnc+h5861mci94IXNOb1Pm2K/0ArQ3l0KACnywjZOwv3P1ECcqa+VZ+zoiXhrRyS
         91dnqz/NNnw7ufWxstEtybtxLBrHrKA/qei/0QaNIh1IkhzJieUH47QlzmN284PWCGCY
         jBB2Kjbb4wm8ZhY0Id2+ri0jTqSC8oFOMEcSb8HPhHhPSyzRNIqNbWWQdVXlEkx5Kmt5
         nfaKo/Pjvo5vRWZzmGTWg/0xjYkxDVKxCASO7ynAFxG/yE//lxPCl3OwMSB5dAZSVR81
         YEKWnHi8tnyQec0gqdbuW4E0tHdQ+NkDo/eO0Ex4cHfU8SiCnN3IA0lXzzIqlU3lWNLr
         /5gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jNO29A3eBJvwf2Vu9Oyg5E4jjTlIZetGj3NF5CjfGMc=;
        b=geJJesax52zdLhgIIW++cNdi8WHRHd+OlWbziefzGGPO4+5kaf2LZDVMLiMKX5N2wh
         YTGXk+e4Nn9mlmBJKjopl6QhD3sntLxiSjKhaieLD3BBiUsiZzimgKXPFigiIMQYgFiS
         SutsLSDbuWXMDBETerGzOwUwH/a/bydtp3wn114pliHOwdWypBvQmIIsQ62GzfMPR0Nm
         cfjrax7r7mCLSZJExAhpKyz3XJ00VIQ+wWzUm8MPC6tvIE2eqAkVa25nhWJ5X+V2jZZa
         kdGPkjWwsIGJMVX8FenWanbkM++bMxf+SLZFX40yh9JalndKTP8jUMeZkwVyrT+c9P5s
         Oo2g==
X-Gm-Message-State: APjAAAVFpnU8QrgD9Uz7fWHSWJ72cHiovZqTGZcdeEtQeycW0vYRKtPD
        2LbuwvBwmYtNm0FIooWgmWHn8w==
X-Google-Smtp-Source: APXvYqxn/8sjKyKDB1q/z3xyIFqbE0YwBOLGF5GhVsgmlK6s3ApK9hMQ4eWtlgBcJSrXjR9IMGygzA==
X-Received: by 2002:a24:16c6:: with SMTP id a189mr8499974ita.179.1559341556857;
        Fri, 31 May 2019 15:25:56 -0700 (PDT)
Received: from [172.22.22.26] (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.googlemail.com with ESMTPSA id 194sm3015704itm.40.2019.05.31.15.25.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 15:25:56 -0700 (PDT)
Subject: Re: [PATCH v2 03/17] soc: qcom: ipa: main code
To:     David Miller <davem@davemloft.net>
Cc:     arnd@arndb.de, bjorn.andersson@linaro.org,
        ilias.apalodimas@linaro.org, evgreen@chromium.org,
        benchan@google.com, ejcaruso@google.com, cpratapa@codeaurora.org,
        syadagir@codeaurora.org, subashab@codeaurora.org,
        abhishek.esse@gmail.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
References: <20190531035348.7194-1-elder@linaro.org>
 <20190531035348.7194-4-elder@linaro.org>
 <20190531.145005.798440469894507477.davem@davemloft.net>
From:   Alex Elder <elder@linaro.org>
Message-ID: <8295f702-2c3f-1fa3-0a4e-ebb51d5b03ee@linaro.org>
Date:   Fri, 31 May 2019 17:25:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190531.145005.798440469894507477.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/31/19 4:50 PM, David Miller wrote:
> From: Alex Elder <elder@linaro.org>
> Date: Thu, 30 May 2019 22:53:34 -0500
> 
>> +	void *route_virt;
>  ...
>> +	void *filter_virt;
>  ...
> 
> If these are arrays of u64's, please declare them as "u64 *" instead of
> the opaque "void *".

Good idea.  I hadn't paid attention to that.  These tables are
arrays of 64-bit addresses so it's better to represent them that
way.

Thanks.

					-Alex
