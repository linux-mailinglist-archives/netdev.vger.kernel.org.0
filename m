Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A86C2BA0BB
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 04:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgKTDCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 22:02:15 -0500
Received: from namei.org ([65.99.196.166]:54340 "EHLO namei.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725887AbgKTDCP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 22:02:15 -0500
Received: from localhost (localhost [127.0.0.1])
        by namei.org (8.14.4/8.14.4) with ESMTP id 0AK3299S020199;
        Fri, 20 Nov 2020 03:02:09 GMT
Date:   Fri, 20 Nov 2020 14:02:09 +1100 (AEDT)
From:   James Morris <jmorris@namei.org>
To:     Paul Moore <paul@paul-moore.com>
cc:     linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        selinux@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] lsm,selinux: pass flowi_common instead of flowi to the
 LSM hooks
In-Reply-To: <160581265397.2575.2287441525647057669.stgit@sifl>
Message-ID: <alpine.LRH.2.21.2011201401570.20132@namei.org>
References: <160581265397.2575.2287441525647057669.stgit@sifl>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020, Paul Moore wrote:

> As pointed out by Herbert in a recent related patch, the LSM hooks do
> not have the necessary address family information to use the flowi
> struct safely.  As none of the LSMs currently use any of the protocol
> specific flowi information, replace the flowi pointers with pointers
> to the address family independent flowi_common struct.
> 
> Reported-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Paul Moore <paul@paul-moore.com>


Acked-by: James Morris <jamorris@linux.microsoft.com>


-- 
James Morris
<jmorris@namei.org>

