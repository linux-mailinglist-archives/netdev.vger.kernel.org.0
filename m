Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F382B3105
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 22:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgKNV02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 16:26:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:39238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgKNV02 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 16:26:28 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E117E22384;
        Sat, 14 Nov 2020 21:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605389188;
        bh=E8wYw/4uCxL/me3aFZC0EgAjuYFr6S9Wu4+njF5jRsE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l9XLE/OSX3wittYPEG0ZHZ3jliIb1Kzys8vD9kI830skpaYsT3ynj9G+Frgo7g3mc
         dxd3PE19OrfTgr9EEX8t1/x3V74y2P2P04YBrVOCE5VCAjAT/NhgxxjXGLUc4JqMVp
         w78OSYcewzSEKhoSjYFCIjeeuYuxzMJ95O94Gk7Q=
Date:   Sat, 14 Nov 2020 13:26:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v3 net-next 0/8] ionic updates
Message-ID: <20201114132627.74538da6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201112182208.46770-1-snelson@pensando.io>
References: <20201112182208.46770-1-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 10:22:00 -0800 Shannon Nelson wrote:
> These updates are a bit of code cleaning and a minor
> bit of performance tweaking.
> 
> v3: convert ionic_lif_quiesce() to void
> v2: added void cast on call to ionic_lif_quiesce()
>     lowered batching threshold
>     added patch to flatten calls to ionic_lif_rx_mode
>     added patch to change from_ndo to can_sleep

Applied, thanks!

FWIW I'm not 100% confident the defines in the last patch are a good
idea, feels too easy to get wrong..  In case you need to extend it in
the future - consider using explicit enum, then at least the compiler
has a chance to warn.
