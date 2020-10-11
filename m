Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5E728A9AD
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 21:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728924AbgJKTeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 15:34:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbgJKTeb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 15:34:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33779215A4;
        Sun, 11 Oct 2020 19:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602444871;
        bh=cewRzNgtJitoRTtPPVZwFIikhbxseqkariotkiSEoJU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uIXh7+mJruxqMnM0gPZCtnBQMolHCFWHorhojrSh47XQNvSDkqMAhTEGt5mkzvb6C
         l1iLaP5U+UU/Jgv0cRyRACoGzoCjAxTZRQ59R0vDScfMKl67h3qoGdP2cWFdgqDq9L
         0q/9ZPHuJ6mkFlxCkMqRwAshmdMYBRASJDzvkwBQ=
Date:   Sun, 11 Oct 2020 12:34:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, gospo@broadcom.com
Subject: Re: [PATCH net-next 3/9] bnxt_en: Set driver default message level.
Message-ID: <20201011123429.05e83141@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1602411781-6012-4-git-send-email-michael.chan@broadcom.com>
References: <1602411781-6012-1-git-send-email-michael.chan@broadcom.com>
        <1602411781-6012-4-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 11 Oct 2020 06:22:55 -0400 Michael Chan wrote:
> Currently, bp->msg_enable has default value of 0.  It is more useful
> to have the commonly used NETIF_MSG_DRV and NETIF_MSG_HW enabled by
> default.
> 
> Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
> Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>

This will add whole bunch of output for "RX buffer error 4000[45]", no?
That one needs to switch to a silent reset first, I'd think.
