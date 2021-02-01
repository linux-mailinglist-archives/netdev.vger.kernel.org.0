Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3DA030A558
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 11:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbhBAKaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 05:30:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49116 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232290AbhBAKa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 05:30:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612175342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dPvV5Ah2SwGZOyYrLj1T+R0u9OfaqGtp9XZx/KfLZdI=;
        b=UauS/WTozgMw6uIQg4+QnmV2lF5TvexBDksWs9bn1k+Kj6BsDSNgOz+c6O5OkG+G4FgXF1
        RVPAdH0ToL3r4BgX+isAhkoVGX4k9QE3TArK3jge+XTcV7G+K65ms0vRblSyYQa5XydqbW
        SGPNb/YMOodwwbH5diPE2yyfLiiHAg4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-npdRnl-oNTy30lVdxUl1iA-1; Mon, 01 Feb 2021 05:28:58 -0500
X-MC-Unique: npdRnl-oNTy30lVdxUl1iA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7788A10054FF;
        Mon,  1 Feb 2021 10:28:56 +0000 (UTC)
Received: from carbon (unknown [10.36.110.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C85CC6A908;
        Mon,  1 Feb 2021 10:28:49 +0000 (UTC)
Date:   Mon, 1 Feb 2021 11:28:48 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com, brouer@redhat.com,
        "Konstantin Ryabitsev" <konstantin@linuxfoundation.org>
Subject: Re: [PATCH bpf-next V14 0/7] bpf: New approach for BPF MTU handling
Message-ID: <20210201112848.6980a021@carbon>
In-Reply-To: <161211094907.493006.5021971055122561766.stgit@firesoul>
References: <161211094907.493006.5021971055122561766.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


I'm going to resend this patchset as it doesn't appear on the list and
also not in patchwork.  I guess, I was hit by the spamcop.net mail
issue that Konstantin mentioned.

On Sun, 31 Jan 2021 17:36:35 +0100
Jesper Dangaard Brouer <brouer@redhat.com> wrote:

> This patchset


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

