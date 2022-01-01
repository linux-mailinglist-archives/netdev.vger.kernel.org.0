Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F12482664
	for <lists+netdev@lfdr.de>; Sat,  1 Jan 2022 04:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbiAADEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 22:04:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231995AbiAADD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 22:03:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6ABC061574
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 19:03:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3102C61795
        for <netdev@vger.kernel.org>; Sat,  1 Jan 2022 03:03:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C780C36AEB;
        Sat,  1 Jan 2022 03:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641006237;
        bh=Ek0iXjnmE4l19PqYbj7ZqiqC2aLBCne4M6JkqvpzNDo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=um8XY2CFjLc3LgVNa9WlsorZDJgNW9gsLYGybqft4V3f2HXgKXx6oNQzbHg937mF/
         m0uIC9s1hdsEf1Krn4hXSMEVMEi2IKVtfDZ3tiW5Fj9DU7UPvKZqwy3Fei8ZrvOeac
         Xn31l18doJSXAZPDF9OtS7EJ6y8rKifr2x/GIWtuvmEb5eghw571XiSM3LVWbKaFQ1
         PWoYnW+tJ4VUx3OQUE3hT44SvMqGKLDAe2JxSE0VFBPkHVd8gCWfJkcZBA8DHBmZZL
         RkmiAhsQV2bUOqjA/si+fwmeniIBoSndYmd9DmibULxbswOOWHsGBuZbtvrjjt83bT
         62grdicHUZy1g==
Date:   Fri, 31 Dec 2021 19:03:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jianguo Wu <wujianguo106@163.com>
Cc:     netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] selftests: net: udpgro_fwd.sh: explicitly checking the
 available ping feature
Message-ID: <20211231190356.0049d5ff@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <825ee22b-4245-dbf7-d2f7-a230770d6e21@163.com>
References: <825ee22b-4245-dbf7-d2f7-a230770d6e21@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Dec 2021 10:01:08 +0800 Jianguo Wu wrote:
> From: Jianguo Wu <wujianguo@chinatelecom.cn>
> 
> As Paolo pointed out, the result of ping IPv6 address depends on
> the running distro. So explicitly checking the available ping feature,
> as e.g. do the bareudp.sh self-tests.
> 
> Fixes: 8b3170e07539 ("selftests: net: using ping6 for IPv6 in udpgro_fwd.sh")
> Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>

Applied, thanks!
