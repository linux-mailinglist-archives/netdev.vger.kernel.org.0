Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEB71A3108
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 10:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgDIIfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 04:35:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40789 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbgDIIfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 04:35:16 -0400
Received: from ip5f5bd698.dynamic.kabel-deutschland.de ([95.91.214.152] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jMSci-0007C4-7g; Thu, 09 Apr 2020 08:33:20 +0000
Date:   Thu, 9 Apr 2020 10:33:19 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
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
        =?utf-8?B?U3TDqXBoYW5l?= Graber <stgraber@ubuntu.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/8] loopfs: implement loopfs
Message-ID: <20200409083319.nlemf6d7g33hxhiy@wittgenstein>
References: <20200408152151.5780-1-christian.brauner@ubuntu.com>
 <20200408152151.5780-3-christian.brauner@ubuntu.com>
 <20200409075320.GA26234@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200409075320.GA26234@infradead.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 09, 2020 at 12:53:20AM -0700, Christoph Hellwig wrote:
> Almost 600 lines of code for a little bit of fine grained control
> is the wrong tradeoff.  Please find a cheaper way to do this.

I think that's a slight misrepresentation of the patchset. Of course, I
get reservations against adding new code but none of this code will
exist at all if the config option is not set; and the config option is
not selected by default. I don't want people to have to use something
they don't care about of course.
The patchset itself unblocks a range of use-cases we had issues with for
quite a while and the standalone, tiny filesystem approach has served us
well already, so this is not something new. It's not just gaining
fine-grained control, it's a whole set of new uses and we don't just do
it for the fun of doing it but because we do have actual users of this.

Christian
