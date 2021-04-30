Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A2136FF97
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 19:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbhD3Rfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 13:35:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230229AbhD3Rfo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 13:35:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 555B061468;
        Fri, 30 Apr 2021 17:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619804095;
        bh=filC7/g4tYd7eJm3TU0/Y1TuD9qd8lJlQG+teeEL2W0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Jb9RBIqXvZxrm07B1euKHAF3691MMdcHi6qBImayhrvkEJZnqQchWtyHHC9SCIHWB
         dN6SsYItNUZyBK9hv2rTEp34nvI2rODjl1hMrSgpGBafMzdEec2rqOkSbHAoC495hT
         hXGo8HPN3RGB9C2rOmgyjbC0xuzFywcFE9NxSWVEkiJD4IUxSFucEqwLzW9N0SECpp
         u2pKuEJXsJ2X4Yc0voYyReo99LimFm9LZQpNg/YdXcWY8kRN0Wfwi67mYL0jCIJxaP
         57M9XvlUpdUVLiNcVzp5T/erviuAd7Fa+AesZPNYawwpdeen1tcmtfrtaR8cm/DzLy
         SB6JD+31dh2Mg==
Date:   Fri, 30 Apr 2021 10:34:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, Chris Snook <chris.snook@gmail.com>
Subject: Re: [PATCH] net: atheros: nic-devel@qualcomm.com is dead
Message-ID: <20210430103454.0e35269f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210430141142.28d49433b7a0.Ibcb12b70ce4d7d1c3a7a3b69200e1eea5f59e842@changeid>
References: <20210430141142.28d49433b7a0.Ibcb12b70ce4d7d1c3a7a3b69200e1eea5f59e842@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Apr 2021 14:11:42 +0200 Johannes Berg wrote:
> Remove it from the MODULE_AUTHOR statements referencing it.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

FWIW I subscribe to the belief that corporations can't be authors,
so I'd personally opt to remove these MODULE_AUTHOR()s completely.
They serve no purpose, strange legal aberrations aside, corporations
are not persons and not being sentient can't take pride in their work. 

This is not a MODULE_COPYRIGHT() macro. In the legal tradition I grew
up in the authorship rights are inalienable and we should not encourage
acting otherwise.
