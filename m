Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6FF465BD5
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 02:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348448AbhLBB4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 20:56:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349741AbhLBByC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 20:54:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E247C061757;
        Wed,  1 Dec 2021 17:50:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 385ABB80DAC;
        Thu,  2 Dec 2021 01:50:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB519C00446;
        Thu,  2 Dec 2021 01:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638409838;
        bh=QTnBVlSoKyzB4f36a959kaReUyDXjm7tKy4VxWwcZ1Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r34/oO3dVC1XxrnPUFf6HULsDlaxAbStU94EYPytWtAnQuWkoFjeAsfWb2TT2bURT
         PflD+GXKJa39hg4pivUBbov3LA95bueqXe2BZ/aG7fw5tbv/wjS8XymBocNeFBUg3b
         VyX1PykJDU/LhQphANUGUsihYoDLoZynEa+AnkoxBI/lMmYaYPoV1PWXh+5qGZ4U2w
         gdBF09TRmTOZLraj0+QnpxyA5wRPIjv6uQm67zRluzeD8BFcFXIdKcZrXX5jwbCl+k
         +IcN2LsHTxFxl+bvjEhCS4h0oRxQnzJkQfdQO0abN4NNyBDHIw8T7KKWM7ghaBvaN8
         u9ynX5zgw0rOg==
Date:   Wed, 1 Dec 2021 17:50:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Li Zhijian <lizhijian@cn.fujitsu.com>
Cc:     <davem@davemloft.net>, <shuah@kernel.org>, <dsahern@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] selftest: net: Correct case name
Message-ID: <20211201175036.5e71ee13@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211201111025.13834-1-lizhijian@cn.fujitsu.com>
References: <20211201111025.13834-1-lizhijian@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Dec 2021 19:10:23 +0800 Li Zhijian wrote:
> Fixes: 34d0302ab86 ("selftests: Add ipv6 address bind tests to fcnal-test")
> Fixes: 75b2b2b3db4 ("selftests: Add ipv4 address bind tests to fcnal-test")

Fixes tag: Fixes: 34d0302ab86 ("selftests: Add ipv6 address bind tests to fcnal-test")
Has these problem(s):
	- SHA1 should be at least 12 digits long
	  Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
	  or later) just making sure it is not set (or set to "auto").
Fixes tag: Fixes: 75b2b2b3db4 ("selftests: Add ipv4 address bind tests to fcnal-test")
Has these problem(s):
	- SHA1 should be at least 12 digits long
	  Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
	  or later) just making sure it is not set (or set to "auto").
