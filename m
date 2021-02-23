Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3FB323394
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 23:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233794AbhBWWFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 17:05:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:41902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233663AbhBWWFp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 17:05:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AEBB60235;
        Tue, 23 Feb 2021 22:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614117862;
        bh=5QHfXBhorYtYFirfVe0QCHesN50mQt+kISjn8pypWSs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DqnxXZJXGon4bY3OZBzCO/jFT3qu5F/fJh+bdBUvq+C2YVY4hkI11lqxtrW5HVZmW
         c24Lnvg37pT4+OiqOr7eFdHSGImhal1lz7XQ2IsNbg010XiILQ4UVyV4rkUCJBe4H5
         Qx2OOwJb7T6fc3jt4t+dRXgUHWMrQNxwpq6m8oUk24bVAM8VmmBMoySpVgC42yFyE9
         1dy6qEPJN96tBi4y4dyrtsMK/JEAqkeMRNH6iD4elwxaxPtTYNZzb5NkR35rJzCxK5
         CFlWUojilwT1hLu2dtAGMe26/vdydx+mPCeeqxKEQTrWI2mReRWLO0FwR7alcES/3n
         GpPJJXfw9Dfhw==
Date:   Tue, 23 Feb 2021 14:04:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Aring <aahringo@redhat.com>, stefan@datenfreihafen.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH wpan 1/4] net: ieee802154: fix nl802154 del llsec key
Message-ID: <20210223140418.5f654572@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210221174321.14210-1-aahringo@redhat.com>
References: <20210221174321.14210-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 21 Feb 2021 12:43:18 -0500 Alexander Aring wrote:
> This patch fixes a nullpointer dereference if NL802154_ATTR_SEC_KEY is
> not set by the user. If this is the case nl802154 will return -EINVAL.
> 
> Reported-by: syzbot+ac5c11d2959a8b3c4806@syzkaller.appspotmail.com
> Signed-off-by: Alexander Aring <aahringo@redhat.com>

Looks like there is a wpan tree, but in recent years Dave just applies
ieee802154 patches directly. I'm going to apply these directly as well,
please let me know if I shouldn't, or more review time is needed.
