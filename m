Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6C51890CF
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 22:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbgCQVzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 17:55:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:57980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726476AbgCQVzA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 17:55:00 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AA0820724;
        Tue, 17 Mar 2020 21:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584482100;
        bh=HNLDSV8Z/dFTvnBFGvRZTAhNXETz1NM/BH9mmRcvdkE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cf4eVlVIUedHvtMvOMccOWT3GYxfsQZnG5WaR6EEmYNbOlgfUJmikrhd8Gs30IbEA
         TXot+JdHHSSRT37qU/5hLMPLoII9qNx9AweNDFaWy+SyC3/lujK9oNHeyEOZGabypc
         0MWBYzwNGMGSQNuNcE2Vj10EhCrM71dLkDOOyYf0=
Date:   Tue, 17 Mar 2020 14:54:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jian Yang <jianyang.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Jian Yang <jianyang@google.com>
Subject: Re: [PATCH net-next 0/5] selftests: expand txtimestamp with new
 features
Message-ID: <20200317145458.56565eca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CA+FuTSczRTvZkf1g8ZmfCU=MDESCf5ZBNT4XUe9K8G9mqj4igw@mail.gmail.com>
References: <20200317192509.150725-1-jianyang.kernel@gmail.com>
        <20200317133320.2df0d2b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CA+FuTSczRTvZkf1g8ZmfCU=MDESCf5ZBNT4XUe9K8G9mqj4igw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Mar 2020 16:39:33 -0400 Willem de Bruijn wrote:
> On Tue, Mar 17, 2020 at 4:33 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > Is there any chance we could move/integrate the txtimestamp test into
> > net/?  It's the only test under networking/
> >
> > I feel like I already asked about this, but can't find the email now.  
> 
> We can probably move all targets from networking/timestamping to net.
> 
> TEST_GEN_FILES := hwtstamp_config rxtimestamp timestamping txtimestamp
> TEST_PROGS := txtimestamp.sh
> 
> For a separate follow-up patchset?

Yup, thanks!
