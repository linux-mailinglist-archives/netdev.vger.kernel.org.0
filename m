Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECC941C698
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 12:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbfENKDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 06:03:55 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:41516 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbfENKDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 06:03:55 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hQUHo-0000Rx-Hu; Tue, 14 May 2019 12:03:52 +0200
Message-ID: <10b446e873dec0fa3026d9c9966ea2b7af2dd434.camel@sipsolutions.net>
Subject: Re: [PATCH] NFC: Orphan the subsystem
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Andy Shevchenko <andriy.shevchenko@intel.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Date:   Tue, 14 May 2019 12:03:51 +0200
In-Reply-To: <20190514100210.GA9224@smile.fi.intel.com>
References: <20190514090231.32414-1-johannes@sipsolutions.net>
         <20190514100210.GA9224@smile.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-05-14 at 13:02 +0300, Andy Shevchenko wrote:
> On Tue, May 14, 2019 at 11:02:31AM +0200, Johannes Berg wrote:
> > Samuel clearly hasn't been working on this in many years and
> > patches getting to the wireless list are just being ignored
> > entirely now. Mark the subsystem as orphan to reflect the
> > current state and revert back to the netdev list so at least
> > some fixes can be picked up by Dave.
> 
> Good to know.
> 
> But Samuel was active like year ago and he is still at Intel, right?

Not AFAICT and yes. I guess you can reach out to him internally, you're
probably closer to him than I am, org-wise? :)

https://patchwork.kernel.org/project/linux-wireless/list/?delegate=sameo

johannes

