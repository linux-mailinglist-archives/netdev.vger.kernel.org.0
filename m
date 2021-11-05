Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03520445D00
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 01:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbhKEAZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 20:25:42 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:46536 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbhKEAZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 20:25:42 -0400
Received: from pecola.lan (unknown [159.196.93.152])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id A8FD620222;
        Fri,  5 Nov 2021 08:23:01 +0800 (AWST)
Message-ID: <5b38692a40561b983f379a2d19de238f444fe50f.camel@codeconstruct.com.au>
Subject: Re: [PATCH net-next v2 0/2] MCTP sockaddr padding
 check/initialisation fixup
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     Eugene Syromiatnikov <esyr@redhat.com>,
        Matt Johnston <matt@codeconstruct.com.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 05 Nov 2021 08:23:01 +0800
In-Reply-To: <cover.1635965993.git.esyr@redhat.com>
References: <cover.1635965993.git.esyr@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eugene,

> While the first commit is definitely an ABI breakage, it is proposed
> in hopes that the change is made soon enough (the interface appeared
> only in Linux 5.15) to avoid affecting any existing user space.

Of the two applications that currently use AF_MCTP:

 - one is already zeroing the sockaddr_mctp
 - the other has a fix for two of the potential sendmsg() & bind()
   calls: https://github.com/CodeConstruct/mctp/commit/072bafe7

Given we have a confined set of applications (and users), and they're
both now compatible with this change:

Acked-by: Jeremy Kerr <jk@codeconstruct.com.au>

For both patches.

Cheers,


Jeremy

