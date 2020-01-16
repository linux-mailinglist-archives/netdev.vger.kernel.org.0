Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A64BA13D64C
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 09:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729949AbgAPI7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 03:59:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31967 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725973AbgAPI7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 03:59:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579165191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kQDv4F/iUPTbc2Af1FsAmAFZfrgyIbGKc9Ro4vkAdEI=;
        b=QYLKl5YDfkW004jhQ3K0mk70E/pkOAEpYHU+hd5tBQpM8iowT0DN9wHsPFeCAni+Hph8t/
        xBe5uVpgHPh00WZ8c2axHr25WFcqKrXW2Aa1PJn0pHIsqPz8JCvu3uwzwa3vAzoigytNpM
        f+kYj4l4Bz0IyN5e7haVgWm0MeqNUik=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-zZ4EgYzHN9eAMgJSz0DjpA-1; Thu, 16 Jan 2020 03:59:48 -0500
X-MC-Unique: zZ4EgYzHN9eAMgJSz0DjpA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD2101088380;
        Thu, 16 Jan 2020 08:59:46 +0000 (UTC)
Received: from krava (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CC7D110841AC;
        Thu, 16 Jan 2020 08:59:44 +0000 (UTC)
Date:   Thu, 16 Jan 2020 09:59:43 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Wenbo Zhang <ethercflow@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Brendan Gregg <bgregg@netflix.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, viro@zeniv.linux.org.uk
Subject: Re: [PATCH bpf-next v14 1/2] bpf: add new helper get_fd_path for
 mapping a file descriptor to a pathname
Message-ID: <20200116085943.GA270346@krava>
References: <8f6b8979fb64bedf5cb406ba29146c5fa2539267.1576575253.git.ethercflow@gmail.com>
 <cover.1576629200.git.ethercflow@gmail.com>
 <7464919bd9c15f2496ca29dceb6a4048b3199774.1576629200.git.ethercflow@gmail.com>
 <51564b9e-35f0-3c73-1701-8e351f2482d7@iogearbox.net>
 <CABtjQmbh080cFr9e_V_vutb1fErRcCvw-bNNYeJHOcah-adFCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABtjQmbh080cFr9e_V_vutb1fErRcCvw-bNNYeJHOcah-adFCA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 11:35:08AM +0800, Wenbo Zhang wrote:
> > [ Wenbo, please keep also Al (added here) in the loop since he was providing
> >    feedback on prior submissions as well wrt vfs bits. ]
> 
> Get it, thank you!

hi,
is this stuck on review? I'd like to see this merged ;-)
we have bpftrace change using it already.. from that side:

Tested-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka

