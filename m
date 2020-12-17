Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38FB02DD98B
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 20:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbgLQTx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 14:53:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:55578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgLQTx6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 14:53:58 -0500
Message-ID: <7eec039dfd7ee7e797521dee6003a5df0d8c5b4a.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608234797;
        bh=+22h2bOhcaMeSWPZ33hfVnTll+Yt/Pmun489lyFQ6qE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VUrYkTvFxjaopLyN7HmYlE2uOK5DtI19E/xhd3i5GKgqmq1ilAHgyPwu/cu1o3Owx
         aErrKgPqpDL2XlE/RTgXPi5R1rWrTzURbuOaltkPhrcZAhQ2PTkaH+IJ46+79wKeJ4
         8bHxRhxo5kiPrsXpv4G9SKPvXVya8Em5i8KKnU1VvvKPZVPdTN4FVwgF+JuJPMlgvM
         TUyI8j+7GlBFxo9hSLGLN3ANsc3ZGuErsXHXicvJvvPbLi0U4fd962SM5aYfvbmskT
         oqD1nl+KuDbvEHZBQnKmP6CBaNRmG3/6+t5gNAqC05mV67qQ/5rqsW9CNIX5fRteON
         f+285DquAxzRg==
Subject: Re: [PATCH net-next] net/mlx5: Fix compilation warning for 32-bit
 platform
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Parav Pandit <parav@nvidia.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, netdev@vger.kernel.org
Date:   Thu, 17 Dec 2020 11:53:16 -0800
In-Reply-To: <20201217105257.6efd99c5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201213120641.216032-1-leon@kernel.org>
         <20201213123620.GC5005@unreal>
         <565c26195b79ca998280d83aca0a193bd1a8c23e.camel@kernel.org>
         <20201216161445.512f2b68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20201217105257.6efd99c5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-12-17 at 10:52 -0800, Jakub Kicinski wrote:
> On Wed, 16 Dec 2020 16:14:45 -0800 Jakub Kicinski wrote:
> > On Mon, 14 Dec 2020 12:08:46 -0800 Saeed Mahameed wrote:
> > > I will change this and attach this patch to my PR of the SF
> > > support.  
> > 
> > Looks like the SF discussion will not wind down in time to make
> > this
> > merge window, so I think I'm going to take this in after all. Okay?
> 
> Done.

Thanks Jakub for your hard work and support!


