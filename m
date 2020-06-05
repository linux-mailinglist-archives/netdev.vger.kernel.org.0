Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0611EFE1F
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 18:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgFEQjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 12:39:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbgFEQjj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 12:39:39 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5A4B206F0;
        Fri,  5 Jun 2020 16:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591375179;
        bh=Kgmk3nIV3lohJ50yrKJoah/NpvrZc30xp5sq8jBq2AE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W5CTzrzgxvQ8E7zGR/ds0l3pWXJhNOlKve1DONzw8DrQ572lRbb/BBFSTKyk4Ilxs
         +JeZhDf+4TUAlNQdvMuZ4v/eIFoN2yZmzxdzA/xuwdkd28dNXwCfO7r4/Fk2+ave5N
         X7L43me/GUbvgkNlkNLByKgJZlQ9taYHZkzT9Pzw=
Date:   Fri, 5 Jun 2020 09:39:37 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] qrtr: Convert qrtr_ports from IDR to XArray
Message-ID: <20200605163937.GA225993@gmail.com>
References: <20200605120037.17427-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605120037.17427-1-willy@infradead.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 05, 2020 at 05:00:37AM -0700, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> The XArray interface is easier for this driver to use.  Also fixes a
> bug reported by the improper use of GFP_ATOMIC.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

This fixes https://lkml.kernel.org/r/000000000000a363b205a74ca6a2@google.com,
so please add:

Reported-by: syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com
