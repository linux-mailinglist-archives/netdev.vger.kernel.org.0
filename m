Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C91C6900A5
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 08:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjBIHCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 02:02:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBIHCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 02:02:10 -0500
Received: from mail.holtmann.org (coyote.holtmann.net [212.227.132.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D0A1A4108B
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 23:02:08 -0800 (PST)
Received: from smtpclient.apple (p5b3d2eb0.dip0.t-ipconnect.de [91.61.46.176])
        by mail.holtmann.org (Postfix) with ESMTPSA id 24484CECE7;
        Thu,  9 Feb 2023 08:02:07 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.2\))
Subject: Re: [PATCH v4 2/2] Bluetooth: btrtl: add support for the RTL8723CS
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CABBYNZKnt5=dar6Rmav=Tv3QH1ghSUV2osZPnp7OQLcANp_1Tw@mail.gmail.com>
Date:   Thu, 9 Feb 2023 08:02:06 +0100
Cc:     Bastian Germann <bage@debian.org>,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        BlueZ <linux-bluetooth@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <0B0EFD39-825F-4635-A7F3-CA96BCFED9A2@holtmann.org>
References: <20230208155220.1640-1-bage@debian.org>
 <20230208155220.1640-3-bage@debian.org>
 <CABBYNZKnt5=dar6Rmav=Tv3QH1ghSUV2osZPnp7OQLcANp_1Tw@mail.gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
X-Mailer: Apple Mail (2.3696.120.41.1.2)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luiz,

>> The Realtek RTL8723CS is a SDIO WiFi chip. It also contains a Bluetooth
>> module which is connected via UART to the host.
>> 
>> It shares lmp subversion with 8703B, so Realtek's userspace
>> initialization tool (rtk_hciattach) differentiates varieties of RTL8723CS
>> (CG, VF, XX) with RTL8703B using vendor's command to read the chip type.
> 
> Don't remember anything called rtk_hciattach, besides if that is based
> on hciattach that is already deprecated in favor of btattach.

and btattach is also deprecated. Write a proper serdev based driver.

The hci_ldisc line discipline crap needs to be removed.

Regards

Marcel

