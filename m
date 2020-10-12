Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F7328BF62
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 20:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404157AbgJLSFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 14:05:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403943AbgJLSFl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 14:05:41 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 447E420725;
        Mon, 12 Oct 2020 18:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602525941;
        bh=qu7wir+upVDw2aA86WKzzczLyqUJW5q7cHWqFEhB08o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R8R5FlFT7EqlQcztaNqcKyyUkkf/Bssb6AJl19QfaVmP5Jqd9bDtF5nkwlFamb7at
         7E4XIPc4UCxycE7ZvA3qmATjCjFQmZeCAUUsJQQ2fKRCDiCStEWRKFdgx21Lb6riFJ
         HI8BGmUttRsJ36txUFu+OD4Hz/6c9aX4Fttnb06w=
Date:   Mon, 12 Oct 2020 11:05:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Subject: Re: pull-request: can-next 2020-10-12
Message-ID: <20201012110539.1b97bc18@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201012082727.2338859-1-mkl@pengutronix.de>
References: <20201012082727.2338859-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 10:27:25 +0200 Marc Kleine-Budde wrote:
> Hello Jakub, hello David,
> 
> here's a pull request of two patches for net-next/master.
> 
> Both patches are by Oliver Hartkopp, the first one addresses Jakub's review
> comments of the ISOTP protocol, the other one removes version strings from
> various CAN protocols.

Great, pulled, thank you!
