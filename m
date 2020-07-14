Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5018D21F68A
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 17:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgGNPz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 11:55:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbgGNPz2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 11:55:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40A58206F5;
        Tue, 14 Jul 2020 15:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594742128;
        bh=Ka5oqUbgC3Qe1A/iiepfsqVJPQrxvFjdswUrDy3yFnA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vTU/7KgZzUzrMtN0W3zv8f/3oRVThWJW4P7RxNBFPBW2pRXnqXKjsKr6ITKkgdJiA
         zhEP0GuzbUAui/+IJW4xrVZfTd3qlf7cR/Qwc5avFz1vnM00icmLgdxHvA2tC+uFeW
         3Mgef3zoPZ89k3LTbe9K5AoC7h+XxRWIxF0gmqrc=
Date:   Tue, 14 Jul 2020 08:55:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Ooi, Joyce" <joyce.ooi@intel.com>
Cc:     Thor Thayer <thor.thayer@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Dalon Westergreen" <dalon.westergreen@linux.intel.com>,
        "Tan, Ley Foon" <ley.foon.tan@intel.com>,
        "See, Chin Liang" <chin.liang.see@intel.com>,
        "Nguyen, Dinh" <dinh.nguyen@intel.com>,
        "Westergreen, Dalon" <dalon.westergreen@intel.com>
Subject: Re: [PATCH v4 09/10] net: eth: altera: add msgdma prefetcher
Message-ID: <20200714085526.2bb89dc6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CY4PR11MB12537DA07C73574B82A239BDF2610@CY4PR11MB1253.namprd11.prod.outlook.com>
References: <20200708072401.169150-1-joyce.ooi@intel.com>
        <20200708072401.169150-10-joyce.ooi@intel.com>
        <20200708144900.058a8b25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CY4PR11MB12537DA07C73574B82A239BDF2610@CY4PR11MB1253.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jul 2020 14:35:16 +0000 Ooi, Joyce wrote:
> > I'm no device tree expert but these look like config options rather than HW
> > description. They also don't appear to be documented in the next patch.  
> 
> The poll_freq are part of the msgdma prefetcher IP, whereby it
> specifies the frequency of descriptor polling operation. I can add
> the poll_freq description in the next patch.

Is the value decided at the time of synthesis or can the driver choose 
the value it wants?
