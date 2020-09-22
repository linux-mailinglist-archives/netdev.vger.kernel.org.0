Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0433E27498C
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 21:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgIVTyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 15:54:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:42384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726577AbgIVTyX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 15:54:23 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25C9E20888;
        Tue, 22 Sep 2020 19:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600804462;
        bh=Zn/Z2CdaIP6QTx5Ejt047CW4S3boZcy3W7WAuEFn30k=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=Db7Wf/TKf+Icycp6D4n17ldpBebSu5xt9LHevpygPcG8t+x9js04ayIdmleRUvANc
         6K9mU4URBnuc4dtfIUBSsgng/N4YQkcWfaoBtYt6vQ/Wwibc6xqTQ1pSOfz8lksVXO
         0RIPhqh3f7Mnk/h5Ua+gfTE/m0AvVaRXGoYn8HA0=
Message-ID: <4eb581435bd7ac528c29815a7d26016bd1c429f4.camel@kernel.org>
Subject: Re: [PATCH] net/mlx5: remove unreachable return
From:   Saeed Mahameed <saeed@kernel.org>
To:     Pavel Machek <pavel@ucw.cz>, eranbe@mellanox.com,
        lariel@mellanox.com, saeedm@mellanox.com, leon@kernel.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 22 Sep 2020 12:54:20 -0700
In-Reply-To: <5d37fdcb0d50d79f93e8cdb31cb3f182548ffcc1.camel@kernel.org>
References: <20200921114103.GA21071@duo.ucw.cz>
         <5d37fdcb0d50d79f93e8cdb31cb3f182548ffcc1.camel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-09-21 at 22:54 -0700, Saeed Mahameed wrote:
> On Mon, 2020-09-21 at 13:41 +0200, Pavel Machek wrote:
> > The last return statement is unreachable code. I'm not sure if it
> > will
> > provoke any warnings, but it looks ugly.
> >     
> > Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
> > 
> > 
> 
> Applied to net-next-mlx5.
> 
> Thanks,
> Saeed.
> 

Actually checkpatch reports this issue:
WARNING:NO_AUTHOR_SIGN_OFF: Missing Signed-off-by: line by nominal
patch author 'Pavel Machek <pavel@ucw.cz>'

Do you want me to override the Signed-off-by tag with the above email ?

Thanks,
Saeed.

