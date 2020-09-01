Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F29258CB9
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 12:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbgIAK0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 06:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbgIAK0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 06:26:53 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2867C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 03:26:51 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id z22so868393ejl.7
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 03:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=2gWDiEzQoGU9QEnWwrbhy8vPaaMS67Cca7PiSY3GhRY=;
        b=MS9ieHnFEVfjRueMslQMhbKV+uCA5C3HJ+8jZvbYifcZnUQRqCz3FQ8SppDSh5NOWd
         srNtP/zWClp1PAb67ZF5F+9OQzPpDFfkX+mFOi0O1x8Mkek1P5AvRmfYV9yRYu798NZB
         xAVHb7w0YBGsxE+GQbeXWHDUfiBgi4s1tIXC75hxxHVFgAcX7oyecHoy8l5yUcHN7eJr
         y/X/hEl1MKJQHpD3uEoXQZTWmKhR6XAhbXkfbA8ant+CwDNPxDM3aigmA4089sm7grHI
         04lfaFDRPcM9DUD2NKcvfU6dvsBQepacTo9a59JoxVMmtS+bf3K3XXTfxi/88yZE4dlL
         e5Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2gWDiEzQoGU9QEnWwrbhy8vPaaMS67Cca7PiSY3GhRY=;
        b=Nr3w12j7DnH6b+WzjOL525YQgmWVRF7wEARYX/v9kgFRrs9SOTgGUELoOsOON6ZHxC
         mz/TQR4mhBnH+rTQXeLXuRSx/4Wl52dwnG84LlQwZn+tpW2CSzGaj31PHFFrK8RoPJYw
         nfmIBdGVxgRe8kFfYdtMsAdZIDRdta2gCtmF9OJ1OG3Qi0gArIGnnKGmeRXhrS1pSwJi
         q6FwhPvLF9vmUXLD3wcYZOr9Tvf0ASruhUZUTVyM+vY9PaQnMLwF4a54DR6UvyT5iM/q
         U/Q5gcq53G6NbynbeWz8Ki+sZtIld08OLuSoKheo2DnfTBfY2iI1RyoMVU1nuuNE3uCc
         /Y4Q==
X-Gm-Message-State: AOAM531VFJmxsR1ehQxboWl3mSkS7gXrhRhNCTrhFg7/FmzTK7CAPofV
        wWUUTpPc0voTZAzXX/D2YwYaCtzkyZCs6Q==
X-Google-Smtp-Source: ABdhPJzIDAe50KxJRrt5e3F6rN7hB8Vl9oJrizJfrKEyRH+tUXZzGYdG4AypaQxW66yz7hvdY73L1Q==
X-Received: by 2002:a17:906:a00d:: with SMTP id p13mr876058ejy.535.1598956010295;
        Tue, 01 Sep 2020 03:26:50 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:f8ec:6f8e:9bdb:e23a? (p200300ea8f235700f8ec6f8e9bdbe23a.dip0.t-ipconnect.de. [2003:ea:8f23:5700:f8ec:6f8e:9bdb:e23a])
        by smtp.googlemail.com with ESMTPSA id i9sm881748ejo.1.2020.09.01.03.26.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 03:26:49 -0700 (PDT)
Subject: Re: [PATCH] drivers: reduce the param length of the line
To:     tongchen@whu.edu.cn,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <0db51a11-7849-4df3-bb8a-65e3c8fba514@email.android.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <1da6dce4-f37c-723d-ea8d-1ebaccbbc87f@gmail.com>
Date:   Tue, 1 Sep 2020 12:26:42 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <0db51a11-7849-4df3-bb8a-65e3c8fba514@email.android.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.09.2020 10:11, tongchen@whu.edu.cn wrote:
> I run the checkpatch script against the c source, and the following output says it prefers a maximum of 75 chars per-line.
> 
That's wrong. As the name suggests, checkpatch is meant to be used with patches,
not with source files.

> #./scripts/checkpatch.pl drivers/net/ethernet/realtek/r8169_phy_config.c 
> WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
> #1305: 

This refers to line length in commit description, not source file line length.

> void r8169_hw_phy_config(struct rtl8169_private *tp, struct phy_device *phydev, 
> 
> ERROR: Does not appear to be a unified-diff format patch
> 
> total: 1 errors, 1 warnings, 0 lines checked
> 
> NOTE: For some of the reported defects, checkpatch may be able to
>       mechanically convert to the typical style using --fix or --fix-inplace.
> 
> drivers/net/ethernet/realtek/r8169_phy_config.c has style problems, please review.
> 
> NOTE: If any of the errors are false positives, please report
>       them to the maintainer, see CHECKPATCH in MAINTAINERS.
> 
> 2020年9月1日 下午3:57，Heiner Kallweit <hkallweit1@gmail.com>写道：
> 
>     On 01.09.2020 09:52, tongchen@whu.edu.cn wrote:
>     > 1)So the patch title should be written like this?
>     > "net: reduce the param length of the line"
>     >
>     > 2)I have checked the patch with the checkpatch script, no warnings or errors.
>     >
>     > 3)I saw the line length exceeded 75 chars which may look better if was written on a new line (which was what checkpatch suggeted).
> 
>     Max line length is 80 characters, therefore I don't see what should be wrong with the
>     current status. Can you send the checkpatch suggestion you're referring to?
> 
>     > (I'm a newbie to the patch world, know not much and feel like taking your advice sincerely)
>     > 2020年9月1日 下午3:29，Heiner Kallweit <hkallweit1@gmail.com>写道：
>     >
>     >     On 01.09.2020 04:28, Tong Chen wrote:
>     >     > Reduce the param length of the line from 79 chars to 52 chars,
>     >     > which complies with kernel preferences.
>     >
>     >     Apart from formal issues with the patch (missing net/net-next
>     >     annotation, wrong prefix): Did you get a checkpatch warning?
>     >     Or what's the source of your assumed kernel preference?
>     >
>     >     > Signed-off-by: Tong Chen <tongchen@whu.edu.cn>
>     >     > ---
>     >     >  drivers/net/ethernet/realtek/r8169_phy_config.c | 3 ++-
>     >     >  1 file changed, 2 insertions(+), 1 deletion(-)
>     >     >
>     >     > diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c b/drivers/net/ethernet/realtek/r8169_phy_config.c
>     >     > index 913d030d73eb..f4b738cf8ad7 100644
>     >     > --- a/drivers/net/ethernet/realtek/r8169_phy_config.c
>     >     > +++ b/drivers/net/ethernet/realtek/r8169_phy_config.c
>     >     > @@ -1302,7 +1302,8 @@ static void rtl8125b_hw_phy_config(struct rtl8169_private *tp,
>     >     >  rtl8125b_config_eee_phy(phydev);
>     >     >  }
>     >     > 
>     >     > -void r8169_hw_phy_config(struct rtl8169_private *tp, struct phy_device *phydev,
>     >     > +void r8169_hw_phy_config(struct rtl8169_private *tp,
>     >     > + struct phy_device *phydev,
>     >     >  enum mac_version ver)
>     >     >  {
>     >     >  static const rtl_phy_cfg_fct phy_configs[] = {
>     >     >
>     >
>     >
> 
> 

