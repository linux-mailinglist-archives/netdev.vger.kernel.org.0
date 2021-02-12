Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECE631A4CD
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 19:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbhBLSyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 13:54:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:57044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229980AbhBLSyX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 13:54:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17EFC64DFF;
        Fri, 12 Feb 2021 18:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613156023;
        bh=BovdCU/ko7fqgM5lABMfXKzAG1q6+rTmeOqviOV1hds=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TrbL7jK3qWL13Z/G0NHiazzJxEp2fJtBDNqF1NzePIqeUUIagzkdVeKBcP9sKTGqM
         JyN47KtJElKHOV3HKQh1jfsDyV5Ie4xw7Fha1d+s8HmLmeZtbTC1h7Zapk4XknCFUp
         WESLM7BDi3sL8S8UDj+bXiIkzPDQvFdZ3fqmkvvTPMccvgCoNJoeawjaU5YeSMLD+m
         mQFSZdUb2v5uE6S3x1CTCOE6aR3hKD/av6TTL76B8DDoaBpPzE+C+vWLGgY7Txqocs
         5drs5TGQIHvDR+NEjYtOcXsJdXNjrErdPcrkHLWUkjTLa2DnSIb7yygT1d2snsAqYE
         7FOfxnZ+9uyrA==
Date:   Fri, 12 Feb 2021 10:53:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dany Madden <drt@linux.ibm.com>
Cc:     netdev@vger.kernel.org, sukadev@linux.ibm.com, ljp@linux.ibm.com,
        ricklind@linux.ibm.com
Subject: Re: [PATCH net] ibmvnic: change IBMVNIC_MAX_IND_DESCS to 16
Message-ID: <20210212105342.5470a751@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210212161727.8557-1-drt@linux.ibm.com>
References: <20210212161727.8557-1-drt@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Feb 2021 11:17:27 -0500 Dany Madden wrote:
> The supported indirect subcrq entries on Power8 is 16. Power9
> supports 128. Redefined this value to 16 to minimize the driver from
> having to reset when migrating between Power9 and Power8. In our rx/tx
> performance testing, we found no performance difference between 16 and
> 128 at this time.
> 
> Fixes: f019fb6392e5 ("ibmvnic: Introduce indirect subordinate Command Response Queue buffers")
> Signed-off-by: Dany Madden <drt@linux.ibm.com>


Fixes tag: Fixes: f019fb6392e5 ("ibmvnic: Introduce indirect subordinate Command Response Queue buffers")
Has these problem(s):
	- Subject does not match target commit subject
	  Just use
		git log -1 --format='Fixes: %h ("%s")'
