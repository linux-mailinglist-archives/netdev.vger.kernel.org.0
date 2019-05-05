Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8717B1422C
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 21:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbfEETvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 15:51:24 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34945 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfEETvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 15:51:23 -0400
Received: by mail-wr1-f66.google.com with SMTP id w12so1089575wrp.2;
        Sun, 05 May 2019 12:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pWv2bFsADdBbZMiNuoGFOaXbQXtQ9Pgo1BAcL/o+Zwo=;
        b=YWm6HyL6RFTAtxtxfXbxaRqZABKfoTPBuvHTsj7l6HD6NDAckXhO5YUWeD2CPsQsDs
         2SORFQdZY22LHDKdS799NgNrGjnfGz4jkYuJzvVyqgnb9FeFiWx7+/hFrzTOQ8D8ziUk
         hRbSstlZwzGwiA+YKwT0hkvyE6pXfTclxtH7d3fKFsIHhXOsNjfNb/bhdEXv1yHhN3yT
         tiXN593D1BhK4bKRc0okphmla5V+xJ/qEz62lTBZlpndrOO0hiAB/aG7Y0LZi54f5hBn
         exFcz4F3dGACfHj1bHK5gNqUvTVh+Fv3ZmxMRjkx/omcAiAdJKQ2wvGkHv0AhFD6Ytld
         aWTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pWv2bFsADdBbZMiNuoGFOaXbQXtQ9Pgo1BAcL/o+Zwo=;
        b=kbF6M8duV1o88RUJg0tfgy02CP4fNMnulZhjp/45e/cJ3tKS8QQ2VII0iySjqdOxMa
         hZ+OTdDaCB3t+yKHaERGn3zCEvrnzWWbJ+18pr76l0HYCT4owxV4f/pgwd2ElVieywjf
         acuDbsKjC+rdwVxsnDdl0/DgTiwdVl0NwhAnT13ozaiK/srlpeN3RVNGuqOf+BJ9RA1t
         EPAQEZ2kVenXvBvHYSOKEfdohwEA9X2ZT7dMvpWC9vZdXauwpkEOXrFbXq4VzZIEvlis
         H+liJLWWFMst9AMlYK0OMMQydQpi7XGG8ddjzdT7yORmpRw4mowyCN8GQmMFo220zIqU
         KXIQ==
X-Gm-Message-State: APjAAAWS89Vkf5HsXptfm6iHjwSv+JTtnLhxltMzGjNiGSF3UWPEJj+1
        b7K6Ka34qDcyrOihySh7g5Xyya44iwA=
X-Google-Smtp-Source: APXvYqyvFtzWaIQnTOq7UkvPKuIt7nxbEUOVKPSPVuIJcbY5zUHXtDtphPFMio46ZFNPVTAS6YRNsw==
X-Received: by 2002:a5d:6a03:: with SMTP id m3mr10871317wru.135.1557085881549;
        Sun, 05 May 2019 12:51:21 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:d9a7:917c:8564:c504? (p200300EA8BD45700D9A7917C8564C504.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:d9a7:917c:8564:c504])
        by smtp.googlemail.com with ESMTPSA id z5sm18998739wre.70.2019.05.05.12.51.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 12:51:20 -0700 (PDT)
Subject: Re: [PATCH] net: phy: sfp: enable i2c-bus detection on ACPI based
 systems
To:     Ruslan Babayev <ruslan@babayev.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     xe-linux-external@cisco.com,
        "David S. Miller" <davem@davemloft.net>, linux-i2c@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20190505193435.3248-1-ruslan@babayev.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <085da32a-8c3a-bf91-38b0-4802375ae414@gmail.com>
Date:   Sun, 5 May 2019 21:51:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190505193435.3248-1-ruslan@babayev.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.05.2019 21:34, Ruslan Babayev wrote:
> Signed-off-by: Ruslan Babayev <ruslan@babayev.com>
> Cc: xe-linux-external@cisco.com
> ---
>  drivers/i2c/i2c-core-acpi.c |  3 ++-
>  drivers/net/phy/sfp.c       | 33 +++++++++++++++++++++++++--------
>  include/linux/i2c.h         |  6 ++++++
>  3 files changed, 33 insertions(+), 9 deletions(-)
> 
Regarding the formal part:
- It should be [PATCH net-next]
- Commit description is missing (scripts/checkpatch.pl should have complained)

And maybe it would be better to split exporting i2c_acpi_find_adapter_by_handle
and extending sfp.c to two patches. If Wolfram acks the i2c patch, then I think
the series could go through the netdev tree. Eventually up to David.
