Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9E7FB944
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 20:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbfKMT7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 14:59:07 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37038 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfKMT7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 14:59:07 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A175A153EC9EE;
        Wed, 13 Nov 2019 11:59:06 -0800 (PST)
Date:   Wed, 13 Nov 2019 11:59:06 -0800 (PST)
Message-Id: <20191113.115906.1738066764972769109.davem@davemloft.net>
To:     aleksander@aleksander.es
Cc:     bjorn@mork.no, netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] net: usb: qmi_wwan: add support for Foxconn T77W968
 LTE modules
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191113101110.496306-1-aleksander@aleksander.es>
References: <20191113101110.496306-1-aleksander@aleksander.es>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 Nov 2019 11:59:06 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksander Morgado <aleksander@aleksander.es>
Date: Wed, 13 Nov 2019 11:11:10 +0100

> These are the Foxconn-branded variants of the Dell DW5821e modules,
> same USB layout as those.
> 
> The QMI interface is exposed in USB configuration #1:
> 
> P:  Vendor=0489 ProdID=e0b4 Rev=03.18
> S:  Manufacturer=FII
> S:  Product=T77W968 LTE
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

Applied and queued up for -stable, thanks.
