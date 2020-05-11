Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 528A61CE391
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 21:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731014AbgEKTGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 15:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729215AbgEKTGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 15:06:35 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8E3C061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 12:06:34 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 18so5162686pfx.6
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 12:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N+EBo2PaSrOPJJuPgKNtebDh4kVRzus9O1QbzAkPgHk=;
        b=pUq1QY1QMynAWp/PjrkIZbi6mw1z9WZUemlDvUnMmrNTakRFr+aeg8cJi+R1V1Z9yb
         1NbuG/MKpLJjMa1rXHBsaF8RIRb4UfEW0KzjLLgUFk8OOGk5cmRdbkwEkqFX9J1xgIXY
         MpwpLqJNh6lCabhL8iemXpV6dNTNRmpdNWrKQH/gVv29Yyg55wMf6SBvSBF8oGrMdWRU
         lYVfQFZVTfWpBiu1JUCLYoa8QOLZBnXQcKyCwkvCWiQ3AAPVxF2E3OzTPtZ5rZrOLyQ5
         pVOZCuVU3FnbK+8rWkhEftn/cXPftNXjj+oZnU1L8MMGC0WVeA39CeicpnlOPiNyJ2yB
         qkhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N+EBo2PaSrOPJJuPgKNtebDh4kVRzus9O1QbzAkPgHk=;
        b=lBeJQB0i8fcyJzN5ror5aDw81/40VoELHtHFrXgYVQfXtNNrtWA/GJ02QMGSmWC/w1
         Guy9G7jIIv0uwoOVZJCsx2NSLSnTtI63y7COdksxRUCY40CjvngAkIJ6+eOquF5RMYs1
         103TQ4jz+rKtvq9TbKjFSPAYVYUJX+awQmeEWuMwiHl9F3KaGY8Ybg2HiZbo54ESfcWJ
         PaTx+cEDCQWIA/sWsQtWGW4GMn2EuWMXxLngPScWmdfnvvmFSIUwhSSCgFIX9f5p3+w7
         AFay4HZ8dwhnH3drHmvrfs9IAWZiq6jDohN804BqfHtfWEhRzf5AJGf18+iLTzFOiWCk
         KPFg==
X-Gm-Message-State: AGi0PuZRxv7OePo3znNKW61AZBioJmYxIq9YsvWXcaq32nlM5cLyxZco
        m9uFFNJGjZ6sX9RrpzxMD88=
X-Google-Smtp-Source: APiQypKC56F/244wnGtGYCEtVj+SXYkfEHQqgKH/mSKiT4KJvXRP0fQPDnj65ijD+Ob+lst/wiZ0yw==
X-Received: by 2002:a65:4486:: with SMTP id l6mr16755552pgq.365.1589223993553;
        Mon, 11 May 2020 12:06:33 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d184sm9650591pfc.130.2020.05.11.12.06.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 12:06:32 -0700 (PDT)
Subject: Re: net: phylink: supported modes set to 0 with genphy sfp module
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Julien Beraud <julien.beraud@orolia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <0ee8416c-dfa2-21bc-2688-58337bfa1e2a@orolia.com>
 <20200511182954.GV1551@shell.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4894f014-88ed-227a-7563-e3bf3b16e00c@gmail.com>
Date:   Mon, 11 May 2020 12:06:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200511182954.GV1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/2020 11:29 AM, Russell King - ARM Linux admin wrote:
> On Mon, May 11, 2020 at 05:45:02PM +0200, Julien Beraud wrote:
>> Following commit:
>>
>> commit 52c956003a9d5bcae1f445f9dfd42b624adb6e87
>> Author: Russell King <rmk+kernel@armlinux.org.uk>
>> Date:   Wed Dec 11 10:56:45 2019 +0000
>>
>>     net: phylink: delay MAC configuration for copper SFP modules
>>
>>
>> In function phylink_sfp_connect_phy, phylink_sfp_config is called before
>> phylink_attach_phy.
>>
>> In the case of a genphy, the "supported" field of the phy_device is filled
>> by:
>> phylink_attach_phy->phy_attach_direct->phy_probe->genphy_read_abilities.
>>
>> It means that:
>>
>> ret = phylink_sfp_config(pl, mode, phy->supported, phy->advertising);
>> will have phy->supported with no bits set, and then the first call to
>> phylink_validate in phylink_sfp_config will return an error:
>>
>> return phylink_is_empty_linkmode(supported) ? -EINVAL : 0;
>>
>> this results in putting the sfp driver in "failed" state.
> 
> Which PHY is this?

Using the generic PHY with a copper SFP module does not sound like a
great idea because without a specialized PHY driver (that is, not the
Generic PHY driver) there is not usually much that can happen.
-- 
Florian
