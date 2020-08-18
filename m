Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1D39248365
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 12:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgHRK4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 06:56:16 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47354 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726484AbgHRK4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 06:56:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597748170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UpL2InzPOSY+bQye+qdcClD9XKYCEvbdiWiHNpwsbPE=;
        b=PwjyIUoyVIHPgeCfr57jMWE4K6DQcxLPtPSBy64TuZjbkxvLlctOrgLx+jAIRzPuSr1ZFi
        soyNCgcoPeuXf0rRMoiy4hZhkq6aJ90kfufm3mWNJQJy16cc/ymug0A+Qt1T5Y9fYIUvU4
        ghfbRyaNLCSm9PfdF02JgqFi3Z/tT1k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-fBHkZSE1MzyT-5PAVYzBCg-1; Tue, 18 Aug 2020 06:56:09 -0400
X-MC-Unique: fBHkZSE1MzyT-5PAVYzBCg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 14B0B425CC;
        Tue, 18 Aug 2020 10:56:08 +0000 (UTC)
Received: from krava (unknown [10.40.193.152])
        by smtp.corp.redhat.com (Postfix) with SMTP id 94DD95C69A;
        Tue, 18 Aug 2020 10:56:03 +0000 (UTC)
Date:   Tue, 18 Aug 2020 12:56:02 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>, sdf@google.com,
        andriin@fb.com
Subject: Re: Kernel build error on BTFIDS vmlinux
Message-ID: <20200818105602.GC177896@krava>
References: <20200818105555.51fc6d62@carbon>
 <20200818091404.GB177896@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818091404.GB177896@krava>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 11:14:10AM +0200, Jiri Olsa wrote:
> On Tue, Aug 18, 2020 at 10:55:55AM +0200, Jesper Dangaard Brouer wrote:
> > 
> > On latest DaveM net-git tree (06a4ec1d9dc652), after linking (LD vmlinux) the
> > "BTFIDS vmlinux" fails. Are anybody else experiencing this? Are there already a
> > fix? (just returned from vacation so not fully up-to-date on ML yet)
> > 
> > The tool which is called and error message:
> >   ./tools/bpf/resolve_btfids/resolve_btfids vmlinux
> >   FAILED elf_update(WRITE): invalid section alignment
> 
> hi,
> could you send your .config as well?

reproduced.. checking on fix

thanks,
jirka

