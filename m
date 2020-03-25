Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC664192CBF
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 16:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727644AbgCYPim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 11:38:42 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:60676 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726838AbgCYPim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 11:38:42 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jH875-0002DR-Dk; Wed, 25 Mar 2020 16:38:39 +0100
Date:   Wed, 25 Mar 2020 16:38:39 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Bug URGENT Report with new kernel 5.5.10-5.6-rc6
Message-ID: <20200325153839.GB878@breakpoint.cc>
References: <20200319104750.x2zz7negjbm6lwch@salvia>
 <20200319105248.GP979@breakpoint.cc>
 <fff10500-8b87-62f0-ec89-49453cf9ae57@gmail.com>
 <4d9f339c-b0a7-1861-7d76-e0f2cee92b8c@gmail.com>
 <CALidq=VJuhEPO-FWOuUdSG+-VO+h7VHfmtQiAxikxH+vMB+vdQ@mail.gmail.com>
 <CALidq=Wq3FaGPbbjDvcjvw3V=yPWNMPDeFFy-bDL6fffdjb2rw@mail.gmail.com>
 <CALidq=VYSt3WbtapwL-n8cG71=ysYDJTo3L---xj4U1rEC63KQ@mail.gmail.com>
 <20200324131829.GF3305@breakpoint.cc>
 <CALidq=WBGwMWZeK95WpunO=+yiCo=iFFijXmjQdOMKxj7-XC1A@mail.gmail.com>
 <CALidq=X1fVQgr1CFNqswNK=me42aYtrqp8cmbFO63ekimn4O-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALidq=X1fVQgr1CFNqswNK=me42aYtrqp8cmbFO63ekimn4O-g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin Zaharinov <micron10@gmail.com> wrote:
> Hi Florian
> 
> after run machine for 7-8 hour in dmesg get same debug :

Mhhh, are you sure you applied the patch?

> [28514.488813] Call Trace:
> [28514.517959]  <IRQ>
> [28514.546187]  nf_queue_entry_release_refs+0x77/0x90
> [28514.574371]  nf_reinject+0x65/0x170

nf_reinject() doesn't call nf_queue_entry_release_refs() anymore
after the patch I made.
