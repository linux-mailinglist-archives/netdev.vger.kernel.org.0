Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 419421DA44C
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 00:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgESWLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 18:11:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgESWLR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 18:11:17 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50EB32075F;
        Tue, 19 May 2020 22:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589926277;
        bh=VL8Cv8XTxPnMHopYILFcsAeZXF8sqfXpNDn4awZ5fU4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=drdQvxn/mSNvypkNwXszeT6EryRNBS83oTfGDp543T58ag/IkLAucbYC92dU90Ifv
         LBvOQ0w1qc3tiymYsQrRGkTVOC9JWnb7zv8VSmJV1rajC0I/WyTXj27tbwacTEWGjk
         8u97XWfLa5KEsVVZUa6Pw0hlk/63MkIjcodK7bE4=
Date:   Tue, 19 May 2020 15:11:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com
Subject: Re: [PATCH net-next v2 0/2] nfp: flower: feature bit updates
Message-ID: <20200519151115.179d01ea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200519141502.18676-1-simon.horman@netronome.com>
References: <20200519141502.18676-1-simon.horman@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 May 2020 16:15:00 +0200 Simon Horman wrote:
> this short series has two parts.
> 
> * The first patch cleans up the treatment of existing feature bits.
>   There are two distinct methods used and the code now reflects this
>   more clearly.
> * The second patch informs firmware of flower features. This allows
>   the firmware to disable certain features in the absence of of host support.


Acked-by: Jakub Kicinski <kuba@kernel.org>
