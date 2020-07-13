Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5316621DDB1
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 18:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730551AbgGMQmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 12:42:04 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:47865 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730298AbgGMQmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 12:42:02 -0400
Received: from marcel-macbook.fritz.box (p5b3d2638.dip0.t-ipconnect.de [91.61.38.56])
        by mail.holtmann.org (Postfix) with ESMTPSA id 8F230CECC9;
        Mon, 13 Jul 2020 18:51:58 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [Linux-kernel-mentees] [PATCH 1/2] net/bluetooth: Prevent
 out-of-bounds read in hci_inquiry_result_evt()
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <3f69f09d6eb0bc1430cae2894c635252a1cb09e1.1594414498.git.yepeilin.cs@gmail.com>
Date:   Mon, 13 Jul 2020 18:42:00 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <72AE7F80-CE19-4051-85DB-60A3FD80D390@holtmann.org>
References: <3f69f09d6eb0bc1430cae2894c635252a1cb09e1.1594414498.git.yepeilin.cs@gmail.com>
To:     Peilin Ye <yepeilin.cs@gmail.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Peilin,

> Check `num_rsp` before using it as for-loop counter.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> ---
> net/bluetooth/hci_event.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

