Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 513A42CFF6E
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 23:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgLEWDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 17:03:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:49998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725270AbgLEWDe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 17:03:34 -0500
Date:   Sat, 5 Dec 2020 14:02:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607205774;
        bh=RL9A/NGIxaCQt537C4DhwQweCK5nsAsArDPyLWlm/6k=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Lf37mZuKTeCqOxzHDSPtbA5KJZN7h84okqv8hk0TcMMPEdnxBlzxdTUOQGNq6UGhS
         YxfmBhP/wMnZWoM+QOhivbOJw/HJIKMFIM8MPsxmkzUl0yo7eovA/+pPUQtGt9WFAX
         lPVdXws7fYhOlX1fWlv1N5vi7KO9CBL6NEuLqwtlw75IXpDNJkFmvnZL4Seevt41oM
         DD4FJk8+jDPC84qnz3cNCnnaa+OlIiPmvL3PPRPsnocv6BNFeueHixnW7U07LQpiPX
         6C7ahd08cQVM1tGBFzSHLTGgBDfrH4EwECKIFqrh0jxErG2W2blQdUGyxhjMCl0Cgn
         HMF+ftBC89Ogw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: Re: [PATCH 1/1 v3 net-next] ptp: Add clock driver for the
 OpenCompute TimeCard.
Message-ID: <20201205140253.17fb23d9@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201205135718.34f11845@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
References: <20201204035128.2219252-1-jonathan.lemon@gmail.com>
        <20201204035128.2219252-2-jonathan.lemon@gmail.com>
        <20201205135718.34f11845@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 5 Dec 2020 13:57:18 -0800 Jakub Kicinski wrote:
> On Thu, 3 Dec 2020 19:51:28 -0800 Jonathan Lemon wrote:
> > +static int __init
> > +ptp_ocp_init(void)
> > +{
> > +	int err;
> > +
> > +	err = pci_register_driver(&ptp_ocp_driver);
> > +	return err;
> > +}
> > +
> > +static void __exit
> > +ptp_ocp_fini(void)
> > +{
> > +	pci_unregister_driver(&ptp_ocp_driver);
> > +}
> > +
> > +module_init(ptp_ocp_init);
> > +module_exit(ptp_ocp_fini);  
> 
> FWIW if you want to send a follow up you can replace all this with:
> 
> module_pci_driver(ptp_ocp_driver);

Also consider adding yourself a MAINTAINERS entry.
