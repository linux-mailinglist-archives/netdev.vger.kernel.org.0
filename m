Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED078D2EE3
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 18:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbfJJQut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 12:50:49 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:32858 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfJJQut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 12:50:49 -0400
Received: by mail-wr1-f48.google.com with SMTP id b9so8792565wrs.0;
        Thu, 10 Oct 2019 09:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=N67GlwHUX6GtWi46USbMqkhjoeZO4P1qdN1iV3c4afE=;
        b=qflmHPMW5aXypqwCgOilRC5ytwg1yWAP5C5dwjaCHPjSyGHDExALRPgWUvkIsaWEyK
         Zn3o///qtDGQl6a3RK75f6H/h/CjBdDb/4RLPA1hQqeR9N+JG1UC9y5ISMg52lRVJz8P
         cXIU7qtl8jd1p6xWDhsm63vSbrEguoaBU3q4V7OMtw8zYKBWgKvMbW7JXwfOOzd347iT
         MgzLhmbr1NrUogstC8eDjOo84/H7apLiCJBQ/hVro3eAGldAULZ9JDa7aAz2vGsEuxP5
         m2Ty9hV6PrCf4vUj3380RqBNcbRnBalk2Xx8nPLE1ieRvp5X1ZIgD6uWfAmgtEI1VZS+
         xIlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=N67GlwHUX6GtWi46USbMqkhjoeZO4P1qdN1iV3c4afE=;
        b=PhuuB2nooqaTugC45/LdgoDK0gKR9R28hYOq/omP3gUXjUT051vquZaDIafDJg6s2r
         i6qHEUkciOF03kcu5dFQCjTY650lnAekuZe7sutkrfnaOe04jRjRlvMFTvCjf+uhQnKA
         Hudog8o+hXBmwK4wvHBakmk2sX9ALAKye+2ygOr4o/lmA25ajTJbcQb5rTCnVuHn7F5+
         Em2XdfAq8taB9Bl7+2rNuwTDJycIXEbHp/7cbX5nikh5k6gFk5LatKyl5W1VQ6fbSoRu
         vscY45sNiJp7YClqFqzhS7dUdvEfSCDRu4UwF4PWEVYTHND0RFG489Kec+BHRuU28iP8
         NzbQ==
X-Gm-Message-State: APjAAAWQTBUhzcET5p2jcg1WhbNzH38pBgC403limeVaMCb9jfiVlYtb
        8Tu43GZurhZWpjEnpvt2NZo=
X-Google-Smtp-Source: APXvYqxPDPYHTErerTKVW/UmfLwO9xJ9NzreaiuR07FLKp5Ho8RyNEghqgv16DMhtyV/n1v9/y6gyw==
X-Received: by 2002:a5d:6b52:: with SMTP id x18mr9302702wrw.66.1570726246497;
        Thu, 10 Oct 2019 09:50:46 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:c8c2:fca8:3f74:726d? (p200300EA8F266400C8C2FCA83F74726D.dip0.t-ipconnect.de. [2003:ea:8f26:6400:c8c2:fca8:3f74:726d])
        by smtp.googlemail.com with ESMTPSA id t18sm7160199wmi.44.2019.10.10.09.50.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 09:50:45 -0700 (PDT)
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Module loading problem since 5.3
Message-ID: <8132cf72-0ae1-48ae-51fb-1a01cf00c693@gmail.com>
Date:   Thu, 10 Oct 2019 18:50:38 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luis,

as maintainer of the r8169 network driver I got user reports that
since 5.3 they get errors due to the needed PHY driver module
not being loaded. See e.g. following bug ticket:
https://bugzilla.kernel.org/show_bug.cgi?id=204343

As mentioned in comment 7 the PHY driver module should be loaded
at two places in the code:
1. phylib when probing the PHY (based on PHY ID)
2. r8169 driver uses the following to ensure PHY driver gets loaded before:
   MODULE_SOFTDEP("pre: realtek")

The issue doesn't exist on all systems, e.g. my test system loads
the PHY driver module normally. On affected systems manually adding
a softdep works around the issue and loads the PHY driver module
properly. Are you aware of any current issues with module loading
that could cause this problem?

Heiner
