Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BED988F08
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 04:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfHKCCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 22:02:49 -0400
Received: from mail.nic.cz ([217.31.204.67]:46724 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726497AbfHKCCt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Aug 2019 22:02:49 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id E88EE140934;
        Sun, 11 Aug 2019 04:02:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1565488968; bh=ZEL0EDnWAWpS9AHlSvQKL4q7w5uGGdmbE5QWhq1bvC4=;
        h=Date:From:To;
        b=gBvxTwS4mpiKAyolUiwnLF632mGfjF1KRjGOOLOnywqP4LxUS4w6uuKtu+edPX8gL
         mstqh4YiTwYVJJTfUt/L1CgDtnHUbtDfztDkKBbrrC2rOhTbjiWnaDRxYplZ4G19am
         urjox9WTdZz3x+jq2fiVWPEh6c2RBhszldeXQroI=
Date:   Sun, 11 Aug 2019 04:02:47 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 1/1] net: dsa: fix fixed-link port registration
Message-ID: <20190811040247.03dcc403@nic.cz>
In-Reply-To: <20190811034742.349f0ef1@nic.cz>
References: <20190811014650.28141-1-marek.behun@nic.cz>
        <20190811034742.349f0ef1@nic.cz>
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

Which means I should have added the Fixes tag /o\

On Sun, 11 Aug 2019 03:47:42 +0200
Marek Behun <marek.behun@nic.cz> wrote:

> This should probably go into stable as well, after review.
> 
> Marek
