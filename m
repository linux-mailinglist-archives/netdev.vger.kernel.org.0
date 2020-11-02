Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B20472A36D8
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 23:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgKBW6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 17:58:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:58318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725883AbgKBW6J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 17:58:09 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF0C921D40;
        Mon,  2 Nov 2020 22:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604357889;
        bh=hpOJ+h1Ej7N12FaBAMcsQd789LVLRp/i1lDjzeuFVM8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=p14VO7A/a6fv5A/ilifAxZ+teGIHmGqeIOzYs2luS0o9EfWg8pPuXfrkvY+Y0Yre/
         +nzKWEYG48Sxw4Ifr+lHW1asTD61Qa2O0tYssv03QC6nkRzZPbGZK5Rfvjv9l+dgFn
         6dAwQfJzsWbD9ft6+ux9dzAHtnPDQnT637LMqWdY=
Message-ID: <5e7fc3cade26bee5633b8d58c9b9627da8d920c9.camel@kernel.org>
Subject: Re: [net-next 00/15][pull request] 100GbE Intel Wired LAN Driver
 Updates 2020-11-02
From:   Saeed Mahameed <saeed@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, sassmann@redhat.com
Date:   Mon, 02 Nov 2020 14:58:08 -0800
In-Reply-To: <20201102222338.1442081-1-anthony.l.nguyen@intel.com>
References: <20201102222338.1442081-1-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-11-02 at 14:23 -0800, Tony Nguyen wrote:
> This series contains updates to ice driver only.

...

> Tony renames Flow Director functions to be more generic as their use
> is expanded.
> 
> Real expands ntuple support to allow for mask values to be specified.
> This
> is done by implementing ACL filtering in HW.
> 

This is a lot of code with only 2 liner commit messages!

Can you please shed more light on what user interface is being used to
program and manage those ACLs, i see it is ethtool from the code but
the cover letter and commit messages do not provide any information 
about that.

Also could you please explain what ethtool interfaces/commands are
being implemented, in the commit messages or cover letter, either is
fine.

Thanks!

