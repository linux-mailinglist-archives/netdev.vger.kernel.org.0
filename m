Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4CE1B4AA7
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgDVQe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:34:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbgDVQez (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 12:34:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC2C42082E;
        Wed, 22 Apr 2020 16:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587573295;
        bh=w4JN5T5oaZgQeBhYVqmXSSTzkWYLzuJOyQMklh0w+mc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aZf1+a1hml5uJnZaaGENlJlwC+gD2DiStpvw9MbJN79Of1MS4pCvEtSRkFH8HgEAs
         7fOVd35T+0Gzr+lcs/fPBzcOfZwgU1mtNIXUpTpq/zVTT1FP1lqMBaln4BIhmCMnnX
         BYRK3509URKr1fwMf23OLyAXB9dtNLLPLUEV5wns=
Date:   Wed, 22 Apr 2020 18:34:53 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-api@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Serge Hallyn <serge@hallyn.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saravana Kannan <saravanak@google.com>,
        Jan Kara <jack@suse.cz>, David Howells <dhowells@redhat.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        David Rheinsberg <david.rheinsberg@gmail.com>,
        Tom Gundersen <teg@jklm.no>,
        Christian Kellner <ckellner@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        Steve Barber <smbarber@google.com>,
        Dylan Reid <dgreid@google.com>,
        Filipe Brandenburger <filbranden@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Benjamin Elder <bentheelder@google.com>,
        Akihiro Suda <suda.kyoto@gmail.com>
Subject: Re: [PATCH v2 1/7] kobject_uevent: remove unneeded netlink_ns check
Message-ID: <20200422163453.GA3438121@kroah.com>
References: <20200422145437.176057-1-christian.brauner@ubuntu.com>
 <20200422145437.176057-2-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422145437.176057-2-christian.brauner@ubuntu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 04:54:31PM +0200, Christian Brauner wrote:
> Back when I rewrote large chunks of uevent sending I should have removed
> the .netlink_ns method completely after having removed it's last user in
> [1]. Let's remove it now and also remove the helper associated with it
> that is unused too.
> 
> Fixes: a3498436b3a0 ("netns: restrict uevents") /* No backport needed. */
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
