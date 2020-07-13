Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC5021E2C1
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 00:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgGMWAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 18:00:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:36290 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbgGMWAS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 18:00:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1E6AEB5DD;
        Mon, 13 Jul 2020 22:00:19 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id AB5DE604B9; Tue, 14 Jul 2020 00:00:16 +0200 (CEST)
Date:   Tue, 14 Jul 2020 00:00:16 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>
Subject: Re: [RFC] bonding driver terminology change proposal
Message-ID: <20200713220016.xy4n7c5uu3xs6dyk@lion.mk-sys.cz>
References: <CAKfmpSdcvFG0UTNJFJgXwNRqQb-mk-PsrM5zQ_nXX=RqaaawgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfmpSdcvFG0UTNJFJgXwNRqQb-mk-PsrM5zQ_nXX=RqaaawgQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 02:51:39PM -0400, Jarod Wilson wrote:
> To start out with, I'd like to attempt to eliminate as much of the use
> of master and slave in the bonding driver as possible. For the most
> part, I think this can be done without breaking UAPI, but may require
> changes to anything accessing bond info via proc or sysfs.

Could we, please, avoid breaking existing userspace tools and scripts?
Massive code churn is one thing and we could certainly bite the bullet
and live with it (even if I'm still not convinced it would be as great
idea as some present it) but trading theoretical offense for real and
palpable harm to existing users is something completely different.

Or is "don't break userspace" no longer the "first commandment" of linux
kernel development?

Michal Kubecek
