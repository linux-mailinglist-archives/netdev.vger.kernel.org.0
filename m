Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B325D1B6EFF
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 09:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgDXH2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 03:28:04 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:20123 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726709AbgDXH2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 03:28:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587713281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+mkhOo4L9DwFWD7/xJxWxANEBJZACGqsdE1Q/H+DWyI=;
        b=Xk+vkEimvoMebYEOvR1ckeRZlqQpBH0+z+2tmEhN9tBWkgSrt5gUPIfFPOg+A07rQ+DxdC
        U7ITN/a8sQZTcYHBlIqeGuLSanM6iRnAi6fS9SiMJZwMT/qix/+GRahwUq4ydK+mJcBfVD
        0gAIEakY/dBNbdAoTpJVmPRN4DRyz3M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-Te7GjsP3P8qRQoeeXFJNtw-1; Fri, 24 Apr 2020 03:27:57 -0400
X-MC-Unique: Te7GjsP3P8qRQoeeXFJNtw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F061A835B42;
        Fri, 24 Apr 2020 07:27:54 +0000 (UTC)
Received: from carbon (unknown [10.40.208.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C93621C94C;
        Fri, 24 Apr 2020 07:27:43 +0000 (UTC)
Date:   Fri, 24 Apr 2020 09:27:42 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        toke@redhat.com, toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>,
        brouer@redhat.com
Subject: Re: [PATCH v2 bpf-next 01/17] net: Refactor convert_to_xdp_frame
Message-ID: <20200424092742.1f31d510@carbon>
In-Reply-To: <20200424021148.83015-2-dsahern@kernel.org>
References: <20200424021148.83015-1-dsahern@kernel.org>
        <20200424021148.83015-2-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Apr 2020 20:11:32 -0600
David Ahern <dsahern@kernel.org> wrote:

> From: David Ahern <dahern@digitalocean.com>
> 
> Move the guts of convert_to_xdp_frame to a new helper, update_xdp_frame
> so it can be reused in a later patch.
> 
> Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: David Ahern <dahern@digitalocean.com>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

