Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3E3A8A35C
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 18:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbfHLQ3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 12:29:34 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:47453 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfHLQ3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 12:29:34 -0400
Received: from marcel-macbook.fritz.box (p4FEFC580.dip0.t-ipconnect.de [79.239.197.128])
        by mail.holtmann.org (Postfix) with ESMTPSA id 2CE6CCECF4;
        Mon, 12 Aug 2019 18:38:14 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH v5 18/29] compat_ioctl: move rfcomm handlers into driver
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20190730195819.901457-6-arnd@arndb.de>
Date:   Mon, 12 Aug 2019 18:29:32 +0200
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <C12653E2-D2EB-423E-82BF-35C05CD1984D@holtmann.org>
References: <20190730192552.4014288-1-arnd@arndb.de>
 <20190730195819.901457-1-arnd@arndb.de>
 <20190730195819.901457-6-arnd@arndb.de>
To:     Arnd Bergmann <arnd@arndb.de>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

> All these ioctl commands are compatible, so we can handle
> them with a trivial wrapper in rfcomm/sock.c and remove
> the listing in fs/compat_ioctl.c.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> fs/compat_ioctl.c           |  6 ------
> net/bluetooth/rfcomm/sock.c | 14 ++++++++++++--
> 2 files changed, 12 insertions(+), 8 deletions(-)

I think it is best if this series is applied as a whole. So whoever takes it

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel

