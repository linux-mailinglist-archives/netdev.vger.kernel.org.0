Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 926AE20EA26
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgF3AV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:21:59 -0400
Received: from mga05.intel.com ([192.55.52.43]:20412 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726065AbgF3AV7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 20:21:59 -0400
IronPort-SDR: G0U9B2AkfWgXyWNqYl+EKxtRqaxJwda23axaSjTtXVfXNHrSIOlz2OBu4qB5zeFYjxt7acUV3t
 pEePcGqkww1g==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="230957941"
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="230957941"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 17:21:57 -0700
IronPort-SDR: uFo1DjG2lFl3tWiiThk/w1Pa3wYAvMyqFCs9B2cLu5NLrbfBM82rcdEwHqkNv2MoqRiq+RpfWh
 buypqklnGrTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="266335275"
Received: from pl-dbox.sh.intel.com (HELO intel.com) ([10.239.159.39])
  by fmsmga008.fm.intel.com with ESMTP; 29 Jun 2020 17:21:54 -0700
Date:   Tue, 30 Jun 2020 08:21:52 +0800
From:   Philip Li <philip.li@intel.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     kernel test robot <lkp@intel.com>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kbuild-all@lists.01.org, devel@driverdev.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org
Subject: Re: [kbuild-all] Re: [PATCH v1 1/4] qlge/qlge_main.c: use genric
 power management
Message-ID: <20200630002152.GA15435@intel.com>
References: <202006300026.hCr1U7Sc%lkp@intel.com>
 <20200629173116.GA3269550@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200629173116.GA3269550@bjorn-Precision-5520>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 12:31:16PM -0500, Bjorn Helgaas wrote:
> Vaibhav: s/genric/generic/ in the subject
> 
> On Tue, Jun 30, 2020 at 12:09:36AM +0800, kernel test robot wrote:
> > Hi Vaibhav,
> > 
> > Thank you for the patch! Yet something to improve:
> > 
> > [auto build test ERROR on staging/staging-testing]
> > [also build test ERROR on v5.8-rc3 next-20200629]
> > [If your patch is applied to the wrong git tree, kindly drop us a note.
> > And when submitting patch, we suggest to use  as documented in
> > https://git-scm.com/docs/git-format-patch]
> > 
> > url:    https://github.com/0day-ci/linux/commits/Vaibhav-Gupta/drivers-staging-use-generic-power-management/20200629-163141
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git 347fa58ff5558075eec98725029c443c80ffbf4a
> > config: x86_64-rhel-7.6 (attached as .config)
> > compiler: gcc-9 (Debian 9.3.0-13) 9.3.0
> > reproduce (this is a W=1 build):
> >         # save the attached .config to linux build tree
> >         make W=1 ARCH=x86_64 
> > 
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> 
> If the patch has already been merged and we need an incremental patch
> that fixes *only* the build issue, I think it's fine to add a
> "Reported-by" tag.
> 
> But if this patch hasn't been merged anywhere, I think adding the
> "Reported-by" tag would be pointless and distracting.  This report
> should result in a v2 posting of the patch with the build issue fixed.
> 
> There will be no evidence of the problem in the v2 patch.  The patch
> itself contains other changes unrelated to the build issue, so
> "Reported-by" makes so sense for them.  I would treat this as just
> another review comment, and we don't usually credit those in the
> commit log (though it's nice if they're mentioned in the v2 cover
> letter so reviewers know what changed and why).
> 
> Is there any chance kbuild could be made smart enough to suggest the
> tag only when it finds an issue in some list of published trees?
Thanks a lot for the suggestion. As of now, this is a recommendation,
and user may judge based on own situation to add "as appropriate".
Meanwhile, we will continue making the bot better.

> 
> > All errors (new ones prefixed by >>):
> > 
> >    drivers/staging/qlge/qlge_main.c: In function 'qlge_resume':
> > >> drivers/staging/qlge/qlge_main.c:4793:17: error: 'pdev' undeclared (first use in this function); did you mean 'qdev'?
> >     4793 |  pci_set_master(pdev);
> >          |                 ^~~~
> >          |                 qdev
> > ...
> _______________________________________________
> kbuild-all mailing list -- kbuild-all@lists.01.org
> To unsubscribe send an email to kbuild-all-leave@lists.01.org
