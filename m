Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB4532EE49
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 05:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733015AbfE3DqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 23:46:00 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46736 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732997AbfE3Dp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 23:45:59 -0400
Received: by mail-pl1-f194.google.com with SMTP id e5so215375pls.13;
        Wed, 29 May 2019 20:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ww+Lpg5UBLlG+2AfGQMM+hVR/fYWxYyw0/ehc0lD/3c=;
        b=M5X6aNH3nvYZQCJNaixfla2mxM4pqJ10Zre/QPd49XnXoLpGQcSXbIm8Zm5cdhVozs
         6bCa44Z0R6i2GxkBKxk+4W+OHC3N0+Tqv8OfKGzaRqfvPcgT1Z+am1qFNPKpAzzANvjp
         sAYzJVkuWL36sdkfJ+jUQnLpXcfNpLduVugBIBPkhbE+1+MTKCPHB+uWkxYZVa9yINFr
         37Wc1cY+b67xwuXJLEeLkQbIAMg7icUW+bcqAwO0h0Fz+ENu4/3oyVfWq/bkeV9dvAr3
         UkjJgcvZq5m+djMoEWA66G4LMONofE72UyVA3zto/okuq3vXvqzlCldV2Ms41zdZf6kl
         iQtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ww+Lpg5UBLlG+2AfGQMM+hVR/fYWxYyw0/ehc0lD/3c=;
        b=ofi5yxhVir1cq9WHi0KIsshtRNxg5EJUb4uQGr/nKReraDNU8TLgtwWr4uf5CCDDfV
         j39lXSqJ4JSpxpieqiKwd26PChHd/dV0FFxQas0J3fg5OeZpGenwQAshIRZR1CdVMCqW
         LyG0+41I1F3jseupaH4CpYIyqrAnbFcF7PklvOHJdlgXT8dylfosM8KPgvdR8C2RtUIz
         FRlM3ssyfHS0PQf3aPzj/7G1Xccus5mg9Qb6Jn4+FnCqXjmP/DtOAl4BFOGVJoTGuCF/
         ZYBCSy+N7wYh4yzi46mbIrrkzL/wsvIlkZoYYY6+FyL7ZrjOprDgQ69Y0EniDFnoKbIH
         pL0A==
X-Gm-Message-State: APjAAAXL+VIA1xYvBUS6dzxT41P8Hk0j1MnzRgOIdvhJU6KmoE/V/9EK
        DeL7FqG+RqnM7eqq6mTCnqk=
X-Google-Smtp-Source: APXvYqyIIykUxao2/xaCmvr45UsU0Y6d/pyZUzuokuqlxonCjFt/gsxsV7y4QtmvbTvtUjoquFCu7Q==
X-Received: by 2002:a17:902:758b:: with SMTP id j11mr1710553pll.191.1559187958599;
        Wed, 29 May 2019 20:45:58 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id w6sm754892pge.30.2019.05.29.20.45.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 May 2019 20:45:57 -0700 (PDT)
Date:   Wed, 29 May 2019 20:45:55 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, john.stultz@linaro.org, tglx@linutronix.de,
        sboyd@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/5] PTP support for the SJA1105 DSA driver
Message-ID: <20190530034555.wv35efen3igwwzjq@localhost>
References: <20190528235627.1315-1-olteanv@gmail.com>
 <20190529045207.fzvhuu6d6jf5p65t@localhost>
 <dbe0a38f-8b48-06dd-cc2c-676e92ba0e74@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbe0a38f-8b48-06dd-cc2c-676e92ba0e74@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 11:41:22PM +0300, Vladimir Oltean wrote:
> I'm sorry, then what does this code from raw.c do?

It is a fallback for HW that doesn't support multicast filtering.

Care to look a few lines above?  If you did, you would have seen this:

	memset(&mreq, 0, sizeof(mreq));
	mreq.mr_ifindex = index;
	mreq.mr_type = PACKET_MR_MULTICAST;
	mreq.mr_alen = MAC_LEN;
	memcpy(mreq.mr_address, addr1, MAC_LEN);

	err1 = setsockopt(fd, SOL_PACKET, option, &mreq, sizeof(mreq));

> > No.  The root cause is the time stamps delivered by the hardware or
> > your driver.  That needs to be addressed before going forward.
> > 
> 
> How can I check that the timestamps are valid?

Well, you can see that there is something wrong.  Perhaps you are not
matching the meta frames to the received packets.  That is one
possible explanation, but you'll have to figure out what is happening.

Thanks,
Richard
