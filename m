Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C833194D9F
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 00:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbgCZX6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 19:58:02 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50825 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgCZX6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 19:58:02 -0400
Received: by mail-wm1-f67.google.com with SMTP id d198so9740183wmd.0
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 16:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m8XYQnaTarNZQVeFraJd92AjFgRnW69mHSI+l63q6KU=;
        b=IC06vqGFa8KejCLEjOFcob9Ajs8ZY4i8CGvyu6O1dA62aXdjVimFobGalbyig1K9lS
         umPVDHPOa33ySN6H0am/C2ID+BtPUDVPHheMgtQi0BbNt+MDfGwJlw5oE3EOZkM31nsU
         v/aHLb/IaGDn+567X0CxpMlvqfhHIb+YK+QnbVgzqZh/HomzhLOCHsVuxuTXcGIoXn7W
         HrfDRopwDZ3IZ7ueG9CC8eDJU6WwSXSiIhkvLZrps5j/N5RADWysszdp2pEhjmo/Ca5c
         BIp22dh+MvwwKAAxyZjO/j5V+QSafFgcAQ8HDAPKqjrLHlV21Rj6Gs+4E4QmVQxdIxgY
         TEkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m8XYQnaTarNZQVeFraJd92AjFgRnW69mHSI+l63q6KU=;
        b=ak58KJMDmy2hWoqHi+ZEkr8bmbv6lNyeqa45lb6fnZL+YzC2pVdiX+i4hk4qPhfoKu
         rr+s7HuJvYcC0vlKmUUoxg7zemcItFuJwDUUPcuuG8hX0VtORD1DZttRjb2lDC4TBwQp
         djQR1LHgn61s/WYtbs9Wk0slVxwfdSUyAtCXjsWpTLLR1nnfwAxnvByymbXq61L+FKHt
         wGukirEJEBRK11U4Kl0mbneMmwAxNHF7zIXd0tqZUt0JW74+QCuk7grHXfd26/Sj+azV
         ih1LhoVixFcYMKg3pyB+Obt4TkREczUMi8Xm9lLKDvqcCv4dTPFWkPAJ7oIcqX49mL5P
         TnAw==
X-Gm-Message-State: ANhLgQ3EK1nBWGgJtInoeUj87AaRXCTpJQ5985Tdjn3di/JZ6yhD4PxH
        1lXsrnqH4n6Sf5PCvd9cpfd75M5A
X-Google-Smtp-Source: ADFU+vvfwc9DGTXa3q+H0bo7hauU26Jtwx8Xqa0pt5t+4IrlkqP3C/4/EMKFDcAxqiuHDQTF4egadg==
X-Received: by 2002:a5d:5228:: with SMTP id i8mr12050735wra.156.1585267078830;
        Thu, 26 Mar 2020 16:57:58 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:d031:3b7b:1a72:8f94? (p200300EA8F296000D0313B7B1A728F94.dip0.t-ipconnect.de. [2003:ea:8f29:6000:d031:3b7b:1a72:8f94])
        by smtp.googlemail.com with ESMTPSA id e9sm6399208wrw.30.2020.03.26.16.57.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2020 16:57:58 -0700 (PDT)
Subject: Re: [PATCH net-next] net: phy: probe PHY drivers synchronously
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <86582ac9-e600-bdb5-3d2e-d2d99ed544f4@gmail.com>
 <20200326233411.GG3819@lunn.ch>
 <4a71aee8-370b-2a87-d549-a7fba5a5f873@gmail.com>
 <20200326234459.GI3819@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <bbcf7c4c-8226-bfd5-3c97-090884ed50a6@gmail.com>
Date:   Fri, 27 Mar 2020 00:57:54 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200326234459.GI3819@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.03.2020 00:44, Andrew Lunn wrote:
>> Default still is sync probing, except you explicitly request async
>> probing. But I saw some comments that the intention is to promote
>> async probing for more parallelism in boot process. I want to be
>> prepared for the case that the default is changed to async probing.
> 
> Right. So this should be in the commit message. This is the real
> reason you are proposing the change.
> 
OK, I'll add it to the commit message.

>        Andrew
> 
Heiner
