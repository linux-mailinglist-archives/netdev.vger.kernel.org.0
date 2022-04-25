Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F57E50DCAF
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 11:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237949AbiDYJdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 05:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240905AbiDYJcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 05:32:53 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF17513F75;
        Mon, 25 Apr 2022 02:29:49 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1niv2N-0002z1-S0; Mon, 25 Apr 2022 11:29:44 +0200
Date:   Mon, 25 Apr 2022 11:29:43 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Neal Cardwell <ncardwell@google.com>,
        Jaco Kroon <jaco@uls.co.za>, netfilter-devel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: linux 5.17.1 disregarding ACK values resulting in stalled TCP
 connections
Message-ID: <20220425092943.GB26757@breakpoint.cc>
References: <CADVnQy=GX0J_QbMJXogGzPwD=f0diKDDxLiHV0gzrb4bo=4FjA@mail.gmail.com>
 <429dd56b-8a6c-518f-ccb4-fa5beae30953@uls.co.za>
 <CADVnQynGT7pGBT4PJ=vYg-bj9gnHTsKYHMU_6W0RFZb2FOoxiw@mail.gmail.com>
 <CANn89iJqKmjvJGtRHVumfP0T_SSa1uioFLgUvW+MF2ov2Ec2vQ@mail.gmail.com>
 <CADVnQykexgJ+NEUojiKrt=HTomF0nL8CncF401+mEFkvuge7Rg@mail.gmail.com>
 <20220406135807.GA16047@breakpoint.cc>
 <726cf53c-f6aa-38a9-71c4-52fb2457f818@netfilter.org>
 <20220407102657.GB16047@breakpoint.cc>
 <9c6d2d7-70b-bd12-ee14-7923664afb1@netfilter.org>
 <CANn89i+v8niaz5ijpkd_XAbRqXSRBUt-nb43HN=11jkPZmOWog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+v8niaz5ijpkd_XAbRqXSRBUt-nb43HN=11jkPZmOWog@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <edumazet@google.com> wrote:
> Hi Jozsef and Florian
> 
> Any updates for this issue ?

Sorry, I was away for a while.  I will send the patch formally in a few
minutes.
