Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793FE217872
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 21:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbgGGT6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 15:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbgGGT6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 15:58:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CD6C061755;
        Tue,  7 Jul 2020 12:58:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7FE3B120F93E0;
        Tue,  7 Jul 2020 12:58:39 -0700 (PDT)
Date:   Tue, 07 Jul 2020 12:58:38 -0700 (PDT)
Message-Id: <20200707.125838.250656053300553400.davem@davemloft.net>
To:     acelan.kao@canonical.com
Cc:     bjorn@mork.no, kuba@kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: usb: qmi_wwan: add support for Quectel EG95 LTE
 modem
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200707081445.1064346-1-acelan.kao@canonical.com>
References: <20200707081445.1064346-1-acelan.kao@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jul 2020 12:58:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: AceLan Kao <acelan.kao@canonical.com>
Date: Tue,  7 Jul 2020 16:14:45 +0800

> Add support for Quectel Wireless Solutions Co., Ltd. EG95 LTE modem
> 
> T:  Bus=01 Lev=01 Prnt=01 Port=02 Cnt=02 Dev#=  5 Spd=480 MxCh= 0
> D:  Ver= 2.00 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
> P:  Vendor=2c7c ProdID=0195 Rev=03.18
> S:  Manufacturer=Android
> S:  Product=Android
> C:  #Ifs= 5 Cfg#= 1 Atr=a0 MxPwr=500mA
> I:  If#=0x0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
> I:  If#=0x1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
> I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
> I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
> I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
> 
> Signed-off-by: AceLan Kao <acelan.kao@canonical.com>

Applied, thank you.
