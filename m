Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26598173F41
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 19:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbgB1SPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 13:15:13 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41590 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgB1SPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 13:15:12 -0500
Received: by mail-pg1-f193.google.com with SMTP id b1so1907698pgm.8;
        Fri, 28 Feb 2020 10:15:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Clif/mEcnn3ME/k5ycRzrGKqtOc9D+bOeqjCbBVwdps=;
        b=QGgynOA/VJOt/cG7OnLMz+tVY8zs6kY14i9YkqCvq1ahYk47pCnYiv/aqOf/3LTayR
         ZaUOLFUzqVsLIewhEEKma7/IjqWgzAUizeJpcAzf6BdNwxt1ENmE3tJ+jCUabTX1TpEq
         g4D6LXm38BYO72RrF1NOIztO8b9g3/CyJQ3Ym5A75lOj5yWaShYE3nHie3OIZY0oKzYq
         3cA4qDtaY4M2uLTc7FS5OXhp+LWYNLbgDls8zw0B+Y+tZK6OgHwl6sarj1kK489NVc2g
         jR1UY1btuYEsvbwn28cQXnRw92zOl2xpiE760psokXpVjQQsIRMjFdMKv6BhIbWFY/D2
         wU5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Clif/mEcnn3ME/k5ycRzrGKqtOc9D+bOeqjCbBVwdps=;
        b=U9kCpWvGQHuOmhReg/JNR6d9mxPfFi23RibuZukAlBZbPiqUdKQKcIfLTgkTvXB20J
         0MaWkSI3byBskPnOqJCUwLWps+T+4jWmHQetTbjTP2x5jW4zfAeTLPyIymhJHPJpZXsv
         5dBIjo+JeOq3Wa+X8tJdWvkQAaoSRJkToppWLzACozV8weorn6UNXFIvXXS+CYtTsS6q
         JBXWX17TNLFyOGO5zafJrvzC1OR8/ZM/AQaX2vR4/xirrEn+prWxE39Sjj1/nWR3bSRN
         vFFixsKncVaxrniIO6MbPyuDRh/pU3Ezs+OtAYQez4s2OIkRNXFykBmAaKve1lLCbwqW
         w+ew==
X-Gm-Message-State: APjAAAX88l3q3l51we9ou+SMnlWiYrx0GeiIBUairqR5kg5DvmylCr6T
        RLF1zmGTzmV+J1VkX6qZ6fM=
X-Google-Smtp-Source: APXvYqxWA8rvGE5/pCJKCoTTMPwDvIxb42dP3gBtBzfZ3HBMzKlZQp9VC5RuRR2HgISpMP+Xw1cRCw==
X-Received: by 2002:a63:257:: with SMTP id 84mr5681448pgc.304.1582913710121;
        Fri, 28 Feb 2020 10:15:10 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 1sm7990801pff.11.2020.02.28.10.15.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 10:15:09 -0800 (PST)
Date:   Fri, 28 Feb 2020 10:15:07 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH v2 0/2] AT8031 PHY timestamping support
Message-ID: <20200228181507.GA4744@localhost>
References: <20200228180226.22986-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228180226.22986-1-michael@walle.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 28, 2020 at 07:02:24PM +0100, Michael Walle wrote:
>  (1) The PHY doesn't support atomic reading of the (timestamp,
>      messageType, sequenceId) tuple. The workaround is to read the
>      timestamp again and check if it has changed. Actually, you'd have
>      to read the complete tuple again.

This HW is broken by design :(

> But if you're using a P2P clock with peer delay requests this whole
> thing falls apart because of caveat (3). You'll often see messages like
>   received SYNC without timestamp
> or
>  received PDELAY_RESP without timestamp
> in linuxptp. Sometimes it working for some time and then it starts to
> loosing packets. I suspect this depends on how the PDELAY messages are
> interleaved with the SYNC message. If there is not enough time to until
> the next event message is received either of these two messages won't
> have a timestamp.

And even the case where a Sync and a DelayResp arrive at nearly the
same time will fail.

> The PHY also supports appending the timestamp to the actual ethernet frame,
> but this seems to only work when the PHY is connected via RGMII. I've never
> get it to work with a SGMII connection.

This is the way to go.  I would try to get the vendor's help in making
this work.

Thanks,
Richard
