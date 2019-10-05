Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5BF2CC9C2
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 13:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbfJELyX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 5 Oct 2019 07:54:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40352 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727800AbfJELyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 07:54:23 -0400
Received: from mail-pf1-f198.google.com ([209.85.210.198])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1iGidg-0001KM-Ig
        for netdev@vger.kernel.org; Sat, 05 Oct 2019 11:54:20 +0000
Received: by mail-pf1-f198.google.com with SMTP id 22so6261870pfx.8
        for <netdev@vger.kernel.org>; Sat, 05 Oct 2019 04:54:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=hYZ5847Alj80JQpYgg086ecj/ozmm05dCI9mdruLuD8=;
        b=biBOrKKXXzPywY/GrC/hj4op6qrLaUfhZtSjorEzCFv+DtAoL8ywkp0I00JUQlaaly
         i4KU04OghkxJzu+o86NDpAAOIpHQLkgC3V8lMsewvyTbTXauq2a0cMmyGjVinncr3JAJ
         sCiDcD5i/HVn1TO9NkiD7MGPLGguW/+tszMSahf/SYQI0mYgcp+uUDg8T0PxMHxHBS0o
         a76uJUrSgdHREb6OGSX6kS1nn9I9XTdo/qUrsnPIHc7WOVozDmmUC79SKic46mg+ztv4
         lOfRfmsfSgOgD4/5H0ReEJ9IBl/AQh39Tz5CwPcWUWU4H3iGtqsBGXo63zYS2nOlw8rk
         TcaQ==
X-Gm-Message-State: APjAAAX01/bFoP+w77QcOi55WcFu31RVA2nxY2uMFCQdOfIQLqEopA4J
        ZDoVKcfD56tBCJBJBRCxAXdGg77keOsvOk6YK60yNwbtVocF9fAhzicMygcaQVyNgB4QvI5kwwK
        st+1O5bfD77E8jHT8CLQYX29p8YGW4WU4Mw==
X-Received: by 2002:a17:902:ba87:: with SMTP id k7mr20233181pls.244.1570276459040;
        Sat, 05 Oct 2019 04:54:19 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz2dpPjmA/e8KXLyAamS63Ku6+uXKdVnzSNEkS12Mq/kQI4x/cmxrA3SejgLZqQRWyEc8GtrA==
X-Received: by 2002:a17:902:ba87:: with SMTP id k7mr20233155pls.244.1570276458632;
        Sat, 05 Oct 2019 04:54:18 -0700 (PDT)
Received: from 2001-b011-380f-3c42-2c2d-b509-b8b9-4afa.dynamic-ip6.hinet.net (2001-b011-380f-3c42-2c2d-b509-b8b9-4afa.dynamic-ip6.hinet.net. [2001:b011:380f:3c42:2c2d:b509:b8b9:4afa])
        by smtp.gmail.com with ESMTPSA id v1sm10890255pfg.26.2019.10.05.04.54.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Oct 2019 04:54:18 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3594.4.19\))
Subject: Re: [PATCH] r8152: Set macpassthru in reset_resume callback
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <20191005114634.wvv4yfdte7qchzxs@verge.net.au>
Date:   Sat, 5 Oct 2019 19:54:15 +0800
Cc:     David Miller <davem@davemloft.net>, hayeswang@realtek.com,
        mario.limonciello@dell.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <AAD739ED-478D-42CE-A0C9-FFBD209B5E38@canonical.com>
References: <20191004125104.13202-1-kai.heng.feng@canonical.com>
 <20191005114634.wvv4yfdte7qchzxs@verge.net.au>
To:     Simon Horman <horms@verge.net.au>
X-Mailer: Apple Mail (2.3594.4.19)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 5, 2019, at 19:46, Simon Horman <horms@verge.net.au> wrote:
> 
> On Fri, Oct 04, 2019 at 08:51:04PM +0800, Kai-Heng Feng wrote:
>> r8152 may fail to establish network connection after resume from system
>> suspend.
>> 
>> If the USB port connects to r8152 lost its power during system suspend,
>> the MAC address was written before is lost. The reason is that The MAC
>> address doesn't get written again in its reset_resume callback.
>> 
>> So let's set MAC address again in reset_resume callback. Also remove
>> unnecessary lock as no other locking attempt will happen during
>> reset_resume.
> 
> This is two separate seemingly unrelated, other than locality in the code,
> changes. One is a fix, the other seems to be a cleanup. Perhaps they would
> be better addressed in separate patches.

rtl8152_set_mac_address() which gets called by set_ethernet_addr(), also holds the same mutex.
So this is more then a cleanup and I should mention it in commit log.

Kai-Heng

> 
>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>> ---
>> drivers/net/usb/r8152.c | 3 +--
>> 1 file changed, 1 insertion(+), 2 deletions(-)
>> 
>> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
>> index 08726090570e..cee9fef925cd 100644
>> --- a/drivers/net/usb/r8152.c
>> +++ b/drivers/net/usb/r8152.c
>> @@ -4799,10 +4799,9 @@ static int rtl8152_reset_resume(struct usb_interface *intf)
>> 	struct r8152 *tp = usb_get_intfdata(intf);
>> 
>> 	clear_bit(SELECTIVE_SUSPEND, &tp->flags);
>> -	mutex_lock(&tp->control);
>> 	tp->rtl_ops.init(tp);
>> 	queue_delayed_work(system_long_wq, &tp->hw_phy_work, 0);
>> -	mutex_unlock(&tp->control);
>> +	set_ethernet_addr(tp);
>> 	return rtl8152_resume(intf);
>> }
>> 
>> -- 
>> 2.17.1
>> 

