Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7223A275FBC
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 20:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgIWSYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 14:24:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726419AbgIWSYy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 14:24:54 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D94B420791;
        Wed, 23 Sep 2020 18:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600885494;
        bh=M/OEd5wD72mHBs5ebPZhfra5G4l0MYhXJhv8QWo2Ofo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=m9zyc/urOGLp9XrmK5UNXZf8KFSnlOCi2fdkIO9yFUUjCCCvF+flQsjfIlNJYqfRl
         PTP63w6xZ51BSQaip1KUqPUk6w6YGctEN0kCWc66oUTVC5rbCgT/EZQXD5sUl2ZzQz
         ei9hwLncv8uqGM6ipduS6cGQ1MG2w+Sb06WekbGk=
Message-ID: <d8c43d2db17ebd24744fe45ae9c4e2005a79fb86.camel@kernel.org>
Subject: Re: [net-next 05/15] net/mlx5: Refactor tc flow attributes structure
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ariel Levkovich <lariel@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Vlad Buslov <vladbu@nvidia.com>
Date:   Wed, 23 Sep 2020 11:24:52 -0700
In-Reply-To: <20200923101817.0b0a79c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200923062438.15997-1-saeed@kernel.org>
         <20200923062438.15997-6-saeed@kernel.org>
         <20200923101817.0b0a79c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-09-23 at 10:18 -0700, Jakub Kicinski wrote:
> On Tue, 22 Sep 2020 23:24:28 -0700 saeed@kernel.org wrote:
> > Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
> > Reviewed-by: Roi Dayan <roid@mellanox.com>
> > Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> > 
> > fixup! net/mlx5: Refactor tc flow attributes structure
> > 
> > Init the parse_attr pointer in the beginning of
> > parse_tc_fdb_actions
> > so it will be valid for the entire method.
> > 
> > Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
> > Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
> > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> fixup

:-/ .. no clue how this happened 

will fix, thanks.

