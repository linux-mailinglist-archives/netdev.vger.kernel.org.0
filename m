Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44D4AE1FA
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 14:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbfD2MJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 08:09:41 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49524 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727913AbfD2MJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 08:09:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=U63qJnTkPJ4enJm1vzK4P1yKEZuVJMuZeVxsRrwlieY=; b=Dlg3wjstvx1Jhum7z5qnmoqVW4
        dBDHsR7o55Z1Pfj0K6PMmpJ5dji0lm6k7BaWEkTUxIj4AKG1KHNn1RIy22+hB1RJoladDCzyMfBdq
        uBFxQN8gJje5SK9Q/Yj6n/hhTEB9vPsxdymYuD1827Tm5VoMhTw1g5xnC+X+/Ra8kBVD/WC4qBzp0
        kzzp2fCPpsaZpK5ODQOVcX8FTSmlQl6+0Ojunp0MJ72OGI9Afmg2q70xPqyTxhWRzp1y84rxu2AtB
        wCeImU7UxMEk/zmWZy0odLacU8/0ACMPkv58vAJ/RK61ky1Zy9Jblz1hvreT1z1QnkNIr89at1+41
        gK8ZriLQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hL56G-0005h9-Li; Mon, 29 Apr 2019 12:09:36 +0000
Date:   Mon, 29 Apr 2019 05:09:36 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Nicholas Mc Guire <hofrat@osadl.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net_sched: force endianness annotation
Message-ID: <20190429120936.GA21405@infradead.org>
References: <1556430899-11018-1-git-send-email-hofrat@osadl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1556430899-11018-1-git-send-email-hofrat@osadl.org>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 28, 2019 at 07:54:59AM +0200, Nicholas Mc Guire wrote:
> While the endiannes is being handled correctly sparse was unhappy with
> the missing annotation as be16_to_cpu()/be32_to_cpu() expects a __be16
> respectively __be32. To mitigate this annotation issue forced annotation
> is introduced. Note that this patch has no impact on the generated binary.

Every __force needs a comment explaining why it actually іs fine in
this particular case.  Even more bonus points for finding a solution
that does not require the __force.
