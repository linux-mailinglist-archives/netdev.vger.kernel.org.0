Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB4652DEC79
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 01:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbgLSAr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 19:47:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:35854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725824AbgLSAr3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 19:47:29 -0500
Date:   Fri, 18 Dec 2020 16:46:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608338808;
        bh=vs4tk1KIt1GYdziuhBNEWGz9QEKqWd2k8muDqbQf7mA=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=CeFSq3hVMLPNEdXRvY1yEC34WkUFcutVYCUKggnlL8MJ9ZUlwkxBYc/bVphYkMuq/
         TtIZC7JvM30ZSVXARe0UBr/IfmTqmPIrb/wBSpyPZNThy+IYU1IPi02aLasoDTiRt+
         mZcqRT/CEJn4GF0V12kbbbrH+ahGbPyNeajR0alHgbVlkwn31RDkA35Cy90efn57mF
         XpGc7CdTrSGVJxip7xhVTCFFEUL0HIJ4f6eno2KwybMjeExOpOrcnHeE4tbGWpwhqc
         B2WY+DK9aIJJ8AS0+iHGhCA/lta4GqfiLgn5V3u+HJdUBDoxYMZakUFWsqlP+9h1Bo
         P7aOK7DUmCB9A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     lyl <liyonglong@chinatelecom.cn>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, fw@strlen.de,
        qitiepeng@chinatelecom.cn
Subject: Re: [PATCH] tcp: remove obsolete paramter sysctl_tcp_low_latency
Message-ID: <20201218164647.1bcc6cb9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1608271876-120934-1-git-send-email-liyonglong@chinatelecom.cn>
References: <1608271876-120934-1-git-send-email-liyonglong@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Dec 2020 14:11:16 +0800 lyl wrote:
> Remove tcp_low_latency, since it is not functional After commit
> e7942d0633c4 (tcp: remove prequeue support)
> 
> Signed-off-by: lyl <liyonglong@chinatelecom.cn>

I don't think we can remove sysctls, even if they no longer control 
the behavior of the kernel. The existence of the file itself is uAPI.
