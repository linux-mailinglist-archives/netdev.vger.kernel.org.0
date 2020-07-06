Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB85215B74
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 18:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729496AbgGFQIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 12:08:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54560 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729293AbgGFQIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 12:08:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594051679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T0Tdrox1piejlTo0hG16l/0bS65uxGbesdx/bv8EYVE=;
        b=C+VGFowkPUZRtt8FeZ5FgAdymkesEgJBafN/IKFq9n9veS6PE74PGC5rPNFD27FS1Year6
        3nj7YAAHNxhW8BijEyf8HmZhaWB1MxepcoHOzIOeWgcLekVsvh51e5D4uTcYYogrroYVRj
        Npm0RrEH6FbX3ztXigQPappaHG0Ef0Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-wZhBXEiiPPCZUgg7fvEFoA-1; Mon, 06 Jul 2020 12:07:56 -0400
X-MC-Unique: wZhBXEiiPPCZUgg7fvEFoA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 438A1800D5C;
        Mon,  6 Jul 2020 16:07:53 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-113.rdu2.redhat.com [10.10.112.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F188D5D9CC;
        Mon,  6 Jul 2020 16:07:49 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20200703224115.29769-8-rdunlap@infradead.org>
References: <20200703224115.29769-8-rdunlap@infradead.org> <20200703224115.29769-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     dhowells@redhat.com, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>, linux-hams@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-afs@lists.infradead.org
Subject: Re: [PATCH 7/7] Documentation: networking: rxrpc: drop doubled word
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2937967.1594051669.1@warthog.procyon.org.uk>
Date:   Mon, 06 Jul 2020 17:07:49 +0100
Message-ID: <2937968.1594051669@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Randy Dunlap <rdunlap@infradead.org> wrote:

> Drop the doubled word "have".
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: linux-doc@vger.kernel.org
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Cc: linux-afs@lists.infradead.org

Acked-by: David Howells <dhowells@redhat.com>

