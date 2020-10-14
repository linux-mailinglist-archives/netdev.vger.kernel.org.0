Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE9EE28D77D
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 02:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389491AbgJNAcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 20:32:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727122AbgJNAcA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 20:32:00 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A422207DE;
        Wed, 14 Oct 2020 00:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602635520;
        bh=GdPJgtc1OQaD8BROpAqQfJm+qTWfFatNJRisr9ptQeY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QhfeIx3F9u/TVHZkRZ+7+0j0iU19MoGuyzWI75fjqB5pBx0Rju/RqV62P2IwE4cK/
         5cx4VZBFwqsvoFyZF3fuemg0FZ0EW36JCj+xQtVCLXYYOAGKjROFNrxLxZqYntSCpn
         GJVgE2Si9QNJ1Og/qqvXE3trwyo2LXaCr2R6OfMQ=
Date:   Tue, 13 Oct 2020 17:31:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ayush Sawal <ayush.sawal@chelsio.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, secdev@chelsio.com
Subject: Re: [PATCH net-next V2] cxgb4/ch_ipsec: Replace the module name to
 ch_ipsec from chcr
Message-ID: <20201013173158.4db35480@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201012065231.21269-1-ayush.sawal@chelsio.com>
References: <20201012065231.21269-1-ayush.sawal@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 12:22:31 +0530 Ayush Sawal wrote:
> This patch changes the module name to "ch_ipsec" and prepends
> "ch_ipsec" string instead of "chcr" in all debug messages and function names.
> 
> V1->V2:
> -Removed inline keyword from functions.
> -Removed CH_IPSEC prefix from pr_debug.
> -Used proper indentation for the continuation line of the function
> arguments.
> 
> Fixes: 1b77be463929 ("crypto/chcr: Moving chelsio's inline ipsec functionality to /drivers/net")
> Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>

Checkpatch complains about bad indentation:

CHECK: Alignment should match open parenthesis
#282: FILE: drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c:408:
+static void *copy_esn_pktxt(struct sk_buff *skb,
+		     struct net_device *dev,

CHECK: Alignment should match open parenthesis
#297: FILE: drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c:462:
+static void *copy_cpltx_pktxt(struct sk_buff *skb,
+		       struct net_device *dev,

CHECK: Alignment should match open parenthesis
#312: FILE: drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c:506:
+static void *copy_key_cpltx_pktxt(struct sk_buff *skb,
+			   struct net_device *dev,

CHECK: Alignment should match open parenthesis
#328: FILE: drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c:554:
+static void *ch_ipsec_crypto_wreq(struct sk_buff *skb,
+			   struct net_device *dev,
