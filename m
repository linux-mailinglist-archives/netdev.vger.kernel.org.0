Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF06299AD6
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 00:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407418AbgJZXj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 19:39:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407409AbgJZXj6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 19:39:58 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20DA1206FB;
        Mon, 26 Oct 2020 23:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603755598;
        bh=sINtQwi0kqYwEBK87v32W7MLInZiQrAncV5kjq1K48Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BsL113S3ffkzdqtTfEdjpHgipsktGb9wpvBLpdJk91GnqNT9clOeNFaL0bW+O+hm8
         s+TWqUqXKp8UfG9Jnf9rlOwUrFiwqEGtFTM9FyaAAZs73fDKfV3pHDs9WE7Jj73HSb
         RhUTk0E2UqweuHjxSfV9qFKCrg7GdbzSb6W+8SCo=
Date:   Mon, 26 Oct 2020 16:39:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, heiko.carstens@de.ibm.com,
        raspl@linux.ibm.com, ubraun@linux.ibm.com
Subject: Re: [PATCH net 0/3] net/smc: fixes 2020-10-23
Message-ID: <20201026163949.35f94fde@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201023184830.59548-1-kgraul@linux.ibm.com>
References: <20201023184830.59548-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Oct 2020 20:48:27 +0200 Karsten Graul wrote:
> Please apply the following patch series for smc to netdev's net tree.
> 
> Patch 1 fixes a potential null pointer dereference. Patch 2 takes care
> of a suppressed return code and patch 3 corrects the system EID in the
> ISM driver.

Applied, thanks!
