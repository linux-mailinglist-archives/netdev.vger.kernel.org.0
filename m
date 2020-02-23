Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 025FF1697C5
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 14:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgBWN2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 08:28:04 -0500
Received: from mail-wr1-f53.google.com ([209.85.221.53]:44451 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbgBWN2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 08:28:04 -0500
Received: by mail-wr1-f53.google.com with SMTP id m16so7201723wrx.11
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 05:28:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tfORkEmuP2mnkKW+w5LAdnAzyBH5SKQK7G3A3mF5YmY=;
        b=Q8nPdiUBSNZpCxrrjMbu4viSfZ//y1U4XMJNS0q9k5xvPULPK0z7SMRKK9dTfsLNat
         Zj0EAJf7M3x8rTq5itYfptnkJ7wj5iU8xb5FeFfhBrSTKNdEQeizoUJtLeSU5kPVYGFC
         BJR9yyA9WZ035RDIxX9R0eIVDLg5PYEScuZFxGq/5QVhYZUwOnhSn8y7a4ClsX//aMDq
         wWBCSzXxFTy4nqMJDODZbcTM8jaGR3WgIwG+XYxEYCw9s5cVd6RdocewZYYbSCcdb+0T
         bdt7V7LBnmypT2Xf2aiLgvKekCc0p/QpSKEufxYiKMGhXx12Bx9wKv+xlc0l+JCz58xO
         6rdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tfORkEmuP2mnkKW+w5LAdnAzyBH5SKQK7G3A3mF5YmY=;
        b=SrmKtco+N/uv4KOjX0g4cJ1RTinv8LPci8k7UNrWsrzieu5AABk+b2Lt+0I2opt3lk
         u/gOxKzgE3kjUdsQ+MzUMsIFvcaSGud1Wil5O37gctK3sTPMsel3dNsyGmNjtbpqM/dO
         LDN3WtrIMwQo++TgDLt+f/MOmIJetwd4K8XCnd0jFT+3z0sMf+wegApcIS2gVS9JgL1A
         dBuTAVq/yqkZV+iDFJ3rvADEXaimiI3XZMBnPKzdbjpoG9JpfeyKJqaMScUKJI4KJRZm
         0F3ZjCOS42d8Y8jjiqyLkWI3FincHHqJAeuFK/hJDzxE2ki4zO/KRW1mB56QQFGr09bB
         yNHQ==
X-Gm-Message-State: APjAAAXnSCncBsWbxuqBN0+M5sgqInYV678HVh+vH5+dZ4pgU1TLed8r
        q/CJ/B+FcAuCx1eRgwCya7wSKw13
X-Google-Smtp-Source: APXvYqw+Ln8mLrbH9CWXHtPmLX2IfPpJa6an4KftxjkaRc8xiWYHwElWxy5NpVSxGmuxYW0m1QFqZg==
X-Received: by 2002:a5d:526c:: with SMTP id l12mr7990984wrc.117.1582464482194;
        Sun, 23 Feb 2020 05:28:02 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:fc5d:9b63:3d2c:875e? (p200300EA8F296000FC5D9B633D2C875E.dip0.t-ipconnect.de. [2003:ea:8f29:6000:fc5d:9b63:3d2c:875e])
        by smtp.googlemail.com with ESMTPSA id a13sm13695053wrp.93.2020.02.23.05.28.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Feb 2020 05:28:01 -0800 (PST)
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
 <e0c43868-8201-fe46-9e8b-5e38c2611340@gmail.com>
 <badbb4f9-9fd2-3f7b-b7eb-92bd960769d9@gmail.com>
 <d2b5d904-61e1-6c14-f137-d4d5a803dcf6@gmail.com>
 <356588e8-b46a-e0bb-e05b-89af81824dfa@gmail.com>
 <86a87b0e-0a5b-46c7-50f5-5395a0de4a52@gmail.com>
 <11c9c70f-5192-9f02-c622-f6e03db7dfb2@gmail.com>
 <49a18ff2-a156-f2af-fa70-ca9657382a73@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <c390dbe6-da0d-dfb6-a0fa-15ee626bd4ef@gmail.com>
Date:   Sun, 23 Feb 2020 14:27:58 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <49a18ff2-a156-f2af-fa70-ca9657382a73@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.02.2020 14:24, Vincas Dargis wrote:
> 2020-02-21 23:01, Heiner Kallweit rašė:
>> OK, thanks anyway for testing. I forwarded your testing results with Realtek's r8168 driver to Realtek,
>> let's see whether they can identify the root cause of the problem.
> 
> Just a sec.. did I had to apply that single-line patch AND use Realtek's driver (r8168-dkms package in Debian)? I assumed not..?

No, the single-line patch was meant for r8169. So no need to worry.

