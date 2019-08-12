Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7022E899CE
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 11:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbfHLJXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 05:23:25 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:40639 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727429AbfHLJXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 05:23:24 -0400
Received: by mail-lf1-f67.google.com with SMTP id b17so73757672lff.7
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 02:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=h/eO9z7ZUtRtxGDaZWfd3b9YhPpdN4udgv48/b95wLA=;
        b=ACXgnmVAqGXCZ3zQfBhm0+YxChQPRjh8JLSMAsSNXo6mFuwhFEvzbJ1WG1egB6bTdS
         BMKOJwnBekgVTSBrByCJroPpds7OmBLpf6D65zMMgPz3gdtHzRqfShftdpQF08lja6m6
         CkNpJYy6DdIpsaJsxqxHb737uPZBHwR8FK75yGy0KuUEeBn9cYiX13pWTrKSrShrSi6H
         ObJ+fExDNdRThn1ktJIZzMjKf2nb+AS2wLWOkp0TQda+r2NjBVodLEH6zszCmODCXbNE
         D+UbWGkxB8Tz7fNLXC5riFLLEZgPqGgTghlOXH54Kdrveqts1l8zAoNSUt7bNDzaKhiZ
         nK2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h/eO9z7ZUtRtxGDaZWfd3b9YhPpdN4udgv48/b95wLA=;
        b=DQ8pGho96to0PCC7chpe5FxdIxuQizUACFbO+u/6v+TRYar0urlhviNu/6gyxVhudS
         1+ihRU8UPjTgveuQS6+F5TOk5ynG5UMr8RRpPCGiPzGxqooA+Cds2XtSnVvwZckQh4Os
         m5msNu8lAlqAADR5cM9PBHRwZ0/0sUmBJmHZqLeWPUiTgpbqj7z+gUovaqNyvRagvAHc
         +FxTWFj1lJANhbjNCBO+nlvdhfNz3IVGQiHGWCCLw2f3OTqKEs9AoCzVaNZe+RbM0Ryf
         vW8Nveyta92GuoJy5L85e4Zk5pYZzU/w+tbet4jcSI5sxzu2aJKUb1l0CR2nDJCJjcJX
         ORyA==
X-Gm-Message-State: APjAAAVWfmjnpbRgnFvkGFj+7p3VL+VNNMzPxkfu96IwY76L/FwCOIh3
        6roDv1QJlP/AnmlDXpYBVtFREw==
X-Google-Smtp-Source: APXvYqztf5VYToiiPPUxUL1v26JDTCmqq/2vaS691jNACCTHX/WzNzQiCu1qVkmvSU8Iep7kzFypHw==
X-Received: by 2002:a05:6512:48f:: with SMTP id v15mr19532306lfq.37.1565601801936;
        Mon, 12 Aug 2019 02:23:21 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:292:160c:a178:b4ac:b55d:ad7? ([2a00:1fa0:292:160c:a178:b4ac:b55d:ad7])
        by smtp.gmail.com with ESMTPSA id d16sm2817717lfi.31.2019.08.12.02.23.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 02:23:21 -0700 (PDT)
Subject: Re: [PATCH net-next 1/2] net: dsa: mv88e6xxx: fix RGMII-ID port setup
To:     =?UTF-8?Q?Marek_Beh=c3=ban?= <marek.behun@nic.cz>,
        netdev@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
References: <20190811150812.6780-1-marek.behun@nic.cz>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <232f5c29-748f-1fd3-d9f5-1b13acab46d1@cogentembedded.com>
Date:   Mon, 12 Aug 2019 12:23:16 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190811150812.6780-1-marek.behun@nic.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 11.08.2019 18:08, Marek Behún wrote:

> The mv88e6xxx_port_setup_mac looks if one of the {link, speed, duplex}
> parameters is being changed from the current setting, and if not, does
> not do anything. This test is wrong in some situations: this method also
> has the mode argument, which can also be changed.
> 
> For example on Turris Omnia, the mode is PHY_INTERFACE_MODE_RGMII_ID,
> which has to be set byt the ->port_set_rgmii_delay method. The test does

    s/byt/by/?

> not look if mode is being changed (in fact there is currently no method
> to determine port mode as phy_interface_t type).
> 
> The simplest solution seems to be to drop this test altogether and
> simply do the setup when requested.
> 
> Signed-off-by: Marek Behún <marek.behun@nic.cz>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
> Cc: Vivien Didelot <vivien.didelot@gmail.com>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: David S. Miller <davem@davemloft.net>
[...]

MBR, Sergei
