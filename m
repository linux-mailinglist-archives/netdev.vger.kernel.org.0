Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD0F9160F64
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 10:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbgBQJ6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 04:58:41 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53023 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726397AbgBQJ6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 04:58:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581933519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TRsLPl3uWJHT4eup5eA03F8IXkj7TA8lnycL5zkmUuw=;
        b=YBnxM8G7LJcTS3Yf905sYFEURsREWTNHgyOcRUKc3aeTk7im8tvOn+iI60WeOoSc4P35FZ
        3+pXQidR3mFO0TZwNuTuSKZ3VgLU/uATc+X4MR9T9b/V155Gv51aUwABJRDoZA3OHgVjkL
        U3DY9C80xfyC6p6nnZpraDdZJwkCDLs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-LsqvZqkiMfy7YQU2DZy6OQ-1; Mon, 17 Feb 2020 04:58:37 -0500
X-MC-Unique: LsqvZqkiMfy7YQU2DZy6OQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E90D801E74;
        Mon, 17 Feb 2020 09:58:36 +0000 (UTC)
Received: from carbon (ovpn-200-41.brq.redhat.com [10.40.200.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D864460BEC;
        Mon, 17 Feb 2020 09:58:28 +0000 (UTC)
Date:   Mon, 17 Feb 2020 10:58:25 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     lorenzo@kernel.org, netdev@vger.kernel.org,
        ilias.apalodimas@linaro.org, lorenzo.bianconi@redhat.com,
        brouer@redhat.com, David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH net-next 0/5] add xdp ethtool stats to mvneta driver
Message-ID: <20200217105825.51e6c9cd@carbon>
In-Reply-To: <20200216.200457.998100759872108395.davem@davemloft.net>
References: <cover.1581886691.git.lorenzo@kernel.org>
        <20200216.200457.998100759872108395.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 16 Feb 2020 20:04:57 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: Lorenzo Bianconi <lorenzo@kernel.org>
> Date: Sun, 16 Feb 2020 22:07:28 +0100
> 
> > Rework mvneta stats accounting in order to introduce xdp ethtool
> > statistics in the mvneta driver.
> > Introduce xdp_redirect, xdp_pass, xdp_drop and xdp_tx counters to
> > ethtool statistics.
> > Fix skb_alloc_error and refill_error ethtool accounting  
> 
> Series applied, thanks Lorenzo.

Hey DaveM,

I think this series got applied a bit too fast.

I didn't have time to review it.  It got posted Sunday night/evening
around (22:07 my TZ), and applied in Monday morning before I woke up.

And I have issues with the patches...
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

