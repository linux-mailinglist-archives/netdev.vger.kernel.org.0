Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8009A1BD378
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 06:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgD2EQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 00:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725497AbgD2EQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 00:16:41 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701E6C03C1AC;
        Tue, 28 Apr 2020 21:16:40 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 145so467374pfw.13;
        Tue, 28 Apr 2020 21:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=33KWTafxGeio2mE7vQkUPBKD+vnrQN9Vu13t8D5iy9Q=;
        b=cm9wtE++qMb+UN8PPrekmIPAzWDkf4AOXQcxm2owZW0UrdNRYDeaLzSNyo+vKU/Lgh
         Jk0wmX7iN6xD28TZtGczjPpqx0ory7iTLtV7pzXZc3Yj5GHABfLJzReyfU+gsheQk6d2
         x/h5H9SwU7lHOE8sduT7GGzxdwpPkvmWmCWk7REqghN7jY3O8mFIdrhwEivG7WQIkD/z
         B/3CC8f1sR9J/xxjDkojO5JYGjGlW9h7Q9XBCVuHi6eHb/uQflNHcIguHGvfEX45n3Q5
         Ss5CzZQTfOFaBPJ8uPuJoA9BVDF6wC6VpRzGjrssDRLninW0dWXR9q/oz0oT5DK9SffE
         MDAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=33KWTafxGeio2mE7vQkUPBKD+vnrQN9Vu13t8D5iy9Q=;
        b=d8cNPOHtU6d13TMOtAwOHkoyS3/Gf9kSvrZ982RHEAMYBLAR7wz8T6YBzBqAoXZxKb
         CPQhQ8PE4JC2i/ORYSv2ROF62BF7yZ8Lxn8Wpp/RykROwYTuf29cQHEKIcxNUA+ahM7x
         OHsYykYWZsdcz/JVcMNa7wBvZluTyQkVLX69D19aad9FmOLpNRzUenuSUmq7NDdpOnUz
         uoP+W/z8RqSXiwRq0twzQiheMSxEGYsY47sYRpc+Mq7wqohRBADMt26sfBL4ZlOBbuio
         E7yl7nMqKX5fG6pS2ZIMFcdXmxgDhKsp7xCXg5Lfr9hDyOQmLsMg2fAwnhBhRomkatyp
         mAUQ==
X-Gm-Message-State: AGi0PuZBqTLAFUWnDWVLo1btRqxKr1j6kVhOUjrnKrGBLqIXcddlvfWT
        sQLoHevIzPPPw7tWla2moH5WALes
X-Google-Smtp-Source: APiQypISyFo533B80OwtY+0HHq25LVfsLJk5M1W9XXaGiZHAYeeXeqy0SHTiUc+H8x2I2a+L67ewBw==
X-Received: by 2002:a65:58c4:: with SMTP id e4mr32549273pgu.61.1588133799894;
        Tue, 28 Apr 2020 21:16:39 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u5sm14961666pfu.198.2020.04.28.21.16.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2020 21:16:38 -0700 (PDT)
Subject: Re: [PATCH net-next v2 4/4] net: phy: bcm54140: add second PHY ID
To:     Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
References: <20200428230659.7754-1-michael@walle.cc>
 <20200428230659.7754-4-michael@walle.cc>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <40b41061-ab48-ab23-9b66-4ad14b000f5d@gmail.com>
Date:   Tue, 28 Apr 2020 21:16:38 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200428230659.7754-4-michael@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/2020 4:06 PM, Michael Walle wrote:
> This PHY has two PHY IDs depending on its mode. Adjust the mask so that
> it includes both IDs.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

For future submissions to netdev, if you have a patch count > 1, please
include a cover letter:

Thanks!
-- 
Florian
