Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB1D346DF8
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 01:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbhCXAAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 20:00:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230439AbhCXAAf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 20:00:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6D74619C7;
        Wed, 24 Mar 2021 00:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616544035;
        bh=7N28Wlu3fdXZtrj0PoWN3PLzhZB9znvo/bmGq1SSlfg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ieORxGcVNm8OUxZzr1dVAd556d+eBCgw5bIdr3mE5ql+AjH8zd3o3p5Hsd9CFNtTW
         Dce3CIbMTtyg28hvwtTKSXcvW069n85aVXQfqk3Ypg/F1eiQ+37ZW/nM1TDwd2YD5z
         lVe8Fb2RWZM9XNTdA3RZ+9MrWa7TpDj87JeMlxU//aiS/ttqg4aEUZ7vyoH8YdgVNz
         RJU8UmNWWfZRybYpE6PPRfraE3bNJCm9kT46GwW1YSiFQZ/ork7ttq6iQylHeiq3lD
         wto6WjZOG/iKf2+aBo2JjFxJJZMNe1Ue864TryaX6yNToo0+8Bos2uwCTGiidWziOT
         AAAHbL7Wk/ztw==
Date:   Tue, 23 Mar 2021 17:00:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: Patch version tags
Message-ID: <20210323170033.2e4411e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <83989a05-0491-bd1d-dc31-f963c3dd6096@linaro.org>
References: <83989a05-0491-bd1d-dc31-f963c3dd6096@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Mar 2021 08:48:35 -0500 Alex Elder wrote:
> Simple question.  Maybe it's been asked before.
> 
> Do you prefer "PATCH v2 net-next ..." or "PATCH net-next v2 ..."?
> 
> Both work.  Which is better?  Which makes more sense to you?

FWIW I believe Dave has used the "PATCH net-next v2" format in the past.
