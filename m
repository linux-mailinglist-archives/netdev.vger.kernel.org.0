Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10026234C00
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 22:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgGaUMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 16:12:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbgGaUMO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 16:12:14 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02350208E4;
        Fri, 31 Jul 2020 20:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596226334;
        bh=EhrrdpqzRlMqderwCUpQuhd4442YcoK1M2tYDp0DwME=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dpffQQNN21UiGm7BEMDF2pyFH//ffzU+6Btr9NmTXB7As7Wbw26U8Xz2Amtgliamf
         P2wDJLPq2m2dDvbWcNavZ10r7cdwh/HNzVtCHaXYUHDN0S7wXqlr14UDLwr17Ut+Ew
         4HbgWHSF3Ffa2RTsO7kt6d90+t1Oqium/O04kSYg=
Date:   Fri, 31 Jul 2020 13:12:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florinel Iordache <florinel.iordache@nxp.com>
Cc:     madalin.bucur@nxp.com, davem@davemloft.net, netdev@vger.kernel.org,
        Markus.Elfring@web.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 5/5] fsl/fman: fix eth hash table allocation
Message-ID: <20200731131212.16a7d2dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1596192562-7629-6-git-send-email-florinel.iordache@nxp.com>
References: <1596192562-7629-1-git-send-email-florinel.iordache@nxp.com>
        <1596192562-7629-6-git-send-email-florinel.iordache@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Jul 2020 13:49:22 +0300 Florinel Iordache wrote:
> Fixes: 57ba4c9b56d8 ("fsl/fman: Add FMan MAC support")
> 
> Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>

Please repost without the empty lines between these tags.
