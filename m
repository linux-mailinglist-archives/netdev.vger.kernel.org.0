Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8EA92A3730
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 00:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbgKBXeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 18:34:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:34278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725831AbgKBXeB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 18:34:01 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0962222BA;
        Mon,  2 Nov 2020 23:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604360041;
        bh=K6bvvJGdS8YF6CuShWuFdR+WmqdGi7JDZ90UC/VK2Sg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xsO3vgF+9+lzxhFYqVWKlnoYFOFw21IQ6MDVONnbANdceVBca7gUvHpxImNwIhvdX
         gJz6k5ADkvvoRvbkVDLhywqsSvvL02kVow4Kl1CEQshLWO/4nxwGXPwTLXyGKGFPX7
         bxP4EMOdB5MeieceOhjgXsDGIesacr4IisxsFBd4=
Date:   Mon, 2 Nov 2020 15:33:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, Geliang Tang <geliangtang@gmail.com>,
        mptcp@lists.01.org, davem@davemloft.net,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 5/6] mptcp: add a new sysctl add_addr_timeout
Message-ID: <20201102153359.29c546f1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201030224506.108377-6-mathew.j.martineau@linux.intel.com>
References: <20201030224506.108377-1-mathew.j.martineau@linux.intel.com>
        <20201030224506.108377-6-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Oct 2020 15:45:05 -0700 Mat Martineau wrote:
> From: Geliang Tang <geliangtang@gmail.com>
> 
> This patch added a new sysctl, named add_addr_timeout, to control the
> timeout value (in seconds) of the ADD_ADDR retransmission.

Please document the new sysctl.
