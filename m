Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8D16224808
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 04:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbgGRCYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 22:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726742AbgGRCYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 22:24:49 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCCC8C0619D4
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 19:24:49 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id k5so6170696plk.13
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 19:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WD4Yn6ZYofTSv8AYZsmKg+hfRtjy504vGs3OarZ+xWg=;
        b=dGNwG3dG3KWntv8LksOuvLYs/FZ6HZ2ujFXBdm8RmeG2YWTpdJUh2Rpjx4ZhcehMpX
         nYf3/DcY2prfd//j6pfKNvzNbSWn5BCpyhQB/JO4yMXyvSBmQcpFvFhA4m8eqCyNIEwI
         +WuXfvgqlzMv1fjIVTu0XCZTnyECqmb5ah+hZuga93hJ7tTZ4uJXvssK+3jjr9WCPfL0
         KLmoimjtNd1hRfQvuAEWEKE4cLHYwiYnEpnTIhIqqXSTLPzBefHX9EyG1GuvAoMxMFgF
         1sppj87TGI0RJrOkwz1BeGVz2+wG5cGwoP+M/hrnt3uq8x6fNtpFpWBTelCQTL/lWjSj
         HwSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WD4Yn6ZYofTSv8AYZsmKg+hfRtjy504vGs3OarZ+xWg=;
        b=QuEkNCaPnwo+pQN2LBGqjhAkLUxw2d72djJ9M4vxVvGSN0ztTwI8g3sPQPrusinQec
         6k+xwalQZtMPPkQ5wlKt8+tDHMQ1UGKGlPB4nS84Vm0q9hrxbJtLqK+iU/tVt0V6dpo2
         u+1V32MSD8V88QRB37hfWZ76MYEujtKCpEVpEUQ7+NNcbTwSa9CbcWKNu6N/bWgX/cC1
         bN+slfjfUbNC4trrxaZMkcRX5p+oeMd8R+qD/OiMsu/LIZpOoxMbxzRpbrkPy82CQi0w
         KE/4NC1Xf0TpodmWF+APPNhONqq3046TTvhF84tKMcYCL+Wtuxj3ucmW9GxeJFsNA7UL
         hIsw==
X-Gm-Message-State: AOAM532FPXJIm2t5pO0aBRiUC3UcV3aILR1M3Az5t2rgiiZ5yyG+038Z
        9rtuPU2y1dH4zEviunZogAI=
X-Google-Smtp-Source: ABdhPJxYhonA9Eo2KZ2xluHY1HpmElUSi2vVmiDn1Eu9ewh8lJfYF4ibi7jH2KB0iohTVcy21/mVYA==
X-Received: by 2002:a17:902:9a07:: with SMTP id v7mr9962638plp.312.1595039089402;
        Fri, 17 Jul 2020 19:24:49 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id b205sm8536451pfb.204.2020.07.17.19.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 19:24:48 -0700 (PDT)
Date:   Fri, 17 Jul 2020 19:24:46 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
Message-ID: <20200718022446.GA4599@hoboy>
References: <E1jvNlE-0001Y0-47@rmk-PC.armlinux.org.uk>
 <20200716204832.GA1385@hoboy>
 <874kq6mva8.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874kq6mva8.fsf@kurt>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 09:54:07AM +0200, Kurt Kanzenbach wrote:
> I'll post the next version of the hellcreek DSA driver probably next
> week. I can include a generic ptp_header() function if you like in that
> patch series. But, where to put it? ptp core or maybe ptp_classify?

Either place is fine with me.  Maybe it makes most sense in ptp_classify?
Please put the re-factoring in a separate patches, before the new
driver.

Thanks,
Richard
