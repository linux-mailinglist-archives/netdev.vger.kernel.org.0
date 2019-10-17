Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF82DB85A
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 22:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437205AbfJQUfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 16:35:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:33790 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391182AbfJQUfP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 16:35:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F12B3AE4D;
        Thu, 17 Oct 2019 20:35:13 +0000 (UTC)
Message-ID: <1571344510.5264.18.camel@suse.com>
Subject: Re: [PATCH] usb: hso: obey DMA rules in tiocmget
From:   Oliver Neukum <oneukum@suse.com>
To:     David Miller <davem@davemloft.net>
Cc:     johan@kernel.org, netdev@vger.kernel.org
Date:   Thu, 17 Oct 2019 22:35:10 +0200
In-Reply-To: <20191017.142055.130965767343659716.davem@davemloft.net>
References: <20191017095339.25034-1-oneukum@suse.com>
         <20191017.141955.1615614075310331285.davem@davemloft.net>
         <20191017.142055.130965767343659716.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Donnerstag, den 17.10.2019, 14:20 -0400 schrieb David Miller:
> From: David Miller <davem@davemloft.net>
> Date: Thu, 17 Oct 2019 14:19:55 -0400 (EDT)
> 
> > From: Oliver Neukum <oneukum@suse.com>
> > Date: Thu, 17 Oct 2019 11:53:38 +0200
> > 
> > > The serial state information must not be embedded into another
> > > data structure, as this interferes with cache handling for DMA
> > > on architectures without cache coherence..
> > > That would result in data corruption on some architectures
> > > Allocating it separately.
> > > 
> > > Signed-off-by: Oliver Neukum <oneukum@suse.com>
> > 
> > Applied, thanks Oliver.
> 
> Ugh, Oliver did you even build test this?
> 
> drivers/net/usb/hso.c:189:9: error: expected ‘{’ before ‘*’ token
>   189 |  struct *hso_serial_state_notification serial_state_notification;
> 
> Seriously, I expect better from an experienced developer such as
> yourself.

Sorry, that is why I sent a v2. I built it, but not alone. I have
a cleanup series for that driver in the works.

	Sorry
		Oliver

