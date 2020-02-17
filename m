Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21185161C0B
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 20:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbgBQT7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 14:59:53 -0500
Received: from mail-wr1-f53.google.com ([209.85.221.53]:36349 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727241AbgBQT7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 14:59:53 -0500
Received: by mail-wr1-f53.google.com with SMTP id z3so21273938wru.3
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 11:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OcxB6EcMws5NEzCahUZiVqz0K2MyyClbma0bUE5ftu8=;
        b=anbdQE/u3S6G37iirZtZUECxYeC1pPmBppWg+kyVk6aEHzghAsD+VC9W0B/uR6nWiS
         r6WVwcvRNsV6g2A2ZjnwXHyioW9Wgvh7sqDQnqiflxMIf6HpNtwQHqHiKCBu7zC3nv3O
         XEilRlRmBlsqkYJeRJgCG+un3Z234HM5sc0s9KgATWVmDTs/bdAtyXThCDSKRqVXY2Vi
         nrxeJDz9V8re+3r+xwQWFHs5aLT513RqrZoB6FqQqG4uJbufv5enzMZq3gtwvQERYz2e
         w0mUJ9aDI6F7NfAT2wnpe2jPrFYtMi95qE8A6JB4gtGylGb2MHq2RFzk5RQo/Bj1ecTD
         I5hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OcxB6EcMws5NEzCahUZiVqz0K2MyyClbma0bUE5ftu8=;
        b=Xl9INYy4oLlrsCTqxPEX1Ap2dhwN0OlHZ1o+d/9yHyNd8G0PPQgdEreiI4q0NZkRtn
         4iXzQ4fBiKfJICu2nAbtu7wLiSObSJu/Mpm7BK4IIH23fVhjsZtI53luvJkAkF7dXfnd
         pG1QCD9QRkVQB2Rj2jBuDB9g0DV4SO9chqQIdEJN+USA3GAwbZnVlmBX2Og9DQfbqJJa
         XoUx90NosOY6GzWnTy//MWaizpchsk0yhFBSap0SFjfcxf5HU2eNI5q6aKQcKt5gC3UP
         yeR0e+JhqVzb/bkvXjlRX1JkHKGSLZ7je/yJZbnPVuJvxQRYsZhcAGk5L4Vh1E5mhpFl
         rqNg==
X-Gm-Message-State: APjAAAVf+LlbzGeI8RMel+jWUMO3wejiYwwJIhY/R558QeilcUEsQVpS
        WsRTETaVPd/JRPwcsTf7xNEI55Y5
X-Google-Smtp-Source: APXvYqzWVW0xQ3cQcioc70Bxx87n4QWFDFPUotWOXI6m6sTkNUWVnPHs69tvhKWd8iLYGINOHKzD9g==
X-Received: by 2002:a5d:6144:: with SMTP id y4mr23517748wrt.15.1581969591293;
        Mon, 17 Feb 2020 11:59:51 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:41c6:31a6:d880:888? (p200300EA8F29600041C631A6D8800888.dip0.t-ipconnect.de. [2003:ea:8f29:6000:41c6:31a6:d880:888])
        by smtp.googlemail.com with ESMTPSA id p5sm2398888wrt.79.2020.02.17.11.59.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 11:59:50 -0800 (PST)
Subject: Re: About r8169 regression 5.4
To:     Vincas Dargis <vindrg@gmail.com>,
        Salvatore Bonaccorso <carnil@debian.org>
Cc:     netdev@vger.kernel.org
References: <b46d29d8-faf6-351e-0d9f-a4d4c043a54c@gmail.com>
 <9e865e39-0406-d5e0-5022-9978ef4ec6ac@gmail.com>
 <97b0eb30-7ae2-80e2-6961-f52a8bb26b81@gmail.com>
 <20200215161247.GA179065@eldamar.local>
 <269f588f-78f2-4acf-06d3-eeefaa5d8e0f@gmail.com>
 <3ad8a76d-5da1-eb62-689e-44ea0534907f@gmail.com>
 <74c2d5db-3396-96c4-cbb3-744046c55c46@gmail.com>
 <81548409-2fd3-9645-eeaf-ab8f7789b676@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <e0c43868-8201-fe46-9e8b-5e38c2611340@gmail.com>
Date:   Mon, 17 Feb 2020 20:59:46 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <81548409-2fd3-9645-eeaf-ab8f7789b676@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.02.2020 19:08, Vincas Dargis wrote:
> 2020-02-16 01:27, Heiner Kallweit rašė:
>> One more idea:
>> Commit "r8169: enable HW csum and TSO" enables certain hardware offloading by default.
>> Maybe your chip version has a hw issue with offloading. You could try:
>>
>> 1. Disable TSO
>> ethtool -K <if> tso off
>>
>> 2. If this didn't help, disable all offloading.
>> ethtool -K <if> tx off sg off tso off
>>
> 
> Unmodified 5.4 was running successfully for whole Sunday with `tx off sg off tso off`! Disabling only tso did not help, while disabling all actually avoided the timeout.
> 
Great, thanks a lot for testing! Then the bisecting shouldn't be needed. Since 5.4 these features are enabled by default,
up to 5.3 they are available but have to be enabled explicitly. This should explain the observed behavior.
So it looks like this chip version has a hw issue with tx checksumming. I contacted Realtek to see whether
they are aware of any such hw issue. Depending on their feedback we may have to add a quirk for this chip version
to not enable these features by default.

> I've attached kern.log from boot 'til 5.4 got that timeout (when I did not use these off's).
> 
> About bisecting - I need to figure out how to build linux-image and linux-headers package only, to reduce that almost hour build...

