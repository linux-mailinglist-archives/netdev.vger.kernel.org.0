Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B664431491D
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 07:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbhBIGwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 01:52:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhBIGwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 01:52:19 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A698C061786;
        Mon,  8 Feb 2021 22:51:39 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id z6so20237047wrq.10;
        Mon, 08 Feb 2021 22:51:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=I7v+PJ0b9OiyE//SnnB+M67vmqUOjCNOaES/F2utvdE=;
        b=kPxmuPF/3SKpRHtEj6a+pzvVJBU1nVTAI5Oy8WxJ13KYGPV/sgtcE3J/3qwxsUvoKD
         2NcNWE5ILKhDG9XdzHjNckFoziIEMcBOcCIPaE6wWuFk+Sb8/arYh0BM6tF97q/wQ5J2
         QXizQZIuFa/zSNd3q72blV3biE36oq1EB1jf3yS6MwDL1F6oHVEhgQHuGgBfXeP/QHct
         LvHD7Ynf0Hf1lz++Z3L51ihdiu4PFNjC0IJ6KxGLBFLHk62JSnHvzA72aSiaA1xUfREB
         txP/pMsKQQJ93dLOpL3+CrxENp/vlkW/vzH2U1aHleQR3CYWpKSxcnwxOQKO7eRGfcXY
         fwgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I7v+PJ0b9OiyE//SnnB+M67vmqUOjCNOaES/F2utvdE=;
        b=ki2zGcBRpLcL+gqNaP0iVzcoTSIFMS0qqcK5odZfcO0M54qth6TzdH9QxpwXBthBWv
         TQKKmQpG4fdlNopG9yk+Cb2fMfvw932wy/KOpKh81p/wdhiqDHC55W9x+o2osJRcvzjw
         WVFfYeXTqOS/UJiNr4RdhmneDMKLDoLQRV0l5+t01SWv/+Z8VW3gnd9CSeiFm2oxqekZ
         U3p79cDpaQnOGWl/08JhVE1bj10a70b4iDQ3ryisq8yeIuntq9NYA7FMR5Fkb/sZ20l2
         igqFTcKTwp31Mba+Gt0Y12z+otu7ql8OfyoVNE+L/LmDMe8UsUdPsXV2O8s1k7M1lBN2
         c1PQ==
X-Gm-Message-State: AOAM532XvXMKwMD9qV25K0gBXjer5iiRlNNTOlsnMT+ViRcmnTaUUZyB
        v6PGtio1o+tp5+gnAEh1qXI=
X-Google-Smtp-Source: ABdhPJz5C6QHu3jqiwI5UgADjj0R104S9vMSzIKY7LXFfnowlcigNxM9+oEC69FuVzwGTmq93180sg==
X-Received: by 2002:adf:dd45:: with SMTP id u5mr23386681wrm.392.1612853498244;
        Mon, 08 Feb 2021 22:51:38 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:88d8:7242:b455:4959? (p200300ea8f1fad0088d87242b4554959.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:88d8:7242:b455:4959])
        by smtp.googlemail.com with ESMTPSA id u14sm482224wro.10.2021.02.08.22.51.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 22:51:37 -0800 (PST)
Subject: Re: [PATCH net-next v2] net: phy: broadcom: remove BCM5482
 1000Base-BX support
To:     Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210208231706.31789-1-michael@walle.cc>
 <YCHlnr7dFWuECcqv@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <1662168f-06ca-5c20-0d3c-4470d4eec2e5@gmail.com>
Date:   Tue, 9 Feb 2021 07:51:30 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YCHlnr7dFWuECcqv@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.02.2021 02:30, Andrew Lunn wrote:
> On Tue, Feb 09, 2021 at 12:17:06AM +0100, Michael Walle wrote:
>> It is nowhere used in the kernel. It also seems to be lacking the
>> proper fiber advertise flags. Remove it.
> 
> Maybe also remove the #define for PHY_BCM_FLAGS_MODE_1000BX? Maybe
> there is an out of tree driver using this? By removing the #define, it
> will fail at compile time, making it obvious the support has been
> removed?
> 

AFAICS this flag is still used in BCM54616S PHY driver code.
