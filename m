Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3463229205C
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 23:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgJRVxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 17:53:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726721AbgJRVxa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 17:53:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86AE422275;
        Sun, 18 Oct 2020 21:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603058009;
        bh=VhQR7p3O5VZ+1Uj7ZyuMsxjzUlH9ZXryFlEMbYoB3Xo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=13KXY15fOrMaVD5sOInM1rNIGybt52gkXoS/R17JKjXsGKO9W09gfX1yZu/McpaSz
         ojMqPj8DKsrBkAhr8a2SIfhdtBtKmplfCn1CBhb6kDj2swzwXkjuPaBo+ujDdNidgt
         ByvXMQRrnjvh/QIzq+vpmajHy1MfNVZdVHclgh/I=
Date:   Sun, 18 Oct 2020 14:53:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: core: use list_del_init() instead of
 list_del() in netdev_run_todo()
Message-ID: <20201018145327.52595f4f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201015162606.9377-1-ap420073@gmail.com>
References: <20201015162606.9377-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Oct 2020 16:26:06 +0000 Taehee Yoo wrote:
> dev->unlink_list is reused unless dev is deleted.
> So, list_del() should not be used.
> Due to using list_del(), dev->unlink_list can't be reused so that
> dev->nested_level update logic doesn't work.
> In order to fix this bug, list_del_init() should be used instead
> of list_del().

Applied, thanks!
