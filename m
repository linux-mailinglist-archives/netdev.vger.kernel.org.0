Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9F421E455
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 02:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgGNAJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 20:09:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:47092 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbgGNAJv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 20:09:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2E860ACFF;
        Tue, 14 Jul 2020 00:09:52 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 89C46604B9; Tue, 14 Jul 2020 02:09:49 +0200 (CEST)
Date:   Tue, 14 Jul 2020 02:09:49 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Jarod Wilson <jarod@redhat.com>
Subject: Re: [RFC] bonding driver terminology change proposal
Message-ID: <20200714000949.txckjqlp4rzku3q3@lion.mk-sys.cz>
References: <CAKfmpSdcvFG0UTNJFJgXwNRqQb-mk-PsrM5zQ_nXX=RqaaawgQ@mail.gmail.com>
 <20200713220016.xy4n7c5uu3xs6dyk@lion.mk-sys.cz>
 <20200713154118.3a1edd66@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713154118.3a1edd66@hermes.lan>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 03:41:18PM -0700, Stephen Hemminger wrote:
> On Tue, 14 Jul 2020 00:00:16 +0200
> Michal Kubecek <mkubecek@suse.cz> wrote:
> 
> > On Mon, Jul 13, 2020 at 02:51:39PM -0400, Jarod Wilson wrote:
> > > To start out with, I'd like to attempt to eliminate as much of the use
> > > of master and slave in the bonding driver as possible. For the most
> > > part, I think this can be done without breaking UAPI, but may require
> > > changes to anything accessing bond info via proc or sysfs.  
> > 
> > Could we, please, avoid breaking existing userspace tools and scripts?
> > Massive code churn is one thing and we could certainly bite the bullet
> > and live with it (even if I'm still not convinced it would be as great
> > idea as some present it) but trading theoretical offense for real and
> > palpable harm to existing users is something completely different.
> > 
> > Or is "don't break userspace" no longer the "first commandment" of linux
> > kernel development?
> > 
> > Michal Kubecek
> 
> Please consider using same wording as current standard for link aggregration.
> Current version is 802.1AX and it uses the terms:
>   Multiplexer /  Aggregator

But both of these are replacements for "master", right?

> As far as userspace, maybe keep the old API's but provide deprecation nags.
> And don't document the old API values.

I'm not a fan of nagging users. And even less of a fan of undocumented
keyword and value aliases.

Michal
