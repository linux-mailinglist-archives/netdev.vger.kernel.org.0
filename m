Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B8E2B1266
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 00:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbgKLXEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 18:04:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:52234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725929AbgKLXEs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 18:04:48 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53D4F20797;
        Thu, 12 Nov 2020 23:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605222287;
        bh=jw9sACHMVzmJYd4L54xn1aIJz0KtCK05yHvhEjyeWbE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C4FG8TSr3zH5RokcVXAEa81nhqHRJf8tr8mvr2rL8Od3EEl48NFCwT9mIOsVfxrQo
         Lvgmqy6pVUIgjYMZt5GX2qwOZY3lX24cN7TpeZmvq48LDMIjScKLfZxZNpQUwm5r8U
         UwpIWa4j1/le4dgwS45roJ6b6m7a8+GI8eSayews=
Date:   Thu, 12 Nov 2020 15:04:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     David Miller <davem@davemloft.net>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Doug Ledford <dledford@redhat.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Oliver Neukum <oneukum@suse.com>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH net-next 0/5] net: switch further drivers to core
 functionality for handling per-cpu byte/packet counters
Message-ID: <20201112150445.6586480d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <5fbe3a1f-6625-eadc-b1c9-f76f78debb94@gmail.com>
References: <5fbe3a1f-6625-eadc-b1c9-f76f78debb94@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 20:46:26 +0100 Heiner Kallweit wrote:
> Switch further drivers to core functionality for handling per-cpu
> byte/packet counters.
> All changes are compile-tested only.

Applied, thanks everyone!
