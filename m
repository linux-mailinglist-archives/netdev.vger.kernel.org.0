Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1EE2B1385
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 01:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgKMAvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 19:51:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:56324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgKMAvV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 19:51:21 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 827E8206FB;
        Fri, 13 Nov 2020 00:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605228681;
        bh=5eY0sA03LYVWlyCCF0UJd0HyCxdFPEIVEB0WTehoc74=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uG+6a45inpPwqBGN8PPHSq9dHgJzsaGBTKN7CBZzr38ekObu9HzR2L5o6UxNLfoKo
         Tw6FhTmFvntBwaGx9tlc3xm/xI9lwGlBePnpBrkzrn8FaDOVPBlxAY+qIrbFlWYIvw
         JApMS5cibm2af5+Zd2TNPi+EQB0DckLWkiMXq27E=
Date:   Thu, 12 Nov 2020 16:51:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Li, Philip" <philip.li@intel.com>
Cc:     lkp <lkp@intel.com>, Dmytro Shytyi <dmytro@shytyi.net>,
        kuznet <kuznet@ms2.inr.ac.ru>,
        yoshfuji <yoshfuji@linux-ipv6.org>,
        liuhangbin <liuhangbin@gmail.com>, davem <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>
Subject: Re: [kbuild-all] Re: [PATCH net-next] net: Variable SLAAC: SLAAC
 with prefixes of arbitrary length in PIO
Message-ID: <20201112165119.54bd07ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <5bc4f8ce9a6c40029043bc902a38af25@intel.com>
References: <175b3433a4c.aea7c06513321.4158329434310691736@shytyi.net>
        <202011110944.7zNVZmvB-lkp@intel.com>
        <20201112162423.6b4de8d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <5bc4f8ce9a6c40029043bc902a38af25@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 00:32:55 +0000 Li, Philip wrote:
> > Subject: [kbuild-all] Re: [PATCH net-next] net: Variable SLAAC: SLAAC with
> > prefixes of arbitrary length in PIO
> > 
> > On Wed, 11 Nov 2020 09:34:24 +0800 kernel test robot wrote:  
> > > If you fix the issue, kindly add following tag as appropriate
> > > Reported-by: kernel test robot <lkp@intel.com>  
> > 
> > Good people of kernel test robot, could you please rephrase this to say
> > that the tag is only appropriate if someone is sending a fix up/follow
> > up patch?  
> Thanks for the input, based on your suggestion how about
> 
> Kindly add below tag as appropriate if you send a fix up/follow up patch

I'm not sure myself how best to phrase it, I'm not a native speaker.
How about:

Kindly add below tag if you send a new patch solely addressing this issue

> Reported-by: kernel test robot <lkp@intel.com>
> 
> Or any wording change suggestion to make it more clear/friendly?

