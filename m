Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C216964BABE
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 18:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236105AbiLMRPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 12:15:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236092AbiLMRPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 12:15:41 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A6B23144
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 09:15:40 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id s7so468637plk.5
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 09:15:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LfAsYSYSOG1Oudz+pzQHWze2C7Lhet185j0QZzl4+a0=;
        b=EOfGyDLyhImoSLSSPiO+dSpXOf33S4WMqmYcXK4CgT6526SgaygDIgP/JkyMFaUw1o
         T7Nh3DXoZ7FrU69IP3FaZue4Gl1+TsqAwAq2TLrLMIXVAYP8i8EmrqNKIAK2nRKtLwhO
         2aEwBhFIoWYqxF+jywF3WFwJIPJX4tibzJpTGTZOhRyWVmiBjGRO68VF3Oj1qrx8E90y
         5UmaMEu3nreaarQB+UKMztlrKUS3Gh66F+KYkp7NHTjUydl83vpsVa6V0Qw7jUYMkJB5
         6k3e5JjjLzkRTvgg4qOKmA0O+DCrSUcjOKpwwtDjv3uFkRsLmDjdIc060ncD7BWBAOn4
         O6Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LfAsYSYSOG1Oudz+pzQHWze2C7Lhet185j0QZzl4+a0=;
        b=mgh82mwma+rarh0nl8M4qMxfLBaWIvIgpX4fIpwlF4oYnkMfIUWmw6JzT1i1uUpB1E
         M3SnPDkoWPHwIoS6uVUA1NifPzOZolbwjuRuza0dfKhkmpOLRwsJ3UxXj1SMSgDWt6n1
         M6udsGU8r+fe+xfzWKPKhpfLbbO5vr6gQgvFSq4m/Hx3FJH7C+Wi6J/OjBL7AEMHuWyu
         dGPeRRSTY8F8H4gZFOi59fcYvYkR4B1gJ7vLYVnGCfiOV8ZNhrlHsfwGhePBvjeIalBv
         YfYYE84qCJ7eCU5e2V5apDkCLAwOz2t4XKEwJzzpG2WqHaVisxvbEEHGpbtdndftbid5
         mUAw==
X-Gm-Message-State: ANoB5pnjQuoEq08qSuHu/8anavJXJ+DcTC793rQRJ95ToHy9mUZO4GSc
        /D11BctM8e/7yDAa+HcPoG37b9QLtn8=
X-Google-Smtp-Source: AA0mqf4XBtKW2DXWMpECxZrosZFL26qDKqqgpTwP9sjmMc2kbByxS2e3XPaoH6zK/5+efgKC3tIWQA==
X-Received: by 2002:a17:902:d4d1:b0:189:e7e:784c with SMTP id o17-20020a170902d4d100b001890e7e784cmr31292592plg.21.1670951739418;
        Tue, 13 Dec 2022 09:15:39 -0800 (PST)
Received: from [192.168.0.128] ([98.97.42.38])
        by smtp.googlemail.com with ESMTPSA id o5-20020a170903210500b00188c9c11559sm177172ple.1.2022.12.13.09.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 09:15:39 -0800 (PST)
Message-ID: <8856b29f14de96e1b1cce3ad8b995bc2c3d962a7.camel@gmail.com>
Subject: Re: [PATCH net-next] net: wangxun: Adjust code structure
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org,
        mengyuanlou@net-swift.com
Date:   Tue, 13 Dec 2022 09:15:38 -0800
In-Reply-To: <20221213063543.2408987-1-jiawenwu@trustnetic.com>
References: <20221213063543.2408987-1-jiawenwu@trustnetic.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-12-13 at 14:35 +0800, Jiawen Wu wrote:
> From: Mengyuan Lou <mengyuanlou@net-swift.com>
>=20
> Remove useless structs 'txgbe_hw' and 'ngbe_hw' make the codes clear.
> And move the same codes which sets MAC address between txgbe and ngbe to
> libwx.

As a general rule you want to avoid having patches with "and" in them
describing what it does. If you need to take care of something else you
should split it into a separate patch as it makes it easier to review.

Specifically it might be easier to read these changes if this was split
over 2 to 3 patches, one for the MAC address handling changes, one for
the removal of the two structures, and maybe one more for the move of
the defines into the _type.h files.

>=20
> Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
> ---
>  drivers/net/ethernet/wangxun/libwx/wx_hw.c    | 123 ++++++++++++-
>  drivers/net/ethernet/wangxun/libwx/wx_hw.h    |   5 +-
>  drivers/net/ethernet/wangxun/libwx/wx_type.h  |  12 ++
>  drivers/net/ethernet/wangxun/ngbe/ngbe.h      |  79 --------
>  drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c   |  21 +--
>  drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h   |   4 +-
>  drivers/net/ethernet/wangxun/ngbe/ngbe_main.c | 127 ++++---------
>  drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |  59 +++++-
>  drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  43 -----
>  drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c |  36 ++--
>  drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |   6 +-
>  .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 174 +++---------------
>  .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  22 ++-
>  13 files changed, 305 insertions(+), 406 deletions(-)
>  delete mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe.h
>  delete mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe.h
>=20
> diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/eth=
ernet/wangxun/libwx/wx_hw.c
> index c57dc3238b3f..205620a1c13b 100644
> --- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
> +++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
> @@ -2,6 +2,7 @@
>  /* Copyright (c) 2015 - 2022 Beijing WangXun Technology Co., Ltd. */
> =20
>  #include <linux/etherdevice.h>
> +#include <linux/netdevice.h>
>  #include <linux/if_ether.h>
>  #include <linux/iopoll.h>
>  #include <linux/pci.h>
> @@ -536,8 +537,8 @@ EXPORT_SYMBOL(wx_get_mac_addr);
>   *
>   *  Puts an ethernet address into a receive address register.
>   **/
> -int wx_set_rar(struct wx_hw *wxhw, u32 index, u8 *addr, u64 pools,
> -	       u32 enable_addr)
> +static int wx_set_rar(struct wx_hw *wxhw, u32 index, u8 *addr, u64 pools=
,
> +		      u32 enable_addr)
>  {
>  	u32 rar_entries =3D wxhw->mac.num_rar_entries;
>  	u32 rar_low, rar_high;
> @@ -581,7 +582,6 @@ int wx_set_rar(struct wx_hw *wxhw, u32 index, u8 *add=
r, u64 pools,
> =20
>  	return 0;
>  }
> -EXPORT_SYMBOL(wx_set_rar);
> =20
>  /**
>   *  wx_clear_rar - Remove Rx address register
> @@ -590,7 +590,7 @@ EXPORT_SYMBOL(wx_set_rar);
>   *
>   *  Clears an ethernet address from a receive address register.
>   **/
> -int wx_clear_rar(struct wx_hw *wxhw, u32 index)
> +static int wx_clear_rar(struct wx_hw *wxhw, u32 index)
>  {
>  	u32 rar_entries =3D wxhw->mac.num_rar_entries;
> =20
> @@ -618,7 +618,6 @@ int wx_clear_rar(struct wx_hw *wxhw, u32 index)
> =20
>  	return 0;
>  }
> -EXPORT_SYMBOL(wx_clear_rar);
> =20
>  /**
>   *  wx_clear_vmdq - Disassociate a VMDq pool index from a rx address
> @@ -722,6 +721,112 @@ void wx_init_rx_addrs(struct wx_hw *wxhw)
>  }
>  EXPORT_SYMBOL(wx_init_rx_addrs);
> =20
> +static void wx_sync_mac_table(struct wx_hw *wxhw)
> +{
> +	int i;
> +
> +	for (i =3D 0; i < wxhw->mac.num_rar_entries; i++) {
> +		if (wxhw->mac_table[i].state & WX_MAC_STATE_MODIFIED) {
> +			if (wxhw->mac_table[i].state & WX_MAC_STATE_IN_USE) {
> +				wx_set_rar(wxhw, i,
> +					   wxhw->mac_table[i].addr,
> +					   wxhw->mac_table[i].pools,
> +					   WX_PSR_MAC_SWC_AD_H_AV);
> +			} else {
> +				wx_clear_rar(wxhw, i);
> +			}
> +			wxhw->mac_table[i].state &=3D ~(WX_MAC_STATE_MODIFIED);
> +		}
> +	}
> +}
> +
> +/* this function destroys the first RAR entry */
> +void wx_mac_set_default_filter(struct wx_hw *wxhw, u8 *addr)
> +{
> +	memcpy(&wxhw->mac_table[0].addr, addr, ETH_ALEN);
> +	wxhw->mac_table[0].pools =3D 1ULL;
> +	wxhw->mac_table[0].state =3D (WX_MAC_STATE_DEFAULT | WX_MAC_STATE_IN_US=
E);
> +	wx_set_rar(wxhw, 0, wxhw->mac_table[0].addr,
> +		   wxhw->mac_table[0].pools,
> +		   WX_PSR_MAC_SWC_AD_H_AV);
> +}
> +EXPORT_SYMBOL(wx_mac_set_default_filter);
> +
> +void wx_flush_sw_mac_table(struct wx_hw *wxhw)
> +{
> +	u32 i;
> +
> +	for (i =3D 0; i < wxhw->mac.num_rar_entries; i++) {
> +		wxhw->mac_table[i].state |=3D WX_MAC_STATE_MODIFIED;
> +		wxhw->mac_table[i].state &=3D ~WX_MAC_STATE_IN_USE;
> +		memset(wxhw->mac_table[i].addr, 0, ETH_ALEN);
> +		wxhw->mac_table[i].pools =3D 0;
> +	}
> +	wx_sync_mac_table(wxhw);
> +}
> +EXPORT_SYMBOL(wx_flush_sw_mac_table);

Rather than flushing all of the entries it might make more sense to
only set the STATE_MODIFIED bit for the "IN_USE" entries.

> +
> +static int wx_del_mac_filter(struct wx_hw *wxhw, u8 *addr, u16 pool)
> +{
> +	u32 i;
> +
> +	if (is_zero_ether_addr(addr))
> +		return -EINVAL;
> +
> +	/* search table for addr, if found, set to 0 and sync */
> +	for (i =3D 0; i < wxhw->mac.num_rar_entries; i++) {
> +		if (ether_addr_equal(addr, wxhw->mac_table[i].addr)) {
> +			if (wxhw->mac_table[i].pools & (1ULL << pool)) {
> +				wxhw->mac_table[i].state |=3D WX_MAC_STATE_MODIFIED;
> +				wxhw->mac_table[i].state &=3D ~WX_MAC_STATE_IN_USE;
> +				wxhw->mac_table[i].pools &=3D ~(1ULL << pool);
> +				wx_sync_mac_table(wxhw);
> +			}
> +			return 0;
> +		}
> +
> +		if (wxhw->mac_table[i].pools !=3D (1 << pool))
> +			continue;
> +		if (!ether_addr_equal(addr, wxhw->mac_table[i].addr))
> +			continue;
> +
> +		wxhw->mac_table[i].state |=3D WX_MAC_STATE_MODIFIED;
> +		wxhw->mac_table[i].state &=3D ~WX_MAC_STATE_IN_USE;
> +		memset(wxhw->mac_table[i].addr, 0, ETH_ALEN);
> +		wxhw->mac_table[i].pools =3D 0;
> +		wx_sync_mac_table(wxhw);
> +		return 0;
> +	}
> +	return -ENOMEM;
> +}
> +

This function doesn't look right. Aren't the block in the if statement
and the block after the two ifs the same? Seems like this would be an
unreachable code block since if the adresses were equal they would hit
the return 0 in the first if block and never be able to hit the second
one.

> +/**
> + * wx_set_mac - Change the Ethernet Address of the NIC
> + * @netdev: network interface device structure
> + * @p: pointer to an address structure
> + *
> + * Returns 0 on success, negative on failure
> + **/
> +int wx_set_mac(struct net_device *netdev, void *p)
> +{
> +	struct wx_hw *wxhw =3D container_of(&netdev, struct wx_hw, netdev);
> +	struct sockaddr *addr =3D p;
> +	int retval;
> +
> +	retval =3D eth_prepare_mac_addr_change(netdev, addr);
> +	if (retval)
> +		return retval;
> +
> +	wx_del_mac_filter(wxhw, wxhw->mac.addr, 0);
> +	eth_hw_addr_set(netdev, addr->sa_data);
> +	memcpy(wxhw->mac.addr, addr->sa_data, netdev->addr_len);
> +
> +	wx_mac_set_default_filter(wxhw, wxhw->mac.addr);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(wx_set_mac);
> +
>  void wx_disable_rx(struct wx_hw *wxhw)
>  {
>  	u32 pfdtxgswc;
> @@ -929,6 +1034,14 @@ int wx_sw_init(struct wx_hw *wxhw)
>  		return err;
>  	}
> =20
> +	wxhw->mac_table =3D kcalloc(wxhw->mac.num_rar_entries,
> +				  sizeof(struct wx_mac_addr),
> +				  GFP_KERNEL);
> +	if (!wxhw->mac_table) {
> +		wx_err(wxhw, "mac_table allocation failed\n");
> +		return -ENOMEM;
> +	}
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL(wx_sw_init);
>=20

