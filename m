Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 355B23ACB4
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 03:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730223AbfFJBc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 21:32:57 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:43147 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729829AbfFJBc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 21:32:56 -0400
Received: by mail-ot1-f66.google.com with SMTP id i8so6829124oth.10
        for <netdev@vger.kernel.org>; Sun, 09 Jun 2019 18:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WCOvYIOEpLPaBdeqqQdQwAdXefsSacXLlyZTFxGz8WM=;
        b=ip9rxCj2Z0Ve5pf6Dz8hRTTELVNjUgD/hVSpOIb97Vv8Ql8xoLR9W+/8Yb4IFKGIWx
         i/hcy49QslbbMGx7A5l355r7TtCYmZirYmy2UW9a7dQZNme02NP71N44dcOvii3Fc/Aq
         IrlwhMVw40iPntAzkleuq5I3Qe8ZLexPVhpagHxIzQJhkvdJif7Uh3aZU1UgeEK0iyXP
         pUWsjLdRZIJwURx322RLosbR19EcyuBj/xas92uYHmbdr42LjWMWdIrEhsjPBrzuOWxE
         wdoyTTszON4GkLZz/z8IPhtU/y7fhBPCigL8aG50CBrquENaUYgHpIEKrog0Xsbp1O8n
         ym3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WCOvYIOEpLPaBdeqqQdQwAdXefsSacXLlyZTFxGz8WM=;
        b=ES5//K0t/2l5SFopT2gn50N6pFfdN2GWxN/qt+RfcM/u5ORSdsbEBX+1aBWAGSkKiP
         GlpSsVqC8nVuqnSVgFoO1SejHO9j1AUsJ1gOuYOsaxgL5wbbK+Q/ZVSHkause8ns7IHV
         Jx30lv2/89BVm+Y9PyEuupt4U0jbaAcH8QdvUt94CXsFeYscwjg3NFvUTsZTKS254UjC
         IIjqvR0YM4/1Wdi7mdbwlRA01LeBFQuLJfmfWd7oI+YWo2w+XPi5Bdy6VHqolN95ctQ2
         PQAPSsoIP6rp4IQWsAhepTsrbwmuVeCl9mCGOl81+aFc4rvIn5SId4HLTRVJjCR654Y1
         KGCA==
X-Gm-Message-State: APjAAAWoDHq+8CdroYPlCjTgSAWlrD2wz0jX7wGoYM5KtpUjWgrNa2bN
        ECQ1ed95/+Jh3rZ716Kv1XZssSnb
X-Google-Smtp-Source: APXvYqyysHyq/4A6gp+fSCOKgcBQrvC80fe1QgYcN/atg5g2N/tR1kqzQ2AeXPESasr8PnAZDtyZ/A==
X-Received: by 2002:a9d:d23:: with SMTP id 32mr19103893oti.174.1560130375748;
        Sun, 09 Jun 2019 18:32:55 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id l65sm3430061oif.20.2019.06.09.18.32.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jun 2019 18:32:54 -0700 (PDT)
Subject: Re: [PATCH net-next 1/1] net: phy: broadcom: Add genphy_suspend and
 genphy_resume for BCM5464
To:     Vladimir Oltean <olteanv@gmail.com>, hkallweit1@gmail.com,
        andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20190608135356.29898-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <66020c50-cbb9-6ce4-c141-9f80ca1bf0c5@gmail.com>
Date:   Sun, 9 Jun 2019 18:32:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190608135356.29898-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/8/2019 6:53 AM, Vladimir Oltean wrote:
> This puts the quad PHY ports in power-down mode when the PHY transitions
> to the PHY_HALTED state.  It is likely that all the other PHYs support
> the BMCR_PDOWN bit, but I only have the BCM5464R to test.

Yes, they should all support that low power mode, but like you, only
have a limited subset to work with.

> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
