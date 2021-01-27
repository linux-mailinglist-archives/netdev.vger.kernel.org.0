Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F40305219
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 06:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbhA0FTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 00:19:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:47034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238831AbhA0EvJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 23:51:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAD522070C;
        Wed, 27 Jan 2021 04:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611723029;
        bh=ZoTvHE9oIFk2KlfhemUgsVGuZnV5lSkKShXKWOgcwJY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WC2l3Mkxr4RelbcmqsfgvP1HBOxi0bvgMPVaShlnv/Fruq6xhZCwoSwHTobBNExLs
         wJQUnZFh4UtbFPM8MrS+any3eAZoVHwvf7bP6edtqZPOu7qKSWIsHSrNGqUGc36vXM
         LIZb+JO0uPCCAvO5DcZPjurP4vYHHtWl80RiTNioJ6HsXrGuIackUwEQtHSeujqfyV
         curgv6rtr2nAuSdIN1z1O7H06aait/zgZntz5j+j1TIH/d9M3H8qNBP/aefOwjirgD
         4oHFCpplf1rosE0s2zy7YP9M2l30mD6bcqpcq8H25vFQQhNAlrLC62+bHghOhbR6IY
         vtliOGwzPU50g==
Message-ID: <46273ca40983f3cdabe6bfe552cabf22a788b02b.camel@kernel.org>
Subject: Re: [PATCH net-next] net: psample: Introduce stubs to remove NIC
 driver dependency
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>, Chris Mi <cmi@nvidia.com>
Cc:     netdev@vger.kernel.org, jiri@nvidia.com
Date:   Tue, 26 Jan 2021 20:50:28 -0800
In-Reply-To: <20210126184955.5f61784a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210126145929.7404-1-cmi@nvidia.com>
         <20210126184955.5f61784a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-01-26 at 18:49 -0800, Jakub Kicinski wrote:
> On Tue, 26 Jan 2021 22:59:29 +0800 Chris Mi wrote:
> > In order to send sampled packets to userspace, NIC driver calls
> > psample api directly. But it creates a hard dependency on module
> > psample. Introduce psample_ops to remove the hard dependency.
> > It is initialized when psample module is loaded and set to NULL
> > when the module is unloaded.
> > 
> > Signed-off-by: Chris Mi <cmi@nvidia.com>
> > Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> 
> This adds a bunch of sparse warnings.
> 
> MelVidia has some patch checking infra, right? Any reason this was
> not
> run through it?

we do but we don't test warnings on non mlnx files, as we rely on the
fact that our mlnx files are clean, We simply don't check for
"added/diff" warnings, we check that mlnx files are kept clean, easier
:) ..

Anyway I am working internally to clone/copy nipa into our CI.. hope it
will work smoothly .. 


Thanks,
Saeed.

