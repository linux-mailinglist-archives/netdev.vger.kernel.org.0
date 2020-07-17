Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A995224470
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 21:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbgGQTnE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 17 Jul 2020 15:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728183AbgGQTnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 15:43:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8FAC0619D2;
        Fri, 17 Jul 2020 12:43:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 454C011E45925;
        Fri, 17 Jul 2020 12:43:03 -0700 (PDT)
Date:   Fri, 17 Jul 2020 12:43:02 -0700 (PDT)
Message-Id: <20200717.124302.745398199914584825.davem@davemloft.net>
To:     bjorn@mork.no
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        wxcafe@wxcafe.net, oliver@neukum.org
Subject: Re: [PATCH v5 net-next 0/5] usbnet: multicast filter support for
 cdc ncm devices
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200715184100.109349-1-bjorn@mork.no>
References: <20200715184100.109349-1-bjorn@mork.no>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jul 2020 12:43:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>
Date: Wed, 15 Jul 2020 20:40:55 +0200

> This revives a 2 year old patch set from Miguel Rodríguez
> Pérez, which appears to have been lost somewhere along the
> way.  I've based it on the last version I found (v4), and
> added one patch which I believe must have been missing in
> the original.
> 
> I kept Oliver's ack on one of the patches, since both the patch and
> the motivation still is the same.  Hope this is OK..
> 
> Thanks to the anonymous user <wxcafe@wxcafe.net> for bringing up this
> problem in https://bugs.debian.org/965074
> 
> This is only build and load tested by me.  I don't have any device
> where I can test the actual functionality.
> 
> 
> Changes v5:
>  - added missing symbol export
>  - formatted patch subjects with subsystem

Series applied, thank you.
