Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327EC2AD009
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 07:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730397AbgKJGxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 01:53:40 -0500
Received: from namei.org ([65.99.196.166]:39870 "EHLO namei.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgKJGxk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 01:53:40 -0500
Received: from localhost (localhost [127.0.0.1])
        by namei.org (8.14.4/8.14.4) with ESMTP id 0AA6rBTi009357;
        Tue, 10 Nov 2020 06:53:11 GMT
Date:   Tue, 10 Nov 2020 17:53:11 +1100 (AEDT)
From:   James Morris <jmorris@namei.org>
To:     Casey Schaufler <casey@schaufler-ca.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
cc:     casey.schaufler@intel.com, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, Audit-ML <linux-audit@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        John Johansen <john.johansen@canonical.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v22 05/23] LSM: Use lsmblob in security_secctx_to_secid
In-Reply-To: <20201105004924.11651-6-casey@schaufler-ca.com>
Message-ID: <alpine.LRH.2.21.2011101753060.9130@namei.org>
References: <20201105004924.11651-1-casey@schaufler-ca.com> <20201105004924.11651-6-casey@schaufler-ca.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Nov 2020, Casey Schaufler wrote:

> Change the security_secctx_to_secid interface to use a lsmblob
> structure in place of the single u32 secid in support of
> module stacking. Change its callers to do the same.
> 
> The security module hook is unchanged, still passing back a secid.
> The infrastructure passes the correct entry from the lsmblob.
> 
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> Cc: netdev@vger.kernel.org

You probably need to include Netfilter maintainers specifically for this 
(added them + the Netfilter list).

This also needs signoffs from LSM owners.

-- 
James Morris
<jmorris@namei.org>

