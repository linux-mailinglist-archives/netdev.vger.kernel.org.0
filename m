Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6CA520DD60
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729500AbgF2SuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 14:50:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729490AbgF2SuP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 14:50:15 -0400
Received: from localhost (mobile-166-170-222-206.mycingular.net [166.170.222.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC30F22597;
        Mon, 29 Jun 2020 17:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593451879;
        bh=N8FS3I1DD7kZ22Utb3chzLeKwWO4IHGYJ7omN9lhIsE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=DcnQQqo8b+8nu/y7YH0imbvpmTVd9dPflJEnYnjwFeRcxlgGsWmm12bLrmtaEnjvE
         1g1P1hcEh8/GCflHfAC4XA2phac2yx3NaQneK1pMmXOzZuFSGSrxMFcUA/Q+gNkOXL
         qhrH58jB2kcQNswJ78qHtrkKjzghWnE9Rm0WABww=
Date:   Mon, 29 Jun 2020 12:31:16 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     kernel test robot <lkp@intel.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kbuild-all@lists.01.org, devel@driverdev.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org
Subject: Re: [PATCH v1 1/4] qlge/qlge_main.c: use genric power management
Message-ID: <20200629173116.GA3269550@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202006300026.hCr1U7Sc%lkp@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vaibhav: s/genric/generic/ in the subject

On Tue, Jun 30, 2020 at 12:09:36AM +0800, kernel test robot wrote:
> Hi Vaibhav,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on staging/staging-testing]
> [also build test ERROR on v5.8-rc3 next-20200629]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use  as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:    https://github.com/0day-ci/linux/commits/Vaibhav-Gupta/drivers-staging-use-generic-power-management/20200629-163141
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git 347fa58ff5558075eec98725029c443c80ffbf4a
> config: x86_64-rhel-7.6 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-13) 9.3.0
> reproduce (this is a W=1 build):
>         # save the attached .config to linux build tree
>         make W=1 ARCH=x86_64 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>

If the patch has already been merged and we need an incremental patch
that fixes *only* the build issue, I think it's fine to add a
"Reported-by" tag.

But if this patch hasn't been merged anywhere, I think adding the
"Reported-by" tag would be pointless and distracting.  This report
should result in a v2 posting of the patch with the build issue fixed.

There will be no evidence of the problem in the v2 patch.  The patch
itself contains other changes unrelated to the build issue, so
"Reported-by" makes so sense for them.  I would treat this as just
another review comment, and we don't usually credit those in the
commit log (though it's nice if they're mentioned in the v2 cover
letter so reviewers know what changed and why).

Is there any chance kbuild could be made smart enough to suggest the
tag only when it finds an issue in some list of published trees?

> All errors (new ones prefixed by >>):
> 
>    drivers/staging/qlge/qlge_main.c: In function 'qlge_resume':
> >> drivers/staging/qlge/qlge_main.c:4793:17: error: 'pdev' undeclared (first use in this function); did you mean 'qdev'?
>     4793 |  pci_set_master(pdev);
>          |                 ^~~~
>          |                 qdev
> ...
