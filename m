Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0505518BD20
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 17:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbgCSQ4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 12:56:47 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44282 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727146AbgCSQ4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 12:56:46 -0400
Received: by mail-wr1-f66.google.com with SMTP id o12so3474450wrh.11;
        Thu, 19 Mar 2020 09:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PXsgN3Xvx75E/VQrukFl6tODlYoxT2hNR8PsVX7/5OY=;
        b=sE77CzTJxTmivCGzQGQLd5CF6KiYJJged980d0YENUHyqfv+nCgV8rS47734kb94wi
         5m1CueJNQhYwCACdUYAB8Ler6mLzOoXaPhI7aCYD54HcG7SylaustwPpMGGLWXaxCXuI
         DrDXPxHx4OHeiW0Z84AWOZh0hJqeIaDTEZV6OgrO6xdeJavHAfGp77ARow/0V8cDDI6C
         1YVvmvL5Uq3VmcklmVknIlLyvd+Xn4dtipZuRDyNjrVBd+t4Cv166kTSnlNpxcZepsdo
         bRfXTWlXTyirdWXFocLad6ZH8rm+nDS2tIedce0Awo+pNSHPM6krFYGmWZ9a2F8/aewQ
         d4Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PXsgN3Xvx75E/VQrukFl6tODlYoxT2hNR8PsVX7/5OY=;
        b=q3+JwtcPSVujgELZ4GgqAkfj7AK/e3jqLiTU7Fx595gcuklqRFYbFG2mgHHNNun13V
         Gswd9aucknnqm37Qu20ksqza1YDHCahMyf5hVYp/gUSpXWTe/nUX+8GDKaWzULm+uQLl
         wRnOYjog/S8kj9juyOSG7mfyax65S1g0q950yNMBvPXrxKeCmTd929mcf/wQdHVyt32N
         DiNQzBqdBZ6gJMGOG7+taUVLAK8wWU7WpTE6BMLmQ/wiDsiVcPS8ZmsC5RVTfsJLm8is
         oh44H4XVKbl05g5+GMM0V7BBHykCMcD54jtEGTdvt7RyP0vkJnycQwYYbg47wK3M76H3
         38Ug==
X-Gm-Message-State: ANhLgQ3VCU5mWJTsbEd66B7opzN8eyVDNA3GHgbVr4kaRj6ZRIqfiuVv
        vPcYhu6F7M/Zr8XaPHyKewqbVqCZ
X-Google-Smtp-Source: ADFU+vtMYiuF+b7V87BvVUKMQP005WAqWiZY1JuJmE92AqsY+mGJCQ2UQNOW6CmZ5jhYfODmaC5scw==
X-Received: by 2002:adf:ef0b:: with SMTP id e11mr5639053wro.115.1584637004267;
        Thu, 19 Mar 2020 09:56:44 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:f482:8f51:2469:4533? (p200300EA8F296000F4828F5124694533.dip0.t-ipconnect.de. [2003:ea:8f29:6000:f482:8f51:2469:4533])
        by smtp.googlemail.com with ESMTPSA id t9sm4290708wrx.31.2020.03.19.09.56.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2020 09:56:43 -0700 (PDT)
Subject: Re: [PATCH net-next 3/7] net: phy: introduce
 phy_read_mmd_poll_timeout macro
To:     Dejin Zheng <zhengdejin5@gmail.com>, andrew@lunn.ch,
        f.fainelli@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        tglx@linutronix.de, broonie@kernel.org, corbet@lwn.net,
        mchehab+samsung@kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <20200319163910.14733-1-zhengdejin5@gmail.com>
 <20200319163910.14733-4-zhengdejin5@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <c88c0ce1-af42-db67-22bc-92e82bd9efbf@gmail.com>
Date:   Thu, 19 Mar 2020 17:56:39 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200319163910.14733-4-zhengdejin5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.03.2020 17:39, Dejin Zheng wrote:
> it is sometimes necessary to poll a phy register by phy_read_mmd()
> function until its value satisfies some condition. introduce
> phy_read_mmd_poll_timeout() macros that do this.
> 
> Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
> ---
>  include/linux/phy.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 36d9dea04016..a30e9008647f 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -24,6 +24,7 @@
>  #include <linux/mod_devicetable.h>
>  #include <linux/u64_stats_sync.h>
>  #include <linux/irqreturn.h>
> +#include <linux/iopoll.h>
>  
>  #include <linux/atomic.h>
>  
> @@ -784,6 +785,9 @@ static inline int __phy_modify_changed(struct phy_device *phydev, u32 regnum,
>   */
>  int phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum);
>  
> +#define phy_read_mmd_poll_timeout(val, cond, sleep_us, timeout_us, args...) \
> +	read_poll_timeout(phy_read_mmd, val, cond, sleep_us, timeout_us, args)
> +
>  /**
>   * __phy_read_mmd - Convenience function for reading a register
>   * from an MMD on a given PHY.
> 
I'm not fully convinced. Usage of the new macro with its lots of
parameters makes the code quite hard to read. Therefore I'm also
not a big fan of readx_poll_timeout.

Even though I didn't invent it, I prefer the way DECLARE_RTL_COND
is used in the r8169 driver. The resulting code is much better
to read, and in case of a timeout a helpful warning is printed
automatically.
