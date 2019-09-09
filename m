Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F17CFAD7B8
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 13:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403987AbfIILNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 07:13:49 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45525 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731105AbfIILNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 07:13:48 -0400
Received: by mail-wr1-f65.google.com with SMTP id l16so13314261wrv.12;
        Mon, 09 Sep 2019 04:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ygjb5SXYteFXPiQW9m/yhcIGhv1xUnGpTSJCQ9cvk3M=;
        b=HKDAivAZv/hgWNcqBK+JhC70byMpCwjCTqQVhwPoz9htAIpJjBAhsOApLXFli4vRnP
         nbbFCQnUITwVqMQohQq4UiTzfxeTwv+4etkQzuionG/dQYdyPSdgoRIL8uU/MLbBPKPe
         gpfZDNerx75hoZkQZLl5JQ4rA+dkIY7k8yTV38+zH+jEM8qwKCt5HCExpRe7SHGvVrPj
         6zzqHcKMkvvCOxntqjhI08JBnQCvb9QjeZcTIFcbUQK42x2+UDGXfoikZBXf+k3swcGk
         r6ZArVZl1JuV1yEJDRDnro/Uz3I3Uh5IxrBrOG+f77ugCfX60WJuWUngOo13f/FHo+PE
         lx4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ygjb5SXYteFXPiQW9m/yhcIGhv1xUnGpTSJCQ9cvk3M=;
        b=G5rwaVdxA4pooZ22Aw6poe26HkmTNyV56vVnQfUZ2zhbZt+6jm999GLUP+kFdmtf+g
         yOwNmAsLyk/qw8x+SQ6uiBHT26D9S2vveS+s6HKQe6D/zX5qrcbmVnOSy7O82mkwiwYv
         XiMDm3rAmi7C2eGvadAoEYb2ZB9gSPV0r++NLAVKlTjGaeNACvXSKcseN/2A2SWALS/E
         3rJCQL0PYlDHr7sjShVQIVvygWUpOcKkWZ2U2tWznPKVXraVMEvaKB38z6Ceu+vdELsD
         6lGeaysgY6Z3Te4mEoCyvIAUAvpokSOLWnMWVH/BSqqm3ehgzIF9VjcYTlneVSpLFeV9
         Ja1g==
X-Gm-Message-State: APjAAAXQleMLIpA6Tmd4cqg3bK1mSoP/Ps58d4ft+WPrZc1raRQGSULt
        MV0CLgRKyyErp18LgjObu1M=
X-Google-Smtp-Source: APXvYqxxen/gfDLsS8z0uEMTV7YAvq1NpNOZUswAwkI+/wNAFYRp1AjTlweHodJF6XB4Q2L3W0hTOg==
X-Received: by 2002:adf:cc84:: with SMTP id p4mr19079803wrj.201.1568027625115;
        Mon, 09 Sep 2019 04:13:45 -0700 (PDT)
Received: from [172.17.146.10] ([199.201.66.0])
        by smtp.gmail.com with ESMTPSA id q14sm31240813wrc.77.2019.09.09.04.13.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Sep 2019 04:13:44 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH] rtl8xxxu: add bluetooth co-existence support for single
 antenna
To:     Chris Chiu <chiu@endlessm.com>, kvalo@codeaurora.org,
        davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com
References: <20190903053735.85957-1-chiu@endlessm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=Jes.Sorensen@gmail.com; keydata=
 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 WQ==
Message-ID: <f6989b49-4d81-617b-0e8a-b893f942d733@gmail.com>
Date:   Mon, 9 Sep 2019 07:13:43 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190903053735.85957-1-chiu@endlessm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/3/19 1:37 AM, Chris Chiu wrote:
> The RTL8723BU suffers the wifi disconnection problem while bluetooth
> device connected. While wifi is doing tx/rx, the bluetooth will scan
> without results. This is due to the wifi and bluetooth share the same
> single antenna for RF communication and they need to have a mechanism
> to collaborate.
> 
> BT information is provided via the packet sent from co-processor to
> host (C2H). It contains the status of BT but the rtl8723bu_handle_c2h
> dose not really handle it. And there's no bluetooth coexistence
> mechanism to deal with it.
> 
> This commit adds a workqueue to set the tdma configurations and
> coefficient table per the parsed bluetooth link status and given
> wifi connection state. The tdma/coef table comes from the vendor
> driver code of the RTL8192EU and RTL8723BU. However, this commit is
> only for single antenna scenario which RTL8192EU is default dual
> antenna. The rtl8xxxu_parse_rxdesc24 which invokes the handle_c2h
> is only for 8723b and 8192e so the mechanism is expected to work
> on both chips with single antenna. Note RTL8192EU dual antenna is
> not supported.

I am pretty excited to see this! It always bugged me the bluetooth
driver was allowed to be applied breaking the existing wifi driver.

Except for some cosmetic stuff, I am all happy with this.

> Signed-off-by: Chris Chiu <chiu@endlessm.com>
> ---
>  .../net/wireless/realtek/rtl8xxxu/rtl8xxxu.h  |  37 +++
>  .../realtek/rtl8xxxu/rtl8xxxu_8723b.c         |   2 -
>  .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 243 +++++++++++++++++-
>  3 files changed, 275 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> index 582c2a346cec..22e95b11bfbb 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h

> +
> +struct rtl8xxxu_btcoex {
> +	u8      bt_status;
> +	bool	bt_busy;
> +	bool	has_sco;
> +	bool	has_a2dp;
> +	bool    has_hid;
> +	bool    has_pan;
> +	bool	hid_only;
> +	bool	a2dp_only;
> +	bool    c2h_bt_inquiry;
> +};

bool is large, maybe just use flags or u8's for this? Not a big deal though.

> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> index a6f358b9e447..4f72c2d14d44 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c


> +	if (!btcoex->has_a2dp &&
> +	    !btcoex->has_sco &&
> +	    !btcoex->has_pan &&
> +	    btcoex->has_hid)

This should all fit in one line - 80 characters

> +		btcoex->hid_only = true;
> +	else
> +		btcoex->hid_only = false;
> +
> +	if (!btcoex->has_sco &&
> +	    !btcoex->has_pan &&
> +	    !btcoex->has_hid &&
> +	    btcoex->has_a2dp)

Ditto

> +static void rtl8xxxu_c2hcmd_callback(struct work_struct *work)
> +{
> +	struct rtl8xxxu_priv *priv;
> +	struct rtl8723bu_c2h *c2h;
> +	struct ieee80211_vif *vif;
> +	struct device *dev;
> +	struct sk_buff *skb = NULL;
> +	unsigned long flags;
> +	int len;
> +	u8 bt_info = 0;
> +	struct rtl8xxxu_btcoex *btcoex;
> +
> +	priv = container_of(work, struct rtl8xxxu_priv, c2hcmd_work);
> +	vif = priv->vif;
> +	btcoex = &priv->bt_coex;
> +	dev = &priv->udev->dev;
> +
> +	if (priv->rf_paths > 1)
> +		goto out;
> +
> +	while (!skb_queue_empty(&priv->c2hcmd_queue)) {
> +		spin_lock_irqsave(&priv->c2hcmd_lock, flags);
> +		skb = __skb_dequeue(&priv->c2hcmd_queue);
> +		spin_unlock_irqrestore(&priv->c2hcmd_lock, flags);
> +
> +		c2h = (struct rtl8723bu_c2h *)skb->data;
> +		len = skb->len - 2;
> +
> +		switch (c2h->id) {
> +		case C2H_8723B_BT_INFO:
> +			bt_info = c2h->bt_info.bt_info;
> +
> +			rtl8723bu_update_bt_link_info(priv, bt_info);
> +
> +			if (btcoex->c2h_bt_inquiry) {
> +				if (vif && !vif->bss_conf.assoc) {
> +					rtl8723bu_set_ps_tdma(priv, 0x8, 0x0, 0x0, 0x0, 0x0);
> +					rtl8723bu_set_coex_with_type(priv, 0);
> +				} else if (btcoex->has_sco ||
> +					   btcoex->has_hid ||
> +					   btcoex->has_a2dp) {
> +					rtl8723bu_set_ps_tdma(priv, 0x61, 0x35, 0x3, 0x11, 0x11);
> +					rtl8723bu_set_coex_with_type(priv, 4);
> +				} else if (btcoex->has_pan) {
> +					rtl8723bu_set_ps_tdma(priv, 0x61, 0x3f, 0x3, 0x11, 0x11);
> +					rtl8723bu_set_coex_with_type(priv, 4);
> +				} else {
> +					rtl8723bu_set_ps_tdma(priv, 0x8, 0x0, 0x0, 0x0, 0x0);
> +					rtl8723bu_set_coex_with_type(priv, 7);
> +				}
> +
> +				return;
> +			}

Kernel code is 80 characters wide - maybe create a btcoex helper
function for this?

> +
> +			if (vif && vif->bss_conf.assoc) {
> +				u32 val32 = 0;
> +				u32 high_prio_tx = 0, high_prio_rx = 0;
> +
> +				val32 = rtl8xxxu_read32(priv, 0x770);
> +				high_prio_tx = val32 & 0x0000ffff;
> +				high_prio_rx = (val32  & 0xffff0000) >> 16;
> +
> +				if (btcoex->bt_busy) {
> +					if (btcoex->hid_only) {
> +						rtl8723bu_set_ps_tdma(priv, 0x61, 0x20, 0x3, 0x11, 0x11);
> +						rtl8723bu_set_coex_with_type(priv, 5);
> +					} else if (btcoex->a2dp_only) {
> +						rtl8723bu_set_ps_tdma(priv, 0x61, 0x35, 0x3, 0x11, 0x11);
> +						rtl8723bu_set_coex_with_type(priv, 4);
> +					} else if ((btcoex->has_a2dp &&
> +						    btcoex->has_pan) ||
> +						   (btcoex->has_hid &&
> +						    btcoex->has_a2dp &&
> +						    btcoex->has_pan)) {
> +						rtl8723bu_set_ps_tdma(priv, 0x51, 0x21, 0x3, 0x10, 0x10);
> +						rtl8723bu_set_coex_with_type(priv, 4);
> +					} else if (btcoex->has_hid &&
> +						 btcoex->has_a2dp) {
> +						rtl8723bu_set_ps_tdma(priv, 0x51, 0x21, 0x3, 0x10, 0x10);
> +						rtl8723bu_set_coex_with_type(priv, 3);
> +					} else {
> +						rtl8723bu_set_ps_tdma(priv, 0x61, 0x35, 0x3, 0x11, 0x11);
> +						rtl8723bu_set_coex_with_type(priv, 4);
> +					}

Same here

Otherwise, thanks for digging into this, it's really great to see!

Cheers,
Jes

