Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 100FE1090B0
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 16:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbfKYPG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 10:06:59 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37287 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727758AbfKYPG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 10:06:59 -0500
Received: by mail-pl1-f195.google.com with SMTP id bb5so6631069plb.4;
        Mon, 25 Nov 2019 07:06:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=glGDXbGDgHhWZX3MtlLpw45TRQKQ7EMUGSl8ozQC3S0=;
        b=QidhwSitTMeoAuQ8tc0oRXaqJzucf8O9TgmzRhD3qpSzmtxZgUsmZ1MmXbcZFHo1EQ
         hm9/lBPu6swSRXbTkorN2JhNllQ7r+LJ8MmzQqjdVDW/R1gQepDKNvSQ1d3dZ4vsxESH
         OSWoZmN/UsRHdbyDWcW2l2Wl8D5Rp+QNXCU1dvgou8eMXBgHrcLWawghMOTj5CvhbiQi
         ZLhovfuOkg14fTXOpd/KPim3UBMmzWafl9aNhePeVbQWmY2LmsmBPWNPK6y50WcvqNke
         aSMG3+6xGondb7vb/CNnIaXF9vSAbcQJnSS3esC4liV4vFlnjtjv8EecdBpnNHVYO8Xg
         E4ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:cc:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=glGDXbGDgHhWZX3MtlLpw45TRQKQ7EMUGSl8ozQC3S0=;
        b=ByWGtNK90u3Me6GH2uPqzheZf/X3IjhLUHnyfxZ5mKIMbdAPZHpcEooM9ZQYzunk9H
         HDlVEBPflWN6TZowyNFKfeUdQo4NDjDA/w/TmtreIJsWUWkMogChtfDdNKWa2FbMRVBt
         KmHceKgsw8JSUp5Xr/6rPbLxGHttG/3uDPf3GEiFuPTftfv3rsnRjE46xxwjy1bgA2wA
         f52N2vN7ehSOoeaLhWB3JHmh2ZniEBIsIuRTaKSX6NqTUdP1fX96AP1KKyzHfrGZaJeB
         fveb6OuTtQb4yWYdUcnnUioBzif5RHxhqYEFhqTB7WrEexScYQb2AEsQrdLBdq6XPljM
         EeMQ==
X-Gm-Message-State: APjAAAWFjCrb0M9jGyrQ+e3jRin70a0CcjqMpq0Clgo7MxMJw1dcMJw6
        QDyJtvsORficA9u26TCDI2iOS5tOGhU=
X-Google-Smtp-Source: APXvYqx5jR4poQirNWpRJvpZfL50FjIGfDVsw/0N/24MfivZzYxS0Xl4PrvMfdSoN0jb6nQa81ADCw==
X-Received: by 2002:a17:90a:eb0f:: with SMTP id j15mr39985938pjz.97.1574694417718;
        Mon, 25 Nov 2019 07:06:57 -0800 (PST)
Received: from ?IPv6:2405:4800:58f7:550c:6dad:1b5f:afc6:7758? ([2405:4800:58f7:550c:6dad:1b5f:afc6:7758])
        by smtp.gmail.com with ESMTPSA id x192sm9114889pfd.96.2019.11.25.07.06.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2019 07:06:56 -0800 (PST)
Cc:     tranmanphong@gmail.com, davem@davemloft.net, keescook@chromium.org,
        kvalo@codeaurora.org, saeedm@mellanox.com,
        jeffrey.t.kirsher@intel.com, luciano.coelho@intel.com,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Fix -Wcast-function-type net drivers
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
References: <20191124094306.21297-1-tranmanphong@gmail.com>
 <20191124143919.63711421@cakuba.netronome.com>
From:   Phong Tran <tranmanphong@gmail.com>
Message-ID: <252466a8-2cad-7e4a-2a87-ade95365fa75@gmail.com>
Date:   Mon, 25 Nov 2019 22:06:49 +0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191124143919.63711421@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/25/19 5:39 AM, Jakub Kicinski wrote:
> On Sun, 24 Nov 2019 16:43:01 +0700, Phong Tran wrote:
>> This series is for fixing the compiler warning while enable
>> -Wcast-function-type.
>>
>> Almost is incompatible callback prototype in using tasklet.
>> The void (*func)(unsigned long) instead of void (*func)(struct foo*).
>>
>> Reported by: https://github.com/KSPP/linux/issues/20
> 
> Hi Tran, thanks for the patches. Could you split the series into two -
> the wireless changes and the USB changes?
> 
> Those usually go via slightly different trees.
> 

Sent in different series:

[wireless]
https://lore.kernel.org/lkml/20191125150215.29263-1-tranmanphong@gmail.com/

[USB]
https://lore.kernel.org/linux-usb/20191125145443.29052-1-tranmanphong@gmail.com/

Regards,
Phong.
