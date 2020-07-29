Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E54A92327A0
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 00:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbgG2W2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 18:28:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727114AbgG2W2X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 18:28:23 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D72320656;
        Wed, 29 Jul 2020 22:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596061702;
        bh=s6XN6FQuW11x9gEqpvZqSpW8QoAqs+XwsUC8i5vOzaM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RonR9rcWncx9rrbVBYtVkmperGYF4ThKntjcFDvcDmrOQrCy74mgqPJfroE8xKJ2Y
         LrNCqxPdTyKXaCLtJrMo/hTzunhS2zkQoRrLjxJmvhJs6dWhPSkAsoBGPlx7b2rB0n
         ud2e0YZQVIfwIBkMff9fZsleBMSZfWuBiP5xo6qs=
Date:   Wed, 29 Jul 2020 15:28:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        drt@linux.ibm.com
Subject: Re: [PATCH net] ibmvnic: Fix IRQ mapping disposal in error path
Message-ID: <20200729152820.79c00fe7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1596058592-12025-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1596058592-12025-1-git-send-email-tlfalcon@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jul 2020 16:36:32 -0500 Thomas Falcon wrote:
> RX queue IRQ mappings are disposed in both the TX IRQ and RX IRQ
> error paths. Fix this and dispose of TX IRQ mappings correctly in
> case of an error.
> 
> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>

Thomas, please remember about Fixes tags (for networking patches, 
at least):

Fixes: ea22d51a7831 ("ibmvnic: simplify and improve driver probe function")
