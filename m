Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A12CECCF6
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 03:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbfKBC5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 22:57:45 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45488 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbfKBC5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 22:57:45 -0400
Received: by mail-pf1-f196.google.com with SMTP id z4so2219342pfn.12;
        Fri, 01 Nov 2019 19:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=n2h/6gw/JXQvSnG6kqsCmbuh4pHjwKVhPunR1jD3PYo=;
        b=k/lAPfaXO1Z/m7JispyJ0Mi720wSeEGtZWo2EG7jbQ7DBr7kQ0ewnkVgn+W1KS6SVi
         ah5c1RZtP5SQovQ9b6E0LBXVon3Xp4kN73haxEZQaeFk/tvq5cdOJDWwXaz6J3ZGbuOd
         22RKmtHVvqdIbGiqHRCVn0K6bsXENhR49sNtN+VJxZJvgatxwc4t+0uxIlYd0qfN6Mx3
         Mv/8dg8sfZwRr+6C1TuvsX+8/wmTlD3wi29N7f4Kd2BPcGiso0eg7/g95TSa1eM3+Z97
         IHr1bHsnR9raSb8aJsedM9v46cKGSc/NwOeF45Luqr/Uo1VXjKWnyN/I7xp7F94fz5O4
         9TNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n2h/6gw/JXQvSnG6kqsCmbuh4pHjwKVhPunR1jD3PYo=;
        b=r7PiQyYq4f5SrHl7ad4Gbg5Lndoj3/FTECDdXB2+RP15tfpprkR/CqNyiWGuJRwHvC
         H277PpRn7axbIQ1cTCcdUnhA4SBeYWCh71FdOGWQc8www1spzktLOO6z8XHxAWa0G5JA
         z/QKjFS9SB8ki4e8P4NMxqLRWbqtQFcUHq3H0rLFgro3nz6p/FYEvSvQD8yvH8j8+enx
         I/QExxa5e6kAXexjr/JDWv2lQxperq1GQ0NQuRS7fcFUKMMu2gslsjSZd4pijP9+S7fz
         5k1cNkpO6OBpPkOmZSalzeaPSKcy8SBkwhlJe5V8J/UJCxFvSs3cug4cQ3uJr8cGXz6G
         0eYg==
X-Gm-Message-State: APjAAAXDv27Kq4h0WhJzYbtoLv24oVNKHGtyWBXWK4Lx4JEcVnlRhhzd
        bLnXJvJudn9bawYKa08iyQ7wONii
X-Google-Smtp-Source: APXvYqwPkVI4cApDiM5uPUR23Hj6kbJM6kTPVWlhb0LBkdhVDSHEs6qzMeVX23pTV8oJ8FuEB7sYLg==
X-Received: by 2002:a17:90a:2623:: with SMTP id l32mr20309858pje.70.1572663464484;
        Fri, 01 Nov 2019 19:57:44 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id m68sm7995310pfb.122.2019.11.01.19.57.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2019 19:57:43 -0700 (PDT)
Subject: Re: [PATCH 1/5] net: phy: at803x: fix Kconfig description
To:     Michael Walle <michael@walle.cc>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
References: <20191102011351.6467-1-michael@walle.cc>
 <20191102011351.6467-2-michael@walle.cc>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <11e4c62b-6f63-5450-8335-1713040a9f13@gmail.com>
Date:   Fri, 1 Nov 2019 19:57:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191102011351.6467-2-michael@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/1/2019 6:13 PM, Michael Walle wrote:
> The name of the PHY is actually AR803x not AT803x. Additionally, add the
> name of the vendor and mention the AR8031 support.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
