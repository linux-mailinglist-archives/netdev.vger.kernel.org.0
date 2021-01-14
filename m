Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5792F680B
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 18:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbhANRrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 12:47:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:37612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726066AbhANRrE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 12:47:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6829B23741;
        Thu, 14 Jan 2021 17:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610646383;
        bh=+qhzGXAGzQbMl+a70D79CKk/VI0kb4CFZRBc3JLZbTc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qf5X0v+qVJMaZNwyIB9iadmJkkyZkYM99djM9zVf7aGdoilGNQFAou3Eqwkp4fZow
         fBdrfTIH1PjP2wGQsbuPVHoF63K8Cf7UB5KkRSeHU0I9g6oruMPrLk7hxUFda23DA5
         u3klu42c79SnInb7ljPXRaK+RnmEvg1u4n1YeS+z5zlSFUW3RCZTuzKUniJl3u0wek
         n0np+NLR46iGbzg15+h5uyq3KNCTUL1NocCLuI+S6Q15IENKFvIKNrRWq9SRFETy1+
         oaJGaIosQ/yi8roYlqJeNP6hohnOKxd4Sate2w3361WDX/vrxpGH2ZiX/V+UDjS/Kb
         eCvUqaL3zJtlA==
Date:   Thu, 14 Jan 2021 09:46:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <stefanc@marvell.com>
Cc:     <netdev@vger.kernel.org>, <thomas.petazzoni@bootlin.com>,
        <davem@davemloft.net>, <nadavh@marvell.com>,
        <ymarkman@marvell.com>, <linux-kernel@vger.kernel.org>,
        <linux@armlinux.org.uk>, <mw@semihalf.com>, <andrew@lunn.ch>,
        <rmk+kernel@armlinux.org.uk>, <atenart@kernel.org>
Subject: Re: [PATCH net-next] net: mvpp2: extend mib-fragments name to
 mib-fragments-err
Message-ID: <20210114094622.265bb315@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1610618858-5093-1-git-send-email-stefanc@marvell.com>
References: <1610618858-5093-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 12:07:38 +0200 stefanc@marvell.com wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> This patch doesn't change any functionality, but just extend
> MIB counter register and ethtool-statistic names with "err".
> 
> The counter MVPP2_MIB_FRAGMENTS_RCVD in fact is Error counter.
> Extend REG name and appropriated ethtool statistic reg-name
> with the ERR/err.
> 
> Change-Id: Ic32b9779b90ba99789e83e85cfaddb5da9e7fda9
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>

Please strip the gerrit IDs from the upstream patches.
Checkpatch flags this as an error. Please always run 
checkpatch --strict before submitting.
