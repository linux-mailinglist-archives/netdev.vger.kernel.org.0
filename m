Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67D462B1336
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 01:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgKMAY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 19:24:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:43508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgKMAYZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 19:24:25 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D42920A8B;
        Fri, 13 Nov 2020 00:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605227065;
        bh=ar7goSXi7/b4Sk9ZcffdwAxw4O/iV5TB3+0YDNXT4aQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lrbf90dtJ8P8EOcWJVQWMKIMMjnNbiXklO42Omp4hc4i7jqNvNu7voes6ojUQgPZN
         EhMj/l/LAo5j+cDffapM0s1F2IzUpFt1tqcAbwioQRGQHiI2bluwOD3r++GQGvDgYK
         bzHsIXjyDfWww1xS25TeQjrmWe4C/Ku0MZP4koc4=
Date:   Thu, 12 Nov 2020 16:24:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     kernel test robot <lkp@intel.com>
Cc:     Dmytro Shytyi <dmytro@shytyi.net>, kuznet <kuznet@ms2.inr.ac.ru>,
        yoshfuji <yoshfuji@linux-ipv6.org>,
        liuhangbin <liuhangbin@gmail.com>, davem <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kbuild-all@lists.01.org
Subject: Re: [PATCH net-next] net: Variable SLAAC: SLAAC with prefixes of
 arbitrary length in PIO
Message-ID: <20201112162423.6b4de8d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <202011110944.7zNVZmvB-lkp@intel.com>
References: <175b3433a4c.aea7c06513321.4158329434310691736@shytyi.net>
        <202011110944.7zNVZmvB-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Nov 2020 09:34:24 +0800 kernel test robot wrote:
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>

Good people of kernel test robot, could you please rephrase this to say
that the tag is only appropriate if someone is sending a fix up/follow
up patch?

Folks keep adding those tags on the next revisions of the their patches
which is quite misleading.
