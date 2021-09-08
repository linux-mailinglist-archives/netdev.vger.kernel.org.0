Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80F7403D9C
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 18:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343797AbhIHQe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 12:34:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231666AbhIHQeY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 12:34:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B903661154;
        Wed,  8 Sep 2021 16:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631118796;
        bh=kbWUvHmBH216zLC8ngCCcrq2I6UDOMZHHVfjuFdQjg4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tpirOhDmuB5dOesNibu6nTudHJ7AXt6L5ZJ5KXVQGjeU/ZBzjqznrHd/19rKPMOXH
         sUPLRNBHDdIhzaojOZ4CfKgZC2va4WgQjZzOoylc1Co0BZ9p3X22sZqUW95CbYnDJO
         8iouTe+knuPP6W//OUVgFCmSvZdIuE+rLnk8VVYnrCJOktVmGkEa6Nuy+OqqMjW9+d
         Q5Fz1n9KCTrbMKUd5tTXkKZfKcMJjAQQGoT8tjZ+9A7Nox2OOMFl3i+dfebq4tU6SY
         zvXGGmpKudCzxd3JuF7uCk6S4cWXbcR1O+StqzWapXzdluriN5Bz3ah5fF2R01FfRf
         lfLw5DA2Trtuw==
Date:   Wed, 8 Sep 2021 09:33:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ujjal Roy <royujjal@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Kernel <netdev@vger.kernel.org>
Subject: Re: ip6mr: Indentation not proper in ip6mr_cache_report()
Message-ID: <20210908093315.404558c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAE2MWknAvL01A9V44PaODencJpGFHuOzH36h4ry=pbgOf4B9jw@mail.gmail.com>
References: <CAE2MWknAvL01A9V44PaODencJpGFHuOzH36h4ry=pbgOf4B9jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Sep 2021 07:55:45 +0530 Ujjal Roy wrote:
> Hi All,
> 
> Before sending the patch, I am writing this email to get your
> attention please. As per my knowledge I can see ip6mr_cache_report()
> has some indentation issues. Please have a look at the line 1085.
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/ipv6/ip6mr.c#n1085
> 
> Sharing a patch based on the latest stable Linux.

Please repost with the patch being inline in the email.

Try to use git format-patch and git send-email for best results.

The subject prefix should be [PATCH net-next].

Regarding the change itself - since you're changing this code could you
also remove the ifdef? Instead of:

#ifdef CONFIG_IPV6_PIMSM_V2                                                     
        if (assert == MRT6MSG_WHOLEPKT) { 

do:

	if (IS_ENABLED(CONFIG_IPV6_PIMSM_V2) && assert == MRT6MSG_WHOLEPKT) {
