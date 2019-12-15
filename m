Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5026711F528
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 01:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfLOAMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 19:12:55 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:44635 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbfLOAMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 19:12:55 -0500
Received: by mail-pj1-f67.google.com with SMTP id w5so1343606pjh.11
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 16:12:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=0RC30s9yFGRgkDdXM4gbZmj3PqMHu1PgggwuoQtSeNg=;
        b=DDprIGuo8AMZ1zeRuEC6sWzR/MYQPQfbvP+vM5og9Uzriud/rkJxipzFEsJmZfFOvo
         8RSUYLPA+PxDG3lsj5hySej7+NgJJxNOqiF5De9jsW6tgspyzv66Ejcx8d6zKqIu38V2
         oT0kb4LJCZshaWviEG2u5NAXTIA5iWl3ZTqCTXqwmL2YaHBAIDFVzMgZvPh0SY8RgItY
         ThwoxXz+WR7c2GMuP8coOpVe2nyWC0ATID5OBHdLhQH0cZK2DWXWg/wkTwLsZRF9kGTf
         5ge8boIX01lt1sfPnjSsA8ct//t6NMea9NVht7ryqhJJ+drnQ8Pswr/EBGOZyGG+dUi6
         bGnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=0RC30s9yFGRgkDdXM4gbZmj3PqMHu1PgggwuoQtSeNg=;
        b=KEckMB6Vv0FQFTOsxWdoNnL+33qFN+GSjRbXS+W1FaEoOAJnF+3ZoM09aKrWoBtZwn
         tL7AjImehfmj5KJ421oYphAOadyOPztJkBWpmKO6QbOCl8JbVwWCZPSwfUYOZ0Cb8yiW
         HZOqN27zDk+P9sYGkhUyjYOTjN9TiBplA1IVrfZXFmaUL5JhEB4JdA0pvxtasV6PqRYA
         TByElIT6rGJr8C8MhPUNYjsbpYsRnqX7WskCYKbRlzOTxaKyoZdE+Ejj2yTxoO0BcWyQ
         jaQQe5aqVgekWTMPM/VXV0ZMNWJ1av+g3rjvYRQZY8YwUWWKBdT68McgKso0MbiaCj/R
         1urw==
X-Gm-Message-State: APjAAAXWiuAGVf8exCR79AGBRWSLOFB1x8wTGuXNXYqbWY4WPjoCgHkd
        tVAy5UWpR2EHJq8gmh2SgmNBPeY54A4=
X-Google-Smtp-Source: APXvYqzJEe/AUS45IbGIamAFwXDRSLCCgQ0iQaxCSaatU5Q5bfXsbaMfSLN9WFUU8a9ogrkjZosjcw==
X-Received: by 2002:a17:902:9048:: with SMTP id w8mr7882080plz.294.1576368774220;
        Sat, 14 Dec 2019 16:12:54 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id o12sm17464280pfg.152.2019.12.14.16.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 16:12:53 -0800 (PST)
Date:   Sat, 14 Dec 2019 16:12:50 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     zhengbin <zhengbin13@huawei.com>
Cc:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: dp83869: Remove unneeded semicolon
Message-ID: <20191214161250.38ab7dfd@cakuba.netronome.com>
In-Reply-To: <1576318644-38066-1-git-send-email-zhengbin13@huawei.com>
References: <1576318644-38066-1-git-send-email-zhengbin13@huawei.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Dec 2019 18:17:24 +0800, zhengbin wrote:
> Fixes coccicheck warning:
> 
> drivers/net/phy/dp83869.c:337:2-3: Unneeded semicolon
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>

Applied, thanks!
