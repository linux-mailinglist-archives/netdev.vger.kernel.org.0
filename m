Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 409D71D3E0D
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728707AbgENT4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 15:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727117AbgENT4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 15:56:05 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DBAC061A0C;
        Thu, 14 May 2020 12:56:05 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EE51E128D3256;
        Thu, 14 May 2020 12:56:03 -0700 (PDT)
Date:   Thu, 14 May 2020 12:56:03 -0700 (PDT)
Message-Id: <20200514.125603.1095750660571738939.davem@davemloft.net>
To:     brgl@bgdev.pl
Cc:     corbet@lwn.net, robh+dt@kernel.org, matthias.bgg@gmail.com,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        kuba@kernel.org, arnd@arndb.de, fparent@baylibre.com,
        hkallweit1@gmail.com, edwin.peer@broadcom.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        stephane.leprovost@mediatek.com, pedro.tsai@mediatek.com,
        andrew.perepech@mediatek.com, bgolaszewski@baylibre.com
Subject: Re: [PATCH v3 00/15] mediatek: add support for MediaTek Ethernet
 MAC
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200514075942.10136-1-brgl@bgdev.pl>
References: <20200514075942.10136-1-brgl@bgdev.pl>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 12:56:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 14 May 2020 09:59:27 +0200

> Next we do some cleanup of the mediatek ethernet drivers directory and update
> the devres documentation with existing networking devres helpers.

I don't agree with the new devres stuff.

You have to be very careful with the ordering of when you map/unmap
registers, free up anciliary resources, etc. in relationship to when
the netdev unregister happens.

Please submit this driver without these controversial devres changes,
and then you can submit and discuss those changes separately later.

Thanks.
