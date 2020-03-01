Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92837174D05
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 12:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgCALgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 06:36:38 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37575 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgCALgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 06:36:38 -0500
Received: by mail-lf1-f65.google.com with SMTP id j11so2241757lfg.4
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 03:36:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/8HHbT56y06/N1CQ2ArO28lxgfkM21Fuvg5jrhOPedQ=;
        b=ATXgwuZH2VDKS//DmttCnhs4pWquSMQE5U+U+aim54TxSinHVu4DXWERNKW+kkU2wY
         RdgMKj6PdiHxxjpVs/D2qVl4POoCqW0f27aTIF0//7xZemZJxwdPw7N9zVkafZ9OUDpM
         lQ2/JvljzOmblHmX+xEK6cSqaAHL0L8aLWA5PIEX6B3G7/6rF2e4gW5x0hQOxZDKh5A1
         R0j8ppu+szvttqmGmMs+++bXBINUUEQ+DeUnZH7kaWhgE3xouEsqupi/xLy25aXwUBe5
         xtzu+Ew4FZAjTprTDLaqvQ11SuHHpWOu2boOUqHtI2v+7GIIvlGtBscIdxUZ6wT+Fa7c
         ryjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/8HHbT56y06/N1CQ2ArO28lxgfkM21Fuvg5jrhOPedQ=;
        b=KFXwuIPp9XFS6eo3bX5d0R/Vo7QKvFhDaUs/snymlPB5+nUSRkaI/rcZEWV9p9DoEq
         nFWLP0zTdBV8vSuEH3BHAXvCp5qPqOWyfey4Yh49i22LCofNbC9ushrBDOzmtalpqvhf
         uVrfUC1Guxa3MI7eD8vbTcDzgf+pD2z+gIsK+e4VTCnlxZng8lfVHGMa7TakE0/vcCU3
         P/Jg/rCbIp7VKb0uH12VBzvZMSHeXQfKSQINMKhghBW7lTeHJpIBFKpyJG/qoKuilBBO
         8rmy1N5dv5NKYuQBcFl1ahBNvDHIHcLNJDCAM3M8igw4chr0F4eEjsuFcjVNfMfbFy8U
         yAyA==
X-Gm-Message-State: ANhLgQ0BnhmEXoYno9x4t0cy1JQT8Gk8TlTSWlDHph6S8azjwXczBc9Q
        nn6p/mIqCfJdfUZfsTr7/KQVIw==
X-Google-Smtp-Source: ADFU+vsw36imBme+IXC8InTEQHv2zlJFuF8e7t/Zs+Jp5Kp2lmwBkCd+mDS1Fi1ibawRLq27Yj4s5Q==
X-Received: by 2002:a19:750c:: with SMTP id y12mr7494621lfe.109.1583062596740;
        Sun, 01 Mar 2020 03:36:36 -0800 (PST)
Received: from ?IPv6:2a00:1fa0:631:be36:41f9:a0d4:22df:3c65? ([2a00:1fa0:631:be36:41f9:a0d4:22df:3c65])
        by smtp.gmail.com with ESMTPSA id n13sm9700980lji.91.2020.03.01.03.36.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2020 03:36:36 -0800 (PST)
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: phy: mscc: document LOS
 active low property
To:     Antoine Tenart <antoine.tenart@bootlin.com>, davem@davemloft.net,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200227154033.1688498-1-antoine.tenart@bootlin.com>
 <20200227154033.1688498-2-antoine.tenart@bootlin.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <43b3a101-9596-6476-8170-f09276311de7@cogentembedded.com>
Date:   Sun, 1 Mar 2020 14:36:34 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200227154033.1688498-2-antoine.tenart@bootlin.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 27.02.2020 18:40, Antoine Tenart wrote:

> This patch adds a "vsc8584,los-active-low" property to denote when the

    The part before comma is supposed to be a vendor name, no?

> LOS signal connected directly to the PHY is active low.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
[...]

MBR, Sergei
