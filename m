Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5888F29E1C5
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbgJ1Vsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:48:41 -0400
Received: from namei.org ([65.99.196.166]:38520 "EHLO namei.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727805AbgJ1Vsi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 17:48:38 -0400
Received: from localhost (localhost [127.0.0.1])
        by namei.org (8.14.4/8.14.4) with ESMTP id 09S5Rmxe026811;
        Wed, 28 Oct 2020 05:27:49 GMT
Date:   Wed, 28 Oct 2020 16:27:48 +1100 (AEDT)
From:   James Morris <jmorris@namei.org>
To:     Paul Moore <paul@paul-moore.com>
cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH] lsm,selinux: pass the family information along with
 xfrm flow
In-Reply-To: <CAHC9VhSq6stUdMSS5MXKDas5RHnrJiKSDU60CbKYe04x2DvymQ@mail.gmail.com>
Message-ID: <alpine.LRH.2.21.2010281627250.25689@namei.org>
References: <160141647786.7997.5490924406329369782.stgit@sifl> <alpine.LRH.2.21.2009300909150.6592@namei.org> <CAHC9VhTM_a+L8nY8QLVdA1FcL8hjdV1ZNLJcr6G_Q27qPD_5EQ@mail.gmail.com> <CAHC9VhSq6stUdMSS5MXKDas5RHnrJiKSDU60CbKYe04x2DvymQ@mail.gmail.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020, Paul Moore wrote:

> On Wed, Sep 30, 2020 at 9:44 AM Paul Moore <paul@paul-moore.com> wrote:
> > On Tue, Sep 29, 2020 at 7:09 PM James Morris <jmorris@namei.org> wrote:
> > > I'm not keen on adding a parameter which nobody is using. Perhaps a note
> > > in the header instead?
> >
> > On Wed, Sep 30, 2020 at 6:14 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > > Please at least change to the struct flowi to flowi_common if we're
> > > not adding a family field.
> >
> > It did feel a bit weird adding a (currently) unused parameter, so I
> > can understand the concern, I just worry that a comment in the code
> > will be easily overlooked.  I also thought about passing a pointer to
> > the nested flowi_common struct, but it doesn't appear that this is
> > done anywhere else in the stack so it felt wrong to do it here.
> 
> With the merge window behind us, where do stand on this?  I see the
> ACK from Casey and some grumbling about adding an unused parameter
> (which is a valid argument, I just feel the alternative is worse), but
> I haven't seen any serious NACKs.
> 
> Any objections or other strong feelings to me merging this via the
> selinux/next branch?

Yes, we should not add unused parameters to functions.

-- 
James Morris
<jmorris@namei.org>

