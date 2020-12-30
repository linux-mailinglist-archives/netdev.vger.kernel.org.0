Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC11D2E7B1A
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 17:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgL3QmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 11:42:20 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44738 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgL3QmU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Dec 2020 11:42:20 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kueXQ-00F3dA-5g; Wed, 30 Dec 2020 17:41:28 +0100
Date:   Wed, 30 Dec 2020 17:41:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Praveen Chaudhary <praveen5582@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow user to set metric on default route learned via
 Router Advertisement.
Message-ID: <X+ytuBD5+PqszmUz@lunn.ch>
References: <1609318113-12770-1-git-send-email-pchaudhary@linkedin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1609318113-12770-1-git-send-email-pchaudhary@linkedin.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 30, 2020 at 12:48:32AM -0800, Praveen Chaudhary wrote:
> Allow user to set metric on default route learned via Router Advertisement.
> Not: RFC 4191 does not say anything for metric for IPv6 default route.

Hi Praveen

Please take a look at

https://www.kernel.org/doc/html/latest/process/submitting-patches.html

and

https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html

In particular, you should be using git format-patch, which will
correctly number your patches, make use of a version number inside the
[PATCH v0 net-next] subject part, and please indicate which tree this
is for.

       Andrew
