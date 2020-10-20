Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA2D294191
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 19:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437183AbgJTRlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 13:41:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395567AbgJTRlK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 13:41:10 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4D1721D6C;
        Tue, 20 Oct 2020 17:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603215669;
        bh=v1Qm7Vl/Cw24zRlFjV1TGctlBsTtVgZtsEhzooeXYqY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b5TOV8EI/eI2I7okxgAS9McAFzq3u++OS9RUlM9KGCV4QpRYCVVEmWkwZ/T/mJjfH
         e7BsxEH7YFTHVDiqjYXbJvPA2b0BY/ST0aRIam3Poaw0NOXEkfY3WbdTbokhD8Sswe
         309Ey7j7F1GI8U7kX+AnmAeHFoSKqnqPAD8Vx404=
Date:   Tue, 20 Oct 2020 10:41:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     trix@redhat.com
Cc:     mgreer@animalcreek.com, davem@davemloft.net, bianpan2016@163.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-nfc@lists.01.org
Subject: Re: [PATCH] nfc: remove unneeded break
Message-ID: <20201020104106.10e27a43@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201019191500.9264-1-trix@redhat.com>
References: <20201019191500.9264-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Oct 2020 12:15:00 -0700 trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> A break is not needed if it is preceded by a return
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Applied to net, thanks!
