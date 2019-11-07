Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8075F3C56
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 00:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbfKGXu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 18:50:57 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50200 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbfKGXu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 18:50:56 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1201F1537E173;
        Thu,  7 Nov 2019 15:50:55 -0800 (PST)
Date:   Thu, 07 Nov 2019 15:50:54 -0800 (PST)
Message-Id: <20191107.155054.81286627810540930.davem@davemloft.net>
To:     aleksander@aleksander.es
Cc:     bjorn@mork.no, netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] net: usb: qmi_wwan: add support for DW5821e with eSIM
 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191107105701.1010823-1-aleksander@aleksander.es>
References: <20191107105701.1010823-1-aleksander@aleksander.es>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Nov 2019 15:50:55 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksander Morgado <aleksander@aleksander.es>
Date: Thu,  7 Nov 2019 11:57:01 +0100

> Exactly same layout as the default DW5821e module, just a different
> vid/pid.
> 
> The QMI interface is exposed in USB configuration #1:
> 
> P:  Vendor=413c ProdID=81e0 Rev=03.18
> S:  Manufacturer=Dell Inc.
> S:  Product=DW5821e-eSIM Snapdragon X20 LTE
> S:  SerialNumber=0123456789ABCDEF
> C:  #Ifs= 6 Cfg#= 1 Atr=a0 MxPwr=500mA
> I:  If#=0x0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
> I:  If#=0x1 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=00 Prot=00 Driver=usbhid
> I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> I:  If#=0x5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
> 
> Signed-off-by: Aleksander Morgado <aleksander@aleksander.es>
> Cc: stable <stable@vger.kernel.org>

Do not CC: stable for networking changes, we submit to -stable by hand
ourselves, as per the netdev FAQ.

Applied and queued up for -stable, thanks.
