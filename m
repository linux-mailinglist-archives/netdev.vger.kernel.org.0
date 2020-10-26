Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB65D299818
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 21:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388624AbgJZUht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 16:37:49 -0400
Received: from namei.org ([65.99.196.166]:37980 "EHLO namei.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388577AbgJZUht (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 16:37:49 -0400
Received: from localhost (localhost [127.0.0.1])
        by namei.org (8.14.4/8.14.4) with ESMTP id 09QKbbkE009912;
        Mon, 26 Oct 2020 20:37:38 GMT
Date:   Tue, 27 Oct 2020 07:37:37 +1100 (AEDT)
From:   James Morris <jmorris@namei.org>
To:     Jeff Vander Stoep <jeffv@google.com>
cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-security-module@vger.kernel.org,
        Roman Kiryanov <rkir@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vsock: use ns_capable_noaudit() on socket create
In-Reply-To: <20201023143757.377574-1-jeffv@google.com>
Message-ID: <alpine.LRH.2.21.2010270737290.9603@namei.org>
References: <20201023143757.377574-1-jeffv@google.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Oct 2020, Jeff Vander Stoep wrote:

> During __vsock_create() CAP_NET_ADMIN is used to determine if the
> vsock_sock->trusted should be set to true. This value is used later
> for determing if a remote connection should be allowed to connect
> to a restricted VM. Unfortunately, if the caller doesn't have
> CAP_NET_ADMIN, an audit message such as an selinux denial is
> generated even if the caller does not want a trusted socket.
> 
> Logging errors on success is confusing. To avoid this, switch the
> capable(CAP_NET_ADMIN) check to the noaudit version.
> 
> Reported-by: Roman Kiryanov <rkir@google.com>
> https://android-review.googlesource.com/c/device/generic/goldfish/+/1468545/
> Signed-off-by: Jeff Vander Stoep <jeffv@google.com>


Reviewed-by: James Morris <jamorris@linux.microsoft.com>


-- 
James Morris
<jmorris@namei.org>

