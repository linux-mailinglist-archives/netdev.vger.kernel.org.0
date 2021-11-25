Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2076A45D3A0
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 04:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240150AbhKYDcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 22:32:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:41334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231406AbhKYDaV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 22:30:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25C236108F;
        Thu, 25 Nov 2021 03:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637810831;
        bh=OPupC+1O0F4PZsJNle63preWsMRIOFG/+YnZTsj5dL4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hUOZIOMNTk2fwgDtJvakWEc+M0B9C7Q7pKYvIJLKgAjY1CAX/VjpF/xBgTR/gcR6t
         mHkB8HiVvkGemRSY+d2SieuIJ6G5CuruRHGt1+NEpKMpKFXqStIQdO2dQ5s5T83Y+r
         kZKNw9ciHs4CVTjSSkAyFQ2yRB47CK+DAJL84H7ZEs9udorjsJxqolv+qGsv5JuZiU
         KZNN5wGKig9DG1qBpvNWKhW+HjibuPTXefD56JSTn+XhifZMsE35C2+sw9esdDhzrj
         drWs9zmyvnPHTTZRlgpB9R61FT5ldK5mue7CoS14m6BdHzWfEx8+hK4K2iloNUjcqI
         UwVvOwqRJGdLA==
Date:   Wed, 24 Nov 2021 19:27:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Radha Mohan <mohun106@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        sgoutham@marvell.com
Subject: Re: [PATCH] octeontx2-nicvf: Add netdev interface support for SDP
 VF devices
Message-ID: <20211124192710.438657ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAC8NTUX1-p24ZBGvwa7YcYQ_G+A_kn3f_GeTofKhO7ELB2bn8g@mail.gmail.com>
References: <20211125021822.6236-1-radhac@marvell.com>
        <CAC8NTUX1-p24ZBGvwa7YcYQ_G+A_kn3f_GeTofKhO7ELB2bn8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Nov 2021 18:21:04 -0800 Radha Mohan wrote:
> This patch adds netdev interface for SDP VFs. This interface can be used
> to communicate with a host over PCIe when OcteonTx is in PCIe Endpoint
> mode.

All your SDP/SDK/management interfaces do not fit into our netdev 
model of the world and should be removed upstream.

The pleasure I have from marking this as rejected is slightly
undermined by the fact that the patch isn't even correctly formatted :/
