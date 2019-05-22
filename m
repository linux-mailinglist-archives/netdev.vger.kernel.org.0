Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88FAB26653
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 16:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729709AbfEVOwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 10:52:38 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:43103 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728450AbfEVOwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 10:52:38 -0400
Received: from localhost ([10.193.186.161])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id x4MEqYxG031431;
        Wed, 22 May 2019 07:52:35 -0700
Date:   Wed, 22 May 2019 20:22:37 +0530
From:   Vishal Kulkarni <vishal@chelsio.com>
To:     David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nirranjan Kirubaharan <nirranjan@chelsio.com>,
        Indranil Choudhury <indranil@chelsio.com>, dt <dt@chelsio.com>
Subject: Re: [PATCH net-next] cxgb4: Revert "cxgb4: Remove SGE_HOST_PAGE_SIZE
 dependency on page size"
Message-ID: <20190522145235.GA8075@chelsio.com>
References: <1558410122-29341-1-git-send-email-vishal@chelsio.com>
 <20190521.132331.1475679105999327536.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521.132331.1475679105999327536.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Wednesday, May 05/22/19, 2019 at 01:53:31 +0530, David Miller wrote:
> From: Vishal Kulkarni <vishal@chelsio.com>
> Date: Tue, 21 May 2019 09:12:02 +0530
> 
> > This reverts commit 2391b0030e241386d710df10e53e2cfc3c5d4fc1
> > SGE's BAR2 Doorbell/GTS Page Size is now interpreted correctly in the
> > firmware itself by using actual host page size. Hence previous commit
> > needs to be reverted.
> > 
> > Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>
> 
> Really confusing.
> 
> First of all, I see a lot of cxgb4 patch submissions targetting net-next that
> are really legitimate bug fixes.
> 
> Are you only targetting net-next to be "on the safe side" because you are
> unsure of the 'net' rules?  Please don't do that.  If it's a bug fix, send
> it to 'net' as appropriate.

My apologies. I will retarget to 'net' and resend.

> 
> Second, so what happens to people running older firmware?  Have you made a
> completely incompatible change to the firmware behavior?  If so, you have
> to version check the firmware and use the correct interpretation based upon
> how the firmware verion interprets things.

The fix in the commit 2391b0030e241386d710df10e53e2cfc3c5d4fc1 is wrong
and introduced regression. The correct fix is done in the firmware and 
hence it needs to be reverted. The changes done in firmware is compatible.

> 
> Thanks.
