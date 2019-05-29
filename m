Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7DF42D4F2
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 06:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725865AbfE2E6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 00:58:01 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:28289 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725855AbfE2E6B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 00:58:01 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 5AB2033DC;
        Wed, 29 May 2019 06:57:58 +0200 (CEST)
Received: from localhost (meh.true.cz [local])
        by meh.true.cz (OpenSMTPD) with ESMTPA id 19bbadf5;
        Wed, 29 May 2019 06:57:57 +0200 (CEST)
Date:   Wed, 29 May 2019 06:57:56 +0200
From:   Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
To:     Octavio Alvarez <octallk1@alvarezp.org>
Cc:     Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: PROBLEM: [1/2] Marvell 88E8040 (sky2) stopped working
Message-ID: <20190529045756.GC13432@meh.true.cz>
Reply-To: Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
References: <26edfbe4-3c62-184b-b4cc-3d89f21ae394@alvarezp.org>
 <20190518215802.GI63920@meh.true.cz>
 <56e0a7a9-19e7-fb60-7159-6939bd6d8a45@alvarezp.org>
 <61d96859-ad26-68d8-6f91-56e7895b04d3@alvarezp.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61d96859-ad26-68d8-6f91-56e7895b04d3@alvarezp.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Octavio Alvarez <octallk1@alvarezp.org> [2019-05-28 22:59:24]:

Hi,

> On 5/18/19 8:22 PM, Octavio Alvarez wrote:
> > Hi, Petr,
> > 
> > > I'm just shooting out of the blue, as I don't have currently any rational
> > > explanation for that now, but could you please change the line above to
> > > following:
> > > 
> > >            if (!IS_ERR_OR_NULL(iap))
> > 
> > It worked! Thank you for being so quick!
> 
> I just pulled from master and I don't see any updates for sky2.c.

it was fixed in commit 6a0a923dfa14 ("of_net: fix of_get_mac_address retval if
compiled without CONFIG_OF").

-- ynezz
