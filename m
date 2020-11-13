Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D09612B1969
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 11:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgKMKzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 05:55:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42348 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726176AbgKMKzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 05:55:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605264934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uA4mZrRQvqoFy1D08UwJPi5KGtPusbGvuR8nEE41yPY=;
        b=KmCPJogbBifdIC6ohjR6vq3CueML89O3xlsALnFhKHwDMDuz+NPSQN9BSP5iKu80PNavP4
        Fo1KlpvQ5aSk7cOxBNSfQEZy+Ng1AMkLRRkPy9YqARbq8nsizcvb6YxmP/MRFq67WAjsgr
        bTZPT0/9GVEV5FKzYudnskv9lpl7ITU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-pMrBOwICNmqwum_9TOlHkQ-1; Fri, 13 Nov 2020 05:55:32 -0500
X-MC-Unique: pMrBOwICNmqwum_9TOlHkQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DAB11084C9A;
        Fri, 13 Nov 2020 10:55:30 +0000 (UTC)
Received: from carbon (unknown [10.36.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 78D0919C66;
        Fri, 13 Nov 2020 10:55:19 +0000 (UTC)
Date:   Fri, 13 Nov 2020 11:55:15 +0100
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, mst@redhat.com,
        davem@davemloft.net, kuba@kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        "Jubran, Samih" <sameehj@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        Shay Agroskin <shayagr@amazon.com>
Subject: Re: [PATCH netdev 1/2] virtio: add module option to turn off guest
 offloads
Message-ID: <20201113115515.3886b224@carbon>
In-Reply-To: <f078cd84-4d65-ceb1-e7a9-75ec22da5823@redhat.com>
References: <cover.1605184791.git.xuanzhuo@linux.alibaba.com>
        <5b2e0f71d5feddd9fe23babaad60114208731a59.1605184791.git.xuanzhuo@linux.alibaba.com>
        <f078cd84-4d65-ceb1-e7a9-75ec22da5823@redhat.com>
Organization: Red Hat Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 09:05:19 +0800
Jason Wang <jasowang@redhat.com> wrote:

> On 2020/11/12 =E4=B8=8B=E5=8D=884:11, Xuan Zhuo wrote:
> > * VIRTIO_NET_F_GUEST_CSUM
> > * VIRTIO_NET_F_GUEST_TSO4
> > * VIRTIO_NET_F_GUEST_TSO6
> > * VIRTIO_NET_F_GUEST_ECN
> > * VIRTIO_NET_F_GUEST_UFO
> > * VIRTIO_NET_F_MTU
> >
> > If these features are negotiated successfully, it may cause virtio-net =
to
> > receive large packages, which will cause xdp to fail to load.=20

I really want the people that implement XDP multi-buffer support, to
think about how this can help virtio-net overcome these limitations.

IHMO XDP need to evolve to support these features for virtio-net.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

