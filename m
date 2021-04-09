Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3771135A05D
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 15:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233534AbhDINwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 09:52:13 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:40226 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232642AbhDINwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 09:52:08 -0400
Received: from marcel-macbook.holtmann.net (p5b3d235a.dip0.t-ipconnect.de [91.61.35.90])
        by mail.holtmann.org (Postfix) with ESMTPSA id 5C4A8CECC3;
        Fri,  9 Apr 2021 15:59:37 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH] net/Bluetooth - delete unneeded variable initialization
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1617360389-42664-1-git-send-email-yekai13@huawei.com>
Date:   Fri, 9 Apr 2021 15:51:53 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <C1B92089-BE7C-4495-BAB3-8000EA3996BC@holtmann.org>
References: <1617360389-42664-1-git-send-email-yekai13@huawei.com>
To:     Kai Ye <yekai13@huawei.com>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kai,

> Delete unneeded variable initialization.
> 
> Signed-off-by: Kai Ye <yekai13@huawei.com>
> ---
> net/bluetooth/6lowpan.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

