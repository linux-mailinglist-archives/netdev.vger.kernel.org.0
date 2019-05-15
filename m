Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86A5A1FA42
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 20:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbfEOSzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 14:55:41 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33937 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfEOSzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 14:55:40 -0400
Received: by mail-wm1-f67.google.com with SMTP id j187so5352638wma.1
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 11:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kinRmn6ne3GWS24pAVtXK4Grth8FXipe8qXXnrQRMkw=;
        b=Qm3VdkkPn0Kt4IM4+0azyFSC2y2v9O5QL102B4eUF+G83nDPepfU/yVs+vGgfg1mhX
         mT5T/EXl27pwGOOZcUGOZLWe51REaME3OogOyQ61MQzP4JaueAItx2AIM0NwRNpxcuzx
         H1CS24GkSq6iB7gROX91REbJEpEzKrbuMJOngU6rXw7tcGNioMU8Os3N/VUmrPBYGl01
         IP1BbUr0UlVrCRASb7XhJpGiTjGWeEXhrpWSqoEN+m8H1cT5orT6M1h38poT+JBWebET
         rjN9AnhoWx9MImr7pz5j1mZT8DjzkrQWFTRVh94QNUD/4mrm1Gdm+fuZ5B9BmQGzobHe
         hhPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kinRmn6ne3GWS24pAVtXK4Grth8FXipe8qXXnrQRMkw=;
        b=gG1FDZmhzrSVzMueC9DtHxpMiy67SuUxPRXej1fdZpzOnqYfwduygG/iAlk5zRGA2d
         MqscpdLubwcBdcR9roxKA1rMIS2Br4wehRc4rFqByAqihj+u2c5E1ltW50f2CnOU1guB
         at/7Lk35oskFYetz4k6G0gOMZlFRABrpNJF+K+P75r011Q7hmZ9LLrBJrQSn6uGeYFWi
         yAptgdqnZ5SF3EEUhsahGIC5rJ7rFu/W1fw3ZkEXXD3GFSv9J/tSoJaerPyzHbzGxdWD
         WWoQA3WjCmP6EGvRiefJo64Jj+/Cky6InfixlHRIrdw56DQ2SPt0X0P/GqUL0rFr5RQF
         KgYQ==
X-Gm-Message-State: APjAAAVCrFIKDj7Gj58PPt9vtsQCdZhL3Am1mSAwubbWf1iO0UvEqkqy
        XSx8Yj7qdtgCxjZvF7P32UU=
X-Google-Smtp-Source: APXvYqzdKa5EiQkPpu/Z8MDhQeuw3grha7MXhaH2S7NJNBqvwzr9ZVjGI6CaO4+cdzbLia+a7mbFVw==
X-Received: by 2002:a1c:730c:: with SMTP id d12mr24727697wmb.10.1557946538547;
        Wed, 15 May 2019 11:55:38 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:19b8:f19b:746e:bed2? (p200300EA8BD4570019B8F19B746EBED2.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:19b8:f19b:746e:bed2])
        by smtp.googlemail.com with ESMTPSA id 17sm3340901wrk.91.2019.05.15.11.55.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 11:55:37 -0700 (PDT)
Subject: Re: [PATCH v2] net: phy: aquantia: readd XGMII support for AQR107
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Madalin-cristian Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <VI1PR04MB556702627553CF4C8B65EE9FEC090@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <a7ba6f22-066e-5ab0-c42f-c275db579f32@gmail.com>
 <459eba93-e499-a78b-4318-907748033ccf@gmail.com>
 <20190515184412.GD24455@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <119f4d94-a26b-38b7-0d3e-6c720c2b075f@gmail.com>
Date:   Wed, 15 May 2019 20:55:34 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190515184412.GD24455@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.05.2019 20:44, Andrew Lunn wrote:
> On Wed, May 15, 2019 at 07:25:14PM +0200, Heiner Kallweit wrote:
>> On 15.05.2019 18:19, Florian Fainelli wrote:
>>> On 5/15/19 8:07 AM, Madalin-cristian Bucur wrote:
>>>> XGMII interface mode no longer works on AQR107 after the recent changes,
>>>> adding back support.
>>>>
>>>> Fixes: 570c8a7d5303 ("net: phy: aquantia: check for supported interface modes in config_init")
>>>>
>>>> Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
>>>
>>> Just so you know for future submissions, there is no need for a newline
>>> between your Fixes: and Signed-off-by: tag, it's just a normal tag.
>>>
>>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>>>
>> I checked the datasheet and AQR107 doesn't support XGMII. It supports USXGMII,
>> maybe XGMII is used as workaround because phy_interface_t doesn't cover
>> USXGMII yet. If it makes the board work again, I think using XGMII is fine for
>> now. But we should add USXGMII and the remove this workaround.
> 
> Hi Heiner
> 
> We should add USXGMII anyway. But that is net-next material, if it is
> not the fix we go with.
> 
Right. It's a very small patch, I added it to my tree already.

>     Andrew
> 
Heiner
