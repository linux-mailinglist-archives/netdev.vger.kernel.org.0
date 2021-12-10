Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9279F46F950
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 03:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236116AbhLJCt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 21:49:59 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:51230 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbhLJCt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 21:49:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6BC8BCE25DC;
        Fri, 10 Dec 2021 02:46:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5690FC004DD;
        Fri, 10 Dec 2021 02:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639104381;
        bh=atO7jbYOHFpTryIkCpFbTf+3j8DZXUNfXnO5Dzs9RuM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X+cAA4AT9eSedVgKPvO2NglqcxMWmSQuYGLS0rifg8oHMdXrkMF4XJ6S4FLDGfIUO
         kMyf7FvQwPIyV2tE9tsUfc0K5+9DdfKXnKKHO7XLoU58ba2P/oH1pY2aiPKhRY1ACn
         jUq+3IDldOcfVTe/qFHWSYBR0dq7tORMrQay48NMJEKAWAyl3utUqXusRK4kreUIhF
         QGV4PlbYg7+WYaj715+ogmr0KjdA8xdvH/11NTikq4wLX5CaIbjoOzu7cLbnJMzDdk
         UDx0PiJAFvj9UUHVXE2eYKDO78Suc1roWOuFey4TMHVDMFjYSRzK6O5TnJ7W0PJDGB
         Oi/D0vQ/e9VTA==
Date:   Thu, 9 Dec 2021 18:46:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        skhan@linuxfoundation.org
Subject: Re: [PATCH] selftests: icmp_redirect: pass xfail=0 to log_test()
 for non-xfail cases
Message-ID: <20211209184620.78d02085@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211208071151.63971-1-po-hsu.lin@canonical.com>
References: <20211208071151.63971-1-po-hsu.lin@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  8 Dec 2021 15:11:51 +0800 Po-Hsu Lin wrote:
> If any sub-test in this icmp_redirect.sh is failing but not expected
> to fail. The script will complain:
>     ./icmp_redirect.sh: line 72: [: 1: unary operator expected
> 
> This is because when the sub-test is not expected to fail, we won't
> pass any value for the xfail local variable in log_test() and thus
> it's empty. Fix this by passing 0 as the 4th variable to log_test()
> for non-xfail cases.
> 
> Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>

Thanks, could you please add a fixes tag (even if the breakage is only
present in linux-next) and CC David Ahern on v2?
