Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA7D64B5340
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 15:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355113AbiBNO03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 09:26:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355102AbiBNO03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 09:26:29 -0500
X-Greylist: delayed 490 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 14 Feb 2022 06:26:20 PST
Received: from mail.holtmann.org (coyote.holtmann.net [212.227.132.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 558EB93;
        Mon, 14 Feb 2022 06:26:20 -0800 (PST)
Received: from smtpclient.apple (p4fefcd07.dip0.t-ipconnect.de [79.239.205.7])
        by mail.holtmann.org (Postfix) with ESMTPSA id 7CA08CED32;
        Mon, 14 Feb 2022 15:18:09 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.60.0.1.1\))
Subject: Re: [PATCH] Bluetooth: 6lowpan: No need to clear memory twice
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <2f67f1c5ed7de38b78a296c798f3d4afe9e3bd63.1644787831.git.christophe.jaillet@wanadoo.fr>
Date:   Mon, 14 Feb 2022 15:18:09 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        BlueZ <linux-bluetooth@vger.kernel.org>, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <5FD0BDD8-3EC8-4A22-92F3-1235E1E44CC5@holtmann.org>
References: <2f67f1c5ed7de38b78a296c798f3d4afe9e3bd63.1644787831.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
X-Mailer: Apple Mail (2.3693.60.0.1.1)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christophe,

> 'peer_addr' is a structure embedded in 'struct lowpan_peer'. So there is no
> need to explicitly call memset(0) on it. It is already zeroed by kzalloc()
> when 'peer' is allocated.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> net/bluetooth/6lowpan.c | 1 -
> 1 file changed, 1 deletion(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

