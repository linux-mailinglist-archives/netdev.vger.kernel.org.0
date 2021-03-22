Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9542E344CF2
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 18:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbhCVRM4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 22 Mar 2021 13:12:56 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:47478 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbhCVRMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 13:12:18 -0400
Received: from marcel-macbook.holtmann.net (p4fefce19.dip0.t-ipconnect.de [79.239.206.25])
        by mail.holtmann.org (Postfix) with ESMTPSA id B1F35CECC4;
        Mon, 22 Mar 2021 18:19:54 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH] bluetooth: fix set_ecdh_privkey() prototype
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210322164637.941598-1-arnd@kernel.org>
Date:   Mon, 22 Mar 2021 18:12:15 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <9CD4D9AD-D1A3-4C4D-965A-7EFD918608A4@holtmann.org>
References: <20210322164637.941598-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

> gcc-11 points out that the declaration does not match the definition:
> 
> net/bluetooth/ecdh_helper.c:122:55: error: argument 2 of type ‘const u8[32]’ {aka ‘const unsigned char[32]’} with mismatched bound [-Werror=array-parameter=]
>  122 | int set_ecdh_privkey(struct crypto_kpp *tfm, const u8 private_key[32])
>      |                                              ~~~~~~~~~^~~~~~~~~~~~~~~
> In file included from net/bluetooth/ecdh_helper.c:23:
> net/bluetooth/ecdh_helper.h:28:56: note: previously declared as ‘const u8 *’ {aka ‘const unsigned char *’}
>   28 | int set_ecdh_privkey(struct crypto_kpp *tfm, const u8 *private_key);
>      |                                              ~~~~~~~~~~^~~~~~~~~~~
> 
> Change the declaration to contain the size of the array, rather than
> just a pointer.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> net/bluetooth/ecdh_helper.h | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

