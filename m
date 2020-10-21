Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3695F29463F
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 03:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411045AbgJUBUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 21:20:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411041AbgJUBUW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 21:20:22 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 233F522253;
        Wed, 21 Oct 2020 01:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603243222;
        bh=J7RoMMyRpp2siLAhRjA046+/isVgKeIMYaMweXeJVtY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W07d3x0NKOr9+PlnKs7Qgv9FfcvoHoEFZoFeBaRB8VQhEJqavnh4+5ZVC2vfEG0ma
         Bc9MBoCGUFEtG0YEDb8gpRZzcGffBI/88BiMfisWjatwHT41sK+0d47KIuLF6IJ3Ru
         HSoMkFouGD3xfV82FJMxOPbuSCU9WL/4ts2Ioj9E=
Date:   Tue, 20 Oct 2020 18:20:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
Subject: Re: [PATCH net 0/6] chelsio/chtls: Fix inline tls bugs
Message-ID: <20201020182020.00b7b797@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201019115025.24233-1-vinay.yadav@chelsio.com>
References: <20201019115025.24233-1-vinay.yadav@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Oct 2020 17:20:19 +0530 Vinay Kumar Yadav wrote:
> This series of patches fix following bugs in chelsio inline tls driver.
> 
> Patch1: Fix incorrect socket lock.
> Patch2: correct netdevice for vlan interface.
> Patch3: Fix panic when server is listening on ipv6.
> Patch4: Fix panic when listen on multiadapter.
> Patch5: correct function return and return type.
> Patch6: Fix writing freed memory.

Applied, thanks.
