Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6A244255F
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 02:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbhKBCAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 22:00:11 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:44532 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbhKBCAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 22:00:11 -0400
Received: from pecola.lan (unknown [159.196.93.152])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id C2B7320164;
        Tue,  2 Nov 2021 09:57:34 +0800 (AWST)
Message-ID: <b8c77eb3b3379e52e91b9ecc9c35c2f707cc3ae5.camel@codeconstruct.com.au>
Subject: Re: [PATCH net-next 0/2] MCTP sockaddr padding check/initialisation
 fixup
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     Eugene Syromiatnikov <esyr@redhat.com>,
        Matt Johnston <matt@codeconstruct.com.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 02 Nov 2021 09:57:34 +0800
In-Reply-To: <cover.1635788968.git.esyr@redhat.com>
References: <cover.1635788968.git.esyr@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eugene,

> Padding/reserved fields necessitate appropriate checks in order to be
> usable in the future.

We don't have a foreseeable need for extra fields here; so this is a bit
hypothetical at the moment. However, I guess there may be something that
comes up in future - was there something you have in mind?

The requirements for the padding bytes to be zero on sendmsg() will
break the ABI for applications that are using the interface on 5.15;
there's a small, contained set of those at the moment though, so I'm OK
to handle the updates if this patch is accepted, but we'd need to make a
call on that soon.

Setting the pad bytes to zero on recvmsg() is a good plan though, I'm
happy for that change to go in regardless.

Cheers,


Jeremy

