Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFD7354ED2
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 10:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244427AbhDFImd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 04:42:33 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:42638 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232876AbhDFImc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 04:42:32 -0400
Received: from marcel-macbook.holtmann.net (p4ff9fed5.dip0.t-ipconnect.de [79.249.254.213])
        by mail.holtmann.org (Postfix) with ESMTPSA id 91C3ECED1D;
        Tue,  6 Apr 2021 10:50:05 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH] net/Bluetooth - use the correct print format
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1617690384-48272-1-git-send-email-yekai13@huawei.com>
Date:   Tue, 6 Apr 2021 10:42:22 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <57C48BD1-8872-42C7-928C-7498C34DFE04@holtmann.org>
References: <1617690384-48272-1-git-send-email-yekai13@huawei.com>
To:     Kai Ye <yekai13@huawei.com>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kai,

> Use the correct print format. Printing an unsigned int value should use %u
> instead of %d. For details, please read document:
> Documentation/core-api/printk-formats.rst
> 
> Signed-off-by: Kai Ye <yekai13@huawei.com>
> ---
> net/bluetooth/l2cap_core.c | 16 ++++++++--------
> 1 file changed, 8 insertions(+), 8 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

