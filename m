Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4EFAF005
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 18:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436930AbfIJQ4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 12:56:44 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40162 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436473AbfIJQ4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 12:56:44 -0400
Received: by mail-pf1-f196.google.com with SMTP id x127so11868917pfb.7
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 09:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lFJbRzCHpigfHH5uKTKzm6rxOlGf6QMdAoPu4TQLuH4=;
        b=uQ8tJtFg/QZ2FGnvDYZ0VN5FUTic6gZviiFpCgBFiHLRJqyJsgC88qKTk3sjtxpUqq
         CzlOpY8/e0k4eQo44+0wUXJBrAMvhrBd5eFBoOWcKHxXcFmoD1nUYcUixUraYyAthktC
         HhJ3j0YqdxHI3SvZYU5O19MQcO6PJ4dDuI+BQ8P/tyAoc9jO9vBqVq1aKUvPN5Ajomxd
         LQqNQui0fcYJQpvrDVGMrfTEQGb6coeQ/ZtEASY87e9rOmlFNWG7pjF2LTQel61xlWVr
         wUiBiJGyCRJO0+IHvXMwtrpgKtTswIZk9pyGKhb8duYSIV2bApDG1V80g6IkRQf4x4z6
         wFgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=lFJbRzCHpigfHH5uKTKzm6rxOlGf6QMdAoPu4TQLuH4=;
        b=a73FEr19IH29Qz0i3CbIFyGgWJjuN0fZfdwp3392HUOmonslKjrRpvLPdLQBFk311+
         8cQi7xI0V2AS/HcxXid5TYjYddzLnWQP3/tZvQ/w/CZwA5xnWlZVZIKyuh9sxuoN8Bjx
         j5sN6ZXVeRw/RpfBkFOxKfh0h9CRi2Qa7mRqjF67uDAqish0+pAmkZL3rJCzbQGJTFV3
         79nwZsPOTn+w/+/CG+LWgy9ExTR8vur5CaGgVY+DPJf9Lo3jxmZwfRW69qjenLU1RoDB
         Qq3+Dn5Xy7IWdENfOW7bwfrNoeiS7y92bIJ4TQwh1DaisaFhgP+MGUj6/zeLVChkfOS2
         Rlug==
X-Gm-Message-State: APjAAAXxEXl4wqBFCeOKfzoqmZRyRF5fXo41Pi/kjbHhXhrQhz2qKwrf
        q2vyoS14SzUJShpwigvzoC0=
X-Google-Smtp-Source: APXvYqw85iBAw9lWodPdO/DWpZB0dwa/OgEn0z3o/c6ZT16ng2fQxYyr1780mVsWSkFrZ4yxqHqBAw==
X-Received: by 2002:aa7:8c42:: with SMTP id e2mr37369747pfd.158.1568134601926;
        Tue, 10 Sep 2019 09:56:41 -0700 (PDT)
Received: from [10.67.49.31] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z4sm15916965pgp.80.2019.09.10.09.56.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Sep 2019 09:56:41 -0700 (PDT)
Subject: Re: [PATCH 1/7] net/dsa: configure autoneg for CPU port
To:     Robert Beckett <bob.beckett@collabora.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20190910154238.9155-1-bob.beckett@collabora.com>
 <20190910154238.9155-2-bob.beckett@collabora.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <133068ef-b5ce-37c7-8cbc-637e8aededb8@gmail.com>
Date:   Tue, 10 Sep 2019 09:56:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190910154238.9155-2-bob.beckett@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/10/19 8:41 AM, Robert Beckett wrote:
> Configure autoneg for phy connected CPU ports.
> This allows us to use autoneg between the CPU port's phy and the link
> partner's phy.
> This enables us to negoatiate pause frame transmission to prioritise
> packet delivery over throughput.

s/autoneg/auto-negotiation/
s/phy/PHY/
s/negoatiate/negotiate/
s/prioritise/prioritize/ (maybe the latter is just my US english
dictionary tripping up)

Also the subject should be net: dsa: Configure auto-negotiation for CPU
port to match previous submissions done to that file.

Fixing up that code path sounds reasonable, but are you not hitting the
PHYLINK code path instead?

> 
> Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
> ---
>  net/dsa/port.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index f071acf2842b..1b6832eac2c5 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -538,10 +538,20 @@ static int dsa_port_setup_phy_of(struct dsa_port *dp, bool enable)
>  		return PTR_ERR(phydev);
>  
>  	if (enable) {
> +		phydev->supported = PHY_GBIT_FEATURES | SUPPORTED_MII |
> +				    SUPPORTED_AUI | SUPPORTED_FIBRE |
> +				    SUPPORTED_BNC | SUPPORTED_Pause |
> +				    SUPPORTED_Asym_Pause;
> +		phydev->advertising = phydev->supported;
> +
>  		err = genphy_config_init(phydev);
>  		if (err < 0)
>  			goto err_put_dev;
>  
> +		err = genphy_config_aneg(phydev);
> +		if (err < 0)
> +			goto err_put_dev;
> +
>  		err = genphy_resume(phydev);
>  		if (err < 0)
>  			goto err_put_dev;
> 


-- 
Florian
