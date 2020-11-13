Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F1F2B26CC
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 22:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbgKMVbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 16:31:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:44544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgKMVbN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 16:31:13 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3261622252;
        Fri, 13 Nov 2020 21:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605303072;
        bh=n9pfdoiksLmdOvb3hdIIu/0QFIeG2tkAW6wTfTltSJg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gZ8nNd7tBW38752l7DmJbmiOZBrkAVyRqb3x3rvoD5u6iT9xPxEKUXSAoqNSn43JH
         9Q+n83bhb8iemeD8O7zO0i6f2yX87Qu9SC5NClP+X6ID10AlT2jS17CcmnOVgBh2D6
         jeNZPI2iINeIJ4J/gKrtHm7TDqrKFa5ohnGfIQ1Y=
Date:   Fri, 13 Nov 2020 13:31:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lev Stipakov <lstipakov@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lev Stipakov <lev@openvpn.net>
Subject: Re: [PATCH v2 1/3] net: mac80211: use core API for updating TX/RX
 stats
Message-ID: <20201113133111.15516437@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAGyAFMVpjwJWMaWp-tQuXCf9WPpsdzNhV0AYOX4iuDQef5jnHA@mail.gmail.com>
References: <44c8b5ae-3630-9d98-1ab4-5f57bfe0886c@gmail.com>
        <20201113085804.115806-1-lev@openvpn.net>
        <53474f83c4185caf2e7237f023cf0456afcc55cc.camel@sipsolutions.net>
        <CAGyAFMUrNRAiDZuNa2QCJQ-JuQAUdDq3nOB17+M=wc2xNknqmQ@mail.gmail.com>
        <20201113115118.618f57de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAGyAFMVpjwJWMaWp-tQuXCf9WPpsdzNhV0AYOX4iuDQef5jnHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 23:25:31 +0200 Lev Stipakov wrote:
> > Since there are no dependencies between the patches here you could have
> > gone for separate patches here.  
> 
> Shall I re-send those 3 patches separately or can we proceed with those
> in the (sub-optimal) form they've been already sent?

Resend would be great, please keep Heiner's review tags.
