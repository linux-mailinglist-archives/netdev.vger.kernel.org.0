Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 579FC179C24
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 00:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388513AbgCDXJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 18:09:31 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:43186 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388400AbgCDXJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 18:09:31 -0500
Received: by mail-io1-f66.google.com with SMTP id n21so4323403ioo.10
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 15:09:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LO4sFnLO2wiKWhH2CPGBBj7RnEjSWuWu+5bPaWGne3A=;
        b=GRUxsx43gpC2xVKP9oFcjdHOtdsoBEiZVqdYpYccGdnPmwDJ5vaIAUlkJkYEwM2cn9
         4iBt9rhv3B5SnI7cZpBxkf8bnsueotIEG7J6JKz6nkQSN7xuo7MqW2KmYc47CwuDZdqq
         UTfnBjMjiUEv9mQcXNkWTEDhbTK9axnU9qTYw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LO4sFnLO2wiKWhH2CPGBBj7RnEjSWuWu+5bPaWGne3A=;
        b=X3v7tyLaMsXN3Yp4ySsJQJp5V/knuKkC+PPx3/rCBFIfmKzBGWfEf5WSy2xq6d2kUH
         sAq4yG2WY6dk5y2jAVvfpwsK86gOJR/NhYGcxQaTzH40xyZjVPc+WPiIdTqEoAlktczs
         oti+grppxdY5G57WPKgUk8KeU5dS5WOrI/Fiud1opsj1iQf3kxrrli4+zxYFWRThu8vl
         +npKE7HGItOCwlvUbA6scoya2cjyhyxHxkN7bd5YH2Y3iEaniqSJohs8gbwHMamwIedt
         i3j3+6LkkLINUno8W70EuwqebtDKkiQluvJNW5YMb8EgH4RUwoAXV1AdWMicgvj9iTMJ
         NYzA==
X-Gm-Message-State: ANhLgQ3j6PuWKWhPCJhp4hmW6V+zMV5S0wJsQoC4COkxLag0g04/clWY
        DfQDdt89uNfbT2NiRlVsu6Bu9Q==
X-Google-Smtp-Source: ADFU+vtyCpv8ORr2dtmq5bQJdqqW/cgZJGtUiAs4EcPOweiSbguRMZiA3Ga6HVFtBYEgjjU6+sp9Vg==
X-Received: by 2002:a5d:814a:: with SMTP id f10mr3969167ioo.7.1583363370669;
        Wed, 04 Mar 2020 15:09:30 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id s3sm8163040ild.7.2020.03.04.15.09.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2020 15:09:30 -0800 (PST)
Subject: Re: [PATCH 0/4] Kselftest integration into Kernel CI - Part 1
To:     shuah@kernel.org, keescook@chromium.org, luto@amacapital.net,
        wad@chromium.org, daniel@iogearbox.net, kafai@fb.com, yhs@fb.com,
        andriin@fb.com, gregkh@linuxfoundation.org, tglx@linutronix.de
Cc:     khilman@baylibre.com, mpe@ellerman.id.au,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        "skh >> Shuah Khan" <skhan@linuxfoundation.org>
References: <cover.1583358715.git.skhan@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <408294cd-5c54-d8c2-1dce-7224699670fe@linuxfoundation.org>
Date:   Wed, 4 Mar 2020 16:09:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <cover.1583358715.git.skhan@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/4/20 3:13 PM, Shuah Khan wrote:
> This patch series consists of first round of fixes to integrate
> Kselftest into Kernel CI.
> 
> You can find full list of problems in my announcement I sent out
> last week:
> 
> https://lkml.org/lkml/2020/2/27/2221

Here is the lore link:

https://lore.kernel.org/lkml/3b3dc707-7ae7-955b-69fe-b9abe9ae26c5@linuxfoundation.org/

thanks,
-- Shuah
