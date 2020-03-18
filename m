Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87D88189A45
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 12:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbgCRLJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 07:09:22 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40767 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbgCRLJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 07:09:21 -0400
Received: by mail-wm1-f68.google.com with SMTP id z12so2759547wmf.5;
        Wed, 18 Mar 2020 04:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=kehKErmO/T8CFv0inK9qKIVG6iYwXmTiNKX37K+5Bu8=;
        b=IwYsMLKu/HPVQ6HkCKPH8PCgjFUp0j/w00yQJpqCfX6hXC7lCr7P4r2jlDH37I4mTx
         krbmpPKHeEShlI2JyX/kgDIyKUjb6octmy+RXwAbi5t3Vy3ZV9H6nR6yRDVNQPs9tsxA
         iL7sYHdXzcFQzjfOAgzFFDwgd4IKTYrInGGx4ldqH7MLM+UVd8JMKPFS1Lev+gLYeJ2Y
         5GWebcyOzJ5DnYZXClqz5rytCrolTKBTjUSJX49Shp/Ww06/VAPSQddntQtAfB69fz3v
         wbh+gM/TiAZxUxiotyX91/BXmiyT0+dyHbO/psXYG2knGpyztDmdrG3sYYZWU7n92k+J
         F6Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kehKErmO/T8CFv0inK9qKIVG6iYwXmTiNKX37K+5Bu8=;
        b=HRqYSDIBIjjFcDt82XwaEfyhH9z7FQ4wZgQt8xhrm5XTl7utPRhfW6oQK9lp+Wn9h3
         8zp+0MSZbPee5uYjAOPEL2eTm9VsIwgbjv7DTk7hv6eVa+EfNzefXn2JoTWoJQT/l0lE
         twhNR1YNKnOpNZvZy6EXBD7ltYJrdddHrDED9U3UZ0nHHbXsZnupG2QT87Xww/ZiemB3
         e8QVPhS1X25dIv88lCKC2edhSooiAlc8MwDqYUf433yBCQJVTvfbjOF5YcSKwdVRMehQ
         ecqs6rJB0QTX3ndQaEdtvpln5i1/Akb3hEekvt3LLRLZIfw40YYe08mBV26jJ+/XpffS
         xFfw==
X-Gm-Message-State: ANhLgQ2AGrqzCn/ZR2xRszdq6AEfY8uzFzjkOsc/GvwWi4AVRgy2Xqhu
        BpUfDeKqeUKp3khgYxtKFIzX5kz3
X-Google-Smtp-Source: ADFU+vsGZJDvTBiI6DCmhK26WWpAZi09BXAekjhR8B6zMP9PF/q+O38Ms8oHldq0IwI93goZh6R9lQ==
X-Received: by 2002:a1c:4e14:: with SMTP id g20mr4412919wmh.143.1584529759540;
        Wed, 18 Mar 2020 04:09:19 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:20e9:4ff4:ed4b:ad06? (p200300EA8F29600020E94FF4ED4BAD06.dip0.t-ipconnect.de. [2003:ea:8f29:6000:20e9:4ff4:ed4b:ad06])
        by smtp.googlemail.com with ESMTPSA id t81sm3327012wmb.15.2020.03.18.04.09.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2020 04:09:18 -0700 (PDT)
Subject: Re: [PATCH] r8169: only disable ASPM L1.1 support, instead of
 disabling them all
To:     AceLan Kao <acelan.kao@canonical.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200318014548.14547-1-acelan.kao@canonical.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <78aa4db2-6dec-e23c-03f4-f76577de756f@gmail.com>
Date:   Wed, 18 Mar 2020 12:09:14 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200318014548.14547-1-acelan.kao@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.03.2020 02:45, AceLan Kao wrote:
> The issues which have been seen by enabling ASPM support are from the
> BIOS that enables the ASPM L1.1 support on the device. It leads to some
> strange behaviors when the device enter L1.1 state.
> So, we don't have to disable ASPM support entriely, just disable L1.1
> state, that fixes the issues and also has good power management.
> 

Meanwhile you can use sysfs to re-enable selected ASPM states, see
entries in "link" directory under the PCI device (provided that BIOS
allows OS to control ASPM). This allows users with mobile devices
w/o the ASPM issue to benefit from the ASPM power savings.

There are ~ 50 RTL8168 chip versions, used on different platforms and
dozens of consumer mainboards (with more or less buggy BIOS versions).
This leaves a good chance that some users may face issues with L0s/L1
enabled. And unfortunately the symptoms of ASPM issues haven't always
been obvious, sometimes just the performance was reduced.
Having said that I'd prefer to keep ASPM an opt-in feature.

Heiner

> Signed-off-by: AceLan Kao <acelan.kao@canonical.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index a2168a14794c..b52680e7323b 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -5473,11 +5473,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	if (rc)
>  		return rc;
>  
> -	/* Disable ASPM completely as that cause random device stop working
> -	 * problems as well as full system hangs for some PCIe devices users.
> +	/* r8169 suppots ASPM L0 and L1 well, and doesn't support L1.1,
> +	 * so disable ASPM L1.1 only.
>  	 */
> -	rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S |
> -					  PCIE_LINK_STATE_L1);
> +	rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1_1);
>  	tp->aspm_manageable = !rc;
>  
>  	/* enable device (incl. PCI PM wakeup and hotplug setup) */
> 

