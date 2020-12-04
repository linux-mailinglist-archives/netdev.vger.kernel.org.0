Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E6C2CF4C6
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 20:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729762AbgLDT3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 14:29:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:57682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgLDT3C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 14:29:02 -0500
Date:   Fri, 4 Dec 2020 11:28:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607110101;
        bh=+eL5ChOqF7NJjCGanP4eigtibaQaJEbumEe82smotUQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZP9TInJt5NiCAYjJdBrf1WZuX8QVvCsvE0tjCUK1ByNQ3VCLFLCy/tmu6CNeuYgAV
         iaDyd1KKIEYV0nZwXQKlBVSaD4Ea0JVxOzWdkjN/6SbJw7Qqd6nmCGWOD0H+gE1T6D
         tpTVXJA3v444C2U58vBouHBhJ97dk2f/dpg7W1qHC/aNQYZ+ix8AhNP0PzFmj13X+J
         418xTXV/IFl+yIyqk0agHa+z69iWFspaajgAYVMy5+/c7NvLXLKJ/PJnEQmHuK4PQD
         mRWkiX/zglJVmCZEMSlv6iSgtY7d87CuubcnRLeup+syLoscFoU5Hhqe9C26YiQmYu
         wKSM+CD8eQn6w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2020-12-04
Message-ID: <20201204112820.0d52b580@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201204122017.118099-1-johannes@sipsolutions.net>
References: <20201204122017.118099-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Dec 2020 13:20:16 +0100 Johannes Berg wrote:
> Hi Jakub,
> 
> We've got a few more fixes for the current cycle, everything
> else I have pending right now seems likely to go to 5.11 instead.
> 
> Please pull and let me know if there's any problem.

Pulled, thanks!
