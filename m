Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEBB027DCEA
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 01:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbgI2Xsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 19:48:37 -0400
Received: from namei.org ([65.99.196.166]:60428 "EHLO namei.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728192AbgI2Xsg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 19:48:36 -0400
X-Greylist: delayed 2347 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Sep 2020 19:48:35 EDT
Received: from localhost (localhost [127.0.0.1])
        by namei.org (8.14.4/8.14.4) with ESMTP id 08TN9KBD006807;
        Tue, 29 Sep 2020 23:09:20 GMT
Date:   Wed, 30 Sep 2020 09:09:20 +1000 (AEST)
From:   James Morris <jmorris@namei.org>
To:     Paul Moore <paul@paul-moore.com>
cc:     selinux@vger.kernel.org, linux-security-module@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH] lsm,selinux: pass the family information along with
 xfrm flow
In-Reply-To: <160141647786.7997.5490924406329369782.stgit@sifl>
Message-ID: <alpine.LRH.2.21.2009300909150.6592@namei.org>
References: <160141647786.7997.5490924406329369782.stgit@sifl>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Sep 2020, Paul Moore wrote:

> As pointed out by Herbert in a recent related patch, the LSM hooks
> should pass the address family in addition to the xfrm flow as the
> family information is needed to safely access the flow.
> 
> While this is not technically a problem for the current LSM/SELinux
> code as it only accesses fields common to all address families, we
> should still pass the address family so that the LSM hook isn't
> inherently flawed.  An alternate solution could be to simply pass
> the LSM secid instead of flow, but this introduces the problem of
> the LSM hook callers sending the wrong secid which would be much
> worse.
> 
> Reported-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Paul Moore <paul@paul-moore.com>

I'm not keen on adding a parameter which nobody is using. Perhaps a note 
in the header instead?

-- 
James Morris
<jmorris@namei.org>

