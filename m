Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3224F1C6941
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgEFGrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:47:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727859AbgEFGrG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 02:47:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 298CB206F9;
        Wed,  6 May 2020 06:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588747625;
        bh=aKk/pN/cUJn3REjudMML6/onOxG2p84gG9MnT2qH7i8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gUeRsQ1vavsKSFzz7n4A7lOGR8bCY2r4BfX+SAquJ5tN9tZLG7gzyGHRUkfTkYXqs
         eqcY44b+nMHndqsryyu1Yn1bnQIOoByxTXhRRVbBRn8c9hQzRqHK1ASoesDxwMwS5C
         UCphDaZHGPuEMdE5/zc0VkhhiRlBt+6eHfxBfm7k=
Date:   Wed, 6 May 2020 08:47:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     ashwin-h <ashwinh@vmware.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsab@vmware.com,
        srivatsa@csail.mit.edu, rostedt@goodmis.org, srostedt@vmware.com,
        ashwin.hiranniah@gmail.com
Subject: Re: [PATCH 0/2] Backport to 4.19 - sctp: fully support memory
 accounting
Message-ID: <20200506064703.GA2273049@kroah.com>
References: <cover.1588242081.git.ashwinh@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1588242081.git.ashwinh@vmware.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 07:50:52PM +0530, ashwin-h wrote:
> Backport below upstream commits to 4.19 to address CVE-2019-3874.
> 1033990ac5b2ab6cee93734cb6d301aa3a35bcaa
> sctp: implement memory accounting on tx path
> 
> 9dde27de3e5efa0d032f3c891a0ca833a0d31911
> sctp: implement memory accounting on rx path
> 
> Xin Long (2):
>   sctp: implement memory accounting on tx path
>   sctp: implement memory accounting on rx path
> 
>  include/net/sctp/sctp.h |  2 +-
>  net/sctp/sm_statefuns.c |  6 ++++--
>  net/sctp/socket.c       | 10 ++++++++--
>  net/sctp/ulpevent.c     | 19 ++++++++-----------
>  net/sctp/ulpqueue.c     |  3 ++-
>  5 files changed, 23 insertions(+), 17 deletions(-)
> 
> -- 
> 2.7.4
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
