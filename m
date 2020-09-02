Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C52E25AF9A
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 17:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbgIBPmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 11:42:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728451AbgIBPly (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 11:41:54 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 187E820639;
        Wed,  2 Sep 2020 15:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599061314;
        bh=AWODfIl05aHfa4owhk5+GLYrpYRwHkI+jwpViLIh8nA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=teD5NHAfnPaPq63HVH/liOFevjYo2twqhgU81wQxTEoASOObyeIQT8pcnKeCgreI7
         nf2lycIkIR8D+A7huApfO2u+iHtEId8nnSPsRGz54qbAFIlFjdEyBUbVhJ3e5WJZ8I
         cNTMv8X4Ri9ykI4TDSNONa3ANFNkOsgcqPHx8p0w=
Date:   Wed, 2 Sep 2020 08:41:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        Louis Peens <louis.peens@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com
Subject: Re: [PATCH net] nfp: flower: fix ABI mismatch between driver and
 firmware
Message-ID: <20200902084152.1f1f7083@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200902150458.10024-1-simon.horman@netronome.com>
References: <20200902150458.10024-1-simon.horman@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Sep 2020 17:04:58 +0200 Simon Horman wrote:
> From: Louis Peens <louis.peens@netronome.com>
> 
> Fix an issue where the driver wrongly detected ipv6 neighbour updates
> from the NFP as corrupt. Add a reserved field on the kernel side so
> it is similar to the ipv4 version of the struct and has space for the
> extra bytes from the card.
> 
> Fixes: 9ea9bfa12240 ("nfp: flower: support ipv6 tunnel keep-alive messages from fw")
> 

no need for this empty line

> Signed-off-by: Louis Peens <louis.peens@netronome.com>
> Signed-off-by: Simon Horman <simon.horman@netronome.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
