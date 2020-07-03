Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96ADD2141F9
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 01:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgGCXjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 19:39:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726258AbgGCXjf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 19:39:35 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BE4C20826;
        Fri,  3 Jul 2020 23:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593819575;
        bh=HBSf+pSiuMgcxLXXufTzWQj01EYrngNWHsDuA7z0vUY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HCM7iINQ11oIXBXaGXJBkfkmBwLnTp9CLgdFtiNMRawzoil0DcDGCaOShk8a3KucG
         fxdyg50ESmDAlmArOrbhvWnHGVcIoLXa17ll4Elhs1u6jEN8qYLI+ZFWkfSqurQGFm
         5KmKUStPze9ghDhxVVw1UvN1KbSBtCRa5bSGV/5M=
Date:   Fri, 3 Jul 2020 16:39:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 5/8] bnxt_en: Return correct RSS indirection
 table entries to ethtool -x.
Message-ID: <20200703163934.6a7a2553@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1593760787-31695-6-git-send-email-michael.chan@broadcom.com>
References: <1593760787-31695-1-git-send-email-michael.chan@broadcom.com>
        <1593760787-31695-6-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  3 Jul 2020 03:19:44 -0400 Michael Chan wrote:
> +	if (bp->flags & BNXT_FLAG_CHIP_P5) {
> +		return (bp->rx_nr_rings + BNXT_RSS_TABLE_ENTRIES_P5 - 1) &
> +		       ~(BNXT_RSS_TABLE_ENTRIES_P5 - 1);
> +	}

ALIGN() here as well?
