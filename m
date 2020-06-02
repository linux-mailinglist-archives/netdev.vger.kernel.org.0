Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B43051EB5C1
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 08:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbgFBGSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 02:18:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbgFBGSi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 02:18:38 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20BF420734;
        Tue,  2 Jun 2020 06:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591078717;
        bh=dfTXNH+fO4KHybwHWDqOQVsJWSqM89WbqAwXBn6Yq8A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NjM0KtSCSadjWtRFLplN00mR2MBfKz+QY83Brp0T3nJxiEBgRm97ixl4FZ4Cyx8G4
         5+JhglrL5/36NO1No4sFvYys6GwQWbAv9TMMbxsEqRBVsAJXPxAhyLaGajTgkKoiC1
         Wb7XvqjzE54WU7Srzlesqd1JUBR13xLi4pGJc0cM=
Date:   Tue, 2 Jun 2020 09:18:33 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Rao Shoaib <rao.shoaib@oracle.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Somasundaram Krishnasamy <somasundaram.krishnasamy@oracle.com>
Subject: Re: [PATCH net-next] rds: transport module should be auto loaded
 when transport is set
Message-ID: <20200602061833.GB56352@unreal>
References: <20200527081742.25718-1-rao.shoaib@oracle.com>
 <20200531100833.GI66309@unreal>
 <c2631a65-c4f9-2913-8a24-08a2de5ac1d3@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2631a65-c4f9-2913-8a24-08a2de5ac1d3@oracle.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 01, 2020 at 10:08:44AM -0700, Rao Shoaib wrote:
>
> On 5/31/20 3:08 AM, Leon Romanovsky wrote:
> > On Wed, May 27, 2020 at 01:17:42AM -0700, rao.shoaib@oracle.com wrote:
> > > From: Rao Shoaib <rao.shoaib@oracle.com>
> > >
> > > This enhancement auto loads transport module when the transport
> > > is set via SO_RDS_TRANSPORT socket option.
> > >
> > > Orabug: 31032127
> > I think that it is internal to Oracle and should not be in the commit
> > message.
> >
> > Thanks
>
> There are logs that have internals bug numbers mentioned in them.

Right, it was missed in the review.

> I do agree with you and will take the bug number out.
>
> Thanks for the comment.
>
> Shoaib
>
