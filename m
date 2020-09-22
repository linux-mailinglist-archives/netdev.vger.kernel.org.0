Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9254274BF4
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 00:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgIVWRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 18:17:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:36734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726550AbgIVWRg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 18:17:36 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7019020684;
        Tue, 22 Sep 2020 22:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600813056;
        bh=4/jieAoPQSkO21CuFx1L8pagE0cMJDwGFEnT8iu5MrI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M1BDRnqTMU8ibv4p7dmvSsWLlc80mCDzV3qBqOkJn1teZEqbiIGhTvlxrLjEy31on
         Uaj4hQmobt+8dc5MkkZA5akUWstiNAp+WkSgxo+LpsfdqhtDi5/dy3KJQFFhUVSYUs
         NZwA8ZhTL653rhM1/eax/fdFEXroc2/2vy2qd3n0=
Date:   Tue, 22 Sep 2020 15:17:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT] Networking
Message-ID: <20200922151734.44461552@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAHk-=whKx3FCCXR+VQoCwcEmOFe45fmaJWXYL0UHiQPqYMOX-w@mail.gmail.com>
References: <20200921184443.72952cb4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAHk-=whKx3FCCXR+VQoCwcEmOFe45fmaJWXYL0UHiQPqYMOX-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Sep 2020 15:02:24 -0700 Linus Torvalds wrote:
> Pulled.

Thanks!

>  (a) please put "git pull" somewhere in the email (lots of people just
> put it in the subject by prepending it with "[GIT PULL]" but all I
> really look for is "git" and "pull" anywhere in the email. You had the
> "git" but there was no "pull" anywhere).
 
>  (b) please use an imperative sentence structure for the description
> instead of present tense.

> Also, I'd love to see signed tags. I don't _require_ them for
> git.kernel.org pulls, but I do prefer them.

Thanks a lot for the guidance. Will do better next time!
