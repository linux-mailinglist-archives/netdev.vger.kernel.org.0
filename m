Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9719C17EC61
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 00:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbgCIXAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 19:00:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726536AbgCIXAo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 19:00:44 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C706324649;
        Mon,  9 Mar 2020 23:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583794844;
        bh=EW9qBZ3ri0ExP7ziBkY/oqYXqOSg2Y1o33FVT2CEKag=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sIZQqO09PQjNksJ6EJH6UHTllRjJNeGsidsQ307PO5QCe++VrqMwaR0/OQU2uhFwt
         1t8NooEKiiTgb489po9Cz9XIvX1ZOem/23cAQF1aF6dJJJTR4TAf47x70fNztzBWmY
         giRK/hidyPDn5TpaSuYJX20ftuy6mzRoVhLhQrsQ=
Date:   Mon, 9 Mar 2020 16:00:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     borisp@mellanox.com, netdev@vger.kernel.org, davem@davemloft.net,
        herbert@gondor.apana.org.au, secdev@chelsio.com, varun@chelsio.com
Subject: Re: [PATCH net-next v4 6/6] cxgb4/chcr: Add ipv6 support and
 statistics
Message-ID: <20200309160041.579e1753@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200307143608.13109-7-rohitm@chelsio.com>
References: <20200307143608.13109-1-rohitm@chelsio.com>
        <20200307143608.13109-7-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  7 Mar 2020 20:06:08 +0530 Rohit Maheshwari wrote:
> - added few necessary stat counters.

That wasn't the point :/ You were supposed to used ethtool -S like
everyone else rather than your debugfs files :/
