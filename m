Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB18E3273F7
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 20:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhB1TGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 14:06:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:44066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230019AbhB1TGb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Feb 2021 14:06:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD6AC64E66;
        Sun, 28 Feb 2021 19:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614539151;
        bh=M0Zcw0IfcrOYYGGIYw8W7nsJGscf39K7eDvmuHdMvFo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DV4yEkUw1heC1fW4HVvqrX6mYmJvVIw3Bxig8hwIBYJlCkO0UG4AqNa4U1gyx3CeU
         CYBvhiySN2Zp45G7UxPyBVwkFHQvnqxeiiH7Sj7qF00p93FA9w+U3djzHgby5QllB+
         JiBhClY/0wpkyuu69/PVfTVyA+DnPQtA0eBOuEfr8FSqeTEMjHWTE4IF/aw7HHBhtj
         StEy/zbQkToQlz+g8S78GBLPuTN/xIZ4Fk0SXoQ55c6F0xde6TsN2Cnc6behvyEP8J
         nU3MFIgQfc04aTJHvzbKnJVtH069DAb2KHCy2si9qDxoY7MxWMAJvQmdpPmPKs8GQL
         9GaqXADrOD0UQ==
Date:   Sun, 28 Feb 2021 11:05:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, 3chas3@gmail.com,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH 01/11] pragma once: delete include/linux/atm_suni.h
Message-ID: <20210228110550.17488e90@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YDvLqaIUVaoP8rtm@localhost.localdomain>
References: <YDvLYzsGu+l1pQ2y@localhost.localdomain>
        <YDvLqaIUVaoP8rtm@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 28 Feb 2021 19:58:17 +0300 Alexey Dobriyan wrote:
> From c17ac63e1334c742686cd411736699c1d34d45a7 Mon Sep 17 00:00:00 2001
> From: Alexey Dobriyan <adobriyan@gmail.com>
> Date: Wed, 10 Feb 2021 21:07:45 +0300
> Subject: [PATCH 01/11] pragma once: delete include/linux/atm_suni.h
> 
> This file has been empty since 2.3.99-pre3!
> Delete it instead of converting to #pragma once.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

I'm guessing you want this to be merged via the networking tree?
(Guessing since you didn't CC us on the cover letter).

In that case please wait a couple of days and re-post it as a
standalone patch to netdev. Our build & validation bots can't deal 
with series where we only get patches 1 and 10 on the list.

If someone else is willing to merge the entire series - consider 
this patch acked.
