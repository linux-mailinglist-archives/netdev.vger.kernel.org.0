Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C43D6289C24
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 01:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbgJIXfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 19:35:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbgJIXcF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 19:32:05 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 248152222E;
        Fri,  9 Oct 2020 23:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602286325;
        bh=yJu8EXl8D1pEUwc8r+UBZKhYKtgj1+XO5ugK2OLxPKU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tLGfq+AFyi6sDaIGGU2GCjTrG6W5kV70Xdc9qJqiPwEDTXQs8CEbxxJ3F4mtJ37uR
         0XlkUaDrC9chieZsW5gpFmVAtb/O9bi4hJQLAWwyPWAWay2MbWHopsTemxkKKHNim9
         N5fnYfAFFh84rockHzJp9nGjBsrS51CUqKPQScGk=
Date:   Fri, 9 Oct 2020 16:32:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Naoki Hayama <naoki.hayama@lineo.co.jp>
Cc:     Samuel Chessman <chessman@tux.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] net: tlan: Fix typo abitrary
Message-ID: <20201009163203.4566578b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cb23855e-7745-e807-e482-79d6d4f32478@lineo.co.jp>
References: <cb23855e-7745-e807-e482-79d6d4f32478@lineo.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Oct 2020 17:47:31 +0900 Naoki Hayama wrote:
> Fix comment typo.
> s/abitrary/arbitrary/
> 
> Signed-off-by: Naoki Hayama <naoki.hayama@lineo.co.jp>

Applied to net.
