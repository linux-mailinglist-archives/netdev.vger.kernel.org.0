Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1367C8E92F
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 12:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730707AbfHOKmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 06:42:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:51988 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726027AbfHOKmG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 06:42:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1EE1DADCB;
        Thu, 15 Aug 2019 10:42:03 +0000 (UTC)
Message-ID: <1565865720.5780.3.camel@suse.com>
Subject: Re: [PATCH] net: usbnet: fix a memory leak bug
From:   Oliver Neukum <oneukum@suse.com>
To:     Wenwen Wang <wenwen@cs.uga.edu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:USB NETWORKING DRIVERS" <linux-usb@vger.kernel.org>,
        "open list:USB USBNET DRIVER FRAMEWORK" <netdev@vger.kernel.org>
Date:   Thu, 15 Aug 2019 12:42:00 +0200
In-Reply-To: <1565804493-7758-1-git-send-email-wenwen@cs.uga.edu>
References: <1565804493-7758-1-git-send-email-wenwen@cs.uga.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Mittwoch, den 14.08.2019, 12:41 -0500 schrieb Wenwen Wang:
> In usbnet_start_xmit(), 'urb->sg' is allocated through kmalloc_array() by
> invoking build_dma_sg(). Later on, if 'CONFIG_PM' is defined and the if
> branch is taken, the execution will go to the label 'deferred'. However,
> 'urb->sg' is not deallocated on this execution path, leading to a memory
> leak bug.

Just to make this clear:

> Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
NACK

For the reason Jack explained. Deferral is not a failure.

	Regards
		Oliver

