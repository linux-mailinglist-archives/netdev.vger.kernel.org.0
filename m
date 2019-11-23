Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 506BD108015
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 19:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfKWSvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 13:51:47 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43565 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfKWSvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 13:51:47 -0500
Received: by mail-pf1-f196.google.com with SMTP id 3so5250437pfb.10
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 10:51:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=fW+qNDyIgT0hFMbcoK1jwShTO8vWl0Ds/OEjRZqacwc=;
        b=nNvxwXL2dQu8qouXnwh3q6FCZ5yZtbPsegLFPANNOccgfa3VIhAigD/zDcIN2TxkPa
         whMduDFVMcwoeUPLORLbb9bpRO+/4d5q+Z3jSd9/uSobOS9T2jqfJoyEH6HNqIYCio74
         FG+HRoqtPCfZV+faoog6ZNpjJojm5oXQLNelNTR0O/NGuh0j+GIKs9eRO5NpcFSEuU9y
         rnmouAjQ1kmbFJkBSeehpyXFG2/++y3v8YqZOb+bxFBh3njKME8FDRYlIqSF+i5nQmzd
         GFO2GV1paCwEFJKO7Cm3ry5KWGR74+4TTWprnfdExv2Dqfu4RFW6Jguq4DWAIVafag9f
         iW5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=fW+qNDyIgT0hFMbcoK1jwShTO8vWl0Ds/OEjRZqacwc=;
        b=uS8CFJinUYG8t+soMN26TxCwSOxk4MdIYMFQzTXfY2oBs0lzNG0zaMXiSSQVSycJ20
         5NkUq/SjfvTfjaLmR32mNF8ez4fdU1n6/3IIv+lYHy9lO2zf01eQ1uUfN306VB9bzlNH
         o2oB2FnLqwJdGT5cfQQqpVJA5fZcUbiF7eTUB2Nb5yQRCRclVdf7i1hKW7Njl2cFK7Hg
         hp95AK8Y42CzyYcO0gek6jxZQnNdD7RlEodoIR/pMIxiE3o8VFwN35eM139+oyq0RM6u
         P/snRvoAZWtvISCWu8inAhPhqf27BLpRdREUVIhjI/2ruuOIkUStEHhCh9w4pfFIxzgg
         6WdA==
X-Gm-Message-State: APjAAAWvvUs7Yxpnwg1YZ8/AlgpeinKbPHUFBkqJUtPBuAYI4YPRYGqC
        VbScADOQ+VD/FWuyETnB7K0zHQ==
X-Google-Smtp-Source: APXvYqz7IyhpKJ3Z3/jH1T5VJ5CuK1OMSDa3EO7ZCn5BLDWIwi5lwBHvQm4upCxj2unGJgEEMGRS/A==
X-Received: by 2002:a62:38d8:: with SMTP id f207mr25442964pfa.209.1574535106410;
        Sat, 23 Nov 2019 10:51:46 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id h13sm2464081pfr.98.2019.11.23.10.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 10:51:46 -0800 (PST)
Date:   Sat, 23 Nov 2019 10:51:41 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: remove phy_ethtool_sset()
Message-ID: <20191123105141.3a75fd7f@cakuba.netronome.com>
In-Reply-To: <20191123105021.2a7b1fb9@cakuba.netronome.com>
References: <E1iY8BQ-00066m-TG@rmk-PC.armlinux.org.uk>
        <20191123105021.2a7b1fb9@cakuba.netronome.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Nov 2019 10:50:21 -0800, Jakub Kicinski wrote:
> On Fri, 22 Nov 2019 12:37:08 +0000, Russell King wrote:
> > There are no users of phy_ethtool_sset() in the kernel anymore, and
> > as of 3c1bcc8614db ("net: ethernet: Convert phydev advertize and
> > supported from u32 to link mode"), the implementation is slightly
> > buggy - it doesn't correctly check the masked advertising mask as it
> > used to.
> > 
> > Remove it, and update the phy documentation to refer to its replacement
> > function.
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>  
> 
> Applied, thank you!

FWIW I've added the word "commit" before the hash, checkpatch is really
insistent on that.
