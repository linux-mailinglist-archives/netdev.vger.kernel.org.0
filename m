Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B278D3EA863
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 18:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbhHLQRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 12:17:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230089AbhHLQRR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 12:17:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4AF96104F;
        Thu, 12 Aug 2021 16:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628785012;
        bh=LbUrk7wsh11pwwDn7W3KKBVOleHytlFxjSZL7TitFz0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i7XLc/wt3LUuaJ45SckdKUNMuKRi9+jIvGUyj1CYv2RcRyk3tyc0TMV0VwnQ27/08
         cy9Od/qJiMbhjrka8dGl2qbYOuwqYFjTsC3qqfwnBKe6A8NFs0P+iakCUKRGUyY5zY
         Bg7ruu3jnuEy/vNXQpttqA2WGtKufdtpjVGsIPe934jOFEvChJ2YqPe/iBvstEa2c/
         7qCiZMIrFn9D9PAib2J4u9G41PZFsrxfgZDpr+FOQxEvOuFZnXV77xjAq9okYm4JJr
         bY2dusYh/rINozKMiMahX5ViO995iAyL8rVg7BsM+7hnytc6lKYDg/PLJaFMtJnhGy
         2XDetzDte9HtQ==
Date:   Thu, 12 Aug 2021 09:16:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     davem@davemloft.net, linux-wpan@vger.kernel.org,
        alex.aring@gmail.com, netdev@vger.kernel.org
Subject: Re: pull-request: ieee802154 for net 2021-08-11
Message-ID: <20210812091651.593afc12@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210811200417.1662917-1-stefan@datenfreihafen.org>
References: <20210811200417.1662917-1-stefan@datenfreihafen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Aug 2021 22:04:17 +0200 Stefan Schmidt wrote:
> Stefan Schmidt (1):
>       Merge remote-tracking branch 'net/master' into merge-test

Hi Stefan, would it be possible to toss this Merge commit and resubmit?
I don't think it's a common practice to merge the target tree before
submitting a PR?
