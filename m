Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4057B25A238
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 02:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgIBARl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 20:17:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgIBARk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 20:17:40 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09441206EF;
        Wed,  2 Sep 2020 00:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599005860;
        bh=QKse6WYfFLh40BozBSJIZ8PT7epdcCRA3jriVaFdrtQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TAj+NP2NfObIZQjL9BaXqlJlh4Q22Jlo4uwASa2sjg6CPOS1BKAshZVaf0x7C0I/V
         022CSM0D95C1tEFCHtWyJf2F/f9JqgrfuqacNYbAo4Kn1Y7GdDRx4CNNi4tXQOFCqP
         8KT65dqOJD8XGJbzzoZsljfASUqkgucVOgRFYFEI=
Date:   Tue, 1 Sep 2020 17:17:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Alex Elder <elder@linaro.org>, Networking <netdev@vger.kernel.org>
Subject: Re: COMPILE_TEST
Message-ID: <20200901171738.23af6c63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200901214852.GA3050651@lunn.ch>
References: <d615e441-dcee-52a8-376b-f1b83eef0789@linaro.org>
        <20200901214852.GA3050651@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Sep 2020 23:48:52 +0200 Andrew Lunn wrote:
> On Tue, Sep 01, 2020 at 03:22:31PM -0500, Alex Elder wrote:
> > Jakub, you suggested/requested that the Qualcomm IPA driver get
> > built when the COMPILE_TEST config option is enabled.  I started
> > working on this a few months ago but didn't finish, and picked
> > it up again today.  I'd really like to get this done soon.
> > 
> > The QCOM_IPA config option depends on and selects other things,
> > and those other things depend on and select still more config
> > options.  I've worked through some of these, but now question
> > whether this is even the right approach.  Should I try to ensure
> > all the code the IPA driver depends on and selects *also* gets
> > built when COMPILE_TEST is enabled?  Or should I try to minimize
> > the impact on other code by making IPA config dependencies and
> > selections also depend on the value of COMPILE_TEST?
> > 
> > Is there anything you know of that describes best practice for
> > enabling a config option when COMPILE_TEST is enabled?  
> 
> Hi Alex
> 
> In general everything which can be build with COMPILE_TEST should be
> built with COMPILE_TEST. So generally it just works, because
> everything selected should already be selected because they already
> have COMPILE_TEST.
> 
> Correctly written drivers should compile for just about any
> architecture. If they don't it suggests they are not using the APIs
> correctly, and should be fixed.
> 
> If the dependencies have not had COMPILE_TEST before, you are probably
> in for some work, but in the end all the drivers will be of better
> quality, and get build tested a lot more.

Nothing to add :) I'm not aware of any codified best practices.
