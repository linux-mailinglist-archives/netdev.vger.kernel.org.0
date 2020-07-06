Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF43215EF8
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 20:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729797AbgGFSpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 14:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729738AbgGFSpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 14:45:43 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99941C061755;
        Mon,  6 Jul 2020 11:45:43 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id j18so40361364wmi.3;
        Mon, 06 Jul 2020 11:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sB+M5xN2q4aSHO4ImD3f9WDwtbdfsUY52yLNYBoRoMk=;
        b=sOw+T1jXnmcOBApPeHZG3ZXckOn+qWGRfSFB/+A6Ssg5pNiiuu/Uy5xZJNt0DeRQei
         KLFmMx8fKdNYYcreXPfjn8d/XX+ndO4PsoaYYr3ziKynahHxS0gc8cO7IAKvXPMAzcZc
         j8kgKHF72bXfaw37A50fR5BZ7HovOHpDtVAsNGpQ+6Gu5klU1FbFnVhrQzXu7oM7zZVX
         q2fv/u/jO/U0JU1Ja+AA/Zc8grG1mozSe/RTqa6tijd5zgO+Vw2LjiIPUTPnMq5Wyw7w
         uf7ZVwamP+cD0ragN3/2JUI8b+gDDoMwNKrmPkyfUcFuz+tZd9zdUohX/RXov1gmPtxh
         NQaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sB+M5xN2q4aSHO4ImD3f9WDwtbdfsUY52yLNYBoRoMk=;
        b=Qm0rb2sixucqhxCkkD3WQaMSz7m0o7KBAbsZeCIgJ1Tknef8hjn7GN2J7PFRWaXqtU
         MRtXdb2akauQ3Rz+Gc6ATmjvxZloOetH0UkCaBwnfBfFZ2K5w91ptp6/MSK7gx4ILV1Z
         2XC2D2Vw4VfHJgm9dG9ck85LtPj5U2ntRs3jv9S9GWbm+gFnN/f4TCfKFbHT/i8ML54W
         0G+Ut6mbtPZhJxI7Gsr4+hLryfBuqpYTl96HTbEu4+tfKop1SttvviDojGdWI0/UG8lH
         TRFU8Nu5iGQg7ccBPrpdRvDR6nwARg8PDk1hYqhVgT/Kgg4sMKcI9TgyZKcgby3BURBA
         y3xA==
X-Gm-Message-State: AOAM530aDC8swvAD0S4qom5Ehc6KbmHTG8rXc4W7TWE2mAAe6Q4qBGBq
        wUPEdmD+U4j2mM7/XzybZwSWT8Q+
X-Google-Smtp-Source: ABdhPJzkLw9HjsK+77mKDWHEKufH4k9ZKlgtwrVIspUS2QmWsD1KW1YQSRx5MF7CQ1AAt0/9j9ti9g==
X-Received: by 2002:a7b:c38c:: with SMTP id s12mr518917wmj.136.1594061142041;
        Mon, 06 Jul 2020 11:45:42 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id 12sm393621wmg.6.2020.07.06.11.45.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2020 11:45:41 -0700 (PDT)
Subject: Re: [PATCH net-next v2 3/3] net: ethtool: Remove PHYLIB direct
 dependency
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        open list <linux-kernel@vger.kernel.org>
References: <20200706042758.168819-1-f.fainelli@gmail.com>
 <20200706042758.168819-4-f.fainelli@gmail.com>
 <20200706114000.223e27eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <262dbde0-2a0e-6820-fd69-157b7f05a8c4@gmail.com>
Date:   Mon, 6 Jul 2020 11:45:38 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200706114000.223e27eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/6/2020 11:40 AM, Jakub Kicinski wrote:
> On Sun,  5 Jul 2020 21:27:58 -0700 Florian Fainelli wrote:
>> +	ops = ethtool_phy_ops;
>> +	if (!ops || !ops->start_cable_test) {
> 
> nit: don't think member-by-member checking is necessary. We don't
> expect there to be any alternative versions of the ops, right?

There could be, a network device driver not using PHYLIB could register
its own operations and only implement a subset of these operations.

> 
>> +		ret = -EOPNOTSUPP;
>> +		goto out_rtnl;
>> +	}
>> +
>>  	ret = ethnl_ops_begin(dev);
>>  	if (ret < 0)
>>  		goto out_rtnl;
>>  
>> -	ret = phy_start_cable_test(dev->phydev, info->extack);
>> +	ret = ops->start_cable_test(dev->phydev, info->extack);
> 
> nit: my personal preference would be to hide checking the ops and
> calling the member in a static inline helper.
> 
> Note that we should be able to remove this from phy.h now:

I would prefer to keep thsose around in case a network device driver
cannot punt entirely onto PHYLIB and instead needs to wrap those calls
around.

> 
> #if IS_ENABLED(CONFIG_PHYLIB)
> int phy_start_cable_test(struct phy_device *phydev,
> 			 struct netlink_ext_ack *extack);
> int phy_start_cable_test_tdr(struct phy_device *phydev,
> 			     struct netlink_ext_ack *extack,
> 			     const struct phy_tdr_config *config);
> #else
> static inline
> int phy_start_cable_test(struct phy_device *phydev,
> 			 struct netlink_ext_ack *extack)
> {
> 	NL_SET_ERR_MSG(extack, "Kernel not compiled with PHYLIB support");
> 	return -EOPNOTSUPP;
> }
> static inline
> int phy_start_cable_test_tdr(struct phy_device *phydev,
> 			     struct netlink_ext_ack *extack,
> 			     const struct phy_tdr_config *config)
> {
> 	NL_SET_ERR_MSG(extack, "Kernel not compiled with PHYLIB support");
> 	return -EOPNOTSUPP;
> }
> #endif
> 
> 
> We could even risk a direct call:
> 
> #if IS_REACHABLE(CONFIG_PHYLIB)
> static inline int do_x()
> {
> 	return __do_x();
> }
> #else
> static inline int do_x()
> {
> 	if (!ops)
> 		return -EOPNOTSUPP;
> 	return ops->do_x();
> }
> #endif
> 
> But that's perhaps doing too much...

Fine either way with me, let us see what Michal and Andrew think about that.
-- 
Florian
