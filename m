Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145A146CCA0
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 05:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244257AbhLHEln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 23:41:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244255AbhLHEln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 23:41:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F67C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 20:38:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 04487CE1F98
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 04:38:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE2CCC00446;
        Wed,  8 Dec 2021 04:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638938288;
        bh=Qds3XxTlhzSOuGvCRODUZJWIAez9ysr8b+sya6f0P9o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KswvwFNKWqpcGN+C8cDhw/tZL4gh9uTjIG1QB0ynV4NdEHnC2e4BtBwMABTEHinxn
         xiYvMEqOoQtYYUl+oMVW8bQk63Z1Vez1Fru9dRnAE7PHm4+PjrD08tXAcM5deZUz2C
         VYnlHL3W20ELhWi2I0pev5ED/MHoc56t1l8MC4RFogx9PnHIm+6z3RhH168coj2vZ0
         vfcO6W5s0tSeo6gAE78l4xdJL+GLRtov82P6eCJjHZk0QUeg2+tBexZy46XOHrAjM6
         +UouSfCos+97x7LIh8gHIMgA6a9T3HwvAjsgUudXokbsmZa4vmsSuEYxFl9Ytp7hL8
         usWOcziuwLAuw==
Date:   Tue, 7 Dec 2021 20:38:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net] MAINTAINERS: net: mlxsw: Remove Jiri as a
 maintainer, add myself
Message-ID: <20211207203806.3b2b9ccb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <45b54312cdebaf65c5d110b15a5dd2df795bf2be.1638807297.git.petrm@nvidia.com>
References: <45b54312cdebaf65c5d110b15a5dd2df795bf2be.1638807297.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Dec 2021 17:17:23 +0100 Petr Machata wrote:
> Jiri has moved on and will not carry out the mlxsw maintainership duty any
> longer. Add myself as a co-maintainer instead.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Acked-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Hat tip to Jiri. Applied, thanks!
