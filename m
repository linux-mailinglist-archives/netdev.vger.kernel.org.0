Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2BAA202B56
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 17:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730341AbgFUP0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 11:26:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32048 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730336AbgFUP0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 11:26:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592753191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cWOFXqe77YS6YzbDR6+z2zQxKXTvyvkGVHOU7i7tFyA=;
        b=GViL1/SGN4NCQmVAtdd2k3qDN+IWCz8lZ21GCkzmNsLyML1bOQY/q+uHvBkvAb9rEiDSOK
        MOPXp+zluSdT+iv8z/qHXhr04i7HDP4xg/nTpX1b/ra8hH4OnEywHqJbm0wpKL+gH8wnXb
        1tlRinubpr0I9JWOPsZlSa50wb03cJk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-X5Hak8USNA-J2Qr8gBZ1VA-1; Sun, 21 Jun 2020 11:26:29 -0400
X-MC-Unique: X5Hak8USNA-J2Qr8gBZ1VA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E09FB1005512;
        Sun, 21 Jun 2020 15:26:27 +0000 (UTC)
Received: from carbon (unknown [10.40.208.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 025A660C87;
        Sun, 21 Jun 2020 15:26:16 +0000 (UTC)
Date:   Sun, 21 Jun 2020 17:26:15 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, toke@redhat.com,
        lorenzo.bianconi@redhat.com, dsahern@kernel.org, brouer@redhat.com
Subject: Re: [PATCH v2 bpf-next 2/8] samples/bpf: xdp_redirect_cpu_user: do
 not update bpf maps in option loop
Message-ID: <20200621172615.6d6a8edb@carbon>
In-Reply-To: <c14e981309801a9496fbd3bd449d170e139623d0.1592606391.git.lorenzo@kernel.org>
References: <cover.1592606391.git.lorenzo@kernel.org>
        <c14e981309801a9496fbd3bd449d170e139623d0.1592606391.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 20 Jun 2020 00:57:18 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Do not update xdp_redirect_cpu maps running while option loop but
> defer it after all available options have been parsed. This is a
> preliminary patch to pass the program name we want to attach to the
> map entries as a user option
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  samples/bpf/xdp_redirect_cpu_user.c | 36 +++++++++++++++++++++--------
>  1 file changed, 27 insertions(+), 9 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

