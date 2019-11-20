Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E88D1042D5
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 19:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbfKTSFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 13:05:18 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46070 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727644AbfKTSFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 13:05:17 -0500
Received: by mail-wr1-f67.google.com with SMTP id z10so911232wrs.12
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 10:05:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iWjoarTRI2uMmQJVs0cTKC49IVOo4cntdWf6MRSUmiQ=;
        b=GIV9OEENEc8Nk4ZQFf7hjWtiyFTrLIB2HWtWxOoJwr32Tp61aYf9No2YO9KV4n0J8q
         N4uX/Pwv3e1GNmptxJSVteX9HNrncYrIGDEr12yo7linDILPau6yJC5NYBEQXxe79gjW
         dNLAVbb4wN1oYvx8lsncwr2q9jOPKlUcHR8L19gOf2pwMkbq28bqBX7K0sLBqaW+PFpa
         NyxtsHSVU+P57cGBlG9ujU4GI3l2bNjQbVICg4TNbLuR3mvsyuSKnIw1XdK/xeEIs+t8
         kHhnBJk9V0XNtp6hXQKLeQyX0jVaZqunB33Xh4f49pmHToqkBeCTSvUQjMtlLxxlnuMG
         1LQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iWjoarTRI2uMmQJVs0cTKC49IVOo4cntdWf6MRSUmiQ=;
        b=FoTCie+8XeQ8O9/TKi7eee7UR/snXVKXHFQpQJnJVIgeSDgQINclYvABajVhpJTovB
         39W066tahJ6o4lfXb0I1Xwj94J2rXfLRtOTFZ8YRQZTAonjfOO9CN9D45nXbCFouuOVp
         lGTdOmOe0bCSwFoQlZrV4XUf6vZjc41KL8dsi7ZT21pOda69pR8LFJk8MpTxHlteSPKb
         3HZRTM/X+vxnwYDNZJKyhLnN7wKXplJH0zCx95wDOEXmfZSBiKacKz/8w+Dhh35l1TrP
         uUSEudi492C/23x58OFu3V0+cbSuwdidJDbbvl0teqsC9W8H1xSFA6YeCg2U2uYBMFbs
         u8IA==
X-Gm-Message-State: APjAAAUt8q+WoKh+ATZOXwoGS4Sy1kyoDUdXq11HaQPZ30ghNQlTY3pn
        2E+V/B6KngSb8xEbqzpBY7jHLA==
X-Google-Smtp-Source: APXvYqzSuKilU3N+/DQ/Rf/o5L2FF7c4FI6ozRdFQT68W5qvtuh9oC+Ein0AKKcwPj2KGs7dKZEfyg==
X-Received: by 2002:adf:b746:: with SMTP id n6mr5077992wre.65.1574273115837;
        Wed, 20 Nov 2019 10:05:15 -0800 (PST)
Received: from apalos.home (athedsl-4484009.home.otenet.gr. [94.71.55.177])
        by smtp.gmail.com with ESMTPSA id 19sm59017wrc.47.2019.11.20.10.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 10:05:15 -0800 (PST)
Date:   Wed, 20 Nov 2019 20:05:12 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        davem@davemloft.net, lorenzo.bianconi@redhat.com,
        mcroce@redhat.com, jonathan.lemon@gmail.com
Subject: Re: [PATCH v5 net-next 0/3] add DMA-sync-for-device capability to
 page_pool API
Message-ID: <20191120180512.GB26040@apalos.home>
References: <cover.1574261017.git.lorenzo@kernel.org>
 <20191120163708.3b37077a@carbon>
 <20191120154522.GC21993@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120154522.GC21993@localhost.localdomain>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 05:45:22PM +0200, Lorenzo Bianconi wrote:
> > On Wed, 20 Nov 2019 16:54:16 +0200
> > Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > 
> > > Do not change naming convention for the moment since the changes will
> > > hit other drivers as well. I will address it in another series.
> > 
> > Yes, I agree, as I also said over IRC (freenode #xdp).
> > 
> > The length (dma_sync_size) API addition to __page_pool_put_page() is
> > for now confined to this driver (mvneta).  We can postpone the API-name
> > discussion, as you have promised here (and on IRC) that you will
> > "address it in another series".  (Guess, given timing, the followup
> > series and discussion will happen after the merge window...)
> 
> Right, I will work on it after next merging window.

As we discussed we can go a step further as page_pool_put_page() and
page_pool_recycle_direct() can probably go away. Syncing with the len make more
sense as long. As we document the 'allow_direct' flag sufficiently we can just
rename __page_pool_put_page -> page_pool_put_page and keep one function only. 

In any case this patchset is fine for this merge window

for the series

Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
