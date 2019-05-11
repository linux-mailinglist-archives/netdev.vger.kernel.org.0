Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A31171A795
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 12:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbfEKKlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 May 2019 06:41:40 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39894 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbfEKKlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 May 2019 06:41:39 -0400
Received: by mail-wr1-f67.google.com with SMTP id w8so7893859wrl.6;
        Sat, 11 May 2019 03:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dxo37QiebDnia51nBIXSyhvdd7R5v9MF4iXVx2vhVik=;
        b=EdcLPKtnYZSorPFZws0W0CPF7F821AUXHVPp+92cnlCVS0uS6klBTjKGfJwNOxvWaM
         IZwn1/jtPcgRxstd+PF7JKTydUDBUus+HZly3U2RhupDEygZT0PuAu/QOH4rgeeBNO9F
         svnjf11HuaY1246HzVMyHnTgZQAQc1JlzPHxN2Aa4dQaqI54GiqG7RFIU3hMU8K05dSR
         5qPtbIaV/5cikfWlFOxXz77gYebGAdXUeM8Tfy80ftJ52klj2sI51bwCpDSiqqbaKCTv
         Qgh7NN8eMDXPdPpQEsDUEIiQHCpn/fdYP+iVM/DyC1JNFENmFTSp8xQ9fw9WC9eFz75M
         JpmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dxo37QiebDnia51nBIXSyhvdd7R5v9MF4iXVx2vhVik=;
        b=Dj0KHtDbrhqkXtfMLDyrQbrrBdNnHfwoVYcncyCAPE+9hn6TUDD6D/2recTxp+xEsC
         sDLpjW9NtmbMGQ5XF/0LJs5MHCtAlxhfIR09XB0ZFjqteE9DnTsX7bGfVuaNoUdI40bp
         6N5DMlJX8mgXDLfjkPXhijJjnKJJwr56RyaaaPfP+2rRKhInHioCIK9OBBPLJxIgBh/J
         1YbmtqiDr/Ix0kaouuYRLFkkExVEto/IZH3uWIBVjA/JqVrBgPIbCG/44JTWWH7S6rFQ
         yjx5eF84ro4wtm3AtqG7w0ZkVboGvvqL1dKpfGvhAvXoLPEVQCJd69gEhXIYQZBG7Vt3
         gZtg==
X-Gm-Message-State: APjAAAVwQJ1sXVtvwJ9EczJU0ZHFEdEQaagBDjyoncEcl6W2TzTKjESF
        E3YgImaJcKQzK3fB1j1VyOc=
X-Google-Smtp-Source: APXvYqwqeEqNJmtHPVZezZmUT6MtGbi4k3ufZFZ0tezCR4ruOL5pRDJHgIEpEhu5LVlkdUTkIarQAA==
X-Received: by 2002:adf:dc4b:: with SMTP id m11mr11302841wrj.66.1557571297735;
        Sat, 11 May 2019 03:41:37 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:152f:e071:7960:90b9? (p200300EA8BD45700152FE071796090B9.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:152f:e071:7960:90b9])
        by smtp.googlemail.com with ESMTPSA id f7sm6466262wrt.81.2019.05.11.03.41.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 May 2019 03:41:36 -0700 (PDT)
Subject: Re: [PATCH 5/5] net: phy: dp83867: Use unsigned variables to store
 unsigned properties
To:     Trent Piepho <tpiepho@impinj.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <20190510214550.18657-1-tpiepho@impinj.com>
 <20190510214550.18657-5-tpiepho@impinj.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <49c6afc4-6c5b-51c9-74ab-9a6e8c2460a5@gmail.com>
Date:   Sat, 11 May 2019 12:41:31 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190510214550.18657-5-tpiepho@impinj.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.05.2019 23:46, Trent Piepho wrote:
> The variables used to store u32 DT properties were signed ints.  This
> doesn't work properly if the value of the property were to overflow.
> Use unsigned variables so this doesn't happen.
> 
In patch 3 you added a check for DT properties being out of range.
I think this would be good also for the three properties here.
The delay values are only 4 bits wide, so you might also consider
to switch to u8 or u16.

Please note that net-next is closed currently. Please resubmit the
patches once it's open again, and please annotate them properly
with net-next.

> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Signed-off-by: Trent Piepho <tpiepho@impinj.com>
> ---
>  drivers/net/phy/dp83867.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
> index a46cc9427fb3..edd9e27425e8 100644
> --- a/drivers/net/phy/dp83867.c
> +++ b/drivers/net/phy/dp83867.c
> @@ -82,9 +82,9 @@ enum {
>  };
>  
>  struct dp83867_private {
> -	int rx_id_delay;
> -	int tx_id_delay;
> -	int fifo_depth;
> +	u32 rx_id_delay;
> +	u32 tx_id_delay;
> +	u32 fifo_depth;
>  	int io_impedance;
>  	int port_mirroring;
>  	bool rxctrl_strap_quirk;
> 

