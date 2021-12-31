Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87F7482147
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 02:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242489AbhLaBbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 20:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242480AbhLaBbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 20:31:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281D4C061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 17:31:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0454B81CAC
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 01:31:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E605C36AEA;
        Fri, 31 Dec 2021 01:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640914267;
        bh=BBfF2d+wIkYJAw4tllipfPQRS6wm2YnLkJ5sccdAHh0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i+UlHulFRZjSPRK3XBtYI0zc2AIpauQcviLfGOUxRt+7a2t21K2b7uyBVWfsthW1U
         twnH4W5gOTvXMkWmDPbcjqkEK9/L7d4RWV16cV8/Ov1u55LEfx6I7k6DcSyLTLxBln
         EXgbbaYV7qzfsTsQQ27OzJPlbLYgRirGT1jMgULYTJIavSTUylXGjBzGOD8AJDYnnm
         VniPiVwr8TNFnv94M/n9YkuVE5h3vYzpHWZXlVnMeC0s4//fUhYMYnqDWUnFrRRylA
         uzgGJmD+ESDUkdsaKAyzynuMR8RF1ZFPA70okRzk+hWIhyEAhs/6vg5j7WOGdIU5ys
         lGVBjjN0/TaIA==
Date:   Thu, 30 Dec 2021 17:31:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jianguo Wu <wujianguo106@163.com>
Cc:     netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2] selftests: net: udpgro_fwd.sh: Use ping6 on systems
 where ping doesn't handle IPv6
Message-ID: <20211230173106.1345deb5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <a2295ebf-0734-a480-e908-caf5c02cb6a9@163.com>
References: <a2295ebf-0734-a480-e908-caf5c02cb6a9@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Dec 2021 09:10:00 +0800 Jianguo Wu wrote:
> From: Jianguo Wu <wujianguo@chinatelecom.cn>
> 
> In CentOS7(iputils-20160308-10.el7.x86_64), udpgro_fwd.sh output
> following message:
>   ping: 2001:db8:1::100: Address family for hostname not supported
> 
> Use ping6 on systems where ping doesn't handle IPv6.
> 
> v1 -> v2:
>  - explicitly checking the available ping feature, as e.g. do the
>    bareudp.sh self-tests.(Paolo)
> 
> Fixes: a062260a9d5f ("selftests: net: add UDP GRO forwarding self-tests")
> Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>

I'm afraid v1 got silently applied, see 8b3170e07539 ("selftests: net:
using ping6 for IPv6 in udpgro_fwd.sh") upstream. Could you send an
incremental patch?
