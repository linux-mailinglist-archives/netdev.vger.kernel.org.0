Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E75311F98
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 20:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbhBFTS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 14:18:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:53446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229848AbhBFTSy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 14:18:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4805664E0F;
        Sat,  6 Feb 2021 19:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612639093;
        bh=UndI31krt4k9kySSqtYJmedqrHwdeJImBlI8ieJDuRQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LreAs6MRMrtrG0gjwKmd05/oYsABJ4/OPqCM9UkXNcmr/wOz47AqIgY+U+P7E27RT
         VGAN7ovXMBRhELKXVpC9NsxasD54q4VGa4sFryWkdxggQzazKeG+8M9iojLl2nWc8q
         ECHRJrSwZsrbFmyRnYMeLcrdYPPf+FLhBmhidlQbv7HGGWNVVeMyc4HO9npTfG9oyt
         G45wpVy2HHSYMTwOZ2EWG4O60hSc7qqn5XT33e2s1EHMEFWBPCgWQublLO9m0IkK0E
         13Jvvjx1MKXSmFsmpzHjciWCQqFavp+H+UF69ceWaiG2kDypVMHoa98XqcXzW6B6+7
         h4d5IY2v7Xyeg==
Date:   Sat, 6 Feb 2021 11:18:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>, <davem@davemloft.net>,
        <linux-decnet-user@lists.sourceforge.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: Return the correct errno code
Message-ID: <20210206111812.284f2bc0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210204111426.00001bba@intel.com>
References: <20210204085630.19452-1-zhengyongjun3@huawei.com>
        <20210204111426.00001bba@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Feb 2021 11:14:26 -0800 Jesse Brandeburg wrote:
> Zheng Yongjun wrote:
> 
> > When kzalloc failed, should return ENOMEM rather than ENOBUFS.  
> 
> All these patches have the same subject and description, couldn't they
> just be part of a single series with a good cover letter?

Agreed. The patches seem to be lacking clear justification.
Cover letter would be good.

> I'm not saying make them a single patch, because that is bad for
> bisection, but having them as a single series means we review related
> changes at one time, and can comment on them as a group.
