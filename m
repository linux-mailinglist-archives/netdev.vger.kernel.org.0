Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 641F817D3F1
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 14:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgCHNpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 09:45:46 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:52177 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgCHNpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 09:45:46 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id E1A92CED1A;
        Sun,  8 Mar 2020 14:55:11 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH v2] bluetooth/rfcomm: fix ODEBUG bug in rfcomm_dev_ioctl
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1583660727-9227-1-git-send-email-hqjagain@gmail.com>
Date:   Sun, 8 Mar 2020 14:45:43 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hdanton@sina.com
Content-Transfer-Encoding: 7bit
Message-Id: <09FF395C-AA3B-461B-A825-E8683C9A97D5@holtmann.org>
References: <1583660727-9227-1-git-send-email-hqjagain@gmail.com>
To:     Qiujun Huang <hqjagain@gmail.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Qiujun,

> Needn't call 'rfcomm_dlc_put' here, because 'rfcomm_dlc_exists' didn't
> increase dlc->refcnt.
> 
> Reported-by: syzbot+4496e82090657320efc6@syzkaller.appspotmail.com
> Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
> Suggested-by: Hillf Danton <hdanton@sina.com>
> ---
> net/bluetooth/rfcomm/tty.c | 4 +---
> 1 file changed, 1 insertion(+), 3 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

