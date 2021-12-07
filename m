Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7A246AF80
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243644AbhLGA6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:58:09 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41466 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378860AbhLGA5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:57:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B856B815DB;
        Tue,  7 Dec 2021 00:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D757C004DD;
        Tue,  7 Dec 2021 00:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638838445;
        bh=MOFFfkFtc+MzJIZEKxsyGBCKlJUvd4Qzj1iJAAO8ysI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Jcq5Dcf1xoXUop/3vEBQSoLzp5DMbF1c6GR3+ztDwGBqyB4/ykSsSGODnz24ew5vF
         PSuBRhRVqEouCTN8uIJ7UHtF/VJo6KOmziY994RUxecbKB9orz0jfFZ7fjMYtWWNsG
         F7dGj42TcgnFoaL9gM4jNiuW4S6Ic4xvsdT+VBpXZlbDSzb+0W/T+o49ZZwP3g7Tyh
         J1tBXsEKZe3idVJb83f6bC6yBfuZ7qaS3caE4FOUcnvNXWcrLAEjKkqKGng/i/bKw/
         RzeWw1lYZS06g/qjaIKdm9EBIIjsG7FKlHY7GLWll7E8sWu/h9chbgsr5B+iNznGBM
         FRCU5xKLAjTWg==
Date:   Mon, 6 Dec 2021 16:54:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     GR-Linux-NIC-Dev@marvell.com, Ron Mercer <ron.mercer@qlogic.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net/qla3xxx: fix an error code in
 ql_adapter_up()
Message-ID: <20211206165403.05a420a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211203101024.GI18178@kadam>
References: <20211203100300.GF2480@kili>
        <20211203101024.GI18178@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Dec 2021 13:10:25 +0300 Dan Carpenter wrote:
> I had intended to put [PATCH net] in the subject.  Although it's not a
> high priority bug so net-next is fine too.

Looks like it's marked 'Changes Requested' in pw. The Fixes tag is also
incorrect (the subject does not match, there's a [PATCH] in it, which
seems to have been replaced by [PATCH net-next]). 

Would you mind reposting?
