Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DB037A7DD
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 15:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbhEKNkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 09:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbhEKNkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 09:40:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6CFC061574;
        Tue, 11 May 2021 06:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SKJhE6L8p0+9htttbQMfz6vP+47lUTeOtbP24QTWnlo=; b=pMFte22mrITclViRsAe1ciWoEx
        ZyMunvfrUCenCLoSqCtJ2N/fHxKeZhEjkW+bW5ldbaXrbuGfjqV7HEDY+UiLb0XKB/yD5LvNwGxUn
        ZLHv+OPanaF2l3Ge45ApAlAaMMPMJqjFvbsnsUVExEYxStiLOZraNieJmvzpAR8lY9bEcCrTFja9U
        p/KqXldFLBckAPzxX/e52ZDHXfV+4v7bFjShOOp5NQnAQa2IGuyhoNsQXSKB1kxSH+P7Q5p27XzWQ
        5Vj8AjQhm5JQGG6Nl5WWtKncoR2aUa2FMw+D06f5gMWmuWQXBSR4y3qjcatEMypV8QEfkM7Zdh9vx
        kSZGmYew==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lgSar-007Jrs-TV; Tue, 11 May 2021 13:38:44 +0000
Date:   Tue, 11 May 2021 14:38:37 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH] udp: Switch the order of arguments to copy_linear_skb
Message-ID: <YJqI3Vixcqr+jyZX@casper.infradead.org>
References: <20210511113400.1722975-1-willy@infradead.org>
 <ae8f4e176b17439b87420cad69fbabf9@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae8f4e176b17439b87420cad69fbabf9@AcuMS.aculab.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 01:11:42PM +0000, David Laight wrote:
> From: Matthew Wilcox
> > Sent: 11 May 2021 12:34
> > 
> > All other skb functions use (off, len); this is the only one which
> > uses (len, off).  Make it consistent.
> 
> I wouldn't change the order of the arguments without some other
> change that ensures old code fails to compile.
> (Like tweaking the function name.)

Yes, some random essentially internal function that has had no new
users since it was created in 2017 should get a new name *eyeroll*.

Please find more useful things to critique.  Or, you know, write some
damned code yourself instead of just having opinions.
