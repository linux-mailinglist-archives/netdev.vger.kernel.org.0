Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA281470683
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 17:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240723AbhLJRB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 12:01:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239983AbhLJRB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 12:01:27 -0500
Received: from eidolon.nox.tf (eidolon.nox.tf [IPv6:2a07:2ec0:2185::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAFB9C061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 08:57:51 -0800 (PST)
Received: from equinox by eidolon.nox.tf with local (Exim 4.94.2)
        (envelope-from <equinox@diac24.net>)
        id 1mvjDR-0078nr-Jp; Fri, 10 Dec 2021 17:57:49 +0100
Date:   Fri, 10 Dec 2021 17:57:49 +0100
From:   David Lamparter <equinox@diac24.net>
To:     Alexandra Winter <wintera@linux.ibm.com>
Cc:     David Lamparter <equinox@diac24.net>, netdev@vger.kernel.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [PATCH] bridge: extend BR_ISOLATE to full split-horizon
Message-ID: <YbOHDeyhFeMz1a8j@eidolon.nox.tf>
References: <20211209121432.473979-1-equinox@diac24.net>
 <2556a385-425c-0f25-2be5-efcfdc77aeaa@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2556a385-425c-0f25-2be5-efcfdc77aeaa@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 05:53:17PM +0100, Alexandra Winter wrote:
> On 09.12.21 13:14, David Lamparter wrote:
> > Alexandra, could you double check my change to the qeth_l2 driver?  I
> > can't really test it...
>
> Reviewed and tested for s390/qeth. Looks good to me, see 2 comments below.

Awesome, Thanks a lot!

I'll fix your comments together with the other bits Nikolay pointed out
& send a v2 in a few days or so.

Cheers,


-David
