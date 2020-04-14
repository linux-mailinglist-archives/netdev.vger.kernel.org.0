Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12251A75D7
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 10:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436541AbgDNIVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 04:21:51 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51205 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2436518AbgDNIVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 04:21:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586852460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=toFkkTRUT+tBuF1GBlkOmL6dzS3CV3U/nMSkRVoGu3o=;
        b=LJXknNGk8yDC29kzZd84zZDKCYOQ/bt/GsBSck92YF7QsRTSxUBvr+DN8pJPElY7rrGWRG
        Azv2YNLqlel2K0P3iFP0Hj1u9GsN9e2CAqH5nvls2l/xTPRvSJPBfzC3VT9g6NhB2Bn3KB
        BNirzFzhdqokro1PlLp/SFrV0T49E4k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-95-nvUtIZg_MpmH-uvmOVGWsw-1; Tue, 14 Apr 2020 04:19:21 -0400
X-MC-Unique: nvUtIZg_MpmH-uvmOVGWsw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFE2E18B9FC9;
        Tue, 14 Apr 2020 08:19:19 +0000 (UTC)
Received: from carbon (unknown [10.40.208.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 257D95D9CD;
        Tue, 14 Apr 2020 08:19:07 +0000 (UTC)
Date:   Tue, 14 Apr 2020 10:19:06 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     sameehj@amazon.com, Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>, brouer@redhat.com
Subject: Re: [PATCH RFC v2 16/33] mlx4: add XDP frame size and adjust max
 XDP MTU
Message-ID: <20200414101906.4f19ccd4@carbon>
In-Reply-To: <6ccf0d63-809e-bd50-c0af-06580ca75745@gmail.com>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
        <158634671560.707275.13938272212851553455.stgit@firesoul>
        <6ccf0d63-809e-bd50-c0af-06580ca75745@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Apr 2020 15:57:00 +0300
Tariq Toukan <ttoukan.linux@gmail.com> wrote:

> Reviewed-by: Tariq Toukan <tariqt@mellanox.com>

Thanks, collected this reviewed-by.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

