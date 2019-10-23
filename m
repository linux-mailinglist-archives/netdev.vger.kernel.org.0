Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26A1EE2611
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 00:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436614AbfJWWER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 18:04:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:50792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405661AbfJWWER (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 18:04:17 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 475632084C;
        Wed, 23 Oct 2019 22:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571868254;
        bh=ZxZ2bjgrY8LxhC2gxwLipAEf5uWwjrnOAtpoB5RPRXI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nNtl5XCv0j9A48YnWaF5iTudfCQq33+QXJgRHWDYDg2YmEqbZCLDe+NCQQetvnR/b
         3CtLgVZL25LnwIFN+itO3rrgLffBBVQHhKExtJ614qS8GnmXP7HXLzSds5ViMnMXX/
         nrTddbLuRTbdz423kAsG34HKFcGZ+DmZP7edoe2A=
Date:   Wed, 23 Oct 2019 15:04:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Andrey Konovalov <andreyknvl@google.com>
Cc:     linux-usb@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Windsor <dwindsor@gmail.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>
Subject: Re: [PATCH v2 0/3] kcov: collect coverage from usb and vhost
Message-Id: <20191023150413.8aa05549bd840deccfed5539@linux-foundation.org>
In-Reply-To: <cover.1571844200.git.andreyknvl@google.com>
References: <cover.1571844200.git.andreyknvl@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Oct 2019 17:24:28 +0200 Andrey Konovalov <andreyknvl@google.com> wrote:

> This patchset extends kcov to allow collecting coverage from the USB
> subsystem and vhost workers. See the first patch description for details
> about the kcov extension. The other two patches apply this kcov extension
> to USB and vhost.
> 
> These patches have been used to enable coverage-guided USB fuzzing with
> syzkaller for the last few years

I find it surprising that this material is so focused on USB.  Is
there something unique about USB that gave rise to this situation, or
is it expected that the new kcov feature will be used elsewhere in the
kernel?

If the latter, which are the expected subsystems?
