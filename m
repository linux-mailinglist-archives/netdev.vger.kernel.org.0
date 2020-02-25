Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D67016EA40
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 16:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730111AbgBYPjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 10:39:09 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:41762 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728065AbgBYPjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 10:39:09 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1j6cIX-00A0J7-Hm; Tue, 25 Feb 2020 16:39:01 +0100
Message-ID: <983917b5637ce1d9948c94f638d857d37a2ab808.camel@sipsolutions.net>
Subject: Re: [RFC] wwan: add a new WWAN subsystem
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Alex Elder <elder@linaro.org>, m.chetan.kumar@intel.com,
        Dan Williams <dcbw@redhat.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Date:   Tue, 25 Feb 2020 16:39:00 +0100
In-Reply-To: <20200225151521.GA7663@lunn.ch>
References: <20200225100053.16385-1-johannes@sipsolutions.net>
         <20200225105149.59963c95aa29.Id0e40565452d0d5bb9ce5cc00b8755ec96db8559@changeid>
         <20200225151521.GA7663@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-02-25 at 16:15 +0100, Andrew Lunn wrote:

> Looking at it bottom up, is the WWAN device itself made up of multiple
> devices? Are the TTYs separate drivers to the packet moving engines?

Possibly, yes, it depends a bit.

> They have there own USB end points, and could just be standard CDC
> ACM?

Yeah, for a lot of USB devices that's indeed the case.

> driver/base/component.c could be useful for bringing together these
> individual devices to form the whole WWAN device.

Huh, I was unaware of this, I'll take a look!

A very brief look suggests that it wants to have a driver for the whole
thing in the end, which isn't really true here, but perhaps we could
"make one up" and have that implement the userspace API. I need to take
a closer look, thanks for the pointer.

> Plus you need to avoid confusion by not adding another "component
> framework" which means something totally different to the existing
> component framework.

:)

johannes

