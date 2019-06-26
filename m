Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 254F8574E8
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 01:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfFZX36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 19:29:58 -0400
Received: from rere.qmqm.pl ([91.227.64.183]:20537 "EHLO rere.qmqm.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726373AbfFZX36 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 19:29:58 -0400
Received: from remote.user (localhost [127.0.0.1])
        by rere.qmqm.pl (Postfix) with ESMTPSA id 45YzkB28LgzC7;
        Thu, 27 Jun 2019 01:28:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rere.qmqm.pl; s=1;
        t=1561591730; bh=J+oBx6U75ufW5LbMVz54rPQbkVZe7d38SIq0Nd/GVcA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CGFFnDmJpxk1TC2FtHsGEuIJq2u1yMuxgn6EQlVnCBc9opceOT2StPZnkowabbwUl
         Ylgt7ghCB1AvEQ7hEtU/mYj4gEk9eR2aONUNezCHTolVrUQwYwGB5LnwoDcADZPVWL
         eSzCi/IRTziIp20b79Ia0+e1IUdB9nabHEaplhIHhjC5I6aWfFJkuYEZSisndnsz9U
         gLYn01KiETX9WJe01DaH+1ci4dKqpZbM9hHnjKnqMLY7SdQ1GQF5nYvaDE2JxOCNWu
         6rpPuFDCn89TF0+AunpiqMZ1XCKmbzqrB3Z0AbKP4vpewLP6UnNMF8gKJF2J9T+43F
         iwEKMTOnzBbeQ==
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 0.100.3 at mail
Date:   Thu, 27 Jun 2019 01:29:53 +0200
From:   =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     YueHaibing <yuehaibing@huawei.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] bonding: Always enable vlan tx offload
Message-ID: <20190626232953.GA11474@qmqm.qmqm.pl>
References: <20190624135007.GA17673@nanopsycho>
 <20190626080844.20796-1-yuehaibing@huawei.com>
 <20190626161337.GA18953@qmqm.qmqm.pl>
 <20190626164853.GC2424@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190626164853.GC2424@nanopsycho>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 06:48:53PM +0200, Jiri Pirko wrote:
> Wed, Jun 26, 2019 at 06:13:38PM CEST, mirq-linux@rere.qmqm.pl wrote:
> >On Wed, Jun 26, 2019 at 04:08:44PM +0800, YueHaibing wrote:
[...]
> >> This patch always enable bonding's vlan tx offload, pass the vlan
> >> packets to the slave devices with vlan tci, let them to handle
> >> vlan implementation.
[...]
> >I can see that bonding driver uses dev_queue_xmit() to pass packets to
> >slave links, but I can't see where in the path it does software fallback
> >for devices without HW VLAN tagging. Generally drivers that don't ever
> >do VLAN offload also ignore vlan_tci presence. Am I missing something
> >here?

> validate_xmit_skb->validate_xmit_vlan

Yes it is. Thanks!

Best Regards,
Micha³ Miros³aw
