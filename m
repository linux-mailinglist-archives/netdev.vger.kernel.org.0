Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C843A88F31
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 05:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfHKDT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 23:19:26 -0400
Received: from mail.nic.cz ([217.31.204.67]:47028 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbfHKDT0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Aug 2019 23:19:26 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id 57EED140BB0;
        Sun, 11 Aug 2019 05:19:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1565493564; bh=fPo9phXeaLZl59m9srX/u8moxfAKsDJ8f1MTnfcIL9s=;
        h=Date:From:To;
        b=J6cIKHyIzYDGLC641lRyYfSsEOUDBM8Iye7JTbg6hA+KqdmUPagPXTNYIbk60tkQI
         2XXHyhRAn71oKAE94Z0yDuVseCxrcjGHxGhPmoBwko+hGEKGGBXLS9ZlueK1g51b6M
         d5R+ElwPmIk/iKwDH8ScGoYQr9yL09r0ssfCirx4=
Date:   Sun, 11 Aug 2019 05:19:23 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com,
        sebastian.reichel@collabora.co.uk, vivien.didelot@gmail.com,
        andrew@lunn.ch, f.fainelli@gmail.com
Subject: Re: [PATCH net-next 1/1] net: dsa: fix fixed-link port registration
Message-ID: <20190811051923.6b7e7b52@nic.cz>
In-Reply-To: <20190810.200001.1046174945054576670.davem@davemloft.net>
References: <20190811014650.28141-1-marek.behun@nic.cz>
        <20190811034742.349f0ef1@nic.cz>
        <20190811040247.03dcc403@nic.cz>
        <20190810.200001.1046174945054576670.davem@davemloft.net>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 10 Aug 2019 20:00:01 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Marek Behun <marek.behun@nic.cz>
> Date: Sun, 11 Aug 2019 04:02:47 +0200
> 
> > Which means I should have added the Fixes tag /o\  
> 
> Which means you need to repost this patch with it added.

Sent as v2
