Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 442EA4444E6
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 16:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbhKCPuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 11:50:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229928AbhKCPuY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 11:50:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82E7360E73;
        Wed,  3 Nov 2021 15:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635954467;
        bh=ShZNa7IW9gaF+i032Z807KygJzIVvjgwfigBHlZygoM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZimQOUk4jdQdwDMhecAVgUsdtQ3K9TwgQybjHJlfCrXzeqQmtgJR/tsZKd4nZKmN5
         8W0eWWO3l4hlIcmACaHjGlc2O50HhOFvBsxE4o/YgqDE1Bn3CIf/p3rPW6fWoi1pWy
         f5Su3+xYGuN7pAdj5apkZapCReGbEVB7Zf8SRBKiX5dZ/sXoTUnOcfpncpCN6kOge+
         nuqcArUV/yBjjC7uZmlCAlqWRDkDq3ULk6NLiaUG1v/9azpygcv/2z2RCpAq+7Yde3
         SNnrWQlehQGRA2bTRyT8CzOsqlB0A+yub8si1KATIcQitEmIFpwYKJ63aIDWTBW+pO
         FoWqSgynBzEuQ==
Date:   Wed, 3 Nov 2021 08:47:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Ziyang Xuan <william.xuanziyang@huawei.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: vlan: fix a UAF in vlan_dev_real_dev()
Message-ID: <20211103084746.2ae1c324@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20211103135034.GP2744544@nvidia.com>
References: <20211102021218.955277-1-william.xuanziyang@huawei.com>
        <20211103135034.GP2744544@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Nov 2021 10:50:34 -0300 Jason Gunthorpe wrote:
> (though I can't tell either if there is a possiblecircular dep problem
> in some oddball case)

Same, luckily we're just starting a new dev cycle and syzbot can have
at it. 

We should probably not let this patch get into stable right away -
assuming you agree - would you mind nacking the selection if it happens?
I'm not sure I'll get CCed since it doesn't have my tags.
