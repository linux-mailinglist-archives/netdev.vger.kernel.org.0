Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D69265464
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgIJVmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:42:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32890 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730433AbgIJMYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 08:24:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599740655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=muH0NbM6qkF7816Knh8ja/ys3WTdLHaEL495utmiJeA=;
        b=B8yZ8HL1br22Y/gcox4a2a3sYJfGmR90WwfuPGvfCGkayxt9oHfnxS+9S10HZpmojWaJKL
        4ulVMXv22Qmsgu2e/iHVViDSzqd26hjfy6GkvR9e+yg8pWIqbZ0QXki2BXqWeN/E+cdV03
        bKDiWr0J4B3BZzX+5pbX0g88R/mf/WA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-NA9IpCcrMFOie5xI-PEC-A-1; Thu, 10 Sep 2020 08:24:13 -0400
X-MC-Unique: NA9IpCcrMFOie5xI-PEC-A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 36004107E8A7;
        Thu, 10 Sep 2020 12:23:47 +0000 (UTC)
Received: from carbon (unknown [10.40.208.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 509CC821E5;
        Thu, 10 Sep 2020 12:23:21 +0000 (UTC)
Date:   Thu, 10 Sep 2020 14:23:20 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        thomas.petazzoni@bootlin.com, echaudro@redhat.com
Subject: Re: [PATCH net] net: mvneta: fix possible use-after-free in
 mvneta_xdp_put_buff
Message-ID: <20200910142320.163ecb67@carbon>
In-Reply-To: <f203fdb6060bb3ba8ff3f27a30767941a4a01c17.1599728755.git.lorenzo@kernel.org>
References: <f203fdb6060bb3ba8ff3f27a30767941a4a01c17.1599728755.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 11:08:01 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Release first buffer as last one since it contains references
> to subsequent fragments. This code will be optimized introducing
> multi-buffer bit in xdp_buff structure.
> 
> Fixes: ca0e014609f05 ("net: mvneta: move skb build after descriptors processing")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

