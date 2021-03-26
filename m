Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2736634A29F
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 08:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbhCZHjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 03:39:31 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:55027 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbhCZHjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 03:39:07 -0400
Received: from marcel-macbook.holtmann.net (p4fefce19.dip0.t-ipconnect.de [79.239.206.25])
        by mail.holtmann.org (Postfix) with ESMTPSA id C2565CEC82;
        Fri, 26 Mar 2021 08:46:44 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH] Bluetooth: L2CAP: Rudimentary typo fixes
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210325043544.29248-1-unixbhaskar@gmail.com>
Date:   Fri, 26 Mar 2021 08:39:04 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, rdunlap@infradead.org
Content-Transfer-Encoding: 7bit
Message-Id: <BE8F35E8-42D5-42E1-BCCC-576936F00540@holtmann.org>
References: <20210325043544.29248-1-unixbhaskar@gmail.com>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bhaskar,

> s/minium/minimum/
> s/procdure/procedure/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
> net/bluetooth/l2cap_core.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

