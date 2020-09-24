Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705AB2771BE
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 15:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbgIXNCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 09:02:39 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:47221 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727475AbgIXNCj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 09:02:39 -0400
Received: from [141.14.13.128] (g383.RadioFreeInternet.molgen.mpg.de [141.14.13.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 2BF8220646203;
        Thu, 24 Sep 2020 15:02:36 +0200 (CEST)
Subject: Re: [Intel-wired-lan] [PATCH] e1000e: Power cycle phy on PM resume
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20200923074751.10527-1-kai.heng.feng@canonical.com>
 <17092088-86ff-2d31-b3de-2469419136a3@molgen.mpg.de>
 <AC6D77B8-244D-4816-8FFE-A4480378EC4C@canonical.com>
 <79f01082-c9b1-f80a-7af4-b61bdbf40c90@molgen.mpg.de>
 <20200923192813.GE3764123@lunn.ch>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <d4c72cf9-930d-7559-9ca8-3336626e29d9@molgen.mpg.de>
Date:   Thu, 24 Sep 2020 15:02:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200923192813.GE3764123@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Andrew,


Am 23.09.20 um 21:28 schrieb Andrew Lunn:
>>>> How much does this increase the resume time?
> 
> Define resume time? Until you get the display manager unlock screen?
> Or do you need working networking?

Until network is functional again. Currently, the speed negotiation 
alone takes three(?) seconds, so making it even longer is unacceptable. 
(You wrote it below.)

> It takes around 1.5 seconds for auto negotiation to get a link. I know
> it takes me longer than that to move my fingers to the keyboard and
> type in my password to unlock the screen. So by the time you actually
> get to see your desktop, you should have link.

Not here.

> I've no idea about how the e1000e driver does link negotiation. But
> powering the PHY off means there is going to be a negotiation sometime
> later. But if you don't turn it off, the driver might be able to avoid
> doing an autoneg if the PHY has already done one when it got powered
> up.

Indeed.


Kind regards,

Paul
