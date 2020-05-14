Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B331D37C6
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 19:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgENRPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 13:15:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbgENRPS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 13:15:18 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 147C12054F;
        Thu, 14 May 2020 17:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589476518;
        bh=kQGcL/DZnsP7u0gCLC4AvReVHlF7g16wecEvbCGNpjg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Jig7QO4GSWS4ZWCGBJ5gPduJqNPhU4/QNblhU6AwK0Cyea1dHHij1fEh3y3lgBccH
         LM8s+dbMvz1UymlVMPZouq0QOP/NbKmtsIB9W6vx2xkCxDXS/SyyFFZzwB7U5p69BZ
         bBgoStssDcln5xEdjDIMjqXxRwYMP84H9tJL1rIw=
Date:   Thu, 14 May 2020 10:15:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wang Wenhu <wenhu.wang@vivo.com>
Cc:     Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@vivo.com
Subject: Re: [PATCH] drivers: ipa: use devm_kzalloc for simplicity
Message-ID: <20200514101516.0b2ccda2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200514035520.2162-1-wenhu.wang@vivo.com>
References: <20200514035520.2162-1-wenhu.wang@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 May 2020 20:55:20 -0700 Wang Wenhu wrote:
> Make a substitution of kzalloc with devm_kzalloc to simplify the
> ipa_probe() process.
> 
> Signed-off-by: Wang Wenhu <wenhu.wang@vivo.com>

The code is perfectly fine as is. What problem are you trying to solve?
