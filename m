Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74C086C34C
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 00:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729497AbfGQWwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 18:52:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:36672 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727653AbfGQWwr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 18:52:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 522FFAB91;
        Wed, 17 Jul 2019 22:52:46 +0000 (UTC)
Date:   Thu, 18 Jul 2019 07:52:39 +0900
From:   Benjamin Poirier <bpoirier@suse.com>
To:     David Miller <davem@davemloft.net>
Cc:     gregkh@linuxfoundation.org, GR-Linux-NIC-Dev@marvell.com,
        manishc@marvell.com, netdev@vger.kernel.org
Subject: Re: [PATCH] qlge: Move drivers/net/ethernet/qlogic/qlge/ to
 drivers/staging/qlge/
Message-ID: <20190717225239.GA12765@f1>
References: <20190716023459.23266-1-bpoirier@suse.com>
 <20190717.120208.205802053970227674.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190717.120208.205802053970227674.davem@davemloft.net>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/07/17 12:02, David Miller wrote:
> From: Benjamin Poirier <bpoirier@suse.com>
> Date: Tue, 16 Jul 2019 11:34:59 +0900
> 
> > The hardware has been declared EOL by the vendor more than 5 years ago.
> > What's more relevant to the Linux kernel is that the quality of this driver
> > is not on par with many other mainline drivers.
> > 
> > Cc: Manish Chopra <manishc@marvell.com>
> > Message-id: <20190617074858.32467-1-bpoirier@suse.com>
> > Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
> 
> Please resubmit this when the net-next tree opens back up.
> 

Sorry, I thought this was gonna go through Greg's tree. Will do.
