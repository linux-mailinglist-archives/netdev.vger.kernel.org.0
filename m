Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDFE02A9136
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 09:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgKFIY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 03:24:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55993 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726443AbgKFIY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 03:24:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604651096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d18i73IoyTVLDHS4kB4hrjoSwOYtNo3Eb/osp3LxP5A=;
        b=Wo2X6QJzMV1gDHQAGSjsVl/Ml4EmWVExJqIVmQnhFL8/FxGfmG4Gr35WRB9XBi4LS2pDoe
        fwiAv+B4wMqqXoYcY+ILid+QP/0p4Yp1ALSXWfkbQXjoc2uSivS5QflIxMpA+KAp4VKxEl
        hu8e//IJvbSCgyMBbYsnU6ZQusABXQc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-NvTg7VpjO3S8cGPs_jvKrg-1; Fri, 06 Nov 2020 03:24:54 -0500
X-MC-Unique: NvTg7VpjO3S8cGPs_jvKrg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C5A78049CD;
        Fri,  6 Nov 2020 08:24:52 +0000 (UTC)
Received: from localhost (unknown [10.40.193.217])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A872819C66;
        Fri,  6 Nov 2020 08:24:50 +0000 (UTC)
Date:   Fri, 6 Nov 2020 09:24:48 +0100
From:   Jiri Benc <jbenc@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next] bpf: make verifier log more relevant by
 default
Message-ID: <20201106092448.5c14808c@redhat.com>
In-Reply-To: <20201105145713.10af539e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200423195850.1259827-1-andriin@fb.com>
        <20201105170202.5bb47fef@redhat.com>
        <CAEf4Bzb7r-9TEAnQC3gwiwX52JJJuoRd_ZHrkGviiuFKvy8qJg@mail.gmail.com>
        <20201105135338.316e1677@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEf4BzZgXO1Uv49cGQ6PMoe6gXiF8obJr9uKBTeE2MzzHEr=PA@mail.gmail.com>
        <20201105145713.10af539e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Nov 2020 14:57:13 -0800, Jakub Kicinski wrote:
> If you're saying the driver message would still be there if
> verification or translation failed that's perfectly fine, we 
> can definitely adjust the test. But some check that driver 
> message reporting is working is needed, don't just remove it.

Should we change the test to fail the verification? Sounds reasonable
to me.

 Jiri

