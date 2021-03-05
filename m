Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65DE732E767
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 12:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhCELsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 06:48:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhCELs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 06:48:27 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F3BC061574;
        Fri,  5 Mar 2021 03:48:26 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id o2so1194960wme.5;
        Fri, 05 Mar 2021 03:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9LTUTXPKPI88WIB53+i/C5RZiHIuMYCI/f5QG8TqUTk=;
        b=tBAIlenDYH32IfKXFpSR8GdTpyb6EUEUrrbv1QzoxowszraJHteDDuptV+NKvEuo5I
         Bmhw1h9fUsXcgtzodLPgQFzId+9f/LejYgw+TIfd6JC0C1PclXgP2CHQHRmrC51waFhf
         TXx/OB4Haaon2KS8WqVBCacr9tMdTiqkB1Lj1bkZcbucYGSSF9virtEjN5zz10xooJWL
         Yv/D41v3MwwMxywrqPkWwE08503tfq0CgMAyiL/uiB2t3rlW5Er3VN/pt1MhsIMTmt3G
         riyuUUwbMWtgQ7rxJlE25yRm4RmfPao12Y0l5E2wJv1Kt1awzvCyl2X/C+mn5TC3NNvW
         NV/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9LTUTXPKPI88WIB53+i/C5RZiHIuMYCI/f5QG8TqUTk=;
        b=Aql1wQNHZNMSV/nZc5awGrMZMZKjCjvdTq3QnYnvAv+5krimEFTaMcmUwXtnkhvX6m
         7L6RFGBGIIMshjrVwGNzz8+fAlkUuJvt4ICwFm20yLynrReJRKRedvbug6pTiv0KoA/2
         cMb1KQbu252iTKHeh4jbRJpmnnLqsvdmg9Oe4ymEYxykFScbETXXqyIs6mGU0sQ1HxUr
         tO4kkjgQSjLneuWXe+/zcDSK4dkZRMZaVoBkUHZlcwvLsIBhIVonqGhemHAAGxsjeZ9M
         FOe4BrRFdx7vLSWLb4kcWHmtBkvaQUEBXJEJHx/ClF33vPx6gSKc6tuAELyxdwUCiXGz
         c6ow==
X-Gm-Message-State: AOAM532RCZrh/p58CmW0w2J4gdUJLpQvq2ESvgWBr/1T+MrxyT2m8H/C
        ktmJG7FoDx6XNci4gWtgpUmkQJMjI14xSQ==
X-Google-Smtp-Source: ABdhPJxA4ZqQLTocwVdHyJz6k/0X7FZ+ATSQ98QdxbQn+daJ9PkilSBQNk3gdQ8pq/NLIcIVujo2HA==
X-Received: by 2002:a7b:cdef:: with SMTP id p15mr8661617wmj.0.1614944905206;
        Fri, 05 Mar 2021 03:48:25 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:bb00:59ea:5fe5:d29c:ae07? (p200300ea8f1fbb0059ea5fe5d29cae07.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:59ea:5fe5:d29c:ae07])
        by smtp.googlemail.com with ESMTPSA id h2sm4556160wrq.81.2021.03.05.03.48.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Mar 2021 03:48:24 -0800 (PST)
Subject: Re: [PATCH net] r8169: fix r8168fp_adjust_ocp_cmd function
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <1394712342-15778-348-Taiwan-albertk@realtek.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <46815c59-9eb0-8324-1ff3-df42cd95fdd3@gmail.com>
Date:   Fri, 5 Mar 2021 12:48:18 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <1394712342-15778-348-Taiwan-albertk@realtek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.03.2021 10:34, Hayes Wang wrote:
> The (0xBAF70000 & 0x00FFF000) << 6 should be (0xf70 << 18).
> 
> Fixes: 561535b0f239 ("r8169: fix OCP access on RTL8117")
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index f704da3f214c..7aad0ba53372 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -767,7 +767,7 @@ static void r8168fp_adjust_ocp_cmd(struct rtl8169_private *tp, u32 *cmd, int typ
>  	if (type == ERIAR_OOB &&
>  	    (tp->mac_version == RTL_GIGA_MAC_VER_52 ||
>  	     tp->mac_version == RTL_GIGA_MAC_VER_53))
> -		*cmd |= 0x7f0 << 18;
> +		*cmd |= 0xf70 << 18;
>  }
>  
>  DECLARE_RTL_COND(rtl_eriar_cond)
> 
Acked-by: Heiner Kallweit <hkallweit1@gmail.com>

