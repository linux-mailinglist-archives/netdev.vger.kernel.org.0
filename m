Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC7F751CE
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 16:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388553AbfGYOwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 10:52:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38494 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387646AbfGYOw2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 10:52:28 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 96327C024AF3;
        Thu, 25 Jul 2019 14:52:28 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-49.rdu2.redhat.com [10.10.120.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D36F5F9DD;
        Thu, 25 Jul 2019 14:52:27 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAK8P3a23gnvxA3PcvFy5wadNGoCPRH7PUEY_dqJ+bk3uH5=t+g@mail.gmail.com>
References: <CAK8P3a23gnvxA3PcvFy5wadNGoCPRH7PUEY_dqJ+bk3uH5=t+g@mail.gmail.com> <156406148519.15479.13870345028835442313.stgit@warthog.procyon.org.uk>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH] rxrpc: Fix -Wframe-larger-than= warnings from on-stack crypto
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <24570.1564066346.1@warthog.procyon.org.uk>
Date:   Thu, 25 Jul 2019 15:52:26 +0100
Message-ID: <24571.1564066346@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Thu, 25 Jul 2019 14:52:28 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Would you rather this went through net or net-next?

David
