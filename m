Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1B515D350
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 09:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbgBNIA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 03:00:56 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45785 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728773AbgBNIAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 03:00:55 -0500
Received: by mail-lj1-f193.google.com with SMTP id e18so9616440ljn.12
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 00:00:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ntCZaBsMrzqa5Pcjo865ox0f/FJUUehyZXzmR3FEBlc=;
        b=AIyE3NgmZsK4cm2YpyethNE4ypvl/1LFMdnClKswWaNJVNMoA5sEc9XNdCXCPgm+8n
         2dBLwigR7gH8vR1iBBfclVbdOSV/JwsOGypLeJOarnWHPH5rpEHOu94Kst4Y7kAsHb/5
         wl8gXX9oMJwkuFjCYm58qxp383PaQj+G7lLROfdfXbIE5f+ED1nJKYpOn49hT6fnvb/f
         qVKeFeqlITKOQt6obiCx+to4w4505nkyfU760eVnB22Lq/NbuSlNxQvegDmkQf9/GlrO
         xlZ3dvVxfwkj/KM6QKucKwxUlTsaBzW7qao8FebrJLzRTVIbRUVtomWj0TdWCjbRar6T
         AQsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ntCZaBsMrzqa5Pcjo865ox0f/FJUUehyZXzmR3FEBlc=;
        b=IH16daTDIZWK4jKmgArZF2yq1C+fNv0D7QvKEXIDdMOxz2NnbW4etn0IDI9pP8ly+7
         Ob5tJ6LcsfsQTDNMMpcR1/M5IOzC7i9MGbwsPmOy5tJ2fqKDEQLAvHrAHVpxTjdE6HMq
         yNvszGtO/xA0LV3q83CugSlziQJcgGBwJI57s5muwXxTcml+vghCKndwAtTVrasuPzW8
         BMgh186MyI1Yj6duukKz0/6N9HvmqY7kzBLfxbii//hB8Cm2kv+U2zluD6GTJrKGZch/
         lHmbsawjd++gJ6nQUvzWbf4KfVAtRI1FJviFYOYiewXVahUpWXSe+wr5jfech4WinW9Q
         XcZg==
X-Gm-Message-State: APjAAAWhJdcWZ0ypSxXpoUKg7Tf3PsmnmmQMCt0O+vCtxFyhVrAvlBVg
        RHhVb5NSoTGVQM6aMpcV370R3w==
X-Google-Smtp-Source: APXvYqy9FHHb0Opg6Sksf2GOu5P9zoiGi/EMgpEFOI2LsKVccVqMz8BHaEb+ouXpGTOvJd7U8y5bGQ==
X-Received: by 2002:a2e:a361:: with SMTP id i1mr1228389ljn.29.1581667252389;
        Fri, 14 Feb 2020 00:00:52 -0800 (PST)
Received: from ?IPv6:2a00:1fa0:83e:95a1:50fe:6694:662:5f22? ([2a00:1fa0:83e:95a1:50fe:6694:662:5f22])
        by smtp.gmail.com with ESMTPSA id f19sm3070356ljj.50.2020.02.14.00.00.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 00:00:51 -0800 (PST)
Subject: Re: [PATCH net] net: dsa: b53: Ensure the default VID is untagged
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     olteanv@gmail.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
References: <20200213191015.7150-1-f.fainelli@gmail.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <f045f75b-0e8e-7143-04e9-b0d4894571c2@cogentembedded.com>
Date:   Fri, 14 Feb 2020 11:00:41 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200213191015.7150-1-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 13.02.2020 22:10, Florian Fainelli wrote:

> We need to ensure that the default VID is untagged otherwise the switch
> will be sending frames tagged frames and the results can be problematic.
                   ^^^^^^^^^^^^^^^^^^^^

   Perhaps just "tagged frames"?

> This is especially true with b53 switches that use VID 0 as their
> default VLAN since VID 0 has a special meaning.
> 
> Fixes: fea83353177a ("net: dsa: b53: Fix default VLAN ID")
> Fixes: 061f6a505ac3 ("net: dsa: Add ndo_vlan_rx_{add, kill}_vid implementation")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
[...]

MBR, Sergei

