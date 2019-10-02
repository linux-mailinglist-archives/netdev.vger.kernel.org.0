Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDE6DC8C3C
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 17:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbfJBPEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 11:04:04 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46860 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbfJBPEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 11:04:04 -0400
Received: by mail-qk1-f194.google.com with SMTP id 201so15289388qkd.13;
        Wed, 02 Oct 2019 08:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0YgKCSNqA5nYGNjRTeycqGI7GCtyOJ+yk2120uQIXdI=;
        b=BCGuu9HZ82nHmp59ERbq/Gcc7M5ZvTYKfW6iMZGoBBqJ/p7c4utOtrAqkrmrjI6k6N
         zhYQY1lvhP9B1XH5hvhoGK/krZ9tUuo+CuVw9SsBoaOqq9jQ2cVjxjFOmVzWT3VnWWuQ
         lMpUp5N67DxKVqLU469BcHOCBSLDhpQdW5VvfnI/5HJs7+A+qCww9BKQRuu79uJDDU3O
         aaSGj6NYTRUvghWQjIzrfMXf+zghsIPL+iIyrpih2O1sKOzxclg1MQKqHS+SEA3oICOW
         K5XFIo6WMmCbTv4xHzxUoMhwT279VbXRowJ+fEcwvLQMUz468M2IP2L+5NTsfM9cnLnG
         hf6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0YgKCSNqA5nYGNjRTeycqGI7GCtyOJ+yk2120uQIXdI=;
        b=lbUQd4N71cv4MZuqA/DXah/V4H2aeyrdGk+zwObau0YqWry1E2ycCIBnIo1MS4hBQ0
         2vGCZlt83yewxdC/lqVni0wiqksr9Xg+3c5AfgatKXkEoYpQVNhTf3gX8u/4EbQjYblj
         VqvE+b1JLY1JhSdCzpBHwwJE4UXlatOFvy0lkhSkNfwQPLCBmBJPMuaKk/T5O4O+PZUF
         5NGL9cDWojGpg9jXuulc8c9+Eot9WuSqpg83c0NIbv/nuYGEcupe84BvKyS4BI/AYihM
         18b0AhzBj24CSQBQCkUNHfbVXGxYok1BlR/99wccUiB9iN5twxTxP9A+3w8KQ5HVjZC/
         vHSg==
X-Gm-Message-State: APjAAAU97ytXojgNFG0d4vpjP2gQO9+Kn+jXPdcTrrjMT6ppjVEojgby
        GtyLt5QEIrsoaJnofqnbiYwdyrl8
X-Google-Smtp-Source: APXvYqznrpmyh7fnGpmg233OC+OzV6lr0vYpRFOJ+08z4W1SN0vJa/LHXU04bFcHKD3ATqI9IlNC5g==
X-Received: by 2002:a37:a213:: with SMTP id l19mr4054262qke.397.1570028642549;
        Wed, 02 Oct 2019 08:04:02 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a3:10e0::3ed7? ([2620:10d:c091:500::6025])
        by smtp.gmail.com with ESMTPSA id q47sm16997077qtq.95.2019.10.02.08.03.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2019 08:03:56 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH v2] rtl8xxxu: add bluetooth co-existence support for
 single antenna
To:     Chris Chiu <chiu@endlessm.com>, kvalo@codeaurora.org,
        davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com
References: <20190911025045.20918-1-chiu@endlessm.com>
Message-ID: <0c049f46-fb15-693e-affe-a84ea759b5d7@gmail.com>
Date:   Wed, 2 Oct 2019 11:03:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20190911025045.20918-1-chiu@endlessm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/10/19 10:50 PM, Chris Chiu wrote:
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
> 
> Signed-off-by: Chris Chiu <chiu@endlessm.com>
> ---
> 
> Notes:
>    v2:
>     - Add helper functions to replace bunch of tdma settings
>     - Reformat some lines to meet kernel coding style
> 
> 
>   .../net/wireless/realtek/rtl8xxxu/rtl8xxxu.h  |  37 +++
>   .../realtek/rtl8xxxu/rtl8xxxu_8723b.c         |   2 -
>   .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 262 +++++++++++++++++-
>   3 files changed, 294 insertions(+), 7 deletions(-)

In general I think it looks good! One nit below:

Sorry I have been traveling for the last three weeks, so just catching up.


> +void rtl8723bu_set_coex_with_type(struct rtl8xxxu_priv *priv, u8 type)
> +{
> +	switch (type) {
> +	case 0:
> +		rtl8xxxu_write32(priv, REG_BT_COEX_TABLE1, 0x55555555);
> +		rtl8xxxu_write32(priv, REG_BT_COEX_TABLE2, 0x55555555);
> +		rtl8xxxu_write32(priv, REG_BT_COEX_TABLE3, 0x00ffffff);
> +		rtl8xxxu_write8(priv, REG_BT_COEX_TABLE4, 0x03);
> +		break;
> +	case 1:
> +	case 3:

The one item here, I would prefer introducing some defined types to 
avoid the hard coded type numbers. It's much easier to read and debug 
when named.

If you shortened the name of the function to rtl8723bu_set_coex() you 
won't have problems with line lengths at the calling point.

Cheers,
Jes
