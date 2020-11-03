Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E602A3A1D
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 02:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbgKCByi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 20:54:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:50062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726212AbgKCByh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 20:54:37 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCEA921D40;
        Tue,  3 Nov 2020 01:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604368477;
        bh=CM+dRabkS+5N3AgorQdfkEnLyWquTCSJ5vnkqCSLOo8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pFimId3hBsEgcuxVSZHOc7mfomOQImrqQliHLCL7u1Hcp7tfOVNEuDjEXUCt5hfNv
         pkAqSFBwUZjxALkoYZXQNa7rXnTgmVf1h5wEIKeDSTVmX/1Qm4jMCSqwjujg5Nz4d6
         hkb6w0wChM4XBSlx9gGnSEk5eKODRETO99TcmPcA=
Date:   Mon, 2 Nov 2020 17:54:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     trix@redhat.com
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tipc: remove unneeded semicolon
Message-ID: <20201102175436.752a0ab3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201101155822.2294856-1-trix@redhat.com>
References: <20201101155822.2294856-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  1 Nov 2020 07:58:22 -0800 trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> A semicolon is not needed after a switch statement.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

... and applied. Thanks! :)
