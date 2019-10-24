Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5A3E4073
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 01:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387458AbfJXX7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 19:59:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731922AbfJXX7J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 19:59:09 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D04A21BE5;
        Thu, 24 Oct 2019 23:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571961548;
        bh=a/612v51V67JQto4Q9B5ZAq4SDuSUffERC3MjVZlvzQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FLKyYhRTbZ+/+IsLcbdEP5BKSXEhbWMmIVlLS9FtMbHpRTEcfHgQeEPyhskQ1t1CU
         xncLjQCMgcgw92AAmidj76BEJIazepTQm+zp6MZzE8V4iXprTMLgEjFOJjahfRZWGD
         bm9roxJxzS9yzjC8jMbJtKm4MnaSA47vUui31rco=
Date:   Thu, 24 Oct 2019 16:59:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Andrey Konovalov <andreyknvl@google.com>
Cc:     USB list <linux-usb@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
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
Message-Id: <20191024165907.d56f8050b5097639263c0a41@linux-foundation.org>
In-Reply-To: <CAAeHK+xLS8TVioJeqYrf9Kso9TsiWiH0O-k+RrRBCKPPS9_Hrg@mail.gmail.com>
References: <cover.1571844200.git.andreyknvl@google.com>
        <20191023150413.8aa05549bd840deccfed5539@linux-foundation.org>
        <CAAeHK+xLS8TVioJeqYrf9Kso9TsiWiH0O-k+RrRBCKPPS9_Hrg@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Oct 2019 14:47:31 +0200 Andrey Konovalov <andreyknvl@google.com> wrote:

> > is it expected that the new kcov feature will be used elsewhere in the
> > kernel?
> >
> > If the latter, which are the expected subsystems?
> 
> Currently we encountered two cases where this is useful: USB and vhost
> workers. Most probably there are more subsystems that will benefit
> from this kcov extension to get better fuzzing coverage. I don't have
> a list of them, but the provided interface should be easy to use when
> more of such cases are encountered.

It would be helpful to add such a list to the changelog.  Best-effort
and approximate is OK - just to help people understand the eventual
usefulness of the proposal.


