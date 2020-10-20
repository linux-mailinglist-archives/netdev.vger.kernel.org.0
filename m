Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF05029417F
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 19:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395550AbgJTReq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 13:34:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395541AbgJTRep (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 13:34:45 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D5BD2222D;
        Tue, 20 Oct 2020 17:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603215285;
        bh=AD5oVSPzJ1zd5FClS+hyWvNYZp4xz20dNie3ffoZsRw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jSdfk20aErjXh9JkUEjItNT65BmMBv237o0NL8aGwAGZIo6cbsx0lHjnnvdydO0xD
         j6QS8Cr0nYkzoHTxkeD9/EiXLzJb4xW3KSpkEvlIZcEnpdEe+6akRUXKfKhlNKX1Gm
         29AXIHZTjDK7rhT+kMBAfBkCw2JoBFhCXxBT02DM=
Date:   Tue, 20 Oct 2020 10:34:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     trix@redhat.com
Cc:     irusskikh@marvell.com, davem@davemloft.net, benve@cisco.com,
        _govind@gmx.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, bigeasy@linutronix.de,
        tglx@linutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH] net: remove unneeded break
Message-ID: <20201020103441.06dc6247@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201019172607.31622-1-trix@redhat.com>
References: <20201019172607.31622-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Oct 2020 10:26:07 -0700 trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> A break is not needed if it is preceded by a return or goto
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Applied, thanks!
