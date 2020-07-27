Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08EBD22FA32
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 22:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbgG0UiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 16:38:04 -0400
Received: from namei.org ([65.99.196.166]:55724 "EHLO namei.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727008AbgG0UiE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 16:38:04 -0400
Received: from localhost (localhost [127.0.0.1])
        by namei.org (8.14.4/8.14.4) with ESMTP id 06RKbiR2028215;
        Mon, 27 Jul 2020 20:37:44 GMT
Date:   Tue, 28 Jul 2020 06:37:44 +1000 (AEST)
From:   James Morris <jmorris@namei.org>
To:     Casey Schaufler <casey@schaufler-ca.com>,
        Paul Moore <paul@paul-moore.com>
cc:     casey.schaufler@intel.com, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, Audit-ML <linux-audit@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        John Johansen <john.johansen@canonical.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Stephen Smalley <sds@tycho.nsa.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH v19 17/23] LSM: security_secid_to_secctx in netlink
 netfilter
In-Reply-To: <20200724203226.16374-18-casey@schaufler-ca.com>
Message-ID: <alpine.LRH.2.21.2007280637160.18670@namei.org>
References: <20200724203226.16374-1-casey@schaufler-ca.com> <20200724203226.16374-18-casey@schaufler-ca.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Jul 2020, Casey Schaufler wrote:

> Change netlink netfilter interfaces to use lsmcontext
> pointers, and remove scaffolding.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: John Johansen <john.johansen@canonical.com>
> Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> cc: netdev@vger.kernel.org

I'd like to see Paul's acks on any networking related changes.

-- 
James Morris
<jmorris@namei.org>

