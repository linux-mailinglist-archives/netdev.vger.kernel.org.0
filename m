Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F45836DDC
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 09:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfFFHzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 03:55:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:54274 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726066AbfFFHzJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 03:55:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 00286AF96;
        Thu,  6 Jun 2019 07:55:07 +0000 (UTC)
Date:   Thu, 6 Jun 2019 09:55:07 +0200
From:   Marcus Meissner <meissner@suse.de>
To:     wmealing@redhat.com, blackgod016574@gmail.com,
        netdev@vger.kernel.org
Subject: Re: likely invalid CVE assignment for commit
 95baa60a0da80a0143e3ddd4d3725758b4513825
Message-ID: <20190606075507.GA32166@suse.de>
References: <20190605092029.GB19508@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605092029.GB19508@suse.de>
Organization: SUSE Linux GmbH, GF: =?iso-8859-1?Q?Felix_?=
 =?iso-8859-1?Q?Imend=F6rffer=2C_Mary_Higgins=2C_Sri_Rasiah=2C_HRB_21284_?=
 =?iso-8859-1?Q?=28AG_N=FCrnberg=29?=
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Dave does not like private-only emails, so again for netdev list:

On Wed, Jun 05, 2019 at 11:20:29AM +0200, Marcus Meissner wrote:
> Hi Gen Zhang,
> 
> looking at https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=95baa60a0da80a0143e3ddd4d3725758b4513825
> 
> 	ipv6_sockglue: Fix a missing-check bug in ip6_ra_control()
> 	In function ip6_ra_control(), the pointer new_ra is allocated a memory
> 	space via kmalloc(). And it is used in the following codes. However,
> 	when there is a memory allocation error, kmalloc() fails. Thus null
> 	pointer dereference may happen. And it will cause the kernel to crash.
> 	Therefore, we should check the return value and handle the error.
> 
> There seems to be no case in current GIT where new_ra is being dereferenced even if it
> is NULL (kfree(NULL) will work fine).
> 
> Was this just an assumption based on insufficient code review, or was there a real
> crash observed and how?

The reporter had replied privately that he was only doing a code audit.

We (Redhat and SUSE) wonder if this fix is needed at all.

Ciao, Marcus
