Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D0A34E85E
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 15:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbhC3NFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 09:05:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32815 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232147AbhC3NFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 09:05:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617109504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zEabHD/V6iZrPn1MSypSR5kWmST9dAaEpzKcbSfdR40=;
        b=jIoomYLzKujwxEarAeXyqtM4DiEaMhYrV3mo5MwnGLBBBfx9es/rwvPKrzSQsQtA47AdN4
        DUecnF+IZB0dvP6hYdy5rEU+DDIT3cKybTXUnYwwl38rtOCLrV4tABFi4pikATYiO+pGv3
        877gAK+zsXDEMUxIYbVswj6stMtHmUQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-N9TsKufIOluS7OyA4Uc8OQ-1; Tue, 30 Mar 2021 09:05:00 -0400
X-MC-Unique: N9TsKufIOluS7OyA4Uc8OQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17E0A8030A1;
        Tue, 30 Mar 2021 13:04:58 +0000 (UTC)
Received: from carbon (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C8FE654272;
        Tue, 30 Mar 2021 13:04:49 +0000 (UTC)
Date:   Tue, 30 Mar 2021 15:04:48 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     brouer@redhat.com, Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/6] stmmac: Add XDP support
Message-ID: <20210330150448.1eae9a6b@carbon>
In-Reply-To: <20210330024949.14010-1-boon.leong.ong@intel.com>
References: <20210330024949.14010-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Mar 2021 10:49:43 +0800
Ong Boon Leong <boon.leong.ong@intel.com> wrote:

> It will be great if community help test out these v2 patch series on your
> platform and provide me feedback.

Are there any (developer) boards available that can be bought online?
(that have HW for this Ethernet driver stmmac)

I'm interested in playing with the hardwares Split Header (SPH)
feature. As this was one of the use-cases for XDP multi-frame work.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

