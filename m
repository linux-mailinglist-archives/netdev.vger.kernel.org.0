Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A57E511A2F0
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 04:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfLKDUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 22:20:40 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36077 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbfLKDUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 22:20:40 -0500
Received: by mail-pl1-f196.google.com with SMTP id d15so823228pll.3
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 19:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=2jHJ4JHgC5cvePnWImJM1hJsQ0h/bLKO8qjeUguHivg=;
        b=R/WzI5y6RWgaCRy1ckrMZIIH5WkOtEcPGNwgY7o2Q+nwuxAA6A82MOeV2r2wUTJ0hy
         yFM/aNjBEGNyupPPiKR+4Vw5VEOn1QivA2Z4WOONmiefJ2PjsgyDBZiFnto8eU1e/xVV
         Asu4Zu7KJe3wOklPgpwsPz0IaRuKhNUhIUIdgTmMoD5fTe1sr8ebWMSp0O/Pzz1TGtfU
         2cW5VM1U1PiH3fihPLQyNkEy4Qm4kSfv8LApWvVzmwDFWclpA+ayIWKmiVE/fit6ebAE
         yxSSPehHW6QyqV3vEbDWWDwRzfI8NiD1OaddNYxGFtWPlHsJmyAeKsSs/sGd9HBSkxvm
         DlRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=2jHJ4JHgC5cvePnWImJM1hJsQ0h/bLKO8qjeUguHivg=;
        b=h/Fwsj0usxib2GA1eUnKG0jgxPdSi6yurAzJGk2hPOcLskc0N6VttnVp7J2GqLgTvH
         GgyBO6RXE5XYShU62P1P8XIz2YIRefiMZeG2xSu+w/AAFVNsPpE40YZS7P6USmXYs3H5
         8LmwTePZYLR4KXyhhLSZq4NObGs5TtLkOzBm7KilxBsOFdSIYdq60X4ANUOpgGgPNvxc
         hWY/mo/qo6r/RPJXX+Zt/Xe0omjSdvvr6SU2LMyyUGgCpgIJ5G7KTozN2nfnzwDmn1yD
         KW6II1nW8aXWpHBI04eyNvU/pW/ZCsLYO5LULQiuXT0iGR3+frPCKQ11a9YFzsvu45lZ
         PG7w==
X-Gm-Message-State: APjAAAUwTl5C0UJ5GHilluvwTDdUyUtgVaP9HsbMCR6Sq2CeRoAVghc8
        RJ2ziH5BdBlre/5IbDkhE6MhkQ==
X-Google-Smtp-Source: APXvYqxEXP9v+2noFk5dIfnKF45VtAX5J89K80D3IwLlOljUwaN7sGJD4sRk0SpzjaHto6pKco71Mw==
X-Received: by 2002:a17:90a:9dc3:: with SMTP id x3mr971181pjv.45.1576034439726;
        Tue, 10 Dec 2019 19:20:39 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id x4sm493073pfx.68.2019.12.10.19.20.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Dec 2019 19:20:39 -0800 (PST)
Subject: Re: [PATCH net-next 2/2] ionic: support sr-iov operations
To:     Parav Pandit <parav@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20191210225421.35193-1-snelson@pensando.io>
 <20191210225421.35193-3-snelson@pensando.io>
 <84808074-6984-14ca-7d22-65332086ad19@mellanox.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <2bdf19d1-55e3-60ff-bf6b-dd4f3097d672@pensando.io>
Date:   Tue, 10 Dec 2019 19:20:38 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <84808074-6984-14ca-7d22-65332086ad19@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10/19 5:39 PM, Parav Pandit wrote:
> On 12/10/2019 4:54 PM, Shannon Nelson wrote:
>> Add the netdev ops for managing VFs.  Since most of the
>> management work happens in the NIC firmware, the driver becomes
>> mostly a pass-through for the network stack commands that want
>> to control and configure the VFs.
>>
>> We also tweak ionic_station_set() a little to allow for
>> the VFs that start off with a zero'd mac address.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> ---
[...]
>>   
>> +/* VF commands */
>> +int ionic_set_vf_config(struct ionic *ionic, int vf, u8 attr, u8 *data)
>> +{
> I forgot to mention in my previous review comment that set_vf_config()
> and other VF config friend callback functions can race with
> ionic_sriov_configure().
>
> Former is called from netlink context, later is called from sysfs.
> Its not too hard to crash the system both racing with each other.
>
> Hence protect them using rwsem, where set_vf_() and sriov_configure()
> does down/up_write() and get_vf_config() and get_vf_stat() does
> down_up/read().
>
>

Ah, good catch.  That seems to be relatively a new thing and with a 
quick look around it seems not many drivers deal with that yet. Thanks 
for pointing it out.

sln

