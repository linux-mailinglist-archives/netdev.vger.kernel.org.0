Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00317310C5
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 17:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfEaPAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 11:00:19 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33588 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbfEaPAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 11:00:19 -0400
Received: by mail-qt1-f193.google.com with SMTP id 14so1251940qtf.0;
        Fri, 31 May 2019 08:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=Pt2gM/5yUncpxKqP4ypDT20BNXPN0OQd5ycdgB0cHWQ=;
        b=YCv4XGjTPMN6Vp4EFQYMlpQ3Wy7Krff9/cJZptLmQq+Wpq5AYXbBa0saN2rxEIFMj/
         vB6jZgIkHXRG9uAzI+uge3egzEXm6W6vCbG0Roa0/r2qDAUkQUZq5/O2jzdaAc+/WPwF
         MeYTvAsDESCKWTQJQwFBnWtfcrRGx2qH3UKivaCE23WGV7wzuw0HrOo+sWwYWWHR1kQ7
         wOik6vD6KjK4V7DBq6RmRfrVkQiOVZ0CeYynEBbLVoXjVFkljOTYdXLW676kfdFcXT5L
         IMWj7kINabjW79YwJe69r0OejQ+jys2AdmC8Ms5Y+Vh0djyoMG+4x6mPAy07/FWeDsvW
         K+2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=Pt2gM/5yUncpxKqP4ypDT20BNXPN0OQd5ycdgB0cHWQ=;
        b=aHEHHWXcEkzbuvQIgdX4Wo7QKo6zwu7YczlnxaV4+MARRGmvnCaj+O8O3WbP2gp9qJ
         WNrvKsZ9gC3feF5pTjUkg2BJg9raIHGmBFOCQ8gqSG7Thg3WE9oTOTWeTXEXIdeeI1/v
         vcEwio5SCtZGKGBt7LX55K03auZBoGb9aG2PRLqcUlFEf2E2Xyt6fhqNuENXn+1SlCs0
         JEnOw9KXqBI49M9PkX3tTAZ4/RkEw8UBvO49BLFy6yO3/NDwP5n30Seib5MlOKq+P/Fu
         fIz31dIfr66251KSiImrnhMwjkDy2eyiDEKCaU94Qm+3xPGbjBqzMaR8gR+knSc5TDkO
         /aXA==
X-Gm-Message-State: APjAAAWMDRFoRz0PL8LixAyCfcY8t9H5vZkJihTVIkG8Wf7goPpvZ0Yv
        YBI5waE7iL1q6CTNEOB2gMY=
X-Google-Smtp-Source: APXvYqyw0R4cVUkGKx3ApE3NZSYOIzQAoQk107EtCqLDlzgCmhfB0q5yLhibAaWs+eMagzT6pXlspw==
X-Received: by 2002:a0c:b50b:: with SMTP id d11mr9064245qve.98.1559314818254;
        Fri, 31 May 2019 08:00:18 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id s125sm3157675qkc.43.2019.05.31.08.00.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 31 May 2019 08:00:17 -0700 (PDT)
Date:   Fri, 31 May 2019 11:00:17 -0400
Message-ID: <20190531110017.GB2075@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: avoid error message on remove from
 VLAN 0
In-Reply-To: <422482dc-8887-0f92-c8c9-f9d639882c77@cogentembedded.com>
References: <20190531073514.2171-1-nikita.yoush@cogentembedded.com>
 <20190531103105.GE23464@t480s.localdomain> <20190531143758.GB23821@lunn.ch>
 <422482dc-8887-0f92-c8c9-f9d639882c77@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nikita,

On Fri, 31 May 2019 17:46:29 +0300, Nikita Yushchenko <nikita.yoush@cogentembedded.com> wrote:
> 
> 
> 31.05.2019 17:37, Andrew Lunn wrote:
> >> I'm not sure that I like the semantic of it, because the driver can actually
> >> support VID 0 per-se, only the kernel does not use VLAN 0. Thus I would avoid
> >> calling the port_vlan_del() ops for VID 0, directly into the upper DSA layer.
> >>
> >> Florian, Andrew, wouldn't the following patch be more adequate?
> >>
> >>     diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> >>     index 1e2ae9d59b88..80f228258a92 100644
> >>     --- a/net/dsa/slave.c
> >>     +++ b/net/dsa/slave.c
> >>     @@ -1063,6 +1063,10 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
> >>             struct bridge_vlan_info info;
> >>             int ret;
> >>      
> >>     +       /* VID 0 has a special meaning and is never programmed in hardware */
> >>     +       if (!vid)
> >>     +               return 0;
> >>     +
> >>             /* Check for a possible bridge VLAN entry now since there is no
> >>              * need to emulate the switchdev prepare + commit phase.
> >>              */
> >  
> Kernel currently does, but it is caught in
> mv88e6xxx_port_check_hw_vlan() and returns -ENOTSUPP from there.

But VID 0 has a special meaning for the kernel, it means the port's private
database (when it is isolated, non-bridged), it is not meant to be programmed
in the switch. That's why I would've put that knowledge into the DSA layer,
which job is to translate the kernel operations to the (dumb) DSA drivers.

I hope I'm seeing things correctly here.


Thanks,
Vivien
