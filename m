Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF891DE537
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 13:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbgEVLSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 07:18:04 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27081 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728371AbgEVLSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 07:18:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590146281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7//HsWiw0pMEpfATRtkA08zN0te8MDJfea8SEEh9yRw=;
        b=P68e+9VFsj3Yxe9CLEprg78z16qR1dT4R1T1ZdouKMBLkmx68vBAyZN8DXXHR1Ykasy4WI
        u+JKeAYR31c+PBLJN907w2NoO9WJa9EsF6LS79kwGuQxZrYpuAo6UWocgvxMACTTX/4WM6
        d0HuatXeM+OP7r7f5G2tJ3FIOH5ZNdk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-vcGPExIrPPWmXARjh4KzFw-1; Fri, 22 May 2020 07:17:59 -0400
X-MC-Unique: vcGPExIrPPWmXARjh4KzFw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 823391902EA0;
        Fri, 22 May 2020 11:17:57 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E6FF62932;
        Fri, 22 May 2020 11:17:47 +0000 (UTC)
Date:   Fri, 22 May 2020 13:17:45 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        toke@redhat.com, daniel@iogearbox.net, john.fastabend@gmail.com,
        ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        andriin@fb.com, dsahern@gmail.com, brouer@redhat.com,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH RFC bpf-next 0/4] bpf: Add support for XDP programs in
 DEVMAPs
Message-ID: <20200522131745.0394cc32@carbon>
In-Reply-To: <20200522010526.14649-1-dsahern@kernel.org>
References: <20200522010526.14649-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 May 2020 19:05:22 -0600
David Ahern <dsahern@kernel.org> wrote:

> Implementation of Daniel's proposal for allowing DEVMAP entries to be
> a device index, program id pair. Daniel suggested an fd to specify the
> program, but that seems odd to me that you insert the value as an fd, but
> read it back as an id since the fd can be closed.

Great that you are working on this :-)

Lorenzo (cc lorenzo@kernel.org) is working on a similar approach for
cpumap, please coordinate/Cc him on these patches.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

