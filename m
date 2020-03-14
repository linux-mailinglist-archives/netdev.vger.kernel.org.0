Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E145A185838
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbgCOB6F convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 14 Mar 2020 21:58:05 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:34600 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbgCOB6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 21:58:05 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 95D57CED19;
        Sat, 14 Mar 2020 19:59:44 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH -next] Bluetooth: L2CAP: remove set but not used variable
 'credits'
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200314100606.41532-1-yuehaibing@huawei.com>
Date:   Sat, 14 Mar 2020 19:50:14 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <DB8D6DBD-7FE3-4BF3-A284-4A0DF78F2A98@holtmann.org>
References: <20200314100606.41532-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yue,

> net/bluetooth/l2cap_core.c: In function l2cap_ecred_conn_req:
> net/bluetooth/l2cap_core.c:5848:6: warning: variable credits set but not used [-Wunused-but-set-variable]
> 
> commit 15f02b910562 ("Bluetooth: L2CAP: Add initial code for Enhanced Credit Based Mode")
> involved this unused variable, remove it.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
> net/bluetooth/l2cap_core.c | 3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

