Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7496816EF7A
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 20:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730961AbgBYT5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 14:57:13 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34014 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728051AbgBYT5N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 14:57:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=es4WOeJj2+2O+THX9vfMW8O0+H3ZOd3FPbMxZWfkRGc=; b=gwXGmZUF0+32auLLEixq7KtUF9
        xgowB4ZoBgpdWNcUNHVnibNUELzh4cE9m5gddN5RbWlNgt2U7wOAWg74f10l4VEx6GPj3RRXsP62D
        ctnzex2loii2QJMG7L450aVZN+Y7XWtZ9aE+W/l0WjukTZ2KGQ3HdZoGtoQcO/05zsB0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j6gKM-00011y-Pu; Tue, 25 Feb 2020 20:57:10 +0100
Date:   Tue, 25 Feb 2020 20:57:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sriram Chadalavada <sriram.chadalavada@mindleap.ca>
Cc:     netdev@vger.kernel.org
Subject: Re: Fwd: Kernel crash due to conflict between legacy and current DSA
 mv88e6xxx drivers ?
Message-ID: <20200225195710.GC7663@lunn.ch>
References: <CAOK2joHUDyZvGx6rkMS4D6-Rw0yznc2Q68JXdnUK1e=xN2X9Hw@mail.gmail.com>
 <CAOK2joG_XixQ5EKUcxOph_gECBqfZGuW8=7dwpdskHpgUO5qug@mail.gmail.com>
 <CAOK2joEyyQHmsKz1L6WV_5XmDmP5ZGhucLwFY_CT+U=AiySeNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOK2joEyyQHmsKz1L6WV_5XmDmP5ZGhucLwFY_CT+U=AiySeNA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> https://www.spinics.net/lists/netdev/msg556413.html seems to suggest
> that legacy DSA is still being used for Marvell 88e6xxx drivers.

No, as Florian says, legacy is not used any more. It has been removed

commit 93e86b3bc842c159a60e6987444bf3952adcd4db
Author: Andrew Lunn <andrew@lunn.ch>
Date:   Sun Apr 28 02:56:23 2019 +0200

    net: dsa: Remove legacy probing support
    
    Now that all drivers can be probed using more traditional methods,
    remove the legacy probe code.
    
    Signed-off-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
