Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA4013B9D6
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 07:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbgAOGkO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 15 Jan 2020 01:40:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49546 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgAOGkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 01:40:11 -0500
Received: from mail-pg1-f197.google.com ([209.85.215.197])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1ircLZ-00029A-AZ
        for netdev@vger.kernel.org; Wed, 15 Jan 2020 06:40:09 +0000
Received: by mail-pg1-f197.google.com with SMTP id c8so9778263pgl.15
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 22:40:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ks+FKtYdipfmIovpRk0e6E//v9CS+XKOemaSP1iQ0A8=;
        b=KFOblWfa3uA/WsJu33k6T1shghgwOmFNW6R1zm8Yzn87JIZoQ3+g5iNhELUXtkQb9Y
         9a1IjJn/EFNdvIfbyEieoRB9PaNW4442quRw5AuV95Lf3o7tZLHMZXlsuhAq25DsLYpM
         +YxbfnqK0klx9TLFAV756PSr1lkJf5y7hgcw4gYiakhRgqYaxh513joT+B1IIhiNE1y/
         7woLAfcErHpOowSfFIDgZXyjyEhyyk8q+oPaWzwVQpSe3xfxU9FKMHhnogWqfNq5OW1s
         8C4mnAM29ewtQlD8xvCSJ7Q/sG7U1JqUHOjH4T4CurklK1qqptkz0gGzT8cdoZ4vXrdX
         wvMA==
X-Gm-Message-State: APjAAAX2J81C/Q+ja5GlHD5xPsifkHTEqeIAVL8kvI35QUyM2at1kz0P
        pCtCsl5ohtvhp1KzyGn4mpnXt7yfaCo8YC70H6kRlDpJrghdvtHz1T3X4pzDPyZnNpcZC3bNadQ
        2u+cgIOA+2MVCTGzfSqGDArSNhJBiPyzq9A==
X-Received: by 2002:a63:d141:: with SMTP id c1mr26072649pgj.397.1579070407858;
        Tue, 14 Jan 2020 22:40:07 -0800 (PST)
X-Google-Smtp-Source: APXvYqyCAlUxgFq4p9aUmqfpZAip45/nK5+OQYN5+5gQPity3Khdrn/uFB+ajTrWkrsHEqOLOxPIzg==
X-Received: by 2002:a63:d141:: with SMTP id c1mr26072612pgj.397.1579070407423;
        Tue, 14 Jan 2020 22:40:07 -0800 (PST)
Received: from [10.101.46.91] (61-220-137-37.HINET-IP.hinet.net. [61.220.137.37])
        by smtp.gmail.com with ESMTPSA id l14sm17861129pgt.42.2020.01.14.22.40.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Jan 2020 22:40:06 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3594.4.19\))
Subject: Re: [PATCH] r8152: Add MAC passthrough support to new device
From:   Kai Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <d8af34dbf4994b7b8b0bf48e81084dd0@AUSX13MPC101.AMER.DELL.COM>
Date:   Wed, 15 Jan 2020 14:40:03 +0800
Cc:     David Miller <davem@davemloft.net>, hayeswang@realtek.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        pmalani@chromium.org, grundler@chromium.org,
        "<David.Chen7@dell.com>" <David.Chen7@Dell.com>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <430A264A-27E0-489D-B7B1-8E78AAD528D7@canonical.com>
References: <20200114044127.20085-1-kai.heng.feng@canonical.com>
 <d8af34dbf4994b7b8b0bf48e81084dd0@AUSX13MPC101.AMER.DELL.COM>
To:     Mario.Limonciello@dell.com
X-Mailer: Apple Mail (2.3594.4.19)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 15, 2020, at 4:33 AM, Mario.Limonciello@dell.com wrote:
> 
> 
> 
>> -----Original Message-----
>> From: Kai-Heng Feng <kai.heng.feng@canonical.com>
>> Sent: Monday, January 13, 2020 10:41 PM
>> To: davem@davemloft.net; hayeswang@realtek.com
>> Cc: Kai-Heng Feng; Jakub Kicinski; Prashant Malani; Grant Grundler; Limonciello,
>> Mario; Chen7, David; open list:USB NETWORKING DRIVERS; open list:NETWORKING
>> DRIVERS; open list
>> Subject: [PATCH] r8152: Add MAC passthrough support to new device
>> 
>> 
>> [EXTERNAL EMAIL]
>> 
>> Device 0xa387 also supports MAC passthrough, therefore add it to the
>> whitelst.
> 
> Have you confirmed whether this product ID is unique to the products that
> support this feature or if it's also re-used in other products?

This is unique for Lenovo product.

> 
> For Dell's devices there are very specific tests that make sure that this
> feature only applies on the products it is supposed to and nothing else
> (For example RTL8153-AD checks variant as well as effuse value)
> (Example two: RTL8153-BND is a Dell only part).

Hayes, do you know how macpassthru on Lenovo dock works?

Kai-Heng

> 
>> 
>> BugLink: https://bugs.launchpad.net/bugs/1827961/comments/30
>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>> ---
>> drivers/net/usb/r8152.c | 3 ++-
>> 1 file changed, 2 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
>> index c5ebf35d2488..42dcf1442cc0 100644
>> --- a/drivers/net/usb/r8152.c
>> +++ b/drivers/net/usb/r8152.c
>> @@ -6657,7 +6657,8 @@ static int rtl8152_probe(struct usb_interface *intf,
>> 	}
>> 
>> 	if (le16_to_cpu(udev->descriptor.idVendor) == VENDOR_ID_LENOVO &&
>> -	    le16_to_cpu(udev->descriptor.idProduct) == 0x3082)
>> +	    (le16_to_cpu(udev->descriptor.idProduct) == 0x3082 ||
>> +	     le16_to_cpu(udev->descriptor.idProduct) == 0xa387))
>> 		set_bit(LENOVO_MACPASSTHRU, &tp->flags);
>> 
>> 	if (le16_to_cpu(udev->descriptor.bcdDevice) == 0x3011 && udev->serial
>> &&
>> --
>> 2.17.1
> 

