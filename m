Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35A831F95B
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 19:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfEORac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 13:30:32 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37078 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbfEORab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 13:30:31 -0400
Received: by mail-wr1-f66.google.com with SMTP id e15so412244wrs.4
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 10:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ywFTEFDJ4d8F9ck+MFm9E0yBMQ/X3TskODhptxKjJ5Q=;
        b=NuMjXeLFvtW64g4FzVI3OAlY0WbSTaZX1hDxFXCQmyLGSQq/1gcwFWV55YIolF+xlF
         gqyaXZzUpXYFZ49TQYV/R+6b4UsiOYfeSY1d5gALTiSASV1XcMhuOTPl6QW0udrorCgM
         RWG8KC226iE4xfDSE6v5XAG4BKVV6ZLse2pRqfVDFrjK96mYTSTiauoCwgk0v8C10ZAN
         kegieH5w2CUWXPGahRbPBUQK254cn7lfDsGxS12h9Lz8VsTE55hWoQt35VMeqTTu4zFh
         +fl+y3K45XDdCM5CpFmPF6J28aMSjPA4G6zI7cQ5xh0QBJnjZCVSGfhz+L0onN+ZMSiN
         X5NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ywFTEFDJ4d8F9ck+MFm9E0yBMQ/X3TskODhptxKjJ5Q=;
        b=KKFZ4gaB9eELkEV68WLLQvyOHrVY7ioBdmnUo52TbQxgd85PMr4JPHsTD/y/nwRKEO
         5fMZ6mIVerI3tumluMj2AjM5x4ef7xzNkQVDZRVEmBZjcfDWgce2xVYExp6zugsBTfJg
         QoHencG81hiOx42ZC8azY/9xkwg+w1nEkxayYTEfH+2qs8uiXrUmRa26Me9GmG737exR
         2uhyC7WeElQl0OkBzMJyCQMOFZ6wGIK0wbSY7DAv+Qh/vNRM5eoI4jMsPnJGkV5ibhoR
         VuOx1gRMQUeufmOyk1IYD+tSH0nC3TqViTSg+Eie0v3mXQDhmM3/xpbuqfJ8bHlD9qQw
         P9Qw==
X-Gm-Message-State: APjAAAVCDscAFoTiHRrowIUxqgUCXCCbmZnfIMjwOjQl7BOZY9QeUCnE
        You5TEoVj6+jTY7yUwMXBifMFsIaKG0=
X-Google-Smtp-Source: APXvYqwKg03JK/JDeEY07mSqWMXASA1urUmyoniZTX9yk2fDMtf/2jxz7Ln1ZLqCHqN9qZzW6m3orA==
X-Received: by 2002:a5d:688f:: with SMTP id h15mr16375308wru.44.1557941429985;
        Wed, 15 May 2019 10:30:29 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:19b8:f19b:746e:bed2? (p200300EA8BD4570019B8F19B746EBED2.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:19b8:f19b:746e:bed2])
        by smtp.googlemail.com with ESMTPSA id v5sm5357498wra.83.2019.05.15.10.30.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 10:30:29 -0700 (PDT)
Subject: Re: FW: [PATCH] net: phy: aquantia: readd XGMII support for AQR107
To:     Madalin-cristian Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <VI1PR04MB5567F06E7A9B5CC8B2E4854CEC090@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <VI1PR04MB5567FAF88B84E9C77B93A40EEC090@VI1PR04MB5567.eurprd04.prod.outlook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <31722d85-7b01-3516-1b12-bf2be5c9cf71@gmail.com>
Date:   Wed, 15 May 2019 19:30:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <VI1PR04MB5567FAF88B84E9C77B93A40EEC090@VI1PR04MB5567.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.05.2019 10:46, Madalin-cristian Bucur wrote:
> XGMII interface mode no longer works on AQR107 after the recent changes,
> adding back support.
> 
I'd like to check the configuration of the system with the AQR107.
Which board is it, and which DT config is used?

> Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
> ---
>  drivers/net/phy/aquantia_main.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
> index eed4fe3d871f..0fedd28fdb6e 100644
> --- a/drivers/net/phy/aquantia_main.c
> +++ b/drivers/net/phy/aquantia_main.c
> @@ -487,6 +487,7 @@ static int aqr107_config_init(struct phy_device *phydev)
>  	/* Check that the PHY interface type is compatible */
>  	if (phydev->interface != PHY_INTERFACE_MODE_SGMII &&
>  	    phydev->interface != PHY_INTERFACE_MODE_2500BASEX &&
> +	    phydev->interface != PHY_INTERFACE_MODE_XGMII &&
>  	    phydev->interface != PHY_INTERFACE_MODE_10GKR)
>  		return -ENODEV;
>  
> 

