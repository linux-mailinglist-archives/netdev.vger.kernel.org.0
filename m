Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 721542FD189
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 14:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730633AbhATMwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 07:52:13 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:19173 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389539AbhATMSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 07:18:10 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60081f590001>; Wed, 20 Jan 2021 04:17:29 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Wed, 20 Jan 2021 12:17:27 +0000
Date:   Wed, 20 Jan 2021 14:17:21 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Jason Wang <jasowang@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lulu@redhat.com>
Subject: Re: [PATCH v1] vdpa/mlx5: Fix memory key MTT population
Message-ID: <20210120121721.GA139465@mtl-vdi-166.wap.labs.mlnx>
References: <20210107071845.GA224876@mtl-vdi-166.wap.labs.mlnx>
 <07d336a3-7fc2-5e4a-667a-495b5bb755da@redhat.com>
 <20210120053619.GA126435@mtl-vdi-166.wap.labs.mlnx>
 <20210120025651-mutt-send-email-mst@kernel.org>
 <20210120081154.GA132136@mtl-vdi-166.wap.labs.mlnx>
 <20210120035031-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210120035031-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611145050; bh=r/7qdqKXIizY6E6ZcPBAWAJd9m1X63I9mq9Qamw9384=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=PVnBLxLt4qsuspYauoxBReRrHx7LpLsiiB+cFrxFc2Agz10BFhVTWbElnybO0zPCu
         xt4IOCbz9ieFGNpFz2LYSY7x1AAVABwaNZjfQUYAMEpCXjMQNpaBvNcf/kGGm8dW9F
         5dDwvRIDLI+Hp4ZFY9kaQs5nGiEFag+a/8nQahjJaqLErDN0f5MgvWxB8M11oaRXuX
         xpe1wAGMrQFs6pO74w2TAcNWl9MqWXsUaeRD2aAt44P4s5JL6p9R2qGSF5fNo/F+NW
         DFctw+LAB1wWKLFirhwjp6nymzuEpMZCBdHV6mGI0FmH8lK83BgB3CiqvkKWD4miBE
         sahXONlbDkEnw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 03:52:00AM -0500, Michael S. Tsirkin wrote:
> On Wed, Jan 20, 2021 at 10:11:54AM +0200, Eli Cohen wrote:
> > On Wed, Jan 20, 2021 at 02:57:05AM -0500, Michael S. Tsirkin wrote:
> > > On Wed, Jan 20, 2021 at 07:36:19AM +0200, Eli Cohen wrote:
> > > > On Fri, Jan 08, 2021 at 04:38:55PM +0800, Jason Wang wrote:
> > > > 
> > > > Hi Michael,
> > > > this patch is a fix. Are you going to merge it?
> > > 
> > > yes - in the next pull request.
> > > 
> > 
> > Great thanks.
> > Can you send the path to your git tree where you keep the patches you
> > intend to merge?
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
> 
> Note I often rebase it (e.g. just did).
> 

Great, thanks!

> -- 
> MST
> 
