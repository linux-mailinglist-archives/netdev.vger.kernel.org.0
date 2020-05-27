Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110371E378E
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 06:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgE0EyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 00:54:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:51400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725294AbgE0EyJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 00:54:09 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA18F2078C;
        Wed, 27 May 2020 04:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590555248;
        bh=m4k3TkPLrHArLtdF0GxXUJBVIXlG8VaDSVG9PaHh6DM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OndqCj+D+FGNsAjLzkGh7vKxjQFr/svFV2DT2nUkq1ePAit4fP6RowoaGPbVtqNBk
         sYVuM9r5Ri05MBGLkkCYzCCpZw1nKYby9vWX3TrSgJsEhvxWKdc21zk5mOsrTUNYPm
         iZZbkNIYJooaAnb0hd0WQP1tU8xompbbz+e7eLpE=
Date:   Wed, 27 May 2020 07:54:04 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH iproute2-next 0/4] RAW format dumps through RDMAtool
Message-ID: <20200527045404.GA349682@unreal>
References: <20200520102539.458983-1-leon@kernel.org>
 <acfe3236-0ab9-53ae-eb3b-7ff8a510e599@gmail.com>
 <20200527025921.GH100179@unreal>
 <0d9606bc-8829-f6c2-e2d3-6aa4eabfa840@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d9606bc-8829-f6c2-e2d3-6aa4eabfa840@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 09:07:34PM -0600, David Ahern wrote:
> On 5/26/20 8:59 PM, Leon Romanovsky wrote:
> >
> > Yes, you remember correctly.
> >
> > What should I write in the series to make it clear that the patches
> > need to be reviewed but not merged yet due to on-going kernel
> > submission?
> >
> > We are not merging any code in RDMA that doesn't have corresponding
> > parts in iproute2 or rdma-core.
> >
> > Thanks
> >
>
>
> Let's stick with labeling iproute2 patches RFC until they are ready to
> be committed.

Thanks, I'll do.
