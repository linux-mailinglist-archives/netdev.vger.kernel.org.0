Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3F36E66F1
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 16:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbjDROSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 10:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbjDROSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 10:18:31 -0400
Received: from sonata.ens-lyon.org (sonata.ens-lyon.org [140.77.166.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752F5D3;
        Tue, 18 Apr 2023 07:18:24 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by sonata.ens-lyon.org (Postfix) with ESMTP id 7BB632018D;
        Tue, 18 Apr 2023 16:18:22 +0200 (CEST)
Received: from sonata.ens-lyon.org ([127.0.0.1])
        by localhost (sonata.ens-lyon.org [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EmVoFXTU2Zj2; Tue, 18 Apr 2023 16:18:22 +0200 (CEST)
Received: from begin (unknown [109.190.253.11])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by sonata.ens-lyon.org (Postfix) with ESMTPSA id EBD1A20181;
        Tue, 18 Apr 2023 16:18:21 +0200 (CEST)
Received: from samy by begin with local (Exim 4.96)
        (envelope-from <samuel.thibault@ens-lyon.org>)
        id 1pomA0-00C83w-2Z;
        Tue, 18 Apr 2023 16:18:20 +0200
Date:   Tue, 18 Apr 2023 16:18:20 +0200
From:   Samuel Thibault <samuel.thibault@ens-lyon.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     James Chapman <jchapman@katalix.com>, tparkin@katalix.com,
        edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PPPoL2TP: Add more code snippets
Message-ID: <20230418141820.gxueo5pz2vvre442@begin>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Guillaume Nault <gnault@redhat.com>,
        James Chapman <jchapman@katalix.com>, tparkin@katalix.com,
        edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230416220704.xqk4q6uwjbujnqpv@begin>
 <ZD5V+z+cBaXvPbQa@debian>
 <20230418085323.h6xij7w6d2o4kxxi@begin>
 <ZD5dqwPblo4FOex1@debian>
 <20230418091148.hh3b52zceacduex6@begin>
 <ZD5uU8Wrz4cTSwqP@debian>
 <20230418103140.cps6csryl2xhrazz@begin>
 <ZD5+MouUk8YFVOX3@debian>
 <20230418115409.aqsqi6pa4s4nhwgs@begin>
 <ZD6dON0gl3DE8mYr@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZD6dON0gl3DE8mYr@debian>
Organization: I am not organized
User-Agent: NeoMutt/20170609 (1.8.3)
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guillaume Nault, le mar. 18 avril 2023 15:38:00 +0200, a ecrit:
> On Tue, Apr 18, 2023 at 01:54:09PM +0200, Samuel Thibault wrote:
> > Guillaume Nault, le mar. 18 avril 2023 13:25:38 +0200, a ecrit:
> > > As I said in my previous reply, a simple L2TP example that goes until PPP
> > > channel and unit creation is fine. But any more advanced use of the PPP
> > > API should be documented in the PPP documentation.
> > 
> > When it's really advanced, yes. But here it's just about tunnel
> > bridging, which is a very common L2TP thing to do.
> 
> I can't undestand why you absolutely want this covered in l2tp.rst.

Because that's where people working on L2TP software will look for it.

> This feature also works on PPPoE.

Then PPPoE documentation shouls also contain mentions of it.

Note (and I'll repeat myself again below) I'm not talking about
*documentation* (which belongs to ppp_generic.rst, but *mentions* of it.

Networking is complex. If each protocol only speaks for itself and
doesn't take the effort of showing how they glue with others, it's hard
for people to grasp the whole ideas.

> Also, it's probably a desirable feature, but certainly not a common
> thing on Linux. This interface was added a bit more than 2 years ago,
> which is really recent considering the age of the code.

Yes, and in ISPs we have been in need for it for something like
decades. I can find RFC drafts around 2000.

Or IPs have just baked their own kernel implementation (xl2tpd,
accel-ppp, etc.)

> Appart from maybe go-l2tp, I don't know of any user.

Because it's basically undocumented from the point of view of L2TP
people.

> > > I mean, these files document the API of their corresponding modules,
> > > their scope should be limitted to that (the PPP and L2TP layers are
> > > really different).
> > 
> > I wouldn't call
> > 
> > +        ret = ioctl(ppp_chan_fd, PPPIOCBRIDGECHAN, &chindx2);
> > +        close(ppp_chan_fd);
> > +        if (ret < 0)
> > +                return -errno;
> > 
> > documentation...
> 
> The documentation is in ppp_generic.rst.

Yes. and I *definitely* agree on that, and exactly what I'm all talking
about. I'm here just arguing about putting these _*_4 lines of code_*_
example in l2tp.rst, _*_nothing more_*_. See the subject of this thread:
"code snippets". Not documentation.

> Does it really make sense to you to have the doc there

There is basically no doc in what I am proposing.

> and the sample code in l2tp.rst?

Yes, because then L2TP people can be sure to understand how things plug
altogether before writing code...

... instead of having to try various things until understanding how it's
all supposed to fit altogether.

Samuel
