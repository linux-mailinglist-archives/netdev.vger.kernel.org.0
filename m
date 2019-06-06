Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6CE236C65
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 08:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbfFFGif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 02:38:35 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48832 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbfFFGie (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 02:38:34 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id A8550201DA;
        Thu,  6 Jun 2019 08:38:33 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id rXlrOWxfjswb; Thu,  6 Jun 2019 08:38:33 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 44FB2201BB;
        Thu,  6 Jun 2019 08:38:33 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 6 Jun 2019
 08:38:33 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id CBD7631805C3;
 Thu,  6 Jun 2019 08:38:32 +0200 (CEST)
Date:   Thu, 6 Jun 2019 08:38:32 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Florian Westphal <fw@strlen.de>
CC:     <kbuild-all@01.org>, <netdev@vger.kernel.org>
Subject: Re: [ipsec-next:testing 4/6] net/xfrm/xfrm_state.c:1792:9: error:
 '__xfrm6_tmpl_sort_cmp' undeclared; did you mean 'xfrm_tmpl_sort'?
Message-ID: <20190606063832.GC17989@gauss3.secunet.de>
References: <201906052002.P2x8MWme%lkp@intel.com>
 <20190605124045.gzkafkixihwu7447@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190605124045.gzkafkixihwu7447@breakpoint.cc>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 02:40:45PM +0200, Florian Westphal wrote:
> 
> Steffen, as this is still only in your testing branch, I suggest you
> squash this snipped into commit 8dc6e3891a4be64c0cca5e8fe2c3ad33bc06543e
> ("xfrm: remove state and template sort indirections from xfrm_state_afinfo"),
> it resolves this problem for me.

Ok, I did that. Please doublecheck my work.
