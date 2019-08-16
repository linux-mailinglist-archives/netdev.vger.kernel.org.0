Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA9FB9091F
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 22:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbfHPUC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 16:02:27 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:32867 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727545AbfHPUC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 16:02:27 -0400
Received: by mail-wm1-f66.google.com with SMTP id p77so3870692wme.0
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 13:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MVcky00cL9Izjkmq24TTUY3wBYWfFwCVX+CmLNIxHAc=;
        b=Ryl/jnO35VzIc5OmYxSXuX9ZOHwWKrrh9/XKBA2mrIEy6dyJKxcqnc9KP1rmtfbg5z
         +gBgpfQYBWg7tNUMj57KQI+nD27aRFeq6ixsxCONUU849JpGxOBTCrNAR9d/+bnrBchU
         j6K5+0GosP79nhbWtKcE6ExLoSscvu6msxmMAzD/6ovYoPckNfL2vSsN9GFmdYQOzngZ
         t+1zb8DH1QwOSR/cJnh3DkiVU10/fbaXNrP96VLCdg29vIPrN1ILvMlNiisy5PjfuMz0
         pLALKMZZ0mBt3VR0qV4t+WPly5/vYX9gngoJqkHoPRWhBlwrESh0aSDvxKe3a/1J9nJj
         CtzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MVcky00cL9Izjkmq24TTUY3wBYWfFwCVX+CmLNIxHAc=;
        b=Zn0VU5ouOSlyw2R0/xN+B0H1jUZAdL0TpaWebwUb/SV30mPWSMYqGFqUHHyqdyfEU/
         UGluuK4QhQB3Cs119diwpkT7pEexnrhB3qHMSUFqnYhi2uUtrKgG58kNolojjklqo3DB
         bLwUtIP3PhS2zXRlPxZ3MSl9XsRQDjv9jk56CFWcHlE+LCamlzl8LpjXWRl5RCUKO5al
         hnMZOxBU1O2iQgWNyfPkeA12FoYfv6FFtXZCS980OXgibxhXpzmSW5Vc4DdOwLRHc/7G
         qgrGOq0k4KMIose33MkE8RCB5U1QvfkzkICzNTMNZ5/h9FYd1ha6+TdP+ryQxHhjBEeM
         dyAA==
X-Gm-Message-State: APjAAAU8BC8vucoUv8BpG1ya2Yun/hQhagse3+cBONXCaXUQhETjvJY7
        jJxuwinyf+sOhmixX2TeiyE=
X-Google-Smtp-Source: APXvYqzcYrIDjzKdpiQ4tI4a5N55fRtIJCU5ASVcbUwgQs7l82l96u+O+kkNkpM2rDgx/qA1ozKh1A==
X-Received: by 2002:a1c:2302:: with SMTP id j2mr8505269wmj.174.1565985745527;
        Fri, 16 Aug 2019 13:02:25 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:4112:e131:7f21:ec09? (p200300EA8F2F32004112E1317F21EC09.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:4112:e131:7f21:ec09])
        by smtp.googlemail.com with ESMTPSA id z8sm4295465wmi.7.2019.08.16.13.02.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 13:02:24 -0700 (PDT)
Subject: Re: [PATCH net-next 0/3] net: phy: remove genphy_config_init
To:     David Miller <davem@davemloft.net>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, khilman@baylibre.com,
        vivien.didelot@gmail.com, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org
References: <95dfdb55-415c-c995-cba3-1902bdd46aec@gmail.com>
 <20190816.115754.393902669786330872.davem@davemloft.net>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <7ca48c8c-80d0-7abc-c0d9-f0ab7f787f04@gmail.com>
Date:   Fri, 16 Aug 2019 22:02:20 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190816.115754.393902669786330872.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.08.2019 20:57, David Miller wrote:
> From: Heiner Kallweit <hkallweit1@gmail.com>
> Date: Thu, 15 Aug 2019 14:01:43 +0200
> 
>> Supported PHY features are either auto-detected or explicitly set.
>> In both cases calling genphy_config_init isn't needed. All that
>> genphy_config_init does is removing features that are set as
>> supported but can't be auto-detected. Basically it duplicates the
>> code in genphy_read_abilities. Therefore remove genphy_config_init.
> 
> Heiner you will need to respin this series as the new adin driver
> added a new call to genphy_config_init().
> 
> Thank you.
> 
OK, will do. Thanks.
