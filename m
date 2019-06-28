Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC2BF59475
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 08:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfF1GyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 02:54:19 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43000 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbfF1GyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 02:54:18 -0400
Received: by mail-wr1-f66.google.com with SMTP id x17so5022100wrl.9
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 23:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=n9d7CENjg7vRcgHVr+72h+YXv0/LU1KGcJ+6k/oK5/4=;
        b=uQHkkfX7oAO5xZnbr3lhPw3o4Xp1qDK0XtFF8oAcp87cTu7ViJfpz4uMuamZYDn35J
         kc/V0f6qgG39qg+vb9K0aOgaa83gsuA+rs6wW7g/Ce9tAJDpsADcqQyeOFP3Jp327jPX
         kZydVFQtIzH9iPEMojyqddhe3C+eHtQbUGr/3LdMwNhrcquxIsZiqNH62o6gCAEj6U/L
         EMGEF+qbOmZItg43QgATIB4j87WCF35h4dr1abJXoyoNBMeabivz+7NnwlwC+GcNgh9K
         UfnXlHeLq832NQwaSGtrkOS0JooglgW8jNysBmufZ15KLIxooD40Ah0sPu+ERyNa3xh/
         L4Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=n9d7CENjg7vRcgHVr+72h+YXv0/LU1KGcJ+6k/oK5/4=;
        b=CP7Dt8hPhNkncpt2h05SaRXEQ9XPJow0R846ZnYbU3WaMyPizN/UioN7uHg21NyRdf
         8W+oiFU0Tj/caHhvOObkYIdBPI9jcPDtg9uHg837oL3Bd3H3QycPJwZ77WsmbUQ97CqW
         oQQLek9N7r00ok2In9gCI7a132bl6O0kLs8S28NNrctmlYXa2FdHL9M27Hj8hFhtRGPW
         joE1EEsq2pTb874q17Xc2n3MN7VgtVYwxRYoW5WTFfwD00SNS0+vjG4lkHipHW7zt+lZ
         8OoMqKGpRoN/H2QkOeMqnfJRcGcAq5+Eo48eTCZXA5LhoJBa0Mp3EhSqQyrWoXHbWlVH
         QFZw==
X-Gm-Message-State: APjAAAVcl8/M7Us7X7ZPvnFyWH+0brauDup5CkccD9YFr+L0/6q5rwK9
        MArPS9l9ThxyuqiqvRrK4UONRg==
X-Google-Smtp-Source: APXvYqzT6DCNGPkBofHyMqtL1HJcOk0tJ/KhTZn5gK1wOuwiTA6h2RLLUvK79dOxzudY19wgcz10Vw==
X-Received: by 2002:adf:f181:: with SMTP id h1mr6967053wro.18.1561704856376;
        Thu, 27 Jun 2019 23:54:16 -0700 (PDT)
Received: from apalos (athedsl-4461147.home.otenet.gr. [94.71.2.75])
        by smtp.gmail.com with ESMTPSA id u25sm1364445wmc.3.2019.06.27.23.54.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 23:54:15 -0700 (PDT)
Date:   Fri, 28 Jun 2019 09:54:12 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        ard.biesheuvel@linaro.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, brouer@redhat.com, daniel@iogearbox.net,
        ast@kernel.org, makita.toshiaki@lab.ntt.co.jp,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        davem@davemloft.net
Subject: Re: [RFC, PATCH 2/2, net-next] net: netsec: add XDP support
Message-ID: <20190628065412.GA31217@apalos>
References: <1561475179-7686-1-git-send-email-ilias.apalodimas@linaro.org>
 <1561475179-7686-3-git-send-email-ilias.apalodimas@linaro.org>
 <20190627161816.0000645a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627161816.0000645a@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maciej Fijalkowski,

[...]
> > +	tx_ctrl.cksum_offload_flag = false;
> > +	tx_ctrl.tcp_seg_offload_flag = false;
> > +	tx_ctrl.tcp_seg_len = 0;
> 
> Aren't these three lines redundant? tx_ctrl is zero initialized.
> 
Yea i think i can remove those

> > +
> > +	tx_desc.dma_addr = dma_handle;
> > +	tx_desc.addr = xdpf->data;
> > +	tx_desc.len = xdpf->len;
> > +
> > +	netsec_set_tx_de(priv, tx_ring, &tx_ctrl, &tx_desc, xdpf);
> > +
> > +	return NETSEC_XDP_TX;
> > +}
> > +
> > +static u32 netsec_xdp_xmit_back(struct netsec_priv *priv, struct xdp_buff *xdp)
> > +{
> > +	struct netsec_desc_ring *tx_ring = &priv->desc_ring[NETSEC_RING_TX];
> > +	struct xdp_frame *xdpf = convert_to_xdp_frame(xdp);
> > +	u32 ret;
> > +
> > +	if (unlikely(!xdpf))
> > +		return NETSEC_XDP_CONSUMED;
> > +
> > +	spin_lock(&tx_ring->lock);
> > +	ret = netsec_xdp_queue_one(priv, xdpf, false);
> > +	spin_unlock(&tx_ring->lock);
> > +
> > +	return ret;
> > +}
> > +
> > +static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *prog,
> > +			  struct xdp_buff *xdp)
> > +{
> > +	u32 ret = NETSEC_XDP_PASS;
> > +	int err;
> > +	u32 act;
> > +
> > +	rcu_read_lock();
> > +	act = bpf_prog_run_xdp(prog, xdp);
> > +
> > +	switch (act) {
> > +	case XDP_PASS:
> > +		ret = NETSEC_XDP_PASS;
> > +		break;
> > +	case XDP_TX:
> > +		ret = netsec_xdp_xmit_back(priv, xdp);
> > +		if (ret != NETSEC_XDP_TX)
> > +			xdp_return_buff(xdp);
> > +		break;
> > +	case XDP_REDIRECT:
> > +		err = xdp_do_redirect(priv->ndev, xdp, prog);
> > +		if (!err) {
> > +			ret = NETSEC_XDP_REDIR;
> > +		} else {
> > +			ret = NETSEC_XDP_CONSUMED;
> > +			xdp_return_buff(xdp);
> > +		}
> > +		break;
> > +	default:
> > +		bpf_warn_invalid_xdp_action(act);
> > +		/* fall through */
> > +	case XDP_ABORTED:
> > +		trace_xdp_exception(priv->ndev, prog, act);
> > +		/* fall through -- handle aborts by dropping packet */
> > +	case XDP_DROP:
> > +		ret = NETSEC_XDP_CONSUMED;
> > +		xdp_return_buff(xdp);
> > +		break;
> > +	}
> > +
> > +	rcu_read_unlock();
> > +
> > +	return ret;
> > +}
> > +
> >  static int netsec_process_rx(struct netsec_priv *priv, int budget)
> >  {
> >  	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
> > +	struct bpf_prog *xdp_prog = READ_ONCE(priv->xdp_prog);
> 
> Reading BPF prog should be RCU protected. There might be a case where RCU
> callback that destroys BPF prog is executed during the bottom half handling and
> you have the PREEMPT_RCU=y in your kernel config. I've just rephrased Brenden's
> words here, so for further info, see:
> 
> https://lore.kernel.org/netdev/20160904042958.8594-1-bblanco@plumgrid.com/
> 
> So either expand the RCU section or read prog pointer per each frame, under the
> lock, as it seems that currently we have these two schemes in drivers that
> support XDP.
> 
Thanks, i'll fix it

Cheers
/Ilias
