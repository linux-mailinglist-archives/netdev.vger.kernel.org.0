Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75DBF2A5917
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 23:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730787AbgKCWEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 17:04:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:44638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730132AbgKCWEm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 17:04:42 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A555C207BB;
        Tue,  3 Nov 2020 22:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604441081;
        bh=1cgkftunTNAaboJC4qLNo+zXZsxOSB5qwguXgDRLtSE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mT/WFN7rBl8qELFl53Vj6KUdSjkI+gAvPsiXm6nrFgkm748f7Oo/2tNe7FeqwRYTK
         LUNeEhAMm6oA30PC8LE/1l8Leqg0XuCSZvU6XUm54DwUbFUGg723m3nbLB5TvzFsys
         WeZRUaxHhUEYPOG+OGSwfaw81eb+gOcyXxBQURnc=
Date:   Tue, 3 Nov 2020 14:04:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        netdev@vger.kernel.org, sassmann@redhat.com
Subject: Re: [net-next 00/15][pull request] 100GbE Intel Wired LAN Driver
 Updates 2020-11-02
Message-ID: <20201103140440.5dba8402@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <5e7fc3cade26bee5633b8d58c9b9627da8d920c9.camel@kernel.org>
References: <20201102222338.1442081-1-anthony.l.nguyen@intel.com>
        <5e7fc3cade26bee5633b8d58c9b9627da8d920c9.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 02 Nov 2020 14:58:08 -0800 Saeed Mahameed wrote:
> On Mon, 2020-11-02 at 14:23 -0800, Tony Nguyen wrote:
> > This series contains updates to ice driver only.  
> 
> ...
> 
> > Tony renames Flow Director functions to be more generic as their use
> > is expanded.
> > 
> > Real expands ntuple support to allow for mask values to be specified.
> > This
> > is done by implementing ACL filtering in HW.
> >   
> 
> This is a lot of code with only 2 liner commit messages!
> 
> Can you please shed more light on what user interface is being used to
> program and manage those ACLs, i see it is ethtool from the code but
> the cover letter and commit messages do not provide any information 
> about that.
> 
> Also could you please explain what ethtool interfaces/commands are
> being implemented, in the commit messages or cover letter, either is
> fine.

Please remove the defensive programming checks, and preferably slim
down the use of your special return codes.
