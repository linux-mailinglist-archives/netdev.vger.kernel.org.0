Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82A244D7B4
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 14:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233227AbhKKOAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 09:00:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:50416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232513AbhKKOAy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 09:00:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0E3561078;
        Thu, 11 Nov 2021 13:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636639085;
        bh=BVJC0qi5AVk9D+Ewv4CkMNoUQZuUDsuJoh9s4CJ6YSo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o9rt3I0FPF/LLw5Hb61fEv9dwku2zP/D6uT37OvWbSsbvt7JWoKF1TvKteaUsOFTM
         tNimi/LxNMH80CwaWDFnnhVpa3BrnP+NnzdU4cJxDOqU3L5F3B1yF9OGyB7GM0XJwe
         YaZo0lLQJ3/hXfMN2OLZpiKtXoCo8WvTBw8ogI+byxhNnkhA9PpSECy1jl5s30ONxY
         Ni/j+BThf6hLDt3lEqvXC9jYYA2wJA/av1QMrwuhig/O2KqhLzULLEwkwju+RfHCu/
         LMLqEdk31HKoegpE9auER5H9eWz1orM93uWtr7ZDKdeuzuVIpDl9/i565eik3o5mY7
         vywxeRT7fWuKg==
Date:   Thu, 11 Nov 2021 05:58:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Min Li <min.li.xe@renesas.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] ptp: ptp_clockmatrix: repair non-kernel-doc comment
Message-ID: <20211111055803.17021cb3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <d9933dbe-a41b-772f-9d53-b3a08a0ad401@infradead.org>
References: <20211110225306.13483-1-rdunlap@infradead.org>
        <20211110174955.3fb02cde@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d9933dbe-a41b-772f-9d53-b3a08a0ad401@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Nov 2021 18:09:20 -0800 Randy Dunlap wrote:
> On 11/10/21 5:49 PM, Jakub Kicinski wrote:
> > On Wed, 10 Nov 2021 14:53:06 -0800 Randy Dunlap wrote:  
> >> -/**
> >> +/*
> >>    * Maximum absolute value for write phase offset in picoseconds
> >>    *
> >>    * @channel:  channel  
> > 
> > Looks like it documents parameters to the function, should we either
> > fix it to make it valid kdoc or remove the params (which TBH aren't
> > really adding much value)?
> >   
> 
> a. It would be the only kernel-doc in that source file and
> b. we usually want to document exported or at least non-static
> functions and don't try very hard to document static ones.
> 
> I don't care much about whether we remove the other comments
> that are there...
> If you want them removed, I can do that.

Yeah, lest remove the "@channel: channel" etc. while at it.

Thanks, Randy!
