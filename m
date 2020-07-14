Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9221721FFF2
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 23:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbgGNVWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 17:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbgGNVWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 17:22:15 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A050C061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 14:22:15 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f7so280904wrw.1
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 14:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wtEe8+WD5kKptfJEdsjjj58rtaHJHgoKlDLbGYmdpAQ=;
        b=XFLmjdc/p9M7y9HlkVXIUc8gx8uBjYI4ECxLHTgXk5dFYf0if8ztCE3U+jz8DMd7L4
         qq7/KrHePMd0IL+5fFS8ksuY4EEhwiN1LmHLQHICqa+vl3xVuoDSwTwCJwPUAl5gM45a
         h6AWUMP/rvBadp2TwFkvMojLD1xL283bVY17gUqeZOXiCeo1GWTS8dmJOoQpyWJgLcj0
         0FWAe6mxyzCvH0vzWcgWMzlF56H/wLSvcXBnPNQ8HRhqqT4TEuMALDYQonvaj6Gs4r1V
         7UlU5w4d1ViFFFbFNZuSdrmkOUeZpNF0/u5d9wnpw6bjHKpHLx0Nh8ybuScX2aGQ38WH
         EG6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wtEe8+WD5kKptfJEdsjjj58rtaHJHgoKlDLbGYmdpAQ=;
        b=i9UDTtGneugIlVXsI8dv8SUbI94ecHam59jz9Hudk/Kjjh7PErsw+wzKi1+C8NqIh5
         HoxdOjebBi0aQBwUVyINULlW6fOq4CJ1wA3V7uNzJLmsvtJ2yoOZ93RvIEDCTlM7Ycg/
         lNyUtJzsODe0Hc3XHcV+RkjhAcVQB3XGMdQIdM1QRP9kBc5AuubKkWi1pYtXR9hCRqgr
         zuSnrekocruufQN7wLtZWvpIK1gfAyhHQfLAasZrOLSaSx3pPhoTLFxAhdopNlX1rIau
         ubW7P0IfVsO23FXjhtqXZIfSvuQGSveZeolUuYUwyySTZZrdEiSKReI2xuQWCdz3FTEM
         DtPQ==
X-Gm-Message-State: AOAM5303SWpO2LjdcwPCp643yTCQLnOiRVB39v44o8fCM/59VElQ/5bz
        85lReG//002jWLcE4vHwXqo=
X-Google-Smtp-Source: ABdhPJyHp6Rq1QyS1pGX+xlsTSmdzRf0pUvD56wjn4lvPMwJ6bEd7glem/G6ng7kHah8tBdKiWHuaA==
X-Received: by 2002:a5d:6ac7:: with SMTP id u7mr8464086wrw.25.1594761734217;
        Tue, 14 Jul 2020 14:22:14 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p17sm45887wma.47.2020.07.14.14.22.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2020 14:22:12 -0700 (PDT)
Subject: Re: [PATCH RFC net-next 00/13] Phylink PCS updates
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "michael@walle.cc" <michael@walle.cc>, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20200630142754.GC1551@shell.armlinux.org.uk>
 <20200714084958.to4n52cnk32prn4v@skbuf>
 <20200714131832.GC1551@shell.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e56160da-9a17-d69b-25f0-b564b5959377@gmail.com>
Date:   Tue, 14 Jul 2020 14:22:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200714131832.GC1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/14/2020 6:18 AM, Russell King - ARM Linux admin wrote:
> On Tue, Jul 14, 2020 at 11:49:58AM +0300, Vladimir Oltean wrote:
>> Are you going to post a non-RFC version?
> 
> I'm waiting for the remaining patches to be reviewed; Florian reviewed
> the first six patches (which are not the important ones in the series)
> and that seems to be where things have stopped. There has been no
> change, so I don't see there's much point to reposting the series.

Sorry for giving an impression that this had stalled, I reviewed the
obvious changes and am now reviewing the not so obvious changes, would
certainly appreciate if other NXP folks as well as Andrew and Heiner
looked at those changes obviously.
-- 
Florian
