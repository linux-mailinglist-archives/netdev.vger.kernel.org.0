Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 295122A3A1B
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 02:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbgKCByU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 20:54:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:49948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727298AbgKCByU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 20:54:20 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E7472225E;
        Tue,  3 Nov 2020 01:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604368459;
        bh=wDVJWiA0tz8SnS2Ijktq9RqVyn2dbj1LsC85j4YvRU4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1qAFg3OWd+ScYfzuxNyTJkXRyBgNiN2YvLE/2NnHxfq4KnRjhLpasfP8WNSlI/SAm
         u5QTTBpnpXl9ws/fu4WEF6VFAad4alp85hLExO3NjdxXRuXFHRJctIuR0VQc7vxO9B
         VCbJL3rchWNN3PYjKivu1nh4QKp+Hjgr/k/kGmPo=
Date:   Mon, 2 Nov 2020 17:54:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     trix@redhat.com
Cc:     davem@davemloft.net, mkubecek@suse.cz, f.fainelli@gmail.com,
        andrew@lunn.ch, magnus.karlsson@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ethtool: remove unneeded semicolon
Message-ID: <20201102175418.7b578313@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201101155601.2294374-1-trix@redhat.com>
References: <20201101155601.2294374-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  1 Nov 2020 07:56:01 -0800 trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> A semicolon is not needed after a switch statement.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Applied....
