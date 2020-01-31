Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69AAC14E68C
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 01:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbgAaAYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 19:24:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53406 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727614AbgAaAYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 19:24:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580430275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Yce3RzcRj3/knjHHok9NbXtjPYcgNWKvZz8mmZTolms=;
        b=HMgtAbTpRcM0UtZk1S7aW8D+SCDo4EBZAXwQKuXpN4nlYttE2Y838HoE23HnoS8BnEtHxa
        8ISozK01LAlOtN42aT3PDX6L3Oq6tSDdBWAoHDOxRCk4CUMwnTyrgvNwRt3XSVvna4xcib
        +t+7hpddUBnAeMkocWu78EHJRKg/5/E=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-wIs13SRtOXiwlp9wyHxBZQ-1; Thu, 30 Jan 2020 19:24:33 -0500
X-MC-Unique: wIs13SRtOXiwlp9wyHxBZQ-1
Received: by mail-ed1-f69.google.com with SMTP id m21so3513502edp.14
        for <netdev@vger.kernel.org>; Thu, 30 Jan 2020 16:24:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yce3RzcRj3/knjHHok9NbXtjPYcgNWKvZz8mmZTolms=;
        b=ldeHwn27fkw2wE/zr07vZZG7o8rR2a04LRKVapyKr52Ue8ES7h31pl+CmQM+zOFAjQ
         iacs2bNBcNMP6BmZry9+bXHsMBe/RbKVKoToR9RfsSicVi2BNoIvLXBVIS2+Bhy4aplf
         XxprC2r6TNQ0bIlg+AIFX8XiyAGE+1ZG4buEMNe1UmaZ4h97z6Q//qxgg4dL5Aj4AHxH
         DV0W6CFRKlkov4yfjLEX9BgEBbAEaeA8DOXWDbTIo59fXoPD5adQtSksE3wGs0WqZ7oN
         8iMLfCQKCiq9oFB/FARxLZ66kA7P+XLU+EQ8bw6N7l4e3gN6wNbI8Kvd0Ybt2I9twXFF
         LVhg==
X-Gm-Message-State: APjAAAXNptsemSznPU8ZDs1CMEowW6s3kVkdte14a8l7EYvaVPac4xT+
        JMn7UfRKBlPin0HSz8PQHBE5ZAlTg47hqkQLR3/fIpABXPj40MQOVCt3GLURt9V8y5wgHooAsst
        xuh2vRKVQx6y8D+pMKt+J0UU5loaF7bFm
X-Received: by 2002:a50:cfc1:: with SMTP id i1mr6377959edk.366.1580430272321;
        Thu, 30 Jan 2020 16:24:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqxfns7Ipz2OMXE7rsuvi11JkWCkrY9gHsHVLdpY40duyr/etkHlFPDUanfpd7IpDQXFGEdFBuoEY3X8zi7kwNg=
X-Received: by 2002:a50:cfc1:: with SMTP id i1mr6377950edk.366.1580430272088;
 Thu, 30 Jan 2020 16:24:32 -0800 (PST)
MIME-Version: 1.0
References: <20200130191019.19440-1-mcroce@redhat.com> <20200130141448.27fa32aa@cakuba>
In-Reply-To: <20200130141448.27fa32aa@cakuba>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Fri, 31 Jan 2020 01:23:56 +0100
Message-ID: <CAGnkfhzHqHFiqje3_ruSFvz09QKv3M8dqvOqzN_kau6ZpKzWOw@mail.gmail.com>
Subject: Re: [PATCH net] netfilter: nf_flowtable: fix documentation
To:     Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev <netdev@vger.kernel.org>, linux-doc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 30, 2020 at 11:14 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 30 Jan 2020 20:10:19 +0100, Matteo Croce wrote:
> > In the flowtable documentation there is a missing semicolon, the command
> > as is would give this error:
> >
> >     nftables.conf:5:27-33: Error: syntax error, unexpected devices, expecting newline or semicolon
> >                     hook ingress priority 0 devices = { br0, pppoe-data };
> >                                             ^^^^^^^
> >     nftables.conf:4:12-13: Error: invalid hook (null)
> >             flowtable ft {
> >                       ^^
> >
> > Fixes: 19b351f16fd9 ("netfilter: add flowtable documentation")
> > Signed-off-by: Matteo Croce <mcroce@redhat.com>
>
> This is netfilter so even though it's tagged as net, I'm expecting
> Pablo (or Jon) to take it. Please LMK if I'm wrong.
>

You're right.
As get_maintainers.pl didn't list netfilter-devel@vger.kernel.org I missed it.

-- 
Matteo Croce
per aspera ad upstream

