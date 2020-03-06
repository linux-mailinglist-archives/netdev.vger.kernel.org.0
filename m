Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE0C17C309
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 17:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgCFQd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 11:33:59 -0500
Received: from mail-wm1-f44.google.com ([209.85.128.44]:53948 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgCFQd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 11:33:59 -0500
Received: by mail-wm1-f44.google.com with SMTP id g134so3155236wme.3;
        Fri, 06 Mar 2020 08:33:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=q73OcekNycIq1PSkVI7Gx2xIVJb/qda+b0krbcWtz0c=;
        b=ZxZ1f0VhGF21zhOeQYP+c38N2Dni9DdN+6OV3OYQQrhbZazMkyB4aejaNK2OiuQ9+/
         6wlW5n3TvYcphArdozqjsG5Hf0g2lWeGhKE7YHYzQ48pQ2q7HgRzyDevMTHZrsfo2oKP
         18xBJVtiLwtuyWFZD2YmVOiU1rnwczPfw3Wh681/fBS0yta1bqwn4Oorv2aKZpUuxstK
         zbiPc51Ql0es+SCaqeeXr1LzypJzLrCWmnOjoHE5JMWN2hfJRkmllufTFA+lZAtiTB0A
         tZ2kt3PIFxuElVbmZng2TeOD01QwT+0+r46uTcw2RGrv9+zkYZv16Nlp+daE5e2alhGZ
         8sHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q73OcekNycIq1PSkVI7Gx2xIVJb/qda+b0krbcWtz0c=;
        b=BGlgoEeNmMfHWFfLTBJsjI0OoH7JyhNDBbs50IivWTNAAmuXdPulyE6iGmYdIc8pk5
         d3VhiK45K6m9/Osrtv9uxPdfiEGvo3o0aYMvr4w/95lyYa9svHgJFj639wHOUwEvUfi+
         YASBSJVKpMBEpz0rNAVQ8g+CONZDAoVpGH05FvuXeF/dSuigOYW+N+ezKDDHYP9pdJMn
         DmgooJlHEL76K5YMM68ru/eXG9OV/3BU6qeUEziCVswrWoSDzjxC3VL5pX7G7FAX8YtE
         POKC+wqmNNI0xZTuQ6DDd6LUKLkvgosdrTLyhIuLZMmnGlUVSeBDjww6699u1tNohOeq
         x/mA==
X-Gm-Message-State: ANhLgQ09hEosjk4KLI7rQG7ycSmNAg8gpcr67Wk0ttfPAPBJjdX3nqoT
        rU40DSF503PjrjLlB638L2VfyhBw
X-Google-Smtp-Source: ADFU+vu4KkP0kzsX/OVxB6iwLK2yxPg8kBwblZz4he2I+nMMGQWG4Fq+wFr7lfWNw3xOwLXZxEvMoA==
X-Received: by 2002:a7b:c1cf:: with SMTP id a15mr4815228wmj.85.1583512437723;
        Fri, 06 Mar 2020 08:33:57 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:d0bf:bce:c9d1:5027? (p200300EA8F296000D0BF0BCEC9D15027.dip0.t-ipconnect.de. [2003:ea:8f29:6000:d0bf:bce:c9d1:5027])
        by smtp.googlemail.com with ESMTPSA id n1sm3531105wrj.77.2020.03.06.08.33.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2020 08:33:57 -0800 (PST)
Subject: Re: SFP+ support for 8168fp/8117
To:     Hau <hau@realtek.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Anthony Wong <anthony.wong@canonical.com>,
        Jason Yen <jason.yen@canonical.com>
References: <02F7CBDE-B877-481C-A5AF-2F4CBF830A2C@canonical.com>
 <80E9C881-91C8-4F29-B9CE-652F9EE0B018@canonical.com>
 <995bddbc4f9d48cbb3a289a7e9799f15@realtek.com>
 <12EA7285-06D7-44D3-B033-4F52A06123CC@canonical.com>
 <cae39cfbb5174c8884328887cdfb5a89@realtek.com>
 <9AAC75D4-B04F-49CD-BBB9-11AE3382E4D8@canonical.com>
 <5A21808E-C9DA-44BF-952B-4A5077B52E9B@canonical.com>
 <e10eef58d8fc4b67ac2a73784bf86381@realtek.com>
 <20200304152849.GE3553@lunn.ch>
 <1252a766545b48aeafdff9702566565c@realtek.com>
 <20200306155824.GH25183@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <f02b9df7-d57d-d7b6-c0fd-e03e6681dcc8@gmail.com>
Date:   Fri, 6 Mar 2020 17:33:47 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200306155824.GH25183@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.03.2020 16:58, Andrew Lunn wrote:
>> This chip can get fiber info through I2C. It also can detect LOS or control TX Disable via GPIO.
> 
I think the question is whether the chip exposes these signals for kernel use.
- Is there any register to read e.g. LOS status from?
- Is the I2C bus accessed only by chip firmware, or can the OS access the I2C bus somehow?

> O.K. Good
> 
> You should be looking at using phylink to manage the SFP.
> 
>     Andrew
> 

