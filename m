Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A6E2A3A19
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 02:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbgKCByL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 20:54:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:49848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727385AbgKCByL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 20:54:11 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00D0E21D40;
        Tue,  3 Nov 2020 01:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604368450;
        bh=sCs/bAcK0TRKg7ilnU8WcwHgFhr13mjB2AkrChzLGLk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L1WpmLDwfaWW2S0PkQbeulbUICHKG0/biSA1lFP3aD98FOpridWmCTEK9hN4TEQ8h
         ycqq3ZhpzG6P3gABFA+YKf4/2L/XuLiLL097xyvpdgvGs7RWiV7HgVEe9WEVFDO5v7
         2Adl/q1h/g+anK/beqByQV6h6xvVKlh7pGBGIzbk=
Date:   Mon, 2 Nov 2020 17:54:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     trix@redhat.com
Cc:     davem@davemloft.net, ast@kernel.org, andriin@fb.com,
        edumazet@google.com, ap420073@gmail.com, xiyou.wangcong@gmail.com,
        jiri@mellanox.com, maximmi@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: core: remove unneeded semicolon
Message-ID: <20201102175409.69c024e5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201101153647.2292322-1-trix@redhat.com>
References: <20201101153647.2292322-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  1 Nov 2020 07:36:47 -0800 trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> A semicolon is not needed after a switch statement.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Applied...
