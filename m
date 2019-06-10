Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9503B630
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 15:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390324AbfFJNkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 09:40:19 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38672 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390156AbfFJNkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 09:40:18 -0400
Received: by mail-wm1-f68.google.com with SMTP id s15so5767365wmj.3
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 06:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AoKKC1Avyn9o1JfUuZnyId80B/0bdbWbjbZQ8j1SIg0=;
        b=NQaMyw6UtWW578Rw3ir6FkAyGC9SgA/tVYtSOyEaSQE8dB78ftzBFeoM5tnpWBZ1p+
         eS95aGJnmn+qXTzA98gDvlLjxcvU762LDEU9fEBNO69+ukEPOWwHPnbpTi5M+RJ19cup
         Su4ugi7fiDv5i/vlhI+FRvRWnNsg8LJ0WEmcf+uhvi4h90KzCDWCL7hAjH6PHIS+Bw1Z
         UydQWQH5qZNFXzo4fxdoeV//X6//EoHxiq0EUov49zEAm3xOWqyjJgF0G+6Ucpw+IaY5
         rdiiEkebE237YCNOHXFL+X3VZZaBj6PZY5cv2LebdiQpNTeAULnJYbHPCZK85jVgtQUo
         wnJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AoKKC1Avyn9o1JfUuZnyId80B/0bdbWbjbZQ8j1SIg0=;
        b=ah09FhC5jFnaTQgDdH/qZ1LGEogCs49qtM4eW7Dsj+iVtX0MBs7uGW/XyzafW19Hoy
         +dFFa5yNS71ZtWRgui5ghduosxAL6N59P+tnxsGFNo4JqO5rucrBPk68M73qaDmlwsgj
         iHja2Z3Zw2pJImDIkr6xyH6ekPLEbp+nP0SaJ5PPAj1RL5Ry0ZdY9bqKiM2lvRnxsNAR
         IGnXKl+pxp6vMspoEn4tJBe2gPOqYnkWbNeQy4pbwTrq7s77Ph2/aNw3k7JcaXPc3s89
         N/m/A9+b+BDkpeIoaYWkVl2ofdeQZc4mSxmubVQs48uzxQnNSq5ERezBcHu79mgXRhhZ
         lzvw==
X-Gm-Message-State: APjAAAV0RRFk8c37ls0/5K6s0waKjCVIT9TzrZw0QTpZESUxW8T3/FkM
        yT0+X0hifMfXJhXR+1JgR0Ps9//8
X-Google-Smtp-Source: APXvYqwEeedITZZ1PdJIseM4b7Ar+NYEFTPLcbwjj+nMeU01UezZqRvYYEnOD4TOX6V3BAZxnLKvCw==
X-Received: by 2002:a1c:df46:: with SMTP id w67mr13009641wmg.69.1560174016587;
        Mon, 10 Jun 2019 06:40:16 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:8cc:c330:790b:34f7? (p200300EA8BF3BD0008CCC330790B34F7.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:8cc:c330:790b:34f7])
        by smtp.googlemail.com with ESMTPSA id y24sm2767458wmi.10.2019.06.10.06.40.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 06:40:16 -0700 (PDT)
Subject: Re: [PATCH] net: phy: marvell10g: allow PHY to probe without firmware
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>, f.fainelli@gmail.com,
        netdev@vger.kernel.org
References: <E1hYTO0-0000MZ-2d@rmk-PC.armlinux.org.uk>
 <20190605.184827.1552392791102735448.davem@davemloft.net>
 <20190606075919.ysofpcpnu2rp3bh4@shell.armlinux.org.uk>
 <20190606124218.GD20899@lunn.ch>
 <16971900-e6b9-e4b7-fbf6-9ea2cdb4dc8b@gmail.com>
 <20190606183611.GD28371@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <bdb416f7-3f4c-dbcf-3efe-338ab697b4fe@gmail.com>
Date:   Mon, 10 Jun 2019 15:40:10 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190606183611.GD28371@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.06.2019 20:36, Andrew Lunn wrote:
> 65;5402;1c> I don't like too much state changes outside control of the state machine,
>> like in phy_start / phy_stop / phy_error. I think it would be better
>> if a state change request is sent to the state machine, and the state
>> machine decides whether the requested transition is allowed.
> 
> Hi Heiner
> 
> I initially though that phy_error() would be a good way to do what
> Russell wants. But the locks get in the way. Maybe add an unlocked
> version which PHY drivers can use to indicate something fatal has
> happened?
> 
phy_error() switches to PHY_HALTED, therefore phy_start() would start
another attempt to bring up the PHY. Maybe some new state like
PHY_PERMANENT_FAILURE could be helpful.  Or do we need a temporary
failure state?

After a recent patch from Russell the probe callback returns -ENODEV
if no firmware is loaded. With the patch starting this discussion
this would have changed to not failing in probe but preventing the
PHY from coming up. The commit message missed an explanation what we
gain with this behavior change.

> 	Andrew
> 
Heiner

