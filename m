Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA73843CDCC
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 17:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239026AbhJ0Plu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 11:41:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:42452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238707AbhJ0Plu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 11:41:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6302D610A0;
        Wed, 27 Oct 2021 15:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635349164;
        bh=smQnbovxHnPWqHqmLMAA0dBAcc5f97ifoEvRcjwwEzY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Co0JZ+pp60YgFn2XAB8EM/cMHPMFX1E2woFPA/3V1Efbo8x5R6vKveCoL40fGP7em
         B6LiQtjXOvQZFqw3XrSvpI+Q56n2hTeV143MV35vL2v2grYR59I6z2fJz76sfqQdE7
         OSMyeu4NsteP/ABmwS++ksgkVjk/YRJNtq4Jhbmcne/2wQG6pY4fVeRpn5Kb1ih0Z2
         004cOm4yhpYqh/A4b9E0CsYU05acXIfBTZQoq7Mpt0KbJoLWhUNlvKXS1N4jxhav95
         36O005qeEr1hOJYKSdw2PB5k66QS8mjIUMFBv+09/RmvJyww0p+Mc05O1tEoOUP8p9
         WiUDMzXxznt8A==
Date:   Wed, 27 Oct 2021 08:39:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <hkelam@marvell.com>, <gakula@marvell.com>, <sgoutham@marvell.com>,
        <rsaladi2@marvell.com>
Subject: Re: [net-next PATCH 2/2] devlink: add documentation for octeontx2
 driver
Message-ID: <20211027083923.7312f11b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1635330675-25592-3-git-send-email-sbhatta@marvell.com>
References: <1635330675-25592-1-git-send-email-sbhatta@marvell.com>
        <1635330675-25592-3-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Oct 2021 16:01:15 +0530 Subbaraya Sundeep wrote:
> Add a file to document devlink support for octeontx2
> driver. Driver-specific parameters implemented by
> AF, PF and VF drivers are documented.
> 
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>

Please resend just the docs for the existing params.
No point keeping those hostage to the serdes change.
