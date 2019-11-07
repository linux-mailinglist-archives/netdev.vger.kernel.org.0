Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1C9CF2BFB
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 11:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387987AbfKGKTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 05:19:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:34958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727632AbfKGKTK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 05:19:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22BF42084D;
        Thu,  7 Nov 2019 10:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573121949;
        bh=veSNy8fHpebcc4Qmp98qkfhKdLnCD3QplNB+Rkjzb38=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o5HR5UtWgEVSoCewOeCOvQ+7niFoy1nWzZPd9rnyhJlit/8XKLlyRkgKP+RW4/ARv
         HU7XR8MtpDVdY6aDdGNgaMpeCijUFZ4hKWFojxo61Cf2PySQZKiJkV6iRoJgNtfzRi
         PZmi9vfl+T1Q3if4yW5hU8ym1X3VqIneyMPoJIaI=
Date:   Thu, 7 Nov 2019 11:19:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andrey Konovalov <andreyknvl@google.com>
Cc:     linux-usb@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Windsor <dwindsor@gmail.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>
Subject: Re: [PATCH v3 2/3] usb, kcov: collect coverage from hub_event
Message-ID: <20191107101907.GA1365996@kroah.com>
References: <cover.1572366574.git.andreyknvl@google.com>
 <de4fe1c219db2d002d905dc1736e2a3bfa1db997.1572366574.git.andreyknvl@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de4fe1c219db2d002d905dc1736e2a3bfa1db997.1572366574.git.andreyknvl@google.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 29, 2019 at 05:32:28PM +0100, Andrey Konovalov wrote:
> This patch adds kcov_remote_start()/kcov_remote_stop() annotations to the
> hub_event() function, which is responsible for processing events on USB
> buses, in particular events that happen during USB device enumeration.
> Since hub_event() is run in a global background kernel thread (see
> Documentation/dev-tools/kcov.rst for details), each USB bus gets a unique
> global handle from the USB subsystem kcov handle range. As the result kcov
> can now be used to collect coverage from events that happen on a
> particular USB bus.
> 
> Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> ---
>  drivers/usb/core/hub.c | 5 +++++
>  1 file changed, 5 insertions(+)

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
