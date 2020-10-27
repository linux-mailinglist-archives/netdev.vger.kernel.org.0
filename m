Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE50D29A243
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 02:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503965AbgJ0Bjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 21:39:43 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39234 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2442707AbgJ0Bjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 21:39:42 -0400
Received: by mail-qt1-f196.google.com with SMTP id i7so7561651qti.6;
        Mon, 26 Oct 2020 18:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ruu54colUF/ilFVC8cdTe3XtbysMvPE0jNSVGMkpx/Q=;
        b=fnPJD1Lj/6EUJMh/Id06hdWbDezrrk8BEmta6rJGQLIdzIJObUzsARJyDNAZfwz+Qe
         fEx+4Ni9LhjkBIGB6bLB+IVP3Ga3mT93rlCeR+H4yu+7OeMHsqlxEt+DX9XZ+l9FGata
         yY6OH6m0sdCso59nopAI8YNSjyRtBtEg6aWBuMoNzY6lJchHC4Z47i+yDmyVD++qNtsQ
         WDYgacFek6KhrcRFdarV+9D0umR1/ecqUQyfvzPDS0yWFBgFUOVVEJ1xGtezrDCnAGwL
         arSdp5HbcK+SMyhGkUv4IG8lYDRpq1XBfpC7Fx+LQGJijPVSEiCSHTns/282qRUPDJU1
         +cxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ruu54colUF/ilFVC8cdTe3XtbysMvPE0jNSVGMkpx/Q=;
        b=U4sUJDjhhknKSYzVKk7bCjOavX6OLjBOwvUrgSeLI9womRkA6/6ThO4svM//AwqAuc
         CVtgA5ucEsdzR3Tfiz30tlwLOViZh0VUZIqiK8ZgftbWmK8kKWWGiX8VnSkUyNtn123+
         f9/ruBiJ29/H47z+hJVAPVk7Ah+hPhJIAFDdEXQMYC3YMirOhcaDF0xKYTEaC6TH+rtR
         5tFYTPnuCBPPHPVs12460uUPli7SDZX17JfFU0zwDqvRaNcGoA64UttXdtaLuoO+8MiW
         KGqaB7QRAV4mKp0doWhlbfTWB28TJzRmFlGYsPtcVmNTPqx0CPxf018jZI8rJGRG7ZXY
         lrmQ==
X-Gm-Message-State: AOAM530g4gNbC02GkM3LFgeFXmUCsSPUTkwKebLicGPP65qFkJQ65K6Y
        YNKrGPE5GBZxdEXCkTEryg8=
X-Google-Smtp-Source: ABdhPJy2pTUwMgpLfk1Ilj24AuR+qO/m5HSJHaEy8c/0kFjMjIoLta/h9qB9IEr21Mv4fxi24Q4zaw==
X-Received: by 2002:ac8:5743:: with SMTP id 3mr21468464qtx.259.1603762781296;
        Mon, 26 Oct 2020 18:39:41 -0700 (PDT)
Received: from ubuntu-m3-large-x86 ([2604:1380:45d1:2600::3])
        by smtp.gmail.com with ESMTPSA id o2sm7758031qkk.121.2020.10.26.18.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 18:39:40 -0700 (PDT)
Date:   Mon, 26 Oct 2020 18:39:39 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tzu-En Huang <tehuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Chin-Yen Lee <timlee@realtek.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH\ net] rtw88: fix fw dump support detection
Message-ID: <20201027013939.GA4042641@ubuntu-m3-large-x86>
References: <20201026212323.3888550-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026212323.3888550-1-arnd@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 10:22:55PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> clang points out a useless check that was recently added:
> 
> drivers/net/wireless/realtek/rtw88/fw.c:1485:21: warning: address of array 'rtwdev->chip->fw_fifo_addr' will always evaluate to 'true' [-Wpointer-bool-conversion]
>         if (!rtwdev->chip->fw_fifo_addr) {
>             ~~~~~~~~~~~~~~~^~~~~~~~~~~~
> 
> Apparently this was meant to check the contents of the array
> rather than the address, so check it accordingly.
> 
> Fixes: 0fbc2f0f34cc ("rtw88: add dump firmware fifo support")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/wireless/realtek/rtw88/fw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
> index 042015bc8055..b2fd87834f23 100644
> --- a/drivers/net/wireless/realtek/rtw88/fw.c
> +++ b/drivers/net/wireless/realtek/rtw88/fw.c
> @@ -1482,7 +1482,7 @@ static bool rtw_fw_dump_check_size(struct rtw_dev *rtwdev,
>  int rtw_fw_dump_fifo(struct rtw_dev *rtwdev, u8 fifo_sel, u32 addr, u32 size,
>  		     u32 *buffer)
>  {
> -	if (!rtwdev->chip->fw_fifo_addr) {
> +	if (!rtwdev->chip->fw_fifo_addr[0]) {
>  		rtw_dbg(rtwdev, RTW_DBG_FW, "chip not support dump fw fifo\n");
>  		return -ENOTSUPP;
>  	}
> -- 
> 2.27.0
> 

Tom sent an identical patch earlier that it does not look like Kalle has
picked up:

https://lore.kernel.org/linux-wireless/20201011155438.15892-1-trix@redhat.com/

Not that it particularly matters which one goes in so regardless:

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
