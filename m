Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA7B2BB43A
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731587AbgKTSnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:43:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:60436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731207AbgKTSnr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:43:47 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A67A2245F;
        Fri, 20 Nov 2020 18:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897826;
        bh=BYh1+J/eqOcYaGUTamspD4Ta2L9FWc3B70Cfr13Zxko=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xgp53yTpNWrQHKiJlW5n8wWSZMlA6iHzcNVDQb2t0PlV0T/XnwQhl6+U179YkmXdI
         2NS3gNuTlYbK435auBPJE2tKS72SqajALI3oVG+//j/6aP9/ucHAy0ZNFaMvdi9XJc
         yVoKn60B8Jysg6R5D9JPvznUYU9Bcf+N9yU44dcc=
Date:   Fri, 20 Nov 2020 10:43:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        linux-sparse@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: add annotation for
 sock_{lock,unlock}_fast
Message-ID: <20201120104345.56b68991@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <6ed7ae627d8271fb7f20e0a9c6750fbba1ac2635.1605634911.git.pabeni@redhat.com>
References: <6ed7ae627d8271fb7f20e0a9c6750fbba1ac2635.1605634911.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 19:43:49 +0100 Paolo Abeni wrote:
> The static checker is fooled by the non-static locking scheme
> implemented by the mentioned helpers.
> Let's make its life easier adding some unconditional annotation
> so that the helpers are now interpreted as a plain spinlock from
> sparse.
> 
> v1 -> v2:
>  - add __releases() annotation to unlock_sock_fast()
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied, thank you!
