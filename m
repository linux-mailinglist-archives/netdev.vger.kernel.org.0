Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE1B1327B1
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 14:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbgAGNcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 08:32:22 -0500
Received: from mail-wr1-f45.google.com ([209.85.221.45]:45088 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727880AbgAGNcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 08:32:22 -0500
Received: by mail-wr1-f45.google.com with SMTP id j42so53896745wrj.12;
        Tue, 07 Jan 2020 05:32:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=iwseRYdnEFLKIiL5+UtUR55Qh0pC+BNHbWOaIgon+Ss=;
        b=ETcBOF7Xb21BVbDersgBk+meXnCTfjhZMdJR0KK1d12YLN9NS0odJG/OVCRGpPmfzC
         vHMlTWb5LVrDzQJQkjEr2ZRJEA3inJjJshTdoWH3brNWFKho8vReZq8rD0D/af9yO+wT
         SdKY4xiR3AbnAf0zeTZ0OCq89lZ/r6uMG/WxWbD0xUHvd1z5pucEgFk32pJt9ZvAKUHF
         XYxX9+qRsnFaeqqrG068hy/QeAIURsBs5nvP7eGuA5Vn9T+9AotB6UlnJniXP1U0zU/9
         eVAo99E/oG+KSXTEdC7TExth4fXcS+Y0NxrUTl1SNX2XSevcP7qTDy1FQ5i7mmjN3Yj/
         2F+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=iwseRYdnEFLKIiL5+UtUR55Qh0pC+BNHbWOaIgon+Ss=;
        b=l/SSfLNpdByIrpTBybPujxGU/X4KWojK40Vtihddq/tuIAQf43AH7UCxurCqWcEDe9
         H61CgDC8BFH24I9X7giyv8VTj8wxmqazWjhGoXbZqVC1tMNT91lVYDnN498stB/tO7yn
         UvJuoVMywihnBbSINUrVTbH7+BMDPyMrVQgwb7k0tPruPi0wz+ld11LTzZ8DsB5VOAr5
         ObTrFB8NvAGVMmNC3O/JQ/9W5bxG951FNCYpE7BKR1MRxwkDWAU6O4hiTPs1nvHa1NyA
         AsdXDWPI7QSR7pOJyUWJbfTi9I4BhFR+QlEEEREhhIymLA4ykP2MI9fGuVwC7iyvbOZ3
         gfjw==
X-Gm-Message-State: APjAAAXFCzESstjH2dFdb7L2SfGRzhVaz7StKEA4xGC7qaDdTmRiR0DH
        ZM2tELN4/x3OC0KoKDyse4k=
X-Google-Smtp-Source: APXvYqxWqLEKNyzSpq4WliWRICCKbiiiUFNUw2tpqjv46UrW6bDtkpWyW+Pe9VzWbgMw9YbrveJcTw==
X-Received: by 2002:adf:eb89:: with SMTP id t9mr111039655wrn.5.1578403939586;
        Tue, 07 Jan 2020 05:32:19 -0800 (PST)
Received: from xps13.intranet.net (82-64-122-65.subs.proxad.net. [82.64.122.65])
        by smtp.googlemail.com with ESMTPSA id m3sm75970007wrs.53.2020.01.07.05.32.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2020 05:32:18 -0800 (PST)
Subject: Re: [RPI 3B+ / TSO / lan78xx ]
From:   RENARD Pierre-Francois <pfrenard@gmail.com>
To:     nsaenzjulienne@suse.de, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, stefan.wahren@i2se.com
References: <5267da21-8f12-2750-c0c5-4ed31b03833b@gmail.com>
Message-ID: <78b94ba2-9a87-78bb-8916-e6ef5a0668ae@gmail.com>
Date:   Tue, 7 Jan 2020 14:32:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <5267da21-8f12-2750-c0c5-4ed31b03833b@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello all

I am facing an issue related to Raspberry PI 3B+ and onboard ethernet card.

When doing a huge transfer (more than 1GB) in a row, transfer hanges and 
failed after a few minutes.


I have two ways to reproduce this issue


using NFS (v3 or v4)

     dd if=/dev/zero of=/NFSPATH/file bs=4M count=1000 status=progress


     we can see that at some point dd hangs and becomes non interrutible 
(no way to ctrl-c it or kill it)

     after afew minutes, dd dies and a bunch of NFS server not 
responding / NFS server is OK are seens into the journal


Using SCP

     dd if=/dev/zero of=/tmp/file bs=4M count=1000

     scp /tmp/file user@server:/directory


     scp hangs after 1GB and after a few minutes scp is failing with 
message "client_loop: send disconnect: Broken pipe lostconnection"




It appears, this is a known bug relatted to TCP Segmentation Offload & 
Selective Acknowledge.

disabling this TSO (ethtool -K eth0 tso off & ethtool -K eth0 gso off) 
solves the issue.

A patch has been created to disable the feature by default by the 
raspberry team and is by default applied wihtin raspbian.

comment from the patch :

/* TSO seems to be having some issue with Selective Acknowledge (SACK) that
  * results in lost data never being retransmitted.
  * Disable it by default now, but adds a module parameter to enable it for
  * debug purposes (the full cause is not currently understood).
  */


For reference you can find

a link to the issue I created yesterday : 
https://github.com/raspberrypi/linux/issues/3395

links to raspberry dev team : 
https://github.com/raspberrypi/linux/issues/2482 & 
https://github.com/raspberrypi/linux/issues/2449



If you need me to test things, or give you more informations, I ll be 
pleased to help.



Fox


PS : this is a resent in with plain text because vger rejected the first 
one with html formating ...:)

