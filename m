Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28CF512226A
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 04:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfLQDMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 22:12:10 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59200 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbfLQDMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 22:12:09 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3628D14239BC8;
        Mon, 16 Dec 2019 19:12:08 -0800 (PST)
Date:   Mon, 16 Dec 2019 19:12:04 -0800 (PST)
Message-Id: <20191216.191204.2265139317972153148.davem@davemloft.net>
To:     yangbo.lu@nxp.com
Cc:     ioana.ciornei@nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] dpaa2-ptp: fix double free of the ptp_qoriq IRQ
From:   David Miller <davem@davemloft.net>
In-Reply-To: <VI1PR0401MB22378203BDAE222A6FDCCD09F8500@VI1PR0401MB2237.eurprd04.prod.outlook.com>
References: <1576510350-28660-1-git-send-email-ioana.ciornei@nxp.com>
        <VI1PR0401MB22378203BDAE222A6FDCCD09F8500@VI1PR0401MB2237.eurprd04.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Dec 2019 19:12:08 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Y.b. Lu" <yangbo.lu@nxp.com>
Date: Tue, 17 Dec 2019 02:24:13 +0000

>> -----Original Message-----
>> From: Ioana Ciornei <ioana.ciornei@nxp.com>
>> Sent: Monday, December 16, 2019 11:33 PM
>> To: davem@davemloft.net; netdev@vger.kernel.org
>> Cc: Ioana Ciornei <ioana.ciornei@nxp.com>; Y.b. Lu <yangbo.lu@nxp.com>
>> Subject: [PATCH net v2] dpaa2-ptp: fix double free of the ptp_qoriq IRQ
> 
> [Y.b. Lu] Reviewed-by: Yangbo Lu <yangbo.lu@nxp.com>

Please start your tags on the first column of the line, do not
add these "[Y.b. Lu] " prefixes as it can confuse automated tools
that look for the tags.
