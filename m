Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9E5843BE5
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbfFMPcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:32:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52170 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728486AbfFMKtc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 06:49:32 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0DD383003E4F;
        Thu, 13 Jun 2019 10:49:22 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.32.181.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C4AA34506;
        Thu, 13 Jun 2019 10:49:16 +0000 (UTC)
Message-ID: <7ad9dd803e3d961fef3ceaf77215f27e02b04981.camel@redhat.com>
Subject: Re: [PATCH net-next 1/3] net/sched: Introduce action ct
From:   Davide Caratti <dcaratti@redhat.com>
To:     Paul Blakey <paulb@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>
Cc:     Justin Pettit <jpettit@ovn.org>,
        John Hurley <john.hurley@netronome.com>,
        Rony Efraim <ronye@mellanox.com>, nst-kernel@redhat.com,
        Simon Horman <simon.horman@netronome.com>
In-Reply-To: <a08bde08fce26054754172786ced8bd671079833.camel@redhat.com>
References: <1560259713-25603-1-git-send-email-paulb@mellanox.com>
         <1560259713-25603-2-git-send-email-paulb@mellanox.com>
         <a08bde08fce26054754172786ced8bd671079833.camel@redhat.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Thu, 13 Jun 2019 12:49:15 +0200
Mime-Version: 1.0
User-Agent: Evolution 3.30.3 (3.30.3-1.fc29) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Thu, 13 Jun 2019 10:49:30 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-06-13 at 12:16 +0200, Davide Caratti wrote:
> hello Paul!
> 
> On Tue, 2019-06-11 at 16:28 +0300, Paul Blakey wrote:
> 
> > +#endif /* __NET_TC_CT_H */
> > diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
> > index a93680f..c5264d7 100644
> > --- a/include/uapi/linux/pkt_cls.h
> > +++ b/include/uapi/linux/pkt_cls.h
> > @@ -83,6 +83,7 @@ enum {
> >  #define TCA_ACT_SIMP 22
> >  #define TCA_ACT_IFE 25
> >  #define TCA_ACT_SAMPLE 26
> > +#define TCA_ACT_CT 27
> 
> ^^  I think you can't use 27 (act_ctinfo forgot to explicitly define it),
> or the uAPI will break. See below:

[...]

Nevermind, I just read the comment above the definition of TCA_ACT_GACT.
> > 
> so, I think you should use 28. And I will send a patch for net-next now
> that adds the missing define for TCA_ID_CTINFO. Ok?

we don't need to patch pkt_cls.h. Just avoid 

#define TCA_ACT_CT 27 

and the assignment in the enum, that should be sufficient.
-- 
davide

