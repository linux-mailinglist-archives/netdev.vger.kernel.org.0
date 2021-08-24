Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F283F5FE5
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 16:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237541AbhHXOJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 10:09:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234695AbhHXOJK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 10:09:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93C9F61073;
        Tue, 24 Aug 2021 14:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629814106;
        bh=YbRwqdLgn4Fwwk0jFRfU/Ryq4znrFJ3nSKshT+aZSUs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V1qy1YVg4wu3D41iEeuEmX/f1aMgWuXgfmo7/RC4n1/rCHH5RbzcVRRCkiIzKDdXe
         q1e2Sh30wsqTVKa9gD6OptFUO2vVcowL4ADeKyiZMETZOn1c+miwmtcb1tCcbsbRvn
         keJEGLToQyEgMyGzun1YyJUFoNXWQ4unzI5eGO4ImMY2JNpVT/ZrFWDmCqT65SsNxo
         paNmgHEA3PG+6VwNKptRMEM+o6IrCHIgsY8c2lYh9+NXdZXbXhg7IrmChBdUXBozY3
         qJN8R/8XA9fg/WC8bz+Wzfw3781okOZpOlja/EFvNjwxn4HIzNrrcL49y+nhE4/aQP
         fAUKdnQ04WcRw==
Date:   Tue, 24 Aug 2021 07:08:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz, andrew@lunn.ch
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool 0/3] ethool: make --json reliable
Message-ID: <20210824070825.422997d0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210813171938.1127891-1-kuba@kernel.org>
References: <20210813171938.1127891-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Aug 2021 10:19:35 -0700 Jakub Kicinski wrote:
> This series aims to make --json fail if the output is not
> JSON formatted. This should make writing scripts around
> ethtool less error prone and give us stronger signal when
> produced JSON is invalid.

Seems like it's been over a week, any comments anyone?
