Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15EEAABA0E
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 15:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393795AbfIFN5Z convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 6 Sep 2019 09:57:25 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:40220 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728978AbfIFN5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 09:57:25 -0400
Received: from marcel-macbook.fritz.box (p4FEFC197.dip0.t-ipconnect.de [79.239.193.151])
        by mail.holtmann.org (Postfix) with ESMTPSA id 697A5CECDF;
        Fri,  6 Sep 2019 16:06:11 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH] Bluetooth: hidp: Fix assumptions on the return value of
 hidp_send_message
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <nycvar.YFH.7.76.1909061330390.31470@cbobk.fhfr.pm>
Date:   Fri, 6 Sep 2019 15:57:23 +0200
Cc:     Dan Elkouby <streetwalkermc@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Brian Norris <computersforpeace@gmail.com>,
        Fabian Henneke <fabian.henneke@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <3D70AB75-FEFB-4EB3-9AC8-3BCE90F5458D@holtmann.org>
References: <20190906101306.GA12017@kadam>
 <20190906110645.27601-1-streetwalkermc@gmail.com>
 <nycvar.YFH.7.76.1909061330390.31470@cbobk.fhfr.pm>
To:     Jiri Kosina <jikos@kernel.org>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

>> hidp_send_message was changed to return non-zero values on success,
>> which some other bits did not expect. This caused spurious errors to be
>> propagated through the stack, breaking some drivers, such as hid-sony
>> for the Dualshock 4 in Bluetooth mode.
>> 
>> As pointed out by Dan Carpenter, hid-microsoft directly relied on that
>> assumption as well.
>> 
>> Fixes: 48d9cc9d85dd ("Bluetooth: hidp: Let hidp_send_message return number of queued bytes")
>> 
>> Signed-off-by: Dan Elkouby <streetwalkermc@gmail.com>
> 
> Reviewed-by: Jiri Kosina <jkosina@suse.cz>
> 
> Marcel, are you taking this through your tree?

I am taking this through my tree. And yes, I applied the updated patch, but answered the other ;)

Regards

Marcel

