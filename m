Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE572CF8BC
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 02:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgLEBnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 20:43:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:57368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgLEBnl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 20:43:41 -0500
Date:   Fri, 4 Dec 2020 17:42:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607132580;
        bh=gEtq+DZKM9vsy0gJfNbjob9ykjsiaf3M0uoQoWNx1jM=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q2xecgTwFNASPTZy9xlB5hDl+2Sb4tTnG1zvXgfWEvtKmVyFgZE+tkXB8PatdxXW1
         2vLAmp1xnibYDlDw7jyXJDJ/KjyAz1zL4XHzQ4aiueqtnXe+tuDQ0XOSWX9rjN35a/
         43ToGXJwCDbhe8CCNeuPPRGGDG2nvNTSMLwMAz+zG0oH/o9BtHfgrtiLouba5KqtXR
         XWsys0c4NQ5BA8S21GkVFR8yeH+rKPtRgcNnyzgvkvaxm+Bo3rhx7O25ERcUXL+qC7
         0638woPdSSmCNNVeFAli+ggGVD0Z0HreIDtxQz32/+VsIJpqGybX5/sm5B+lir1wX/
         d6CptYwiXMKHQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     trix@redhat.com
Cc:     rmody@marvell.com, skalluru@marvell.com, davem@davemloft.net,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: bna: remove trailing semicolon in macro
 definition
Message-ID: <20201204174259.3a2db7e2@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201202163622.3733506-1-trix@redhat.com>
References: <20201202163622.3733506-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Dec 2020 08:36:22 -0800 trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> The macro use will already have a semicolon.
> Clean up escaped newlines.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Applied, thanks!
