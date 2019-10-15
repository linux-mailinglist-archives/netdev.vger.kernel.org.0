Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5B3D7A6B
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 17:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387651AbfJOPuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 11:50:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40702 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730152AbfJOPuF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 11:50:05 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7034018CB904;
        Tue, 15 Oct 2019 15:50:05 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-121-84.rdu2.redhat.com [10.10.121.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 495BD5D6A9;
        Tue, 15 Oct 2019 15:50:04 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <bf358fc5-c0e1-070f-b073-1675e3d13fd8@gmail.com>
References: <bf358fc5-c0e1-070f-b073-1675e3d13fd8@gmail.com> <157071915431.29197.5055122258964729288.stgit@warthog.procyon.org.uk>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] rxrpc: Fix possible NULL pointer access in ICMP handling
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5907.1571154603.1@warthog.procyon.org.uk>
Date:   Tue, 15 Oct 2019 16:50:03 +0100
Message-ID: <5908.1571154603@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.63]); Tue, 15 Oct 2019 15:50:05 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> wrote:

>  void rxrpc_error_report(struct sock *sk)
>  {
> +       struct rxrpc_local *local = rcu_dereference_sk_user_data(sk);

Acked-by: David Howells <dhowells@redhat.com>
