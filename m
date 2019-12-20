Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA791276B4
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 08:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfLTHrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 02:47:10 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:60387 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727084AbfLTHrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 02:47:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576828029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9iV4z2RQRpVICXyhItIFMfalMQxLbhL/DHBOEt6V43U=;
        b=iXMXUkA9uE8QHenSeSEmHjLTgHwBLBkhb8jr7JezKVFuyTlBvImrbzW4ibORWyfVmK9I+U
        AB87aD7y1FYXYj7J6nYeTZE3ZTbd8Wlbi9eVw+m+mkVM5QzH+Jx++zj7n7FSG/xtibVGwP
        LgVVJFOpiNgkX3o8JPGCm6aKkZq3ejU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-042aShh1Mu-HGoM2hkSaQw-1; Fri, 20 Dec 2019 02:47:03 -0500
X-MC-Unique: 042aShh1Mu-HGoM2hkSaQw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 990DFDB96;
        Fri, 20 Dec 2019 07:47:00 +0000 (UTC)
Received: from carbon (ovpn-200-18.brq.redhat.com [10.40.200.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A9EF5E241;
        Fri, 20 Dec 2019 07:46:53 +0000 (UTC)
Date:   Fri, 20 Dec 2019 08:46:51 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     brouer@redhat.com,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next v2 0/8] Simplify
 xdp_do_redirect_map()/xdp_do_flush_map() and XDP maps
Message-ID: <20191220084651.6dacb941@carbon>
In-Reply-To: <CAADnVQL1x8AJmCOjesA_6Z3XprFVEdWgbREfpn3CC-XO8k4PDA@mail.gmail.com>
References: <20191219061006.21980-1-bjorn.topel@gmail.com>
        <CAADnVQL1x8AJmCOjesA_6Z3XprFVEdWgbREfpn3CC-XO8k4PDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Dec 2019 21:21:39 -0800
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> > v1->v2 [1]:
> >   * Removed 'unused-variable' compiler warning (Jakub)
> >
> > [1] https://lore.kernel.org/bpf/20191218105400.2895-1-bjorn.topel@gmail.com/  
> 
> My understanding that outstanding discussions are not objecting to the
> core ideas of the patch set, hence applied. Thanks

I had hoped to have time to review it in details today.  But as I don't
have any objecting to the core ideas, then I don't mind it getting
applied. We can just fix things in followups.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

