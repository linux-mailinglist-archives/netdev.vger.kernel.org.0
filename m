Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D0537620E
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 10:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236293AbhEGIde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 04:33:34 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:37904 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbhEGIdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 04:33:32 -0400
Received: from smtpclient.apple (p4fefc624.dip0.t-ipconnect.de [79.239.198.36])
        by mail.holtmann.org (Postfix) with ESMTPSA id F05DECECDB;
        Fri,  7 May 2021 10:40:16 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.80.0.2.43\))
Subject: Re: [PATCH] Bluetooth: 6lowpan: remove unused function
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1618476568-117243-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Date:   Fri, 7 May 2021 10:32:26 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <3E023ED4-320B-4713-A9CF-A92FF4DE1065@holtmann.org>
References: <1618476568-117243-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
X-Mailer: Apple Mail (2.3654.80.0.2.43)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiapeng,

> Fix the following clang warning:
> 
> net/bluetooth/6lowpan.c:913:20: warning: unused function 'bdaddr_type'
> [-Wunused-function].
> 
> net/bluetooth/6lowpan.c:106:35: warning: unused function
> 'peer_lookup_ba' [-Wunused-function].
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
> net/bluetooth/6lowpan.c | 36 ------------------------------------
> 1 file changed, 36 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

