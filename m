Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46031F73FF
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 08:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgFLGnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 02:43:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54615 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726396AbgFLGnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 02:43:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591944179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5UhtuP90l943Isqu6Ks89etrSpmI2RwrlhSkwDRnr7w=;
        b=KDIb675cJ0bDbkf24x/IkjlXhwtru3ryuXqBwqUGXOsJv6CFy6s5bjZWoeiSxIG2nayw46
        kiNwBxvNTjClgOHYlfeiZkDJyalVo67aIj28uWFPzT0PxHSJJXMQm1Dmhmqx/D29nLexzZ
        Bf4vsuwYLbyaJMfJboKFz92+dmn2XTY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-MK4jfssWMfSNJ0xQZQHuzw-1; Fri, 12 Jun 2020 02:42:55 -0400
X-MC-Unique: MK4jfssWMfSNJ0xQZQHuzw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C1F6801504;
        Fri, 12 Jun 2020 06:42:53 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 992705D9CA;
        Fri, 12 Jun 2020 06:42:48 +0000 (UTC)
Date:   Fri, 12 Jun 2020 08:42:44 +0200
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
To:     Gaurav Singh <gaurav1086@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        netdev@vger.kernel.org (open list:XDP (eXpress Data Path)),
        bpf@vger.kernel.org (open list:XDP (eXpress Data Path)),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH] xdp_rxq_info_user: Replace malloc/memset w/calloc
Message-ID: <20200612084244.4ab4f6c6@carbon>
In-Reply-To: <20200612003640.16248-1-gaurav1086@gmail.com>
References: <20200611150221.15665-1-gaurav1086@gmail.com>
        <20200612003640.16248-1-gaurav1086@gmail.com>
Organization: Red Hat Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Jun 2020 20:36:40 -0400
Gaurav Singh <gaurav1086@gmail.com> wrote:

> Replace malloc/memset with calloc
> 
> Fixes: 0fca931a6f21 ("samples/bpf: program demonstrating access to xdp_rxq_info")
> Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>

Above is the correct use of Fixes + Signed-off-by.

Now you need to update/improve the description, to also
mention/describe that this also solves the bug you found.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

