Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6942B81FE
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 17:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbgKRQes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 11:34:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:59552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726825AbgKRQes (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 11:34:48 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5364C206B5;
        Wed, 18 Nov 2020 16:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605717287;
        bh=M/WuDEXLQwnkuOdh6TPuYJKRGrECJwAmdO+kaUOXLvA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xKULGW2COcQu/RgQLeXFSkQgShQHdJmcAnkZcVcLow/1lTImxpaAqHIYxeontWSCF
         UGCu8r/GnXfJMV5wxsQmGpNH7mcQ0sQMFe0mtEjsgeWQhiG8D6W/mnIhTatMjQHTWE
         4X5Dfw+IZPEuOEu6WvpcQSWAK4+DQnynAQNJSQDg=
Date:   Wed, 18 Nov 2020 08:34:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     rao.shoaib@oracle.com
Cc:     netdev@vger.kernel.org
Subject: Re: [RFC net-next af_unix v1 0/1] Allow delivery of SIGURG on
 AF_UNIX streams socket
Message-ID: <20201118083446.54c58110@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1605409085-20294-1-git-send-email-rao.shoaib@oracle.com>
References: <1605409085-20294-1-git-send-email-rao.shoaib@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Nov 2020 18:58:04 -0800 rao.shoaib@oracle.com wrote:
> From: Rao Shoaib <rao.shoaib@oracle.com>
> 
> The use of AF_UNIX sockets is on the rise. We have a case where thousands
> of processes connect locally to a database and issue queries that are
> serviced by a pool of threads. Communication is done over AF_UNIX
> sockets. Currently, there is no way for the submitter to signal the
> servicing thread about an urgent condition such as abandoning
> the query. This patch addresses that requirement by adding support for
> MSG_OOB flag for AF_UNIX sockets. On receipt of such a flag,
> the kernel sends a SIGURG to the peer.

You need to widen the CC list on this, I doubt anyone paid much
attention.
