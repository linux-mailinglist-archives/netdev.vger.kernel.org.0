Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7DD4282245
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 09:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbgJCH5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 03:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbgJCH5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 03:57:34 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10280C0613D0;
        Sat,  3 Oct 2020 00:57:34 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id m6so4220664wrn.0;
        Sat, 03 Oct 2020 00:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LyawnCgi1UNdHgpnRwunL/a5wwOIV+1RyoH/sIFjZhE=;
        b=ZStgnWDZd6Pq9OBUHnsqpMpPwoGia4aH00oN6hHsIIJzACcAtQJ/IgPbKzFgRBcOT9
         mSHRDcMrQcgeQk27i4liRIxdcsrxs/WvjScnL0f9XKP0zwr++4XqgWlAZqXdCdWEyatQ
         WeNPlY2UCNLrHJ4Ga2vG0vOqo7beWRnGqobePAten03htYcKbd+eLqon2k1xopqDLEQu
         aTEIKXlIqpAgZ7aSfqOa52X8yDQozSxXW9qKSCME9KoFinmKA7ze1b1HfrwJtJxj7VCh
         g1e+t0guz6FpMrJQcEPQccV6FSoBg1mNnxPkwH0TYvbaAedfODcVRqUcOqwWX281hjab
         TGhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LyawnCgi1UNdHgpnRwunL/a5wwOIV+1RyoH/sIFjZhE=;
        b=cJBf3y4554Ko6J6NuUpAvwPZr29jZGv6EcAdvTRDXGj/uynFy3W3np+pBl8atIJBTz
         vW9g6CS3/+xepLMR3kskc5iNOgNef93xZzRiC+8SM/o1DS1TGwqCg+Rihv+dHtveNiQo
         Ln11tfMNm+wIdlHfEzj3/b89sVbCLtDNOB8GfcFZU89vuuwvOrfBdwUBewvOcY8w+dD0
         Q9CTQEbf+fMsrbjsgSzypTTTJZT70L+2yRoFjyoTThAycuSo+MykhbDAzGrinpT817uP
         cFTl4GTKfEIBh/XXoj/d+F8n19oob4qEyk6TjNbxRLIzEprGsihmwb2sEgTAcQO01rtY
         QC3A==
X-Gm-Message-State: AOAM530eIJPozS4R2bAXXgB3xIS1LNprexs8Zh4UI5IUh21ztyBOc1WP
        1gmDsnkGCRg8kSz7FYYY1z9Xaj+c5JwxbqX6M74=
X-Google-Smtp-Source: ABdhPJzw8nhuV3Avm74CHAjRRdV4e9TmGhSWhbFuT/JtjyLmypAdG1faPr22CFy3WtXhELYZP6TNwjKzxAJG3NgeQl0=
X-Received: by 2002:a5d:45cc:: with SMTP id b12mr7030136wrs.395.1601711852753;
 Sat, 03 Oct 2020 00:57:32 -0700 (PDT)
MIME-Version: 1.0
References: <7ff312f910ada8893fa4db57d341c628d1122640.1601387231.git.lucien.xin@gmail.com>
 <202009300218.2AcHEN0L-lkp@intel.com> <20201003040824.GG70998@localhost.localdomain>
In-Reply-To: <20201003040824.GG70998@localhost.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sat, 3 Oct 2020 16:12:58 +0800
Message-ID: <CADvbK_cPX1f5jrGsKuvya7ssOFPTsG7daBCkOP-NGN9hpzf5Vw@mail.gmail.com>
Subject: Re: [PATCH net-next 11/15] sctp: add udphdr to overhead when udp_port
 is set
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     kernel test robot <lkp@intel.com>,
        network dev <netdev@vger.kernel.org>,
        linux-sctp@vger.kernel.org, kbuild-all@lists.01.org,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        Tom Herbert <therbert@google.com>, davem <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 3, 2020 at 12:08 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Wed, Sep 30, 2020 at 03:00:42AM +0800, kernel test robot wrote:
> > Hi Xin,
> >
> > Thank you for the patch! Yet something to improve:
>
> I wonder how are you planning to fix this. It is quite entangled.
> This is not performance critical. Maybe the cleanest way out is to
> move it to a .c file.
>
> Adding a
> #if defined(CONFIG_IP_SCTP) || defined(CONFIG_IP_SCTP_MODULE)
> in there doesn't seem good.
>
> >    In file included from include/net/sctp/checksum.h:27,
> >                     from net/netfilter/nf_nat_proto.c:16:
> >    include/net/sctp/sctp.h: In function 'sctp_mtu_payload':
> > >> include/net/sctp/sctp.h:583:31: error: 'struct net' has no member named 'sctp'; did you mean 'ct'?
> >      583 |   if (sock_net(&sp->inet.sk)->sctp.udp_port)
> >          |                               ^~~~
> >          |                               ct
> >
Here is actually another problem, I'm still thinking how to fix it.

Now sctp_mtu_payload() returns different value depending on
net->sctp.udp_port. but net->sctp.udp_port can be changed by
"sysctl -w" anytime. so:

In sctp_packet_config() it gets overhead/headroom by calling
sctp_mtu_payload(). When 'udp_port' is 0, it's IP+MAC header
size. Then if 'udp_port' is changed to 9899 by 'sysctl -w',
udphdr will also be added to the packet in sctp_v4_xmit(),
and later the headroom may not be enough for IP+MAC headers.

I'm thinking to add sctp_sock->udp_port, and it'll be set when
the sock is created with net->udp_port. but not sure if we should
update sctp_sock->udp_port with  net->udp_port when sending packets?
