Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9C812392A
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 23:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbfLQWMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 17:12:14 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43604 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfLQWMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 17:12:14 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 90FFC147168D9;
        Tue, 17 Dec 2019 14:12:13 -0800 (PST)
Date:   Tue, 17 Dec 2019 14:12:13 -0800 (PST)
Message-Id: <20191217.141213.638446762932310525.davem@davemloft.net>
To:     yangbo.lu@nxp.com
Cc:     ioana.ciornei@nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] dpaa2-ptp: fix double free of the ptp_qoriq IRQ
From:   David Miller <davem@davemloft.net>
In-Reply-To: <VI1PR0401MB223794F3A1B1D4ED622A3419F8500@VI1PR0401MB2237.eurprd04.prod.outlook.com>
References: <VI1PR0401MB22378203BDAE222A6FDCCD09F8500@VI1PR0401MB2237.eurprd04.prod.outlook.com>
        <20191216.191204.2265139317972153148.davem@davemloft.net>
        <VI1PR0401MB223794F3A1B1D4ED622A3419F8500@VI1PR0401MB2237.eurprd04.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Dec 2019 14:12:13 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Y.b. Lu" <yangbo.lu@nxp.com>
Date: Tue, 17 Dec 2019 03:25:23 +0000

>> -----Original Message-----
>> From: David Miller <davem@davemloft.net>
>> Sent: Tuesday, December 17, 2019 11:12 AM
>> To: Y.b. Lu <yangbo.lu@nxp.com>
>> Cc: Ioana Ciornei <ioana.ciornei@nxp.com>; netdev@vger.kernel.org
>> Subject: Re: [PATCH net v2] dpaa2-ptp: fix double free of the ptp_qoriq IRQ
>> 
>> From: "Y.b. Lu" <yangbo.lu@nxp.com>
>> Date: Tue, 17 Dec 2019 02:24:13 +0000
>> 
>> >> -----Original Message-----
>> >> From: Ioana Ciornei <ioana.ciornei@nxp.com>
>> >> Sent: Monday, December 16, 2019 11:33 PM
>> >> To: davem@davemloft.net; netdev@vger.kernel.org
>> >> Cc: Ioana Ciornei <ioana.ciornei@nxp.com>; Y.b. Lu <yangbo.lu@nxp.com>
>> >> Subject: [PATCH net v2] dpaa2-ptp: fix double free of the ptp_qoriq IRQ
>> >
>> > [Y.b. Lu] Reviewed-by: Yangbo Lu <yangbo.lu@nxp.com>
>> 
>> Please start your tags on the first column of the line, do not
>> add these "[Y.b. Lu] " prefixes as it can confuse automated tools
>> that look for the tags.
> 
> [Y.b. Lu] Sorry, David. I will remember that :)

How about completely not using these silly prefixes in your replies?

Nobody else does this, and the quoting of the email says clearly what
you are saying in reply and what is the content you are replying to.
