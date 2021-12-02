Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F38465BD8
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 02:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349113AbhLBB5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 20:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349071AbhLBB4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 20:56:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5C3C06174A;
        Wed,  1 Dec 2021 17:52:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F5E1B82192;
        Thu,  2 Dec 2021 01:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FFACC00446;
        Thu,  2 Dec 2021 01:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638409972;
        bh=zkFqtzaNKTDw1PbeM765LcudRYRZfAI6zkKmYxOdvlg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YAkHrtqxPljJm0x3XburFBVmi4EPYjJknYDnwDejaAIO+Lh8L210a+28fzHZh9Aur
         W9VuPcAYnrqeV+SVD6/FZ1Wx6ewD1zYaf3SMIQk+66CE6i2FFd4yEw/3IOo06puMab
         G+HINeBWhVNl9pwHWVzcDQ1/3wMiKiLSSEzcMUyUd2/mLqaFvi/tZ0yKbO4ANd8lfS
         0XoKWeFRfE3QvGsT3HxemFMCXkczHK4uFX/BtyZkY8dk1EvbYqEKT4kSgb2XMnFJWA
         Acf7CWpmMIP5Q0IkoI3DjSFRWBDLfxDxfMoOS4nosw2IsCjzYiel7KQAzIctQaPGYv
         2iaLp/XtvMfEQ==
Date:   Wed, 1 Dec 2021 17:52:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Li Zhijian <lizhijian@cn.fujitsu.com>
Cc:     <davem@davemloft.net>, <shuah@kernel.org>, <dsahern@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] selftest: net: remove meaningless help option
Message-ID: <20211201175251.00373dfe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211201111025.13834-3-lizhijian@cn.fujitsu.com>
References: <20211201111025.13834-1-lizhijian@cn.fujitsu.com>
        <20211201111025.13834-3-lizhijian@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Dec 2021 19:10:25 +0800 Li Zhijian wrote:
> $ ./fcnal-test.sh -t help
> Test names: help
> 
> Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>

Not sure why the "help" test was added in the first place but could you
provide motivation for the patch in the commit message?
