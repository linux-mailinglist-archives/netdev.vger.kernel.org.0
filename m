Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3900D277BA3
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 00:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgIXW2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 18:28:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726280AbgIXW2G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 18:28:06 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E88A221EB;
        Thu, 24 Sep 2020 22:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600986485;
        bh=WeA89t8adCxfN/0OUGWVZYy6Au70JX/nzkj60NX0Bg8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PQRQk2q2uj7VBO8d3tgxA7qABhEzFaVVaTNV833hvJZSw9RWyqMO4x8J1/IVUS4Hr
         Ubya5c8AsUFsAZe7Znl7Nv7DxMJqZdkIW88tQR+m7gqxFXVDV9EpFeOg4KVYC5Lrdn
         Vqtq2vUTFeyucdGFn2rJQcYFtyYH/HIX1uhp09+w=
Date:   Thu, 24 Sep 2020 15:28:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "Brown, Aaron F" <aaron.f.brown@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [Intel-wired-lan] [PATCH net-next v1 4/7] selftests: net: add a
 test for shared UDP tunnel info tables
Message-ID: <20200924152803.00b675b4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <808d485e3d63a2e10f1fba75c0cac968d8f844aa.camel@intel.com>
References: <20200722012716.2814777-1-kuba@kernel.org>
        <20200722012716.2814777-5-kuba@kernel.org>
        <SN6PR11MB2896F5ACC5A59F7F330183FFBC3C0@SN6PR11MB2896.namprd11.prod.outlook.com>
        <20200921144408.19624164@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <808d485e3d63a2e10f1fba75c0cac968d8f844aa.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Sep 2020 22:25:46 +0000 Nguyen, Anthony L wrote:
> On Mon, 2020-09-21 at 14:44 -0700, Jakub Kicinski wrote:
> > Ah, good catch, thanks! Please adjust in your tree or I can send a
> > follow up with other patches I still have queued.  
> 
> Hi Jakub,
> 
> It'd be great if you could adjust and resend the series. As we're still
> working through our email server issue, I don't know if everything
> would make it here.

No problem, I'll add Aaron's tags and resend. Thanks!

