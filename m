Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCC937A0E6
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 08:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbfG3GAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 02:00:37 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53973 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726206AbfG3GAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 02:00:37 -0400
Received: by mail-wm1-f67.google.com with SMTP id x15so55862260wmj.3;
        Mon, 29 Jul 2019 23:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4ztu+pimjN743C29mSszt2yGsEtnV4+Z/3nUKYXGTtQ=;
        b=BpaIp+JtF+6eIAsvbjmiYoxlcsvAkOCrc9w/8PmLFI9t0AG1lJZi97ohUGWU83jbgk
         +d5eXUe/+hP3FPPXjdXA/0n8vaqKc219X36ep5VwU0mNkXwimm5sDVtkFf70E29JrxN2
         xShcoQ7ZlUXDJpd4Xe1y5g1Sv4czJ8ULB7BK5+lq3H4AIX+RqYuaWxBnvxmMkfpn645y
         xBQIfbEaJAM/+uSYUcMu+2ZucCsBplZXcu6SchLe6bu1xqFDgBoPzqf2243Y7tZ3X8AS
         9vCOaxtYIo/f+PABV2OO2NlqmBgv8uZWji/st8JlSWI/PZk4t34PDDkngiYcMX6w7v/a
         GPZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4ztu+pimjN743C29mSszt2yGsEtnV4+Z/3nUKYXGTtQ=;
        b=nrrnV35mBlLsnwxygHVPgIpd7fPERbQL+At/PmE3dKZAmSJ9PlYOHk+3OlH9CZU8iQ
         kuYDQ3hWhAVBg5pYOVrDensePGR5TRt4KvLKUnbqnZbNjRU+yPfpD/opOUpw2HAHOHxx
         h7QETpeG6xZkSVTtTD0uGaOduIR27RtclZJmelufeU7dRvPNA7PQqzwnCfifBdBwjur0
         A8vHkvTVcaAVxa/IOGPKOKfarh7bTNh3P7i357PTPe54znX/TZ+q1Zu6r1qJ6uyAqC9b
         YeakB7chZnrOwhqUH1z95HlxiGOSEBqf/2MZct0YZzw5QXuCn7LEUaqwBYwoNWWic4wy
         KdfA==
X-Gm-Message-State: APjAAAWb7SOll+l/59PZ2DYNDlyVZU23LIjYXiaIGtmBdmnmFuBkhph7
        NVcGCGvq2JifIx2LS9elULrcdEz2
X-Google-Smtp-Source: APXvYqxjONCiW2vReiQWjQagiM+52KMDKfC+HZONk+g+xcwNev5z7RbBF96DpBc9Kfdp3o0g08LgXA==
X-Received: by 2002:a1c:35c2:: with SMTP id c185mr101364338wma.58.1564466435081;
        Mon, 29 Jul 2019 23:00:35 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f43:4200:6c98:6a00:6f0a:eb31? (p200300EA8F4342006C986A006F0AEB31.dip0.t-ipconnect.de. [2003:ea:8f43:4200:6c98:6a00:6f0a:eb31])
        by smtp.googlemail.com with ESMTPSA id h16sm68205312wrv.88.2019.07.29.23.00.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 23:00:34 -0700 (PDT)
Subject: Re: [PATCH net-next 1/2] net: phy: broadcom: set features explicitly
 for BCM54616S
To:     Tao Ren <taoren@fb.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
References: <20190730002532.85509-1-taoren@fb.com>
 <20190730033558.GB20628@lunn.ch>
 <aff2728d-5db1-50fd-767c-29b355890323@fb.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <bdfe07d3-66b4-061a-a149-aa2aef94b9b7@gmail.com>
Date:   Tue, 30 Jul 2019 08:00:24 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <aff2728d-5db1-50fd-767c-29b355890323@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.07.2019 07:05, Tao Ren wrote:
> On 7/29/19 8:35 PM, Andrew Lunn wrote:
>> On Mon, Jul 29, 2019 at 05:25:32PM -0700, Tao Ren wrote:
>>> BCM54616S feature "PHY_GBIT_FEATURES" was removed by commit dcdecdcfe1fc
>>> ("net: phy: switch drivers to use dynamic feature detection"). As dynamic
>>> feature detection doesn't work when BCM54616S is working in RGMII-Fiber
>>> mode (different sets of MII Control/Status registers being used), let's
>>> set "PHY_GBIT_FEATURES" for BCM54616S explicitly.
>>
>> Hi Tao
>>
>> What exactly does it get wrong?
>>
>>      Thanks
>> 	Andrew
> 
> Hi Andrew,
> 
> BCM54616S is set to RGMII-Fiber (1000Base-X) mode on my platform, and none of the features (1000BaseT/100BaseT/10BaseT) can be detected by genphy_read_abilities(), because the PHY only reports 1000BaseX_Full|Half ability in this mode.
> 
Are you going to use the PHY in copper or fibre mode?
In case you use fibre mode, why do you need the copper modes set as supported?
Or does the PHY just start in fibre mode and you want to switch it to copper mode?

> 
> Thanks,
> 
> Tao
> 
Heiner
