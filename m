Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9776525A0F6
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 23:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729033AbgIAVs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 17:48:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36850 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727778AbgIAVs5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 17:48:57 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kDE96-00ConX-Ur; Tue, 01 Sep 2020 23:48:52 +0200
Date:   Tue, 1 Sep 2020 23:48:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alex Elder <elder@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: COMPILE_TEST
Message-ID: <20200901214852.GA3050651@lunn.ch>
References: <d615e441-dcee-52a8-376b-f1b83eef0789@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d615e441-dcee-52a8-376b-f1b83eef0789@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 01, 2020 at 03:22:31PM -0500, Alex Elder wrote:
> Jakub, you suggested/requested that the Qualcomm IPA driver get
> built when the COMPILE_TEST config option is enabled.  I started
> working on this a few months ago but didn't finish, and picked
> it up again today.  I'd really like to get this done soon.
> 
> The QCOM_IPA config option depends on and selects other things,
> and those other things depend on and select still more config
> options.  I've worked through some of these, but now question
> whether this is even the right approach.  Should I try to ensure
> all the code the IPA driver depends on and selects *also* gets
> built when COMPILE_TEST is enabled?  Or should I try to minimize
> the impact on other code by making IPA config dependencies and
> selections also depend on the value of COMPILE_TEST?
> 
> Is there anything you know of that describes best practice for
> enabling a config option when COMPILE_TEST is enabled?

Hi Alex

In general everything which can be build with COMPILE_TEST should be
built with COMPILE_TEST. So generally it just works, because
everything selected should already be selected because they already
have COMPILE_TEST.

Correctly written drivers should compile for just about any
architecture. If they don't it suggests they are not using the APIs
correctly, and should be fixed.

If the dependencies have not had COMPILE_TEST before, you are probably
in for some work, but in the end all the drivers will be of better
quality, and get build tested a lot more.

	 Andrew
