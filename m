Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C204E3666AB
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 10:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234154AbhDUIEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 04:04:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:57004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234126AbhDUIEF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 04:04:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44BD761434;
        Wed, 21 Apr 2021 08:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618992213;
        bh=jXiT4IH+777BS2DeQ/xUqpZtNLaaRzu1D7DxC43qKBs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RFJnJhqY4M12LSI6+rmgmiCZoXMlDKHi0awbHq0gVR76VlmbROpUPGMIFqXMNb/rf
         wgHPOuiPvmbd08vUthZNQfhou12lvPDpm6gh2PAZgY3AEJ/5ORz5zPRvJCeZcbuGKn
         jxPH86BUUdJXlRjfNXyTvzsXtaQ8MVRbMP6/hYi3hnXvoY3BENvXZ+0MwTizR5u5CL
         Q/APIhZWVKYCEGT4sKt7l30sYU0gMlKKeSj//sK+3bOEn2ur/Zjha3wz2uQv8uzO4E
         +Cqr/CDklXxnPdAAP6dNcp8nuFSm6wJQXtpZvpNJHakQdmfcylQNQYmZRBLyh250sB
         yhqPTSawHzbTA==
Date:   Wed, 21 Apr 2021 11:03:28 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     M Chetan Kumar <m.chetan.kumar@intel.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, krishna.c.sudi@intel.com,
        linuxwwan@intel.com
Subject: Re: [PATCH V2 01/16] net: iosm: entry point
Message-ID: <YH/cUKYPLQryUjSJ@unreal>
References: <20210420161310.16189-1-m.chetan.kumar@intel.com>
 <20210420161310.16189-2-m.chetan.kumar@intel.com>
 <YH+71wFykp/fWcCe@unreal>
 <494b1d770d7730b5a865b077cdd72ba6d17c7d38.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494b1d770d7730b5a865b077cdd72ba6d17c7d38.camel@sipsolutions.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 08:51:44AM +0200, Johannes Berg wrote:
> On Wed, 2021-04-21 at 08:44 +0300, Leon Romanovsky wrote:
> > 
> > > +#define DRV_AUTHOR "Intel Corporation <linuxwwan@intel.com>"
> > 
> > Driver author can't be a company. It needs to be a person.
> 
> Most of
> 
> 	git grep MODULE_AUTHOR|grep Inc
> 
> disagrees.

Did you actually look on the output of that grep?

We have three types of MODULE_AUTHOR(..) there
1. Really old code with non-existent companies
2. People who added their names together with the company name
3. Heavy copy/pasted code

MODULE_AUTHOR is not copyright which (usually) goes to the company that
sponsored the work, but can be seen as git commit author in pre-historic
days.

So no, old doesn't mean correct.

Thanks

> 
> johannes
> 
