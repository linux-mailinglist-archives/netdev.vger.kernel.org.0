Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB782A9E3A
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 20:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbgKFTmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 14:42:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:41738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbgKFTmK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 14:42:10 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0ADB2151B;
        Fri,  6 Nov 2020 19:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604691730;
        bh=s2Inx9eYd7uxPfxMoT0GW2my3r/hMV9mLcWCvGtA9Go=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wMKjo9VUyquDqCH96i/MBZ2LCvtnZNzxxmEnuNfrQudXAqxt8ctW7jsmMo2Ua590J
         b5CZJ6lwMC99NRf8D64/ZJ7w55itrQa8xdeSs0pivYu8MfS4H+I4LpfGNUKFAV8asZ
         tNzVRyqaLLcbGWOtnY0yiqxEdXnvTh/5t6p4CBvg=
Date:   Fri, 6 Nov 2020 11:42:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     ljp <ljp@linux.vnet.ibm.com>
Cc:     Dany Madden <drt@linux.ibm.com>, wvoigt@us.ibm.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Linuxppc-dev 
        <linuxppc-dev-bounces+ljp=linux.ibm.com@lists.ozlabs.org>
Subject: Re: [PATCH net-next] Revert ibmvnic merge do_change_param_reset
 into do_reset
Message-ID: <20201106114208.4b0e8eec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <0ff353cbada91b031d1bbae250a975d5@linux.vnet.ibm.com>
References: <20201106191745.1679846-1-drt@linux.ibm.com>
        <0ff353cbada91b031d1bbae250a975d5@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 06 Nov 2020 13:30:25 -0600 ljp wrote:
> On 2020-11-06 13:17, Dany Madden wrote:
> > This reverts commit 16b5f5ce351f8709a6b518cc3cbf240c378305bf
> > where it restructures do_reset. There are patches being tested that
> > would require major rework if this is committed first.
> > 
> > We will resend this after the other patches have been applied.  
> 
> I discussed with my manager, and he has agreed not revert this one
> since it is in the net-next tree and will not affect net tree for
> current bug fix patches.

We merge net into net-next periodically (~every week or so) so if you
keep making changes to both branches I will have to deal with the
fallout.

I'm assuming that the resolution for the current conflict which Stephen
Rothwell sent from linux-next is correct. Please confirm.

I will resolve it like he did when Linus pulls from net (hopefully
later today).

But if you know you have more fixes I'd rather revert this, get all the
relevant fixed into net, wait for net to be merged into net-next and
then redo the refactoring.

Hope that makes sense.
