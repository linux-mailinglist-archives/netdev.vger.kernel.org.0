Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99293DB77B
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 12:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238568AbhG3K7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 06:59:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:57782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238520AbhG3K7a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 06:59:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EBCC60F9B;
        Fri, 30 Jul 2021 10:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627642765;
        bh=ZbgI69aDd7vggtE8lam4FbnXr3cFmF9OJt+T1hZ8XdU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e6nxJhp31mFrWlDoaxq3kvu14vu/hsTaNCzMOCxn9f1IyN/eCr1zCvizUedWrIdDo
         iU/uam/RW2h+uIaGen/CLPThgyvlh/C6ZJ9pxDnxogD2cVbGyCYItf8Zjkc36fWMol
         8uhhAPswUn32CJbL1I2sL15PIJtsbrTVFREqblQughFGnPIh0zeSRJlHkSUMVel/S6
         r8V1h50TIIrvm7fGbNw9yDi7+5GSoD/uM0ZxJRA1sY2Zfg1fOQesaD5ECMaIzAcoj8
         +3N5OKAMPucENxfrjbPZZktiiZBRetlX/c8QeuLzeDeO4z/E+xufLFwMykuBsHXKJZ
         JzbpfzleA5lbg==
Date:   Fri, 30 Jul 2021 03:59:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     zhang kai <zhangkaiheb@126.com>
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        krzysztof.kozlowski@canonical.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: let flow have same hash in two directions
Message-ID: <20210730035924.0cfda450@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210728105418.7379-1-zhangkaiheb@126.com>
References: <20210728105418.7379-1-zhangkaiheb@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Jul 2021 18:54:18 +0800 zhang kai wrote:
> using same source and destination ip/port for flow hash calculation
> within the two directions.

Did you observe the hash being different, or just found this by code
inspection? AFAICT the existing code was fine, and probably slightly
faster.
