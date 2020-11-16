Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7FBC2B4970
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 16:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730992AbgKPPd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 10:33:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:55084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730294AbgKPPdz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 10:33:55 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0508E2076E;
        Mon, 16 Nov 2020 15:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605540835;
        bh=PlN7AkGPdWKLxV0qliAp22oD4F9Wmh1uLZjMnCZ/Ri0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xF0P4fpmlSpUOPXALUU719dDrax5vzR6mRGOFsqAVRw6ZqXlbuxBoKJxLyMNlXwQO
         dL74Or/Ndhm6N30wFcCQB8spt90V7lzQQyCdjLGqBze4O0etVVrLA9l019uwXM62Gh
         6DLzdCaiGSOsKOMDic+ZKzvm3+C/1FP35OaCZnmk=
Date:   Mon, 16 Nov 2020 07:33:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Subject: Re: pull-request: can 2020-11-14
Message-ID: <20201116073354.54261a0a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <f94cf530-eec7-c916-d9f1-0cbb964d8e00@pengutronix.de>
References: <20201114173358.2058600-1-mkl@pengutronix.de>
        <20201114173501.023b5e49@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201114173916.64217d86@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <f94cf530-eec7-c916-d9f1-0cbb964d8e00@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 Nov 2020 17:58:27 +0100 Marc Kleine-Budde wrote:
> On 11/15/20 2:39 AM, Jakub Kicinski wrote:
> > On Sat, 14 Nov 2020 17:35:01 -0800 Jakub Kicinski wrote:  
> >> Two invalid fixes tags here, do you want to respin or should I pull?  
> 
> Let me respin this. It'll have the new date tag of today (15th).
> 
> > Just realized you probably have these objects in your tree so it'd be
> > useful if I told you which ones ;)  
> 
> I haven't checked the fixes tags, they were added by the submitter of the patch.
> How do you test for the fixes? Is that script avaiable somewhere?

I stole this script from Stephen Rothwell & Greg:

https://github.com/gregkh/gregkh-linux/blob/master/work/verify_fixes.sh
https://github.com/kuba-moo/nipa/blob/master/tests/patch/verify_fixes/verify_fixes.sh
