Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877D51A6CB0
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 21:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388016AbgDMTmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 15:42:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45382 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387935AbgDMTmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 15:42:22 -0400
Received: from ip5f5bd698.dynamic.kabel-deutschland.de ([95.91.214.152] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jO4yJ-0002rq-Iv; Mon, 13 Apr 2020 19:42:19 +0000
Date:   Mon, 13 Apr 2020 21:42:18 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Tejun Heo <tj@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Serge Hallyn <serge@hallyn.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saravana Kannan <saravanak@google.com>,
        Jan Kara <jack@suse.cz>, David Howells <dhowells@redhat.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        David Rheinsberg <david.rheinsberg@gmail.com>,
        Tom Gundersen <teg@jklm.no>,
        Christian Kellner <ckellner@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?utf-8?B?U3TDqXBoYW5l?= Graber <stgraber@ubuntu.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 6/8] genhd: add minimal namespace infrastructure
Message-ID: <20200413194218.trqz3362k4y2v7ob@wittgenstein>
References: <20200408152151.5780-1-christian.brauner@ubuntu.com>
 <20200408152151.5780-7-christian.brauner@ubuntu.com>
 <20200413190452.GH60335@mtj.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200413190452.GH60335@mtj.duckdns.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 03:04:52PM -0400, Tejun Heo wrote:
> Hello,
> 
> On Wed, Apr 08, 2020 at 05:21:49PM +0200, Christian Brauner wrote:
> > This lets the block_class properly support loopfs device by introducing
> > the minimal infrastructure needed to support different sysfs views for
> > devices belonging to the block_class. This is similar to how network
> > devices work. Note, that nothing changes with this patch since
> 
> I was hoping that all devices on the system would be visible at the root level
> as administration at system level becomes pretty tricky otherwise. Is it just
> me who thinks this way?

Hey Tejun,

I think this is the same question in a different form you had in
https://lore.kernel.org/lkml/20200413193950.tokh5m7wsyrous3c@wittgenstein/T/#m20b396a29c8d499d9dc073e6aef38f38c08f8bbe
and I tried answered it there.

Thanks!
Christian
