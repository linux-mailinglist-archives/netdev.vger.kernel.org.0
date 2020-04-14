Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8161A7577
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 10:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406973AbgDNIIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 04:08:17 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42213 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729379AbgDNIIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 04:08:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586851686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tqXuaO7yAi2HcC6X4kaf5HpEqT1ia5Y528MMasHVBo0=;
        b=K4J26q17mdjft+n5YwTKAzuQuyAxYEU7VQOpTBhIpXiASRHJ9guKULp8S/mMeCU0mDQmy6
        H+NOPSOiFlXDPcGXPv9r22KLbV5lzHiIvbOWvQyP0hCoRjbqFGQyPEfwgGvA1r69JpUhC6
        ipy+P8M0S7JmFz+VgRAmrq1F6A1clWQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-136--BhciZ-ZPIq3tAKjSr9sxg-1; Tue, 14 Apr 2020 04:08:04 -0400
X-MC-Unique: -BhciZ-ZPIq3tAKjSr9sxg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A08B107B270;
        Tue, 14 Apr 2020 08:08:02 +0000 (UTC)
Received: from carbon (unknown [10.40.208.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7C1549F99D;
        Tue, 14 Apr 2020 08:07:50 +0000 (UTC)
Date:   Tue, 14 Apr 2020 10:07:49 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     sameehj@amazon.com, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, zorik@amazon.com,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>, brouer@redhat.com
Subject: Re: [PATCH RFC v2 05/33] net: netsec: Add support for XDP frame
 size
Message-ID: <20200414100749.04a4fa8d@carbon>
In-Reply-To: <20200408130923.GA9157@lore-desk-wlan>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
        <158634665970.707275.15490233569929847990.stgit@firesoul>
        <20200408130923.GA9157@lore-desk-wlan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Apr 2020 15:09:23 +0200
Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> > From: Ilias Apalodimas <ilias.apalodimas@linaro.org>  
> 
> Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

Thanks, collected ACK for next submission.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

