Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F29169DD56
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 07:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbfH0FwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 01:52:01 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34874 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbfH0FwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 01:52:01 -0400
Received: by mail-wr1-f65.google.com with SMTP id k2so17456333wrq.2
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 22:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1UJPBQ3+AfL4X75UQGwWLEtLmrwdIAdU9J5HyB0gHD0=;
        b=GAxeyVx/TTH+h1CMiIb27NUDS9bj6VWvBLsnjlELXBDvcEbgQGEsITvKO/BuDBAB1u
         zDlT/hyPLzBDd7rwu3Em4ltdBszvbhm+W43hQ5i1Huf44pNwHCVFe3NsnRxb9As1blsE
         Fbn/63J5Re6Ze2vxsMVaObxBmyYrIc+6Dutk32HOYA0a4Zj8/i/HRpgPy2mAGAFRGY7a
         bpWK5OncAWkKZDHSEjoJP5cvZHJyXIdVbfDqC8+6Px4Eaw4Lz4FOdo76zJaP0Sye2mdi
         6o6/YypsHMGO3iUET/ymRy5n+OhvpA7Kh/sf4DJ6nTgI88Dh199RzmcVHXDpVuhhBjNc
         hS4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1UJPBQ3+AfL4X75UQGwWLEtLmrwdIAdU9J5HyB0gHD0=;
        b=R005FVhv8Pg6waIHpCjA8XvmoI2al/BYrWQ5GFN4Ptmn7RWq4B18IVBxymbRRbJBzx
         UJp04vnjUA3MnqUwQQ1XHC0NumTLecJzR6o2lf58arnb0MPRr+NdNsCADFxJA9xfX7nr
         YjyhsHxpCgokza2pW3s/02479gBoX22YgSH43wZDUhVwcG7XM83qtkf2X+XNgiiKsgQL
         QuNP5+ZjEce9cdR9l7H3VmVU2r42JhUr0DZC1Nr/6UPIPoLDI6J59uPzHOWtKUuyf2KL
         7CFgCPS128eDHHAU96SFP0LGB358NhR6UnlVBEJB5EJUr4m7ej6yBgaoyDDPleF0F+GC
         pfXw==
X-Gm-Message-State: APjAAAUdaqxPdiLfnuuW3dXZPlTDb6Na7DHTTSDDx9hUpvKJF86Z+TmL
        SKTB16TavX0Iz6aZl7mjWpc=
X-Google-Smtp-Source: APXvYqwJLCFhItULqGnwuAFrISkRnHTBdhuxWzs8ThBJpd72weT39KJeCureVPcszDOoVANo2tUv+w==
X-Received: by 2002:adf:ea08:: with SMTP id q8mr27781120wrm.188.1566885118775;
        Mon, 26 Aug 2019 22:51:58 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:f84f:a633:1040:3183? (p200300EA8F047C00F84FA63310403183.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:f84f:a633:1040:3183])
        by smtp.googlemail.com with ESMTPSA id a141sm2698168wmd.0.2019.08.26.22.51.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 22:51:58 -0700 (PDT)
Subject: Re: [RFC PATCH net-next] net: phy: force phy suspend when calling
 phy_stop
To:     Jian Shen <shenjian15@huawei.com>, andrew@lunn.ch,
        f.fainelli@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, forest.zhouchang@huawei.com,
        linuxarm@huawei.com
References: <1566874020-14334-1-git-send-email-shenjian15@huawei.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <fc2a700a-9c24-b96c-df6b-c5414883d89e@gmail.com>
Date:   Tue, 27 Aug 2019 07:51:53 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1566874020-14334-1-git-send-email-shenjian15@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.08.2019 04:47, Jian Shen wrote:
> Some ethernet drivers may call phy_start() and phy_stop() from
> ndo_open and ndo_close() respectively.
> 
> When network cable is unconnected, and operate like below:
> step 1: ifconfig ethX up -> ndo_open -> phy_start ->start
> autoneg, and phy is no link.
> step 2: ifconfig ethX down -> ndo_close -> phy_stop -> just stop
> phy state machine.
> step 3: plugin the network cable, and autoneg complete, then
> LED for link status will be on.
> step 4: ethtool ethX --> see the result of "Link detected" is no.
> 
Step 3 and 4 seem to be unrelated to the actual issue.
With which MAC + PHY driver did you observe this?

> This patch forces phy suspend even phydev->link is off.
> 
> Signed-off-by: Jian Shen <shenjian15@huawei.com>
> ---
>  drivers/net/phy/phy.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index f3adea9..0acd5b4 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -911,8 +911,8 @@ void phy_state_machine(struct work_struct *work)
>  		if (phydev->link) {
>  			phydev->link = 0;
>  			phy_link_down(phydev, true);
> -			do_suspend = true;
>  		}
> +		do_suspend = true;
>  		break;
>  	}
>  
> 
Heiner
