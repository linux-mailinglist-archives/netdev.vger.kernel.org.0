Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D201C2AE363
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 23:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731654AbgKJWcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 17:32:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:46388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726688AbgKJWcm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 17:32:42 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E533F2068D;
        Tue, 10 Nov 2020 22:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605047562;
        bh=Tod9iGeBtEEvGlenjbHjy/rNq6loIvAyAexQfnqoXss=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ppcz2DiSbleiLXY5jWO1PvqdqATLRKrWEApteE+yIOh2q4KD5o+Xu6ip5wxe9b9RD
         ivaAaLt1PPiRx/p5MuqycIuvHpd5H3Sn/nbuZ2SgyQ+Ch+5VEIrkZjM1jYy+ynYBKh
         dmc+aGEBs0jTDsl4lgjBoCoTVtSh2m2Qgqsg5VtE=
Date:   Tue, 10 Nov 2020 14:32:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vlad Buslov <vlad@buslov.dev>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net] selftest: fix flower terse dump tests
Message-ID: <20201110143241.3de40511@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201107111928.453534-1-vlad@buslov.dev>
References: <20201107111928.453534-1-vlad@buslov.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  7 Nov 2020 13:19:28 +0200 Vlad Buslov wrote:
> Iproute2 tc classifier terse dump has been accepted with modified syntax.
> Update the tests accordingly.
> 
> Signed-off-by: Vlad Buslov <vlad@buslov.dev>
> Fixes: e7534fd42a99 ("selftests: implement flower classifier terse dump tests")

Applied, thanks!
