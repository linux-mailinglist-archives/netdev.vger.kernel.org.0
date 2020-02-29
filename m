Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9D5174775
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 15:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgB2OsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 09:48:22 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42430 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727068AbgB2OsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 09:48:22 -0500
Received: by mail-pg1-f193.google.com with SMTP id h8so3067577pgs.9;
        Sat, 29 Feb 2020 06:48:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=N93FcR1e1Xrf9bS1tDR8+5hXN9E83pgSbSMAJjjKr5U=;
        b=fABkRQRSeICZGWi8MEu3w9UC+36p4GsIOd4+ng5HOrUIbDvS2zQQdGwqvUHQNB1YWy
         LJ9KMXFE/HYWaCtgIFgLQdjWI0Ul8vchJ5vKOSiByJNovD0gb0x9HD4uZQwzBFG5Yv7d
         53T3qLQfdDDcyd7aqaxk9DtNRlBrPCbQH6Au6Ch1794QKCOgHS/8iywdERT6E/d00fr8
         VHAFRstnKGNQXaFOkBjdq1uDD2OqCaBGitkcgdNsEMrTv1cZ6fDMmFbBiWZor06Jow1+
         D9hZwFm9rOQ9EftSvVCX4UbTfk2s4v02wOcetJgg6sNQL82NANWkrg53ZVbWfOI6ysXz
         57aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=N93FcR1e1Xrf9bS1tDR8+5hXN9E83pgSbSMAJjjKr5U=;
        b=YMderoopgB6oqwlSPX8wa3CS6TA1BQvdm6HQzAh123ipQNe55PNN9P0VH+MUzoLayR
         Q0ZhCIjpLyRkjHo0cn/XpHhujcDmDKQPxGJroFumalTLetGiZj5CJ4y2ud0KKWXecFF0
         DFHLRgwXkIACudNtLl+baHr9R1zQIxTBFxL2fgnTx6DSZiWtRX1cxfnQF78W0GaexACG
         DTFm0L/Bo9Q8XZj97IR7OHutARDFR3JSbD0GDbdILtZ93oJ4ikZtUbHoikkHovRGVGM7
         YrcIN0hXgZFTThytKIKhCTM+XCR/LwUCeUn1wChYSefJkKhJXEmq26kuO2QbNxEY3/WY
         cLrw==
X-Gm-Message-State: APjAAAU82tEuKV5rBcriF/8GZife3bMWkhjOuIA/6fZQkz3F6rpnMeZZ
        pH53HMXif8FmGy+/OUxP8is=
X-Google-Smtp-Source: APXvYqxDr4iOlP8VHkMJLlIfs5S8blp/jBrVQfHMHLC8lFxKFV5OnqtGEqeebHPdZ2zuyQSX0ma47A==
X-Received: by 2002:a63:d94d:: with SMTP id e13mr9738712pgj.240.1582987701399;
        Sat, 29 Feb 2020 06:48:21 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id d14sm15909405pfq.117.2020.02.29.06.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Feb 2020 06:48:20 -0800 (PST)
Date:   Sat, 29 Feb 2020 06:48:18 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH v2 0/2] AT8031 PHY timestamping support
Message-ID: <20200229144818.GB25147@localhost>
References: <20200228180226.22986-1-michael@walle.cc>
 <20200228181507.GA4744@localhost>
 <979b0b89b2610c105310e733e98cd862@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <979b0b89b2610c105310e733e98cd862@walle.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 28, 2020 at 08:43:05PM +0100, Michael Walle wrote:
> 
> Yeah, I know. And actually I don't think I'll pursue this further. Like I
> said, I just wanted to my current work. Maybe it will be useful in the
> future who knows.

I appreciate your publishing this work.  It is a good starting place.
Maybe the vendor will wake up and help this along.  One can always hope.
 
> Like I said, our FAE is pretty unresponsive. But I'll at least try to find
> out if my guess is correct (that it only works with RGMII). But even then,
> how should the outgoing timestamping work. There are two possibilities:
> 
>  (1) According to the datasheet, the PHY will attach the TX timestamp to
>      the corresponding RX packet; whatever that means. Lets assume there
>      is such a "corresponding packet", then we would be at the mercy of the
>      peer to actually send such a packet, let alone in a timely manner.

I see.  Mysterious.  For a Sync frame, I can't think of any
"corresponding RX packet".

>  (2) Mixing both methods. Use attached timestamps for RX packets, read the
>      timestamp via PHY registers for TX packets. Theoretically, we could
>      control how the packets are send and make sure, we fetch the TX
>      timestamp before sending another PTP packet. But well.. sounds really
>      hacky to me.

It would not be that bad.  Some of the MAC cards can only buffer one
Tx time stamp, and for this reason, the ptp4l program always fetches
the time stamp immediately after sending.

Thanks,
Richard
