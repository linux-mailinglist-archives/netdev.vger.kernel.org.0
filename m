Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3281F3EF1
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 17:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730740AbgFIPNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 11:13:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51851 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730737AbgFIPND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 11:13:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591715582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Akn0YYeIfcfpqLUHdADi9yu032d9dL3EY8reW+J1ZNQ=;
        b=V0fI91ZClUZcS6lkfhtttzxQuREXmwQW0FBGR4IyZOMj+lZWpsSOwIhNrV+pYf7muGseXu
        h4aBozG1k4XGBnaYl6+8QoDPN0c1FUZj0Apc1j5x82AWd1EbrbbNBKXYSU45NOie03HUWx
        FrtMDzAc0IXGcLuNUq8o5+qaSNmiOxs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-at0vGP1kON2ipcgnAWO7IQ-1; Tue, 09 Jun 2020 11:12:59 -0400
X-MC-Unique: at0vGP1kON2ipcgnAWO7IQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 272DE3640D;
        Tue,  9 Jun 2020 15:12:58 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 00B9A5D9E8;
        Tue,  9 Jun 2020 15:12:52 +0000 (UTC)
Date:   Tue, 9 Jun 2020 17:12:51 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     bpf@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, brouer@redhat.com
Subject: Re: [PATCH bpf V2 1/2] bpf: devmap adjust uapi for attach bpf
 program
Message-ID: <20200609171251.262b2265@carbon>
In-Reply-To: <a34343ec-2248-111d-9360-f00de212dbcb@gmail.com>
References: <159170947966.2102545.14401752480810420709.stgit@firesoul>
        <159170950687.2102545.7235914718298050113.stgit@firesoul>
        <a34343ec-2248-111d-9360-f00de212dbcb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Jun 2020 07:47:06 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 6/9/20 7:31 AM, Jesper Dangaard Brouer wrote:
> > This patch remove the minus-1 checks, and have zero mean feature isn't used.
> >   
> 
> For consistency this should apply to other XDP fd uses as well -- like
> IFLA_XDP_EXPECTED_FD and IFLA_XDP_FD.

I agree, but I choose to limit the scope as this is for bpf-tree.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

