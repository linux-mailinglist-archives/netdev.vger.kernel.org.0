Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53AF5442BFD
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 11:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbhKBLCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 07:02:14 -0400
Received: from todd.t-8ch.de ([159.69.126.157]:48783 "EHLO todd.t-8ch.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229577AbhKBLCO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 07:02:14 -0400
Date:   Tue, 2 Nov 2021 11:59:32 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=weissschuh.net;
        s=mail; t=1635850778;
        bh=EQgH6iFqsqRpn3YWDSWz+nzr9GGk1LqsgNBEiOd9Bno=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YOsujDQuLI5Pd5A72ogB7lsJe//g7lv4F5YHhFsroauupNNiSYRf3RnB3z3hImV1d
         jSzB/ucHxWr7yBQtfAr8cPdjktzgkQUlw7wcPYyucv3hdtlWK3fmGvjRDh4DUpipbb
         4mPVMzAS4ahegxuObHfWUhr1nYJdRED7cyGNQYLo=
From:   Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/9p: autoload transport modules
Message-ID: <922a4843-c7b0-4cdc-b2a6-33bf089766e4@t-8ch.de>
References: <20211017134611.4330-1-linux@weissschuh.net>
 <YYEYMt543Hg+Hxzy@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YYEYMt543Hg+Hxzy@codewreck.org>
Jabber-ID: thomas@t-8ch.de
X-Accept: text/plain, text/html;q=0.2, text/*;q=0.1
X-Accept-Language: en-us, en;q=0.8, de-de;q=0.7, de;q=0.6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2021-11-02 19:51+0900, Dominique Martinet wrote:
> Sorry for the late reply
> 
> Thomas Weißschuh wrote on Sun, Oct 17, 2021 at 03:46:11PM +0200:
> > Automatically load transport modules based on the trans= parameter
> > passed to mount.
> > The removes the requirement for the user to know which module to use.
> 
> This looks good to me, I'll test this briefly on differnet config (=y,
> =m) and submit to Linus this week for the next cycle.

Thanks. Could you also fix up the typo in the commit message when applying?
("The removes" -> "This removes")

> Makes me wonder why trans_fd is included in 9pnet and not in a 9pnet-fd
> or 9pnet-tcp module but that'll be for another time...

To prepare for the moment when those transport modules are split into their own
module(s), we could already add MODULE_ALIAS_9P() calls to net/9p/trans_fd.c.

Thomas
