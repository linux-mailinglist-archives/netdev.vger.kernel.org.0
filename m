Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37C7642E139
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 20:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbhJNS3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 14:29:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229987AbhJNS33 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 14:29:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8211461037;
        Thu, 14 Oct 2021 18:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634236043;
        bh=r8nnRF3wg9rfapChJs0M3XEzSBUtM6+QdsIPwWIx7fQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SLxn4V4RKx910Wrv1YU3/4JEAgX8wSlM4rB56s4rm/LGU48j46btiaY6b2Aiq4gCc
         rBKkKq9QSTGIY7Tue6O3zkaIR2xf6i5TJEvuPvRK8NVvZ9mLR1aA5FnDLOA8fpS3+A
         R7h83qqigInVKTe2nyruKPN7FArkS9Y6VJh4A01IM18wyB4qoW1h2KFt2EEmu6gHMP
         Hn68EJxqyIbIwAkteNBEl6wEgZzj+CYAQUdgXGWWXJBjURC0gLJurhgTBLJvC2pfaa
         RElicEITV1GHwiDMhLUiZfHGb4Ny1bx7GHa4Ng0LVhXRmw3G1VDp6ODOV6v5iGpoL7
         BmJWOyUmOivrQ==
Date:   Thu, 14 Oct 2021 11:27:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Stephen Suryaputra <ssuryaextr@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: Anybody else getting unsubscribed from the list?
Message-ID: <20211014112718.6aed7f47@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <6263102e-ddf2-def1-2dae-d4f69dc04eca@mojatatu.com>
References: <1fd8d0ac-ba8a-4836-59ab-0ed3b0321775@mojatatu.com>
        <20211014144337.GB11651@ICIPI.localdomain>
        <ce98b6b2-1251-556d-e6c8-461467c3c604@mojatatu.com>
        <20211014145940.GC11651@ICIPI.localdomain>
        <6263102e-ddf2-def1-2dae-d4f69dc04eca@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Oct 2021 11:17:53 -0400 Jamal Hadi Salim wrote:
> Ok, so common denominator seems to be google then...
> 
> Other than possibly an outage which would have affected
> a large chunk of the list using gmail cant quiet explain it.

This happens periodically with Gmail. Used to happen to me as well
and has not happened once since I moved to a professional email server.

You can try lei or l2md, no need to subscribe to get the email these
days:

https://git.kernel.org/pub/scm/linux/kernel/git/dborkman/l2md.git/

https://linuxplumbersconf.org/event/11/contributions/983/attachments/759/1421/Doing%20more%20with%20lore%20and%20b4.pdf (slide 24)
