Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 426C84DB4ED
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 16:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353997AbiCPPdb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 16 Mar 2022 11:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241366AbiCPPda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 11:33:30 -0400
Received: from mail.holtmann.org (coyote.holtmann.net [212.227.132.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EBFE46CA74
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:32:15 -0700 (PDT)
Received: from smtpclient.apple (p5b3d2183.dip0.t-ipconnect.de [91.61.33.131])
        by mail.holtmann.org (Postfix) with ESMTPSA id 268DECECF8;
        Wed, 16 Mar 2022 16:32:15 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [PATCH] Bluetooth: call hci_le_conn_failed with hdev lock in
 hci_le_conn_failed
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20220316152027.9988-1-dossche.niels@gmail.com>
Date:   Wed, 16 Mar 2022 16:32:14 +0100
Cc:     netdev@vger.kernel.org, Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <03B539EF-D2F4-4345-A6F9-F2F77CAA41C5@holtmann.org>
References: <20220316152027.9988-1-dossche.niels@gmail.com>
To:     Niels Dossche <dossche.niels@gmail.com>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Niels,

> hci_le_conn_failed function's documentation says that the caller must
> hold hdev->lock. The only callsite that does not hold that lock is
> hci_le_conn_failed. The other 3 callsites hold the hdev->lock very
> locally. The solution is to hold the lock during the call to
> hci_le_conn_failed.
> 
> Fixes: 3c857757ef6e ("Bluetooth: Add directed advertising support through connect()")
> Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
> ---
> net/bluetooth/hci_conn.c | 2 ++
> 1 file changed, 2 insertions(+)

please send net/bluetooth/ to linux-bluetooth mailing list.

Regards

Marcel

