Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22C7B5827E
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 14:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbfF0MYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 08:24:36 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33905 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbfF0MYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 08:24:36 -0400
Received: by mail-wr1-f67.google.com with SMTP id k11so2357233wrl.1
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 05:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2Ri3GDMNaw7b1gK5nyX2tXpirNh8XnIThKsUhPTUdoo=;
        b=RbyCPAPLbYrNA0H8zZWUrycMCFqokWpT2ASITIRFsyQVBRxpz4sbZF4eGhJyxdbAse
         pHePx3WLQRBhFs7KJcr6VR1wNfWRcs66TE9jbS9ArKj4KQ2sf3BaQyoRgwTj6g5SwSm1
         9ZNRmPxRx1i1OoG0kNhu30Q00RoF+wvxfC9Kt3QpQzvALZnf8rg1rfpYQQhpZ7EGUnOI
         X46aA2Kou6PtJmmfET2rXqz/YjJv9xVj6Qewp2jZ3TFIzMd2wcIs2Sy+sOrVoRGCKLRn
         FcYtZFCyaEdMdKyCzBS3HzDjskdBFo5wYZxzrAEZwxTnbJU5izzXQHt8ooxZyBABXrGk
         vHYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2Ri3GDMNaw7b1gK5nyX2tXpirNh8XnIThKsUhPTUdoo=;
        b=Lj9XOWiD3mN+S8E/sIO4ojIwCjbQQpdd/HE7BYUO+Hx57HqbeCr0nQjsGk8hQeA/V5
         +NXY0ScL3RcDFBlLnH6eAyGkV2fC7AsFLnPXVaSe48UTmC2v4boE3vBW2m8E3kBO7YaY
         Iy2XJHSqiJNACltpmpaXU4tJeKgXjt6suCokfFqv6mI8ORW8SHADQbQvUIOlleUuDWXt
         SziwfP4dhNGUD/hTPCnBZ9kYxg2TOWbJmMis30PRMvR7U731VM/xa91whfe8lxzRLDSl
         5iov87QFSWFY2ufqQt5VLhN0bXnOWm2PfHJ0Zg2B0hp+6e1n0K0rMLXJqo0smuqp/hU4
         c1jg==
X-Gm-Message-State: APjAAAWT/0AEPP4BJHE1oZjHkLVSikQ18z4WxaclAQaAZ1X3J3tEF/hb
        +hgq2rez2kusnSb9BKaDNhKgzQ==
X-Google-Smtp-Source: APXvYqysNXu4ekMpyWsXekz5uBHKdn5Iu4ssoPuRx0il+DmQu+6UNFqGMiQvey0gF8DxhXi0Hu4XBQ==
X-Received: by 2002:adf:ec0c:: with SMTP id x12mr3076326wrn.342.1561638273936;
        Thu, 27 Jun 2019 05:24:33 -0700 (PDT)
Received: from apalos (athedsl-4461147.home.otenet.gr. [94.71.2.75])
        by smtp.gmail.com with ESMTPSA id l12sm3917604wrb.81.2019.06.27.05.24.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 05:24:33 -0700 (PDT)
Date:   Thu, 27 Jun 2019 15:24:30 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        ard.biesheuvel@linaro.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, daniel@iogearbox.net, ast@kernel.org,
        makita.toshiaki@lab.ntt.co.jp, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, davem@davemloft.net
Subject: Re: [RFC, PATCH 2/2, net-next] net: netsec: add XDP support
Message-ID: <20190627122430.GA32659@apalos>
References: <1561475179-7686-1-git-send-email-ilias.apalodimas@linaro.org>
 <1561475179-7686-3-git-send-email-ilias.apalodimas@linaro.org>
 <20190627142305.16b8f331@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627142305.16b8f331@carbon>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 02:23:05PM +0200, Jesper Dangaard Brouer wrote:
> On Tue, 25 Jun 2019 18:06:19 +0300
> Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:
> 
> > @@ -609,6 +639,9 @@ static bool netsec_clean_tx_dring(struct netsec_priv *priv)
> >  	int tail = dring->tail;
> >  	int cnt = 0;
> >  
> > +	if (dring->is_xdp)
> > +		spin_lock(&dring->lock);
> > +
> >  	pkts = 0;
> >  	bytes = 0;
> >  	entry = dring->vaddr + DESC_SZ * tail;
> > @@ -622,16 +655,24 @@ static bool netsec_clean_tx_dring(struct netsec_priv *priv)
> >  		eop = (entry->attr >> NETSEC_TX_LAST) & 1;
> >  		dma_rmb();
> >  
> > -		dma_unmap_single(priv->dev, desc->dma_addr, desc->len,
> > -				 DMA_TO_DEVICE);
> > -		if (eop) {
> > -			pkts++;
> > +		if (!eop)
> > +			goto next;
> > +
> > +		if (desc->buf_type == TYPE_NETSEC_SKB) {
> > +			dma_unmap_single(priv->dev, desc->dma_addr, desc->len,
> > +					 DMA_TO_DEVICE);
> 
> I don't think this is correct.  If I read the code correctly, you will
> miss the DMA unmap for !eop packets.
> 

You are reading it correct, thanks for catching this.
I'll fix it on the proper patch

Thanks
/Ilias
