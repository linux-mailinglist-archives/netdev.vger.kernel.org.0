Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFA411D706
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 20:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730681AbfLLTZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 14:25:04 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43118 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730430AbfLLTZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 14:25:04 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C1936153E344D;
        Thu, 12 Dec 2019 11:25:03 -0800 (PST)
Date:   Thu, 12 Dec 2019 11:25:03 -0800 (PST)
Message-Id: <20191212.112503.2124115964978794401.davem@davemloft.net>
To:     schaferjscott@gmail.com
Cc:     dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, GR-Linux-NIC-Dev@marvell.com,
        manishc@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 11/23] staging: qlge: Fix CHECK: braces {} should be
 used on all arms of this statement
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191212150200.GA8219@karen>
References: <0e1fc1a16725094676fdab63d3a24a986309a759.1576086080.git.schaferjscott@gmail.com>
        <20191212121206.GB1895@kadam>
        <20191212150200.GA8219@karen>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Dec 2019 11:25:04 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Scott Schafer <schaferjscott@gmail.com>
Date: Thu, 12 Dec 2019 09:02:00 -0600

> On Thu, Dec 12, 2019 at 03:12:06PM +0300, Dan Carpenter wrote:
>> On Wed, Dec 11, 2019 at 12:12:40PM -0600, Scott Schafer wrote:
>> > @@ -351,8 +352,9 @@ static int ql_aen_lost(struct ql_adapter *qdev, struct mbox_params *mbcp)
>> >  	mbcp->out_count = 6;
>> >  
>> >  	status = ql_get_mb_sts(qdev, mbcp);
>> > -	if (status)
>> > +	if (status) {
>> >  		netif_err(qdev, drv, qdev->ndev, "Lost AEN broken!\n");
>> > +	}
>> >  	else {
>> 
>> The close } should be on the same line as the else.
>> 
>> >  		int i;
>> >  
>> 
>> regards,
>> dan carpenter
> 
> this was fixed in patch 22

It should not be introduced in the first place.  Therefore it needs to be dealt with
in this patch.

