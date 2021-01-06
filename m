Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589842EBAB4
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 08:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbhAFHuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 02:50:54 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:57933 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbhAFHuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 02:50:54 -0500
Received: from marcel-macbook.holtmann.net (p5b3d23d0.dip0.t-ipconnect.de [91.61.35.208])
        by mail.holtmann.org (Postfix) with ESMTPSA id D955ACED10;
        Wed,  6 Jan 2021 08:57:32 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.40.0.2.32\))
Subject: Re: [PATCH] Bluetooth: avoid u128_xor() on potentially misaligned
 inputs
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210105161053.6642-1-ardb@kernel.org>
Date:   Wed, 6 Jan 2021 08:50:11 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <51147682-7227-45AF-8B2F-77F14B02EA7A@holtmann.org>
References: <20210105161053.6642-1-ardb@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
X-Mailer: Apple Mail (2.3654.40.0.2.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ard,

> u128_xor() takes pointers to quantities that are assumed to be at least
> 64-bit aligned, which is not guaranteed to be the case in the smp_c1()
> routine. So switch to crypto_xor() instead.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
> net/bluetooth/smp.c | 5 ++---
> 1 file changed, 2 insertions(+), 3 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

