Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 692214A7660
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 18:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240205AbiBBRBM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Feb 2022 12:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbiBBRBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 12:01:11 -0500
X-Greylist: delayed 31896 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 02 Feb 2022 09:01:10 PST
Received: from mail.corsac.net (unknown [IPv6:2a01:e0a:2ff:c170::5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C60DCC06173B
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 09:01:10 -0800 (PST)
Received: from scapa.corsac.net (unknown [37.172.237.156])
        by mail.corsac.net (Postfix) with ESMTPS id 1ACD197
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 18:01:08 +0100 (CET)
Received: from corsac (uid 1000)
        (envelope-from corsac@corsac.net)
        id a02e4
        by scapa.corsac.net (DragonFly Mail Agent v0.13);
        Wed, 02 Feb 2022 18:01:07 +0100
Message-ID: <a29174ef18ac5a4d6be2cc576252f77a7c16b306.camel@corsac.net>
Subject: Re: [PATCH v2 0/1] ipheth URB overflow fix
From:   Yves-Alexis Perez <corsac@corsac.net>
To:     Georgi Valkov <gvalkov@abv.bg>
Cc:     Jan Kiszka <jan.kiszka@siemens.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-usb <linux-usb@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "stable @ vger . kernel . org" <stable@vger.kernel.org>
Date:   Wed, 02 Feb 2022 18:01:07 +0100
In-Reply-To: <CE7AE1A3-51E9-45CE-A4EE-DACB03B96D9C@abv.bg>
References: <cover.1643699778.git.jan.kiszka@siemens.com>
         <0414e435e29d4ddf53d189d86fae2c55ed0f81ac.camel@corsac.net>
         <CE7AE1A3-51E9-45CE-A4EE-DACB03B96D9C@abv.bg>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.42.3-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-02-02 at 12:35 +0200, Georgi Valkov wrote:
> Without the patch I get EOVERFLOW and there is no further communication.
> It would be nice if a failsafe mechanism is implemented to recover from
> faults
> like that or in the event that no communication is detected over a certain
> period.
> With the patch applied, everything works fine:
> 1480 bytes from 10.98.8.1: icmp_seq=0 ttl=253 time=50.234 ms

Thanks for the steps. I can confirm that without the patch I get:

[  +4.516398] ipheth 1-3.3:4.2: ipheth_rcvbulk_callback: urb status: -75

and the interface doesn't work anymore.

With the patch applied, I get ping results and the network keeps going.

Regards,
-- 
Yves-Alexis
