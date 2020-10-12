Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443B928AEAB
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 09:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbgJLHBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 03:01:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45415 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726620AbgJLHBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 03:01:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602486064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MawKJxZ/xmrlUIiRWs1oRPDDe8lrDsviDaScevM3qK4=;
        b=LxxjkUgBvlLLyTZp50ngNH/Lm3heQlWa39WOjrpfoocq+1K98bGNEiIbR1Rf4qC+EUHP8R
        dRORH/I5LHHfMP2jOmkC1fDFg+EZGSVKA7/7rs1I2dyQgRlNkCJCRGwRzO7NBdFlceck3o
        iphagczpKHhXWIy3MlnfLwx5eHwxbIY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-93-QyCdsYWANbelotgi-0Jz7A-1; Mon, 12 Oct 2020 03:01:00 -0400
X-MC-Unique: QyCdsYWANbelotgi-0Jz7A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1FA041015CA3;
        Mon, 12 Oct 2020 07:00:58 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-196.rdu2.redhat.com [10.10.116.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F00DF27C21;
        Mon, 12 Oct 2020 07:00:55 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <1602412498-32025-2-git-send-email-Julia.Lawall@inria.fr>
References: <1602412498-32025-2-git-send-email-Julia.Lawall@inria.fr> <1602412498-32025-1-git-send-email-Julia.Lawall@inria.fr>
To:     Julia Lawall <Julia.Lawall@inria.fr>
Cc:     dhowells@redhat.com,
        =?UTF-8?q?Valdis=20Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>,
        Joe Perches <joe@perches.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] rxrpc: use semicolons rather than commas to separate statements
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1215802.1602486055.1@warthog.procyon.org.uk>
Date:   Mon, 12 Oct 2020 08:00:55 +0100
Message-ID: <1215803.1602486055@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Julia Lawall <Julia.Lawall@inria.fr> wrote:

> -		call->completion = compl,
> +		call->completion = compl;

Looks good.  Do you want me to pick up the patch or send it yourself?

If the latter:

Acked-by: David Howells <dhowells@redhat.com>

