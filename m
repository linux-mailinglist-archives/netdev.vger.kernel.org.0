Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D24B332FF92
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 09:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhCGILg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 03:11:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:56460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229872AbhCGILf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Mar 2021 03:11:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2515265116;
        Sun,  7 Mar 2021 08:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615104694;
        bh=PZ9OQwFU+M1iW1CMCPNaAkG4B/TCjEzzhjoaDkMXrvA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tvmtDVGzJ4QFCzk70OAg5exXwb0HlSXXm6X1vYnbzTnSpAO905TBIEbG/PquIPscj
         kzaEAAtnVvZqAR3FpJkSpdBhv7bd7gr7eEYuPE7Bvav5cPd6QmgplCu+3i+0LV+47N
         8z749C3fDYh7bVMUh2YlKfJF7Jr2ctFtihB/F+osvo5zhXuoZip4d8zLZOiXQuqgLk
         WwQin3XtL76fo+CbcRAqvi/fh5fzSCYphzYt6/sQNyxSIGdx5Ij42tnmgeC976IjQT
         QikVu/OTa8/+23GTUlBqIHmdDcQv3AIXps+IH0nkAg73ouT6Yf8tgT2lL/gkVdsCAI
         wMAY1CrMKdZLw==
Date:   Sun, 7 Mar 2021 10:11:30 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Bjorn Helgaas <bhelgaas@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
Message-ID: <YESKslDse2iz8jZ7@unreal>
References: <20210301075524.441609-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301075524.441609-1-leon@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 01, 2021 at 09:55:20AM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
>
> @Alexander Duyck, please update me if I can add your ROB tag again
> to the series, because you liked v6 more.
>
> Thanks
>
> ---------------------------------------------------------------------------------
> Changelog
> v7:
>  * Rebase on top v5.12-rc1
>  * More english fixes
>  * Returned to static sysfs creation model as was implemented in v0/v1.

Bjorn, are we good here?

Thanks
