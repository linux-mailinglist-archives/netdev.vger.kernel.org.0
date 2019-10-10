Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8363BD2A1D
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 14:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387979AbfJJMzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 08:55:40 -0400
Received: from ms.lwn.net ([45.79.88.28]:59548 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387959AbfJJMzk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 08:55:40 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 77A71998;
        Thu, 10 Oct 2019 12:55:39 +0000 (UTC)
Date:   Thu, 10 Oct 2019 06:55:38 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     David Miller <davem@davemloft.net>, j.neuschaefer@gmx.net,
        linux-doc@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        snelson@pensando.io, drivers@pensando.io,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: networking: device drivers: Remove stray
 asterisks
Message-ID: <20191010065538.62c14aed@lwn.net>
In-Reply-To: <20191009154803.34e21bae@cakuba.netronome.com>
References: <20191002150956.16234-1-j.neuschaefer@gmx.net>
        <20191002.172526.1832563406015085740.davem@davemloft.net>
        <20191003082953.396ebc1a@lwn.net>
        <20191009154803.34e21bae@cakuba.netronome.com>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Oct 2019 15:48:03 -0700
Jakub Kicinski <jakub.kicinski@netronome.com> wrote:

> Hi Jon, I think Dave intended a few more patches to go via the doc
> tree, in particular:
> 
>  docs: networking: devlink-trap: Fix reference to other document
>  docs: networking: phy: Improve phrasing
> 
> Looks like those went missing. Would you mind taking those, or
> would you prefer for them to land in the networking trees?

Not missing, just sitting in a folder waiting for me to get back to
dealing with the queue.  I'll get caught up soon.

jon
