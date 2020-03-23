Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA71318F726
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 15:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgCWOpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 10:45:06 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:36943 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726145AbgCWOpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 10:45:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584974705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2nk1AP17pznKbxf98FvJCP1dAQK/qMxMTLhV3K3o1u0=;
        b=aqsO3DXT7MVcCYAZ8t1+GYgZDfjt/2v4SARnWPiC1h7+sIiHAewZI9Iq+6XQsAIZDSjpcm
        WYMm5GB25x7/OgocCoqW9Ycoc+SI8Sui+wWKHjxqAD7EJ7QLbPT8B3radoNehN5WNPXz6i
        b5H7NBEZKfnh3HKGb/UOExAwD5ZY+7I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-yrUkIBL_MoCNeK4nKzrABQ-1; Mon, 23 Mar 2020 10:45:01 -0400
X-MC-Unique: yrUkIBL_MoCNeK4nKzrABQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 709B8801A02;
        Mon, 23 Mar 2020 14:44:58 +0000 (UTC)
Received: from carbon (unknown [10.40.208.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B573F7E32D;
        Mon, 23 Mar 2020 14:44:48 +0000 (UTC)
Date:   Mon, 23 Mar 2020 15:44:46 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Andy Gospodarek <andy@greyhouse.net>
Cc:     sameehj@amazon.com, Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, zorik@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>, brouer@redhat.com
Subject: Re: [PATCH RFC v1 03/15] bnxt: add XDP frame size to driver
Message-ID: <20200323154446.0b3ed869@carbon>
In-Reply-To: <20200323141833.GB21532@C02YVCJELVCG.greyhouse.net>
References: <158446612466.702578.2795159620575737080.stgit@firesoul>
        <158446616289.702578.7889111879119296431.stgit@firesoul>
        <20200323141833.GB21532@C02YVCJELVCG.greyhouse.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Mar 2020 10:18:33 -0400
Andy Gospodarek <andy@greyhouse.net> wrote:

> On Tue, Mar 17, 2020 at 06:29:22PM +0100, Jesper Dangaard Brouer wrote:
> > This driver uses full PAGE_SIZE pages when XDP is enabled.  
> 
> Talked with Jesper about this some more on IRC and he clarified
> something for me that was bugging me.

Yes, nice talking to you on IRC. Note some XDP developers are hanging
out on freenode channel #xdp (my nick is netoptimizer from my GitHub name)

> > Cc: Michael Chan <michael.chan@broadcom.com>
> > Cc: Andy Gospodarek <andrew.gospodarek@broadcom.com>  
> 
> I know this is only an RFC, but feel free to add:
> 
> Reviewed-by: Andy Gospodarek <gospo@broadcom.com>

Great, I've added this to my current patchset :-)
 
> to this patch.  Thanks for your work on this!

Thanks!

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

