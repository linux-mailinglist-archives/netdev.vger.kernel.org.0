Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D681C61966
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 05:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728603AbfGHDHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 23:07:30 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36071 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbfGHDH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 23:07:29 -0400
Received: by mail-pg1-f196.google.com with SMTP id l21so2890989pgm.3
        for <netdev@vger.kernel.org>; Sun, 07 Jul 2019 20:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TjGQLOFrldNFSpUAc1tx4rXGqhgyUH3PcbufEbj4dJU=;
        b=knkEvp78IczW7/iWmnp+alAriztuUqjN73nqlifgHHJijcj88ybOt4lEmDcudPcEpw
         0pKwAW+QTmOxocjVd9zsnPaCWz5MKOso5Yjf51ycz0HGBa/rwXxrrdX/tW9PdHnjrY4+
         3sb+9KAu9eXyhw2LbdpllUrkPN6nAc2wDa1WGIKcpuYjq23hXz9t1/CEoDqr36gRIhUC
         xeWgINX6vn6n/fXwIWTPQij1FbkJ/EWBo1YjvvQ3DvCke3WkeWZu+Uao0jtQj7de5y7w
         JPdzF7HMVs6F/PXVF23w4+qs0lKzuyLB553vHcNuPGNTch+sJoiLm3q5UAskcxnl6ECN
         etbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TjGQLOFrldNFSpUAc1tx4rXGqhgyUH3PcbufEbj4dJU=;
        b=ntK8BHdcI9ZKI0G5LdrkRh5u+agieU01tFxeYVsNtjfr/oAqH5+AoZeBFdEyZa8WI5
         KJs9W72LwjJzTc9nlImmQDDKq3gqT7GlN4pqL90qGiXFO7rUGWYUxEPyQN6fi0c8HCD8
         LOrUSvTjWkxaSgveTRNpgdmqwCZmM6qv4dJD5gTLou8iYiP47/pEec83upI3OAlfzzYv
         ZGxENQIf8WTz0pSJ3THootWoNS9ehzb/7mzdMcYjD14XFkp8KpRdx/S//LH6khStsh3s
         rgBM8hDvY20nLjpl+LgH67mqzSslT/VXLhqTYT7uNaA30X+7QRsiW58Jswy2qmsalLUW
         yIVw==
X-Gm-Message-State: APjAAAXYCGpXI3aPz/xYdTWtsvkuQdJcRLQfoKywgnOW/c98zaoz2Nzo
        /HoT1749BIgddw4eAU0RZUgopR1j
X-Google-Smtp-Source: APXvYqxb1s8DYSuOl8jVZJg7YOA8Cvqc9XjoKru9/1WUD1mBh2ZauyVRkrnojfZSb1F+OUw6+0WMWw==
X-Received: by 2002:a17:90a:3463:: with SMTP id o90mr22511480pjb.15.1562555249152;
        Sun, 07 Jul 2019 20:07:29 -0700 (PDT)
Received: from [10.230.28.130] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h12sm17401933pje.12.2019.07.07.20.07.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 07 Jul 2019 20:07:28 -0700 (PDT)
Subject: Re: [PATCH] phy: added a PHY_BUSY state into phy_state_machine
To:     "kwangdo.yi" <kwangdo.yi@gmail.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <1562538732-20700-1-git-send-email-kwangdo.yi@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <539888f4-e5be-7ad5-53ce-63dd182708b1@gmail.com>
Date:   Sun, 7 Jul 2019 20:07:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1562538732-20700-1-git-send-email-kwangdo.yi@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Andrew, Heiner (please CC PHY library maintainers).

On 7/7/2019 3:32 PM, kwangdo.yi wrote:
> When mdio driver polling the phy state in the phy_state_machine,
> sometimes it results in -ETIMEDOUT and link is down. But the phy
> is still alive and just didn't meet the polling deadline. 
> Closing the phy link in this case seems too radical. Failing to 
> meet the deadline happens very rarely. When stress test runs for 
> tens of hours with multiple target boards (Xilinx Zynq7000 with
> marvell 88E1512 PHY, Xilinx custom emac IP), it happens. This 
> patch gives another chance to the phy_state_machine when polling 
> timeout happens. Only two consecutive failing the deadline is 
> treated as the real phy halt and close the connection.

How about simply increasing the MDIO polling timeout in the Xilinx EMAC
driver instead? Or if the PHY is where the timeout needs to be
increased, allow the PHY device drivers to advertise min/max timeouts
such that the MDIO bus layer can use that information?

> 
> 
> Signed-off-by: kwangdo.yi <kwangdo.yi@gmail.com>
> ---
>  drivers/net/phy/phy.c | 6 ++++++
>  include/linux/phy.h   | 1 +
>  2 files changed, 7 insertions(+)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index e888542..9e8138b 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -919,7 +919,13 @@ void phy_state_machine(struct work_struct *work)
>  		break;
>  	case PHY_NOLINK:
>  	case PHY_RUNNING:
> +	case PHY_BUSY:
>  		err = phy_check_link_status(phydev);
> +		if (err == -ETIMEDOUT && old_state == PHY_RUNNING) {
> +			phy->state = PHY_BUSY;
> +			err = 0;
> +
> +		}
>  		break;
>  	case PHY_FORCING:
>  		err = genphy_update_link(phydev);
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 6424586..4a49401 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -313,6 +313,7 @@ enum phy_state {
>  	PHY_RUNNING,
>  	PHY_NOLINK,
>  	PHY_FORCING,
> +	PHY_BUSY,
>  };
>  
>  /**
> 

-- 
Florian
