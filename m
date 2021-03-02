Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC34E32B3BD
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574261AbhCCEFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:05:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:50532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1835424AbhCBTGm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 14:06:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2675C64F0A;
        Tue,  2 Mar 2021 19:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614711960;
        bh=LfnPQ8j71OOwDeXh2lFzTn3X1RHPgd8vGYaDBzgkpE4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q7D962wwFW76mUvpmvcr+e3cmlX1cDru3vp9950L0WE9EHcBd9UApQwZgodC+F9RU
         g19fCoI1R/4vgTE2uKgqKEvjPfQu93cx2nHWuViELmWN2dvtEr5PHx44KKGqzemu39
         59DiJtuQfTSdVXv0hCTfKcT8D67Av82MZI9Qg6wT4rwIoaqKqITlwVbw7KeEMGQXcy
         ExixosIoj3A4/E9sqOtLRcI2ICQ6e8Rhlmp7exGgPsIBcU9fUr+WcG8rLRStHQhn3a
         G5iqmspT3DxXRnWBrrbVSxiYj61MVJT+RpOnnf9I3DJ0WwYSwULOlInpD81EMzyAmp
         xkmE8gqE9u80Q==
Date:   Tue, 2 Mar 2021 11:05:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Coelho, Luciano" <luciano.coelho@intel.com>
Cc:     "nathan@kernel.org" <nathan@kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "gil.adam@intel.com" <gil.adam@intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "weiyongjun1@huawei.com" <weiyongjun1@huawei.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Goodstein, Mordechay" <mordechay.goodstein@intel.com>,
        "hulkci@huawei.com" <hulkci@huawei.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi: mvm: add terminate entry for dmi_system_id
 tables
Message-ID: <20210302110559.1809ceaf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <bd1bd942bcccffb9b3453344b611a13876d0e565.camel@intel.com>
References: <20210223140039.1708534-1-weiyongjun1@huawei.com>
        <20210226210640.GA21320@MSI.localdomain>
        <87h7ly9fph.fsf@codeaurora.org>
        <bd1bd942bcccffb9b3453344b611a13876d0e565.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Mar 2021 18:31:11 +0000 Coelho, Luciano wrote:
> On Sat, 2021-02-27 at 08:39 +0200, Kalle Valo wrote:
> > Nathan Chancellor <nathan@kernel.org> writes:
> > > We received a report about a crash in iwlwifi when compiled with LTO and
> > > this fix resolves it.  
> > 
> > That information should be added to the commit log.
> > 
> > Luca, should I take this to wireless-drivers?  
> 
> I just saw Jens' patch now and I don't remember if I acked this one?
> 
> In any, I assigned it to you in patchwork, so please take it directly
> to w-d.
> 
> Acked-by: Luca Coelho <luciano.coelho@intel.com>

Thanks, I'm getting pinged, too. It sounded like Kalle would like to
see the commit log improved, if Wei doesn't respond could you please
step in to make sure this fix is part of Dave's next PR to Linus?

Thanks!
