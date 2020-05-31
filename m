Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44EF1E96DA
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 12:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgEaKIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 06:08:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726020AbgEaKIh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 May 2020 06:08:37 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63EAD20707;
        Sun, 31 May 2020 10:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590919717;
        bh=yRlZFy054m0/9FR6qua8/ULPSj+AEv2JQeouEy6CBy4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fDmOZp1/ctXG4vy6xMlrmKQqg+PiWqTxUs/SKabrcRHXrqwUNekpf0BVksxw9/AkV
         rIoT2t+a95QBf/JVatFDnBWgDQST6w4Q41BuTE9DtpUC7MFUmr+Y6YPhJ2wBcxnxhn
         UjtGkFWi5XW6P3/EDlb1mjiKdtsEo80iM7w5XjR0=
Date:   Sun, 31 May 2020 13:08:33 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     rao.shoaib@oracle.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Somasundaram Krishnasamy <somasundaram.krishnasamy@oracle.com>
Subject: Re: [PATCH net-next] rds: transport module should be auto loaded
 when transport is set
Message-ID: <20200531100833.GI66309@unreal>
References: <20200527081742.25718-1-rao.shoaib@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527081742.25718-1-rao.shoaib@oracle.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 01:17:42AM -0700, rao.shoaib@oracle.com wrote:
> From: Rao Shoaib <rao.shoaib@oracle.com>
>
> This enhancement auto loads transport module when the transport
> is set via SO_RDS_TRANSPORT socket option.
>
> Orabug: 31032127

I think that it is internal to Oracle and should not be in the commit
message.

Thanks
