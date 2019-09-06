Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE167ABA6B
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 16:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392662AbfIFOMo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 6 Sep 2019 10:12:44 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:56083 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731109AbfIFOMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 10:12:44 -0400
Received: from marcel-macbook.fritz.box (p4FEFC197.dip0.t-ipconnect.de [79.239.193.151])
        by mail.holtmann.org (Postfix) with ESMTPSA id C05D4CECE0;
        Fri,  6 Sep 2019 16:21:29 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH] Bluetooth: hidp: Fix error checks in
 hidp_get/set_raw_report
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20190906140744.GC14147@kadam>
Date:   Fri, 6 Sep 2019 16:12:41 +0200
Cc:     Dan Elkouby <streetwalkermc@gmail.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Fabian Henneke <fabian.henneke@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <48E8A989-AE89-4F59-84F4-075911F4FC75@holtmann.org>
References: <20190906094158.8854-1-streetwalkermc@gmail.com>
 <440C3662-1870-44D8-B4E3-C290CE154F1E@holtmann.org>
 <20190906140744.GC14147@kadam>
To:     Dan Carpenter <dan.carpenter@oracle.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

>>> Commit 48d9cc9d85dd ("Bluetooth: hidp: Let hidp_send_message return
>>> number of queued bytes") changed hidp_send_message to return non-zero
>>> values on success, which some other bits did not expect. This caused
>>> spurious errors to be propagated through the stack, breaking some (all?)
>>> drivers, such as hid-sony for the Dualshock 4 in Bluetooth mode.
>>> 
>>> Signed-off-by: Dan Elkouby <streetwalkermc@gmail.com>
>>> ---
>>> net/bluetooth/hidp/core.c | 4 ++--
>>> 1 file changed, 2 insertions(+), 2 deletions(-)
>> 
>> patch has been applied to bluetooth-next tree.
>> 
> 
> The v2 added an additional fix and used the Fixes tag.  Could you apply
> that instead?

see my reply to Jiri. I replied to the wrong patch, but actually applied to the updated one.

Regards

Marcel

