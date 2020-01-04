Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3F4A13044D
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 21:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgADUGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jan 2020 15:06:47 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33342 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgADUGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jan 2020 15:06:47 -0500
Received: by mail-pf1-f194.google.com with SMTP id z16so25073291pfk.0;
        Sat, 04 Jan 2020 12:06:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r5iWhJ/XxofOoVh5Ayf4EuuLp7gjFaaA/RHvMdC8uzY=;
        b=UERXUXK3e029ndVqB3TiaFgSl6qIqo8Y0eUeNiY2YPiDP+uO2s93A6CN0M1vJuMtgf
         iFeKed//NkZpWUONyCvIm+5itWTTGOmy7xZUk7rNSFS/97fpItzcorghMecICoH28Jbr
         S7aCOy7oGup1ZGBp4uxvCyuhFTQcaIBT66RNeYyGL4KIxkpGfm6paQFY8bF0kJfEABow
         E4uWVZ10HAVH1qvyoujyuJd+vHOUpGWtuRBSyuhml6OIV5DvQ6E+7LbgLS9bCVOHiM4a
         nW5TlcWF3V5KstbN9qm09N73z/2fsZ0dhHavGnPJhDhZvSFHpYrGFQ4U9aE20D4b38+B
         J2LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=r5iWhJ/XxofOoVh5Ayf4EuuLp7gjFaaA/RHvMdC8uzY=;
        b=da386EI7RMsPo38/QX1cqkEq5RAUFt20Gc0Vk25P/dLK3SLuqBz5dZGR9zowVQm9A5
         qUw2Fc3et+/UyYdG7TCrLA9gOfJmaGb60sNeCOpc1aRgNRtCpfi4UjNBDkGFGvZgyseq
         jK0KyedVajK3cSW+N34kmVF5/9NfedLxUckkp90c2nXL7QsksAb+lSZT32mtbxeDOqww
         pgMnEKcSZlmkKWnP3z4DEd9peigyWHWpDiQooSDu46ItATcjn4n1k0J4R7cR/sITnM3l
         BL6b/FRYjUDqiXLTOIUblTzKGCJKrgwtXGBmoB8mEBOv23XL4vYq4WzZ6X0E8ECkWNk7
         tfLA==
X-Gm-Message-State: APjAAAXWzOoLnmmL4W6Etr22nuMuh6nrlrwCCQdymEeZsIc74Hc2WOm9
        fvD3by1eCXlRKrl4JPGwW0RfoYXJ
X-Google-Smtp-Source: APXvYqwjjo5IyhDatXKYVakeqFk37BZuQVb4MiNjDePESEig2TvGYKVdc6jBwTK0zDN3WIGwqlxb4w==
X-Received: by 2002:aa7:968d:: with SMTP id f13mr98765867pfk.67.1578168405514;
        Sat, 04 Jan 2020 12:06:45 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id b19sm56768548pfo.56.2020.01.04.12.06.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Jan 2020 12:06:44 -0800 (PST)
Subject: Re: [PATCH 2/8] net: 8021q: use netdev_info()/netdev_warn()
To:     "Enrico Weigelt, metux IT consult" <info@metux.net>,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc, sven@narfation.org,
        marcel@holtmann.org, johan.hedberg@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        jon.maloy@ericsson.com, ying.xue@windriver.com, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-hyperv@vger.kernel.org, bpf@vger.kernel.org
References: <20200104195131.16577-1-info@metux.net>
 <20200104195131.16577-2-info@metux.net>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <cd748d24-7eef-d3b5-7ed0-07c4a40906aa@gmail.com>
Date:   Sat, 4 Jan 2020 12:06:42 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200104195131.16577-2-info@metux.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/4/2020 11:51 AM, Enrico Weigelt, metux IT consult wrote:
> Use netdev_info() / netdev_warn() instead of pr_info() / pr_warn()
> for more consistent log output.
> 
> Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
> ---
>  net/8021q/vlan.c      | 4 ++--
>  net/8021q/vlan_core.c | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
> index ded7bf7229cf..7f18c8406ff8 100644
> --- a/net/8021q/vlan.c
> +++ b/net/8021q/vlan.c
> @@ -123,7 +123,7 @@ int vlan_check_real_dev(struct net_device *real_dev,
>  	const char *name = real_dev->name;
>  
>  	if (real_dev->features & NETIF_F_VLAN_CHALLENGED) {
> -		pr_info("VLANs not supported on %s\n", name);
> +		netdev_info(real_dev, "VLANs not supported on %s\n", name);

Since we use netdev_info which does internally use net_device::name for
printing, the name argument is now redundant.

>  		NL_SET_ERR_MSG_MOD(extack, "VLANs not supported on device");
>  		return -EOPNOTSUPP;
>  	}
> @@ -376,7 +376,7 @@ static int vlan_device_event(struct notifier_block *unused, unsigned long event,
>  
>  	if ((event == NETDEV_UP) &&
>  	    (dev->features & NETIF_F_HW_VLAN_CTAG_FILTER)) {
> -		pr_info("adding VLAN 0 to HW filter on device %s\n",
> +		netdev_info(dev, "adding VLAN 0 to HW filter on device %s\n",
>  			dev->name);

Likewise.

>  		vlan_vid_add(dev, htons(ETH_P_8021Q), 0);
>  	}
> diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
> index a313165e7a67..bc32b33e0da8 100644
> --- a/net/8021q/vlan_core.c
> +++ b/net/8021q/vlan_core.c
> @@ -360,7 +360,7 @@ static void __vlan_vid_del(struct vlan_info *vlan_info,
>  
>  	err = vlan_kill_rx_filter_info(dev, proto, vid);
>  	if (err)
> -		pr_warn("failed to kill vid %04x/%d for device %s\n",
> +		netdev_warn(dev, "failed to kill vid %04x/%d for device %s\n",
>  			proto, vid, dev->name);

And here as well.
-- 
Florian
