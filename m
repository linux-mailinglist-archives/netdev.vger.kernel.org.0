Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3493D131A9A
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 22:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgAFVkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 16:40:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34475 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726713AbgAFVkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 16:40:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578346804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=92IBDcXHrCniaPpYzIDDSbya4Iw/pUq5jseI84k5wbg=;
        b=YapnuVqdzHjiTKWi2t/GNa1WK3AtQxGeKso78MkqvQCM65aIWCzGUynduWBAmhdQHkt7tT
        +hHlZb23ch4tZd6jfc+aix3Et5OAmC2W6UcKLPQggW2kU3Dh2y67K+qRIX7g0QQRdOf8ub
        PKEBljmJdfFePiupz3Tvgd3pGE8Z1ms=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-VkcnwEa9M_2i3M_AYQK7-Q-1; Mon, 06 Jan 2020 16:40:00 -0500
X-MC-Unique: VkcnwEa9M_2i3M_AYQK7-Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 598AF10054E3;
        Mon,  6 Jan 2020 21:39:58 +0000 (UTC)
Received: from localhost (ovpn-112-4.rdu2.redhat.com [10.10.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0154D60E1C;
        Mon,  6 Jan 2020 21:39:55 +0000 (UTC)
Date:   Mon, 06 Jan 2020 13:39:54 -0800 (PST)
Message-Id: <20200106.133954.516759492863458363.davem@redhat.com>
To:     christophe.jaillet@wanadoo.fr
Cc:     pablo@netfilter.org, laforge@gnumonks.org,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] gtp: simplify error handling code in
 'gtp_encap_enable()'
From:   David Miller <davem@redhat.com>
In-Reply-To: <20200105173607.5456-1-christophe.jaillet@wanadoo.fr>
References: <20200105173607.5456-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Sun,  5 Jan 2020 18:36:07 +0100

> 'gtp_encap_disable_sock(sk)' handles the case where sk is NULL, so there
> is no need to test it before calling the function.
> 
> This saves a few line of code.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied to net-next.

