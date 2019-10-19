Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC3DFDD8DF
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 15:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbfJSN4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 09:56:42 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36775 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbfJSN4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 09:56:42 -0400
Received: by mail-wm1-f67.google.com with SMTP id m18so8633331wmc.1
        for <netdev@vger.kernel.org>; Sat, 19 Oct 2019 06:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=ExyoeiJ4aDElpreJkL3GaXDgL+JJ0SrcQsHddgHXq1I=;
        b=Eg2gmCrXhzG/r7+X6+kfDK9ZL30VPTb4T8iLW3QU1ecb4UkWGj+ucikZO39pAgv++J
         un3tmYeHQGAHYvZGyNPHRQQVzCuqV/t/EtXg7rhJZEWfKlLCHU8KnQpsV8W7seO92N9G
         J5yiQO5lJ6qyggP96pTQzSAvEwDjIAp/YnDHiZERMGSUmr+wfOsKrFHZkP3PVyoWEaV+
         T7ChhvXcZe5A3Hh2k1OqLjujjjgLA7GWW52xD7Hg0AeOXanyAmkvT1QPxrGAdgZjvv+m
         i/0g3zrui6xHjWoR7PbSn7kfx/ooHXCW55LZu/4iSr/VQqJ5qhIDqPmOpGp2ihqfCZmv
         DE9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ExyoeiJ4aDElpreJkL3GaXDgL+JJ0SrcQsHddgHXq1I=;
        b=hYjbnOUWbCin4SMJZ5mXoEDYxeszJLeRSoIiaOi22SLSg3xxOBGIoIz/O7deRDCUYA
         4NqmjByXPwoLRmcDTYBMPrplKaLzYmJfh7tZJpa7HVIPqR3z1/qqxP7mF6ntxJUoMyU1
         YZLYgnTt55HPsfk2fyGlRS9h/rH+nLc+AdN4ffopucSeAMXiA5M2SMWDS96/r0lqut2+
         oIYoymZYGbWvyeBUvcytU1M++7Qm/54GZDq9xCe82liCNNw7KE/3CHYZSUHB2BrYnXRb
         tqac3ZJkArBBKx5yE7EqW64EKZ8lE3VePlJ/oSQm5QsaGdoVdGK/JHvFcNjFxYzQr9ke
         8Y7A==
X-Gm-Message-State: APjAAAUQFdyKKBMka/8VJTZwpnhzS9Xaz0SOBfZ2qg3MwKNqQ0YgpnbP
        iGWLp9fDET6WvGQ3T5YeO+wjFEeP
X-Google-Smtp-Source: APXvYqxWp898GLMHVHtfybnZYeAnlcXpX8QGQhWmmgho3/owL/9y/oBZVyT5DLCtq27tEHy3IEgGMQ==
X-Received: by 2002:a1c:234c:: with SMTP id j73mr9092586wmj.51.1571493400400;
        Sat, 19 Oct 2019 06:56:40 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:cd3d:5fcd:4de0:e061? (p200300EA8F266400CD3D5FCD4DE0E061.dip0.t-ipconnect.de. [2003:ea:8f26:6400:cd3d:5fcd:4de0:e061])
        by smtp.googlemail.com with ESMTPSA id z9sm8903989wrv.1.2019.10.19.06.56.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 19 Oct 2019 06:56:39 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/2] net: phy: marvell: support downshift as PHY
 tunable
Message-ID: <85961f9a-999c-743d-3fd2-66c10e7a219e@gmail.com>
Date:   Sat, 19 Oct 2019 15:56:34 +0200
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

So far downshift is implemented for one small use case only and can't
be controlled from userspace. So let's implement this feature properly
as a PHY tunable so that it can be controlled via ethtool.

Heiner Kallweit (2):
  net: phy: marvell: support downshift as PHY tunable
  net: phy: marvell: remove superseded function marvell_set_downshift

 drivers/net/phy/marvell.c | 176 ++++++++++++++++++++++++++------------
 1 file changed, 122 insertions(+), 54 deletions(-)

-- 
2.23.0

