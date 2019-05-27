Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3C72BA9B
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 21:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbfE0TQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 15:16:42 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:47045 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbfE0TQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 15:16:42 -0400
Received: by mail-pl1-f195.google.com with SMTP id r18so7332004pls.13
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 12:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ICr9od/z3tFhCPuoT9r9ZoPEXf8rTUe97+Q9pQhjQ6w=;
        b=eHNNMPtZb5U2788aEKEtonAhAYXCB01EV1+93aJ0xbXrNbxdiGbtR201OkkyjHgX+P
         oB/jC1zZxWkSAAhcSjC49yxx7vOXX5wp+xvAjF6gAG+yH5h8MJVu1YPZDF0RDmbnedRd
         3Qv1C3FVQ7VuRrrozjtfUw4LAHGuazxzp/IFipKnUz53Yl73DEdDe0UKzoy02GfmzF5U
         VEIyB01jJTMgu+IFSTKPLnm5QIShrl5BPazYamwJKTYDly3m2Dz6hbcHjkniBcP0OuL6
         rvBdhM+yMMFGqDcrlRlAl3sYMJnHtaTiHWhn9RfFM4UPdhoF0qmfvlo8tYdQNOwjpix6
         CiCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ICr9od/z3tFhCPuoT9r9ZoPEXf8rTUe97+Q9pQhjQ6w=;
        b=HlxyBQ8ydAM2kXCbl0SZOFz6i2Ks+mvJb+gjwBb2syDDb+xEQdGQ3Epxow4ATYgoQI
         miYLrWxMpPnfYa/US++td1PWP32Fu4Nd/kfIfHmE3f8oaXFne4OR2o6ip/wsehwgFrA8
         pCxDlD673UjwqqyHcX2TegQKlDEJO+D4nGQ+ppKoVpRmhc5sihu61KZ3gRunvPfSbrRq
         908tW0SCAIRSc7emunpfvv3OgrAxjyklIbK3AMDD5XOdQIKSjQ3aPULboeVYENvvzYsa
         7bJ1mxO6+5JKAH7ki2jEtMQWw72zcvgMFXhsisP/jM0PrCXKziW66dQ6ERwRE6FDdFgo
         rnTA==
X-Gm-Message-State: APjAAAXEWqJ2bzkLfICkIVqVFV0GdbAJdzmjdO1vItlqcVpX3YmgLQM8
        kmY+XnJzvusiXO+A8q+x0Yk=
X-Google-Smtp-Source: APXvYqz2a+ILWM+4wLgIwbFVQjScrpkz/PKXBSt8g57Ilp7kiy2DyDOWbLNDXlqRlizwyDBXdaUDrg==
X-Received: by 2002:a17:902:8f84:: with SMTP id z4mr45832874plo.233.1558984601535;
        Mon, 27 May 2019 12:16:41 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id 184sm13022562pfa.48.2019.05.27.12.16.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 12:16:40 -0700 (PDT)
Subject: Re: [PATCH v2 2/4] net: phy: dp83867: increase SGMII autoneg timer
 duration
To:     Max Uvarov <muvarov@gmail.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net
References: <20190527061607.30030-1-muvarov@gmail.com>
 <20190527061607.30030-3-muvarov@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <f11b777a-4d66-b1c5-9d6a-752672a50137@gmail.com>
Date:   Mon, 27 May 2019 12:16:40 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190527061607.30030-3-muvarov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/26/2019 11:16 PM, Max Uvarov wrote:
> After reset SGMII Autoneg timer is set to 2us (bits 6 and 5 are 01).
> That us not enough to finalize autonegatiation on some devices.

s/us/is/

> Increase this timer duration to maximum supported 16ms.



> 
> Signed-off-by: Max Uvarov <muvarov@gmail.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/phy/dp83867.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
> index 75861b8f3b4d..5fafcc091525 100644
> --- a/drivers/net/phy/dp83867.c
> +++ b/drivers/net/phy/dp83867.c
> @@ -295,6 +295,16 @@ static int dp83867_config_init(struct phy_device *phydev)
>  				    DP83867_10M_SGMII_CFG, val);
>  		if (ret)
>  			return ret;
> +
> +		/* After reset SGMII Autoneg timer is set to 2us (bits 6 and 5
> +		 * are 01). That us not enough to finalize autoneg on some

Likewise, same typo was carried over here. With that fixed and Heiner's
suggestions addressed:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
