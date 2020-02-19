Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF98716429F
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 11:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgBSKxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 05:53:15 -0500
Received: from ms.lwn.net ([45.79.88.28]:33804 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726484AbgBSKxP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 05:53:15 -0500
Received: from localhost.localdomain (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 54B754A8;
        Wed, 19 Feb 2020 10:53:13 +0000 (UTC)
Date:   Wed, 19 Feb 2020 03:53:07 -0700
From:   Jonathan Corbet <corbet@lwn.net>
To:     Niklas =?UTF-8?B?U8O2ZGVybHVuZA==?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     "Daniel W . S . Almeida" <dwlsalmeida@gmail.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] Documentation: nfsroot.rst: Fix references to
 nfsroot.rst
Message-ID: <20200219035307.44298238@lwn.net>
In-Reply-To: <20200212181332.520545-1-niklas.soderlund+renesas@ragnatech.se>
References: <20200212181332.520545-1-niklas.soderlund+renesas@ragnatech.se>
Organization: LWN.net
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Feb 2020 19:13:32 +0100
Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se> wrote:

> When converting and moving nfsroot.txt to nfsroot.rst the references to
> the old text file was not updated to match the change, fix this.
> 
> Fixes: f9a9349846f92b2d ("Documentation: nfsroot.txt: convert to ReST")
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  Documentation/admin-guide/kernel-parameters.txt | 8 ++++----
>  Documentation/filesystems/cifs/cifsroot.txt     | 2 +-
>  fs/nfs/Kconfig                                  | 2 +-
>  net/ipv4/Kconfig                                | 6 +++---
>  net/ipv4/ipconfig.c                             | 2 +-
>  5 files changed, 10 insertions(+), 10 deletions(-)

OK, so this is a mix of documentation, net, and filesystem tweaks.  I'll
happily pick it up, unless somebody else would rather carry it...?

Thanks,

jon
