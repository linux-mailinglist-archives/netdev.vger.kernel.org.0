Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E1046CCEC
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 06:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbhLHFZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 00:25:37 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:55712 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbhLHFZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 00:25:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AAE3ECE1FCB
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 05:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723A1C00446;
        Wed,  8 Dec 2021 05:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638940921;
        bh=pMfsfIa76BPcL/XolVcayyRysR1JcgQh1NXGvqmG3Cg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KleslGBABR6df58Ht16YhqYYnrH8aQAHEMnJEtVGCuEvA9mXZtv/q24vC0tVThL24
         sDQinEDWMDOv89RGM5wBQHOY16j7Ooy/Tvr8WLGUafQFSDdhhXs6gvAPvZsbxZEtv7
         4Ftj7aKdrf2HEMJnDr1uk6kdNsLiSzUKTFbxIpX5ivGaHw6wG+vCQspqL4+6V8mJsM
         g4z15wc7DoRDomMvvI0TDm1q1cBkPLXb0UelOyio6BWAbXUn2nXDGLmsil18PLNfwl
         NFUzgwjJz8Xv48CBxoRxmmoTLUDLZes8WPHWJkhZ11ms3kVJ5lJq6DE27qnde0EUoj
         U4jkCRajr1YhQ==
Date:   Tue, 7 Dec 2021 21:22:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, krishna.c.sudi@intel.com,
        m.chetan.kumar@intel.com, linuxwwan@intel.com
Subject: Re: [PATCH V2 net-next 0/7] net: wwan: iosm: Bug fixes
Message-ID: <20211207212200.507260b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211205150455.1829929-1-m.chetan.kumar@linux.intel.com>
References: <20211205150455.1829929-1-m.chetan.kumar@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  5 Dec 2021 20:34:48 +0530 M Chetan Kumar wrote:
> This patch series brings in IOSM driver bug fixes. Patch details
> are explained below.
> 
> PATCH1:
>  * stop sending unnecessary doorbell in IP tx flow.
> PATCH2:
>  * set tx queue len.
> PATCH3:
>  * Restore the IP channel configuration after fw flash.
> PATCH4:
>  * Release data channel if there is no active IP session.
> PATCH5:
>  * Removes dead code.
> PATCH6:
>  * Removed the unnecessary check around control port TX transfer.
> PATCH7:
>  * Correct open parenthesis alignment to fix checkpatch warning.

Are any of these fixing functional bugs which users may encounter?

Looks like at least patches 1, 3, and 6 may be?

All the fixes for bugs should have Fixes tags and be posted against 
the netdev/net tree with [PATCH net] in the subject (meaning a separate
series). If there are dependencies between cleanups and fixes - you'll
need to defer the cleanups for a few days, until net is merged into
net-next. It usually happens every Thursday.
