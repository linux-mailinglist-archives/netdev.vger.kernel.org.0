Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCE7719374A
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 05:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgCZE3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 00:29:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbgCZE3j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 00:29:39 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3988720772;
        Thu, 26 Mar 2020 04:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585196979;
        bh=eS8y3+IcKmcxDLjrYiPOzMvU37V0Fcfv9OiyrA7MGoU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pe+Va0Rvc88c9aTpvixJTAD2XP76HtsbLC003Qv2w1Wr8DDACnBxJqDf6E76jyz3k
         So8+76sLqP6+7Z5BVCart4KM0og8Lsjt/j5lp19P6UKJqK4c7q15qTZy3Q85+NgMkR
         BAkQlqokp24PO+d4cu1+llCDb3zIOh4LoUmdYTMc=
Date:   Wed, 25 Mar 2020 21:29:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jian Yang <jianyang.kernel@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        Jian Yang <jianyang@google.com>
Subject: Re: [PATCH net-next] selftests: move timestamping selftests to net
 folder
Message-ID: <20200325212937.4c260c04@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200325203207.221383-1-jianyang.kernel@gmail.com>
References: <20200325203207.221383-1-jianyang.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Mar 2020 13:32:07 -0700 Jian Yang wrote:
> From: Jian Yang <jianyang@google.com>
> 
> For historical reasons, there are several timestamping selftest targets
> in selftests/networking/timestamping. Move them to the standard
> directory for networking tests: selftests/net.
> 
> Signed-off-by: Jian Yang <jianyang@google.com>
> Acked-by: Willem de Bruijn <willemb@google.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>

Thank you!
