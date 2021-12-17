Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1CE5479759
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 23:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbhLQWu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 17:50:59 -0500
Received: from sender3-op-o12.zoho.com ([136.143.184.12]:17833 "EHLO
        sender3-op-o12.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbhLQWu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 17:50:59 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1639781445; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=JcjzA91BB41YA/SFPV9ujw/FPRZzCYfAHNAaKWJP1FYTot8X9Cfj9IAF00oOpbJxtpXJZNwoLdMoKAXY3w9f6qVtRawLRDNUCcb3VUjCRjc6dBW/oGmynq+cfLjmLn6PY7vq2aHNVZDpTlYE4JhqHB8vP1gydBJoYz87iT5k3KY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1639781445; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=dXN8AWNdCGAr04ZhcOdQi9JnsXuwJzjYT1Lq9y8zdiM=; 
        b=c9fLgCpukQtLGA/uqWZrPDJBrFiPOiRB5kDZpp1ymnkZm0j8czbX6HU98XVqDkQxvo/2Po1rzJ6zytfOz1cAkwmm3wNKY7YInK6y7pqwcTnzYWJ2/NpjtCEi1o7K1yrbKa4+2D5rKmadi4CU8XuZ1hugNgi15tQtesVTbvRsMIw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1639781445;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=dXN8AWNdCGAr04ZhcOdQi9JnsXuwJzjYT1Lq9y8zdiM=;
        b=Srv5rlGJzpHT45dYnFOe+GYvqHKOMMGo+FX35gjn/38DCoL0m/MEt4UNihh8CkRZ
        yd0SeDvrOVaKonCnSLm710BM/JQneuqZKsGNPOn2ZnlVdmyan0Y0qfAqPhnla/ad3qd
        S4NhpvULkxU5DLrnnkueNM+eG7D6shlIMdTN4+Vc=
Received: from [10.10.10.216] (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1639781444196846.549067901622; Fri, 17 Dec 2021 14:50:44 -0800 (PST)
Message-ID: <fc3405fc-5601-f228-8775-2b7090e9bc1c@arinc9.com>
Date:   Sat, 18 Dec 2021 01:50:39 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH net-next 07/13] net: dsa: rtl8365mb: rename rtl8365mb to
 rtl8367c
Content-Language: en-US
To:     =?UTF-8?Q?Alvin_=c5=a0ipraga?= <ALSI@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>
References: <20211216201342.25587-1-luizluca@gmail.com>
 <20211216201342.25587-8-luizluca@gmail.com>
 <1fbf5793-8635-557b-79f2-39b70b141ba3@bang-olufsen.dk>
 <CAJq09z79xThgsagBLAcLJqDKzC6yx=_jjP+Bg0G4OXXbNj30EQ@mail.gmail.com>
 <15fa5d93-944a-0267-9593-a890080d6e02@bang-olufsen.dk>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <15fa5d93-944a-0267-9593-a890080d6e02@bang-olufsen.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/12/2021 15:15, Alvin Šipraga wrote:
> Honestly it seems like more effort than it is worth. The comments at the
> top of the driver should be sufficient to explain to any future
> developer what exactly is going on. If something is unclear, why not
> just add/remove some lines there?
> 
> Since you don't feel strongly about the name, I would suggest you drop
> the renaming from your MDIO/RTL8367S series for now. It will also make
> the review process a bit easier.

Agreed. Having the driver refer to a real model name, rtl8365mb in this 
case since it's the first to be supported, than an imaginary one makes 
more sense.
