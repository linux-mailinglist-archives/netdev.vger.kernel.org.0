Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E30A61046
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 13:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfGFLIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 07:08:17 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:59311 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbfGFLIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 07:08:17 -0400
Received: from [192.168.0.113] (CMPC-089-239-107-172.CNet.Gawex.PL [89.239.107.172])
        by mail.holtmann.org (Postfix) with ESMTPSA id 03520CEFAE;
        Sat,  6 Jul 2019 13:16:46 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH] Bluetooth: hidp: NUL terminate a string in the compat
 ioctl
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20190516182400.GA8270@mwanda>
Date:   Sat, 6 Jul 2019 13:08:13 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Mark Salyzyn <salyzyn@android.com>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        Allen Pais <allen.pais@oracle.com>,
        Young Xiao <YangX92@hotmail.com>
Content-Transfer-Encoding: 7bit
Message-Id: <3D402D33-37D1-4FAA-B7C0-2D9C2CC5C2DE@holtmann.org>
References: <20190516182400.GA8270@mwanda>
To:     Dan Carpenter <dan.carpenter@oracle.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

> This change is similar to commit a1616a5ac99e ("Bluetooth: hidp: fix
> buffer overflow") but for the compat ioctl.  We take a string from the
> user and forgot to ensure that it's NUL terminated.
> 
> I have also changed the strncpy() in to strscpy() in hidp_setup_hid().
> The difference is the strncpy() doesn't necessarily NUL terminate the
> destination string.  Either change would fix the problem but it's nice
> to take a belt and suspenders approach and do both.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> net/bluetooth/hidp/core.c | 2 +-
> net/bluetooth/hidp/sock.c | 1 +
> 2 files changed, 2 insertions(+), 1 deletion(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

