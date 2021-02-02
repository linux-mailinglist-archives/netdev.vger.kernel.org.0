Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C054730B555
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 03:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbhBBCjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 21:39:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:59404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229543AbhBBCjF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 21:39:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E9BB64DC3;
        Tue,  2 Feb 2021 02:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612233505;
        bh=mMAIztr++POk3Bhs6Tm0NjNUttlK2ac3uegOiEQ4YAw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FO/nU52Fq5hiXKJdjZ9aqLMieaXfduPsD+PWjWDUuLzE/km48teKumYMODLQDhvx6
         cTUBXkQPavCBi2epKhmbU08/7uolmWlM9HVZSGKc25kD59zpIF4rK5K6rrWKV9tBFK
         4SXkm1HvlUg8cx380CvSc6y7tnL3vWUWxEB6JH4bn//gEUbgaX39KrPdTJMdspZir/
         jQpn6P4FCSsLPsoXwNW7VwPeOx46e/xjuA7ZQ4UU3ZXoMyY2Jlij+Pk828HMpzjgzh
         LXZRtI9NNep58NkxU70APsKBVkFL4zsBOYL+SRlEd8La2L4fO15F1O5tijR7iyCxZq
         t53PKTJha6saw==
Date:   Mon, 1 Feb 2021 18:38:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, abdhalee@in.ibm.com
Subject: Re: [PATCH net 1/2] ibmvnic: fix a race between open and reset
Message-ID: <20210201183824.21fcb74b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210129034711.518250-1-sukadev@linux.ibm.com>
References: <20210129034711.518250-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jan 2021 19:47:10 -0800 Sukadev Bhattiprolu wrote:
> +	WARN_ON_ONCE(!rtnl_is_locked());

ASSERT_RTNL() should do nicely here
