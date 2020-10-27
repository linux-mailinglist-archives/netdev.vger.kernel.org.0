Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCF229A258
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 02:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504118AbgJ0BtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 21:49:21 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44861 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504107AbgJ0BtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 21:49:20 -0400
Received: by mail-qt1-f195.google.com with SMTP id m65so8278171qte.11;
        Mon, 26 Oct 2020 18:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A+r2NJhCTfNtmf0TnqVFjaFsZaaztFRz19hT+01PSs4=;
        b=obNNBZeOa1nYyAkUq23VDp7mLzwXVkj6czo0Sem2dvjo5VJXqs15+Q384InGaL08iK
         MnNWN6ePK79kDvqZYIv1yBuifkc7wumArS35UP0LBOwPhKraeFs5nv/+QYYyMQD8nC7X
         KYkkoyANGb8jZWTJFW+f0kuBVdedUgjF4PJyR+51w6MraQYZDGqFWpAu8fqQRjGDLt6w
         4ghujqtj1hLIdZKEdjfmKZsoauRq4K5PKnj813CGRRc0e6wwLfSj+FDyvFiFBvsMEz1A
         GFpT/uz2ZyzakWqLE8RzvhjxXzCnSDi+dxNJUfQXIGGlpPjqWFU2cz/zhnPgPGVcUNYL
         5q3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A+r2NJhCTfNtmf0TnqVFjaFsZaaztFRz19hT+01PSs4=;
        b=UkfC4tPoDXJOIYNOHdUr0TrlgHS9ou99IbfDE9NVe7OoYbQ0BpF1KdMVL6Q2LYMXCq
         bm1azW2aNxgyEaKc78GOPaUjnj3uTuf638MIWwUR9tLQiXSsi95PeqFWRanaCpTsUuTI
         Rts+56OP8jU2+OwJCdiSL+ZCiLasYjPvlSb/YuS8yaY2LTbVVXOwb7iLtWK1J1/xc/13
         I2BFQ4yxtAeqB20tgDo4xvGaK2RInU0z7CokNCAHeNcBJGkB+4nMsGiwWVPquPnJXUsc
         MbpGQNfPgDf4r9cjunpQmaWlDAVEBImFliCEcIYFAz0b/Ee305jZ+W+Mfrr1xxBltNMc
         6NPA==
X-Gm-Message-State: AOAM532gV+7oFuGDtNsBPELuLeRMMqwaIx6V7n7AOyd8NZUTN2o1Ft0j
        d4MB7CH1ku+o44LD+O78jlA=
X-Google-Smtp-Source: ABdhPJwfcK25rsDEcFhyo2Ss23tXc5I5vjdNfTNeKltMdpyka+YN+ziOsp0q/qHSqHXpvXmqUTdnFw==
X-Received: by 2002:ac8:718a:: with SMTP id w10mr17913043qto.145.1603763359475;
        Mon, 26 Oct 2020 18:49:19 -0700 (PDT)
Received: from ubuntu-m3-large-x86 ([2604:1380:45d1:2600::3])
        by smtp.gmail.com with ESMTPSA id j25sm7868874qkk.124.2020.10.26.18.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 18:49:18 -0700 (PDT)
Date:   Mon, 26 Oct 2020 18:49:17 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Chris Chiu <chiu@endlessm.com>,
        Zong-Zhe Yang <kevin_yang@realtek.com>,
        Tzu-En Huang <tehuang@realtek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH net-next 07/11] rtw88: remove extraneous 'const' qualifier
Message-ID: <20201027014917.GB368335@ubuntu-m3-large-x86>
References: <20201026213040.3889546-1-arnd@kernel.org>
 <20201026213040.3889546-7-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026213040.3889546-7-arnd@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 10:29:54PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> clang -Wextra warns about functions returning a 'const' integer:
> 
> drivers/net/wireless/realtek/rtw88/rtw8822b.c:90:8: warning: 'const' type qualifier on return type has no effect [-Wignored-qualifiers]
> static const u8 rtw8822b_get_swing_index(struct rtw_dev *rtwdev)
> 
> Remove the extra qualifier here.
> 
> Fixes: c97ee3e0bea2 ("rtw88: add power tracking support")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
>  drivers/net/wireless/realtek/rtw88/rtw8822b.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.c b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
> index 22d0dd640ac9..b420eb914879 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8822b.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
> @@ -87,7 +87,7 @@ static const u32 rtw8822b_txscale_tbl[RTW_TXSCALE_SIZE] = {
>  	0x2d3, 0x2fe, 0x32b, 0x35c, 0x38e, 0x3c4, 0x3fe
>  };
>  
> -static const u8 rtw8822b_get_swing_index(struct rtw_dev *rtwdev)
> +static u8 rtw8822b_get_swing_index(struct rtw_dev *rtwdev)
>  {
>  	u8 i = 0;
>  	u32 swing, table_value;
> -- 
> 2.27.0
> 
