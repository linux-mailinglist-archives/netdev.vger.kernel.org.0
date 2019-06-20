Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF5DF4C8B7
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 09:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbfFTHzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 03:55:55 -0400
Received: from eva.aplu.fr ([91.224.149.41]:45462 "EHLO eva.aplu.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbfFTHzy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 03:55:54 -0400
Received: from eva.aplu.fr (localhost [127.0.0.1])
        by eva.aplu.fr (Postfix) with ESMTP id 70A66E23;
        Thu, 20 Jun 2019 09:55:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aplu.fr; s=s4096;
        t=1561017353; bh=I9yh62n62fOtNAxNA/Rg9Z/P51cUAU9tBtya1CFeQ4I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p7RBchzzmk6hkXYtqI8ZUGkEwLxzkkh2qiS28PucY+cog9jBqx/1vkL1lOwcouYfT
         n3Q5i27eoASHk9uajGNyycUqpAAqA5dPWaDC0Xw8bXZPFafH9uW6S6w0/9wzRQYLHy
         dhz3MzoghXK0q8ivU7E7Tyri6QFlc8RdgEzc2jGAyPlqZU6KLHIO2KDzPD8zER6dd8
         jLX5wKw/lXQr1bzTllPxv7NRb5iIzr1zFy1gufDCduA6Q2ARjogKR3b1fPa1OMoua6
         /Rqg8RCux3pEYAdGyic6xtwVBLohWBFBg4Jz/jVNRy/Z9MFhie1zhzhPk203tHE9bf
         EDqQbRraISNP1V0cLe/lOqjpfYLeW1FJFfAPyPLOxbd8AHpz2oSrLpbjAZqaruCKGO
         zmj5lvKlOmDsrL+2CqL0FQLb8Hd8XM7JszK8UOfWXpPuHoQoo1XMGAVjwzKs64duFq
         S9yBzx7SzoFSD+e+P8fl3l1vmW9sPsrdzMSN/3B/u5S3TYUJ+G/joozse1Aj0rkTNk
         nAcDuKV1tQa0knWaeyjwV1v9ujnE0rm9Qbi4lEZVrZVwHnZHnxopTZBqNbN8v65jj7
         Sa302DQ/mozPyoH2e/PPnjs7/xMQZZKXuJHlCP+BFoVcuPI+FgJW9tcfJKODHtI4Gd
         NO5OQJlD4YV6GXXCSU3EUjtU=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on eva.aplu.fr
X-Spam-Level: 
X-Spam-Status: No, score=-102.5 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        SHORTCIRCUIT shortcircuit=ham autolearn=disabled version=3.4.2
Received: from mail.aplu.fr (localhost [IPv6:::1])
        by eva.aplu.fr (Postfix) with ESMTPA id 8AA1FBED;
        Thu, 20 Jun 2019 09:55:52 +0200 (CEST)
Authentication-Results: eva.aplu.fr; dmarc=fail (p=none dis=none) header.from=aplu.fr
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aplu.fr; s=s4096;
        t=1561017352; bh=I9yh62n62fOtNAxNA/Rg9Z/P51cUAU9tBtya1CFeQ4I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RbquC23fVadb2GRbKQQ7XNWjEadEkEfGI/tzy5jbgqGuXdRkqfd0O7JaGoqiEqvVK
         iA7uH35Ty5wIArRlwEK37Eh2uPihtTFZi+YfmT4fhZNOze6HtGwpZmyAYPK3h01VIK
         bI0W0Xu+5iXEmCJ83Mc0bP7pR3eEt/HKWtDcE06Kt1QWZ9sBf8zWakByOClfPTOey6
         q+Ru+dGtHDWWcLRz0f7E2oiz5WybqdvFwPNfdvj5aRqmegmb4ilQcDi4ItIUJNQjMY
         WHJMU9ffkq15T33xhSqeWk0mblmZl8cwF+JoMUWsE2OH9HM5Gxr/MNmpQ7oKltKJv7
         w/+R5z1SsZPvpbNZTlptMh1jBDZl1IAHzeWuPWn7mMKUrqJZpHg9IALHQAUEB2irak
         KyOqnHdQT314oBSFqm61xTRNxWp1y5bRoIyUlCad4qr/hh6ZYjGTUhAuEmQ83x37q/
         5/Qal684FNbY0g1ygqSilQQs71Nn1ZBNQx8lmaL6iswf0MqTTuclRuer3tZ7TkAkan
         snZZE7NYcc1sjtRfqDAybXgOE3gEGRl2XY98or7DRxLz6YP6u6XG7XXV5AWO6+zbOi
         Hr6vTSia+jkQIRSSV5AGo4A1BbdW4LHWxWowOPCtJrjxyT2UhL05Z7IBDuQVEgKwoN
         OYXZ/Gw6VrKK5fGA010kD64g=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 20 Jun 2019 09:55:50 +0200
From:   Aymeric <mulx@aplu.fr>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, linux-amlogic@lists.infradead.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: Re: network unstable on odroid-c1/meson8b.
In-Reply-To: <0df100ad-b331-43db-10a5-3257bd09938d@gmail.com>
References: <ff9a72bf-7eeb-542b-6292-dd70abdc4e79@aplu.fr>
 <0df100ad-b331-43db-10a5-3257bd09938d@gmail.com>
Message-ID: <d2e298040f4887c547da11178f9ea64f@aplu.fr>
X-Sender: mulx@aplu.fr
User-Agent: Roundcube Webmail/1.2.9
X-AV-Checked: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
On 2019-06-20 00:14, Heiner Kallweit wrote:
> On 19.06.2019 22:18, Aymeric wrote:
>> Hello all,
>> 

> Kernel 3.10 didn't have a dedicated RTL8211F PHY driver yet, therefore
> I assume the genphy driver was used. Do you have a line with
> "attached PHY driver" in dmesg output of the vendor kernel?

No.
Here is the full output of the dmesg from vendor kernel [¹].

I've also noticed something strange, it might be linked, but mac address 
of the board is set to a random value when using mainline kernel and 
I've to set it manually but not when using vendor kernel.

> 
> The dedicated PHY driver takes care of the tx delay, if the genphy
> driver is used we have to rely on what uboot configured.
> But if we indeed had an issue with a misconfigured delay, I think
> the connection shouldn't be fine with just another link partner.
> Just to have it tested you could make rtl8211f_config_init() in
> drivers/net/phy/realtek.c a no-op (in current kernels).
> 

I'm not an expert here, just adding a "return 0;" here[²] would be 
enough?

> And you could compare at least the basic PHY registers 0x00 - 0x30
> with both kernel versions, e.g. with phytool.
> 

They are not the same but I don't know what I'm looking for, so for 
kernel 3.10 [³] and for kernel 5.1.12 [⁴].

Aymeric

[¹]: 
https://paste.aplu.fr/?38ef95b44ebdbfc3#G666/YbhgU+O+tdC/2HaimUCigm8ZTB44qvQip/HJ5A=
[²]: 
https://github.com/torvalds/linux/blob/241e39004581475b2802cd63c111fec43bb0123e/drivers/net/phy/realtek.c#L164
[³]: 
https://paste.aplu.fr/?2dde1c32d5c68f4c#6xIa8MjTm6jpI6citEJAqFTLMMHDjFZRet/M00/EwjU=
[⁴]: 
https://paste.aplu.fr/?32130e9bcb05dde7#N/xdnvb5GklcJtiOxMpTCm+9gsUliRwH8X3dcwSV+ng=
