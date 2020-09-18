Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C964270447
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 20:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgIRSnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 14:43:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:53566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbgIRSnv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 14:43:51 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12C4321534;
        Fri, 18 Sep 2020 18:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600454630;
        bh=LglCVJhlKwie2ngrvhTX498Yb2sEwnMxnZXYyAZRMsw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=L6ydRE7gU4R7x4qxgnexg5zVzKp5vAUgtqEFa/wCxMy2K8DkPxbTjtFNQ5MvhShcj
         bvAbCpDOotdC+kA2zPeMdnHdOIf/6cRu6SHgkpBTmxiCEU/ED5YopkiXw1OzwMYuXE
         jgiWjmmRgc6rjuSiqs32FaCi4od4k2oE4dXCht7I=
Message-ID: <966695c14eb696cc5551663f2901144ddb8f98d7.camel@kernel.org>
Subject: Re: [PATCH v3,net-next,3/4] drivers: crypto: add support for
 OCTEONTX2 CPT engine
From:   Saeed Mahameed <saeed@kernel.org>
To:     Srujana Challa <schalla@marvell.com>, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        kuba@kernel.org, sgoutham@marvell.com, gakula@marvell.com,
        sbhatta@marvell.com, schandran@marvell.com, pathreya@marvell.com,
        Lukas Bartosik <lbartosik@marvell.com>
Date:   Fri, 18 Sep 2020 11:43:48 -0700
In-Reply-To: <20200917132835.28325-4-schalla@marvell.com>
References: <20200917132835.28325-1-schalla@marvell.com>
         <20200917132835.28325-4-schalla@marvell.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-09-17 at 18:58 +0530, Srujana Challa wrote:
> Add support for the cryptographic acceleration unit (CPT) on
> 
> OcteonTX2 CN96XX SoC.
> 
> 
> 
> Signed-off-by: Suheil Chandran <schandran@marvell.com>
> 
> Signed-off-by: Lukas Bartosik <lbartosik@marvell.com>
> 
> Signed-off-by: Srujana Challa <schalla@marvell.com>
> 
> ---

[...]
>  15 files changed, 5088 insertions(+)

Huge patch, i suggest to break the whole series up to smaller patches, 
i suggest each component in a separate patch (e.g: infrastructure, new
mbox, debugfs, etc..)

What linux interfaces are going to enable your ipsec features? i
couldn't find any netdev, xfrm references in your series .. and the
cover letter + commit messages lack of such information.

FYI checkpatch is not happy at all with this patch:
total: 0 errors, 2 warnings, 85 checks, 5094 lines checked

85 mostly legit checks fire up.



