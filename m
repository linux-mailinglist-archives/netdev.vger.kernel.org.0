Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF9E5179E06
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 03:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbgCECxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 21:53:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:47934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgCECxu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 21:53:50 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5337320838;
        Thu,  5 Mar 2020 02:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583376829;
        bh=b32YGkMstL0h2Pud8CEuaJAe5TmMOSaCGUBsnx3kKFw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lq5fIslUluZaEDYUpGyDOpmlVO2RvSo+QWBs0xXg4a+nhX2O3lKYq1K3cvwkMAdRU
         28FqSTjBhTVl3Z8V7a9NIxcP+ZkbQlf0MB1pabdSZsABcHsVjrXOEBSOvFUeiBJipe
         5zQRV/igrmQyHS1rzMUBWfn53tpIWS9J7yS91LRM=
Date:   Wed, 4 Mar 2020 18:53:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     subashab@codeaurora.org
Cc:     Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net,
        stranche@codeaurora.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/3] net: rmnet: several code cleanup for
 rmnet module
Message-ID: <20200304185347.797972fb@kicinski-fedora-PC1C0HJN>
In-Reply-To: <eb4fa65d10a8b1f81be44bcb4e3b6a43@codeaurora.org>
References: <20200304232415.12205-1-ap420073@gmail.com>
 <eb4fa65d10a8b1f81be44bcb4e3b6a43@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 04 Mar 2020 16:43:58 -0700 subashab@codeaurora.org wrote:
> On 2020-03-04 16:24, Taehee Yoo wrote:
> > This patchset is to cleanup rmnet module code.
> > 
> > 1. The first patch is to add module alias
> > rmnet module can not be loaded automatically because there is no
> > alias name.
> > 
> > 2. The second patch is to add extack error message code.
> > When rmnet netlink command fails, it doesn't print any error message.
> > So, users couldn't know the exact reason.
> > In order to tell the exact reason to the user, the extack error message
> > is used in this patch.
> > 
> > 3. The third patch is to use GFP_KERNEL instead of GFP_ATOMIC.
> > In the sleepable context, GFP_KERNEL can be used.
> > So, in this patch, GFP_KERNEL is used instead of GFP_ATOMIC.
> > 
> > Change log:
> >  - v1->v2: change error message in the second patch.
>
> For the series:
> 
> Acked-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>

LGTM as well, thanks!
