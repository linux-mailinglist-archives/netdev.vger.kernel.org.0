Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2445D3234D5
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 02:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233360AbhBXBDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 20:03:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:33978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233253AbhBXAuJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 19:50:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BC06614A7;
        Wed, 24 Feb 2021 00:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614127768;
        bh=wlubzpWgvnu0LkdUcpm43QontFBvWFgIA554YvBAuhc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n8QTUWe5/IKXHhXC9FEXhIMP5ea1OS7j7IaW4acio6j7fXq7CV9vTFz+NYoD5A/WA
         EXKFIwwr/0t2Qjlletof3k87VvKt+lF5m2G2ypIlFlPswUDMe7japOfWhzq3qWRuX1
         jfRDgkCmU/PzJ2c5EHwLUAryVhj3pP3CF4jYRBPjguVI6lYzcdNw9tB9hNKw8d8dxK
         ty+KfAryWh4u/eNgFwpmkl7gyxkIRLQOvby/kbaBQB6Kz/eMOgRQcgvv5fRnMaaKeC
         6oONx2yiQmIuoPv0/7Sjo6CrcxvVBRZbe5f3HptRU+FMwJODTZ3JKBBHlvgiN3m8kD
         gL8TFcu07DXsA==
Date:   Tue, 23 Feb 2021 16:49:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     syzbot <syzbot+7bf7b22759195c9a21e9@syzkaller.appspotmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        syzkaller-bugs@googlegroups.com
Subject: Re: UBSAN: shift-out-of-bounds in nl802154_new_interface
Message-ID: <20210223164924.080fa605@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAB_54W6FL2vDto3_1=0kAa8qo_qTduCfULLCfvD_XbS4=+VZyw@mail.gmail.com>
References: <000000000000e37c9805bbe843c1@google.com>
        <20210223154855.669413bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAB_54W6FL2vDto3_1=0kAa8qo_qTduCfULLCfvD_XbS4=+VZyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Feb 2021 19:26:26 -0500 Alexander Aring wrote:
> Hi,
> 
> On Tue, 23 Feb 2021 at 18:48, Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > Alex, there seems to be a few more syzbot reports for nl802154 beyond
> > what you posted fixes for. Are you looking at these?  
> 
> Yes, I have it on my list. I will try to fix them at the weekend.

Great, thank you!
