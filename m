Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C245B322DA3
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 16:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbhBWPf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 10:35:56 -0500
Received: from mx.wizbit.be ([87.237.14.2]:56568 "EHLO mx.wizbit.be"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229886AbhBWPfz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 10:35:55 -0500
X-Greylist: delayed 627 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Feb 2021 10:35:55 EST
Received: from [10.2.2.197] (unknown [10.2.2.197])
        by wizmail.wizbit.be (Postfix) with ESMTP id 4D8E82003;
        Tue, 23 Feb 2021 15:24:43 +0000 (UTC)
Message-ID: <60351E4B.5090404@mail.wizbit.be>
Date:   Tue, 23 Feb 2021 16:24:59 +0100
From:   Bram Yvahk <bram-yvahk@mail.wizbit.be>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     Eyal Birger <eyal.birger@gmail.com>, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH ipsec,v2] xfrm: interface: fix ipv4 pmtu check to honor
 ip header df
References: <20210219172127.2223831-1-eyal.birger@gmail.com> <20210220130115.2914135-1-eyal.birger@gmail.com> <YDUbYvCnRN/aBQrM@hog>
In-Reply-To: <YDUbYvCnRN/aBQrM@hog>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/02/2021 16:12, Sabrina Dubroca wrote:
> LGTM. We also need to do the same thing in ip_vti and ip6_vti. Do you
> want to take care of it, or should I?
>   
See the thread
https://lore.kernel.org/netdev/1552865877-13401-1-git-send-email-bram-yvahk@mail.wizbit.be/
(I'm assuming the patches no longer applies cleanly but given that I was
ignored last time I will not be resubmitting them.)

--
Bram
