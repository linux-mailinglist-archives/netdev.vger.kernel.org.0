Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D8C44B24A
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 19:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241457AbhKISHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 13:07:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241149AbhKISHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 13:07:08 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C0DC061764;
        Tue,  9 Nov 2021 10:04:22 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id t21so22363433plr.6;
        Tue, 09 Nov 2021 10:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PeT5cLUiL6MHK4FPkOiax8dsT/NJjA4TiyxrikVui0U=;
        b=ZPvL/1Sl2S2wwAZprgutj0NzY6JOpVvTIpv3J9QZCCr2WLtzzjcNFfgEbp2lUdQqpZ
         m3j8vIS+fAASyftuBWg0RQPnNObtl9APHubBrwLFehTGhvz5Z9waBmBYGI0UNa/YM7kC
         YxOTw/NPRhMvCpSDRs+MiKrRbRIlxsyLBJl8Iu8Uz4ycrJtL59qQ2svQGb9hk0cyMDwO
         dx7RFzpZphk3KEKyT39dJRCXvwB36DcfoBOPwlgTmgWhndLutwFDC2qv5aejDqEt10s9
         tnXph4QFj6QJUXBDaq4VWpPNMrUxgnI0K1QJN1ejdWA0+TY/F2g0BksSoBb8xZVRIG13
         PP4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PeT5cLUiL6MHK4FPkOiax8dsT/NJjA4TiyxrikVui0U=;
        b=k+ojwyiH9h7ws7W8oUnoc2jjCY7TnkVpYNfDW96I3NRD/LONdtGPGZEl9xFRQWtLEx
         1mLrlaxFb4yhw3EXMRpN4lu8b4yt1kTWEkD//tSHrgyCj5h+wfdZpyq0pW03f9gc7WUh
         1ZJ1YPafUqNPUAeO54OkLoxh2xjPxoE6yjVc1a5cYyfxg3HgAi+n9G1ZaNo2zRVEQvWa
         RJHlDM64wKYbIDCI+ObSOCgMGHYUgGBn8mXuu29AjVMl/DsaAAfuQ5FS/gnSPKtwxnEQ
         sBsDz4kMv6XQH6zUW68Q4YyMNd2gOPihKZmiUPcGmci2YXBhEAUM8mpHccGgTBXF3uER
         bTVg==
X-Gm-Message-State: AOAM533iNFiiEf9+KgW7ZehHQHRsjT0uxwV4wldVSPYOtSbhU0v4q5bW
        DZcnKfL44lKChsB2zyWdBxO0EtlVXi0=
X-Google-Smtp-Source: ABdhPJw02X/e5A9sK0sFEhlBu+UWo3oyq5AeQNpoliTmqKx4V5AZTk84nYNv2G0jqGjUyWtPTMLcOQ==
X-Received: by 2002:a17:90a:ad47:: with SMTP id w7mr9479225pjv.16.1636481061410;
        Tue, 09 Nov 2021 10:04:21 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id co4sm3229462pjb.2.2021.11.09.10.04.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Nov 2021 10:04:20 -0800 (PST)
Subject: Re: [PATCH v2 1/7] net: dsa: b53: Add BroadSync HD register
 definitions
To:     Martin Kaistra <martin.kaistra@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20211109095013.27829-1-martin.kaistra@linutronix.de>
 <20211109095013.27829-2-martin.kaistra@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6839c4e9-123d-227a-630d-fae8a2df6483@gmail.com>
Date:   Tue, 9 Nov 2021 10:04:19 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211109095013.27829-2-martin.kaistra@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/9/21 1:50 AM, Martin Kaistra wrote:
> From: Kurt Kanzenbach <kurt@linutronix.de>
> 
> Add register definitions for the BroadSync HD features of
> BCM53128. These will be used to enable PTP support.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
> ---

[snip]

> +/*************************************************************************
> + * ARL Control Registers
> + *************************************************************************/
> +
> +/* Multiport Control Register (16 bit) */
> +#define B53_MPORT_CTRL			0x0e
> +#define   MPORT_CTRL_DIS_FORWARD	0
> +#define   MPORT_CTRL_CMP_ETYPE		1
> +#define   MPORT_CTRL_CMP_ADDR		2
> +#define   MPORT_CTRL_CMP_ADDR_ETYPE	3
> +#define   MPORT_CTRL_SHIFT(x)		((x) << 1)
> +#define   MPORT_CTRL_MASK		0x2

The mask should be 0x3 since this is a 2-bit wide field.
-- 
Florian
