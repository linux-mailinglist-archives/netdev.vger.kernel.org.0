Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975FC311FDB
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 21:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhBFUIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 15:08:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:34184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhBFUId (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 15:08:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B62964DF0;
        Sat,  6 Feb 2021 20:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612642072;
        bh=L09Os1dSDeTrJiRf6YiBfRgHokeKRwdZcZyU+nPjtDI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qdsLjv1MK1vWkQPDs6qgvFogvg62HKb1uOAttfntdAeTA4C4ByLqYOpE2zQSwSp8O
         aHs+umCJYep+xnzp4mujT3gDk1VECeDLOEjoiU/6sWwh1/k9GXdQ1B0i12nzBFlzIF
         IE+t6bTVjOx6CvRf2/EaXR+zUwikgegYkU1WoW+I/y0FgtLSJDecNKQyxLC+FcBtt2
         c4lidLrptW7HEx8zKOqAeVkOv3gdseV8AWqyFWI1ti2iO4dAsVFO8+OHUdh/g9MOyv
         FwtFmOWeM3Ou0FV//KYJAIh4HEXo2HwFKZhIRJLOvhfjWVwtXYziw2fHmwIh3dQdAj
         cUq+KVoR6zSrQ==
Date:   Sat, 6 Feb 2021 12:07:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Amy Parker <enbyamy@gmail.com>
Cc:     davem@davemloft.net, akpm@linux-foundation.org, rppt@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] drivers/net/ethernet/amd: Follow style guide
Message-ID: <20210206120751.30e175a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210206000146.616465-1-enbyamy@gmail.com>
References: <20210206000146.616465-1-enbyamy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  5 Feb 2021 16:01:43 -0800 Amy Parker wrote:
> This patchset updates atarilance.c and sun3lance.c to follow the kernel
> style guide. Each patch tackles a different issue in the style guide.

These are very, very old drivers, nobody worked on them for a decade.
What's your motivation for making these changes?
