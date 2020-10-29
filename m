Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDBC629F7A9
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 23:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725775AbgJ2WSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 18:18:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:41850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgJ2WSX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 18:18:23 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8D88206D5;
        Thu, 29 Oct 2020 22:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604009903;
        bh=qugnenTHcObXuP2JIlysDwHMbHa7mAsYH2KgoO6NeCs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fuZDW2nppRkpTSzJrTHRnomxLX+sB2n8r1o9f4GrFCPu9MakPmiAR8XcW0syf1Orn
         rNTVzNIkF1Viv5B8bwW/5G1AwSICGt9rIc71lhwwQRUd5EONV6SdpIlxFRcEHYbWtg
         qTeQz6owPZj+26Tk+BUszk+ZRrCFjPQ48Wi6Cb1g=
Date:   Thu, 29 Oct 2020 15:18:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mark Deneen <mdeneen@saucontech.com>
Cc:     netdev@vger.kernel.org, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, Klaus Doth <krnl@doth.eu>
Subject: Re: [PATCH net] cadence: force nonlinear buffers to be cloned
Message-ID: <20201029151821.5b2c589a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201028141734.552611-1-mdeneen@saucontech.com>
References: <20201028141734.552611-1-mdeneen@saucontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 14:17:36 +0000 Mark Deneen wrote:
> In my test setup, I had a SAMA5D27 device configured with ip forwarding, =
and
> second device with usb ethernet (r8152) sending ICMP packets. =C2=A0If th=
e packet
> was larger than about 220 bytes, the SAMA5 device would "oops" with the
> following trace:

Can you provide a Fixes tag?
