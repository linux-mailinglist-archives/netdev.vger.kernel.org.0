Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1A9EA5F3
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 23:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfJ3WEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 18:04:32 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:42297 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbfJ3WEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 18:04:31 -0400
Received: by mail-pg1-f176.google.com with SMTP id c23so1759414pgn.9
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 15:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5KO8lw5WrPMW4jI7/3ky9Q/uhKbd1XClfKh4Z0rfzAI=;
        b=JtjfBQtUolIpQaZJ9E9TpsyeWSIbbZaW77PFBMaR6FOxHMgJYsa7iUU5YqVA1SqiYn
         f7Ffn9/eZCuyq6oGVzA3/jxNAp98vOAJ1XOUp9+Gl0y+Yw5VOfU/fV5YYksQ4dzy7Z3W
         LCrYLZwLLowtRls63hZ3OO4OHyY/iX0QSrLvUNbqYBWW8X1GTyTDjQQN9flyYRQbRfKV
         MhhDZ7j0peNF9UH/aIazsEW+fORycBknDjMalueKOHvprr7fg+Jr6TYGofZXvEb2km08
         Tre15YnD/j249P0s4WLyVdmE5Gba02YBEUpdEya6mGDuOFi/wnP+v8wu+JLq1kUUFAsB
         JEFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5KO8lw5WrPMW4jI7/3ky9Q/uhKbd1XClfKh4Z0rfzAI=;
        b=dEcbIE/MymGlF00zvRHm5De/9FpdIXRNdtt7XYtPy4Itltgi//isGlhB6nxDbFN3Hy
         IzgZ5lnvwR2tFySDsJ+4OVM8LlWGm+EAbChnV8QacFHS93Yk8vve/ET5b3evscVtCV7C
         Uzw04hncoTUr56NMKDoEc7+eIs7cBP5+U8F4WxMqVM3OaeXPWhYL3hEroLq9vakoqdlR
         LGXVLOvPVb9k18fg+gVTbHKDOFG7ZYdTxalrcNNP/TvNx5ktHaMYEmFxtf/ymLdvq35m
         stxBelHsdsSFZt8SxDIDn3Zvvj+HbUWticwSNFtaAvc6dPzB4vbPLol9OekeGv4u/4Yd
         m7Kw==
X-Gm-Message-State: APjAAAW8TvXnqD3Dck/XwP7m3a/yuz8vNUge9avrjbdfIap2xFFzd95r
        nBDq6To3SP9he0VDlkPwKNM=
X-Google-Smtp-Source: APXvYqzmfNqGoi80menHFzqI4FvmCndeanYEBmieRQX2IwRgrhB+rPeGWF14l9/cx0tzH4OWWyRh7g==
X-Received: by 2002:a17:90b:310:: with SMTP id ay16mr1879879pjb.25.1572473070899;
        Wed, 30 Oct 2019 15:04:30 -0700 (PDT)
Received: from localhost ([192.55.54.44])
        by smtp.gmail.com with ESMTPSA id i71sm956155pfe.103.2019.10.30.15.04.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 30 Oct 2019 15:04:30 -0700 (PDT)
Date:   Wed, 30 Oct 2019 23:04:06 +0100
From:   Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net,
        Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 5/9] ice: Add support for AF_XDP
Message-ID: <20191030230406.00004e3c@gmail.com>
In-Reply-To: <20191030115009.6168b50f@cakuba.netronome.com>
References: <20191030032910.24261-1-jeffrey.t.kirsher@intel.com>
 <20191030032910.24261-6-jeffrey.t.kirsher@intel.com>
 <20191030115009.6168b50f@cakuba.netronome.com>
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.32; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Oct 2019 11:50:09 -0700
Jakub Kicinski <jakub.kicinski@netronome.com> wrote:

> On Tue, 29 Oct 2019 20:29:06 -0700, Jeff Kirsher wrote:
> > +/**
> > + * ice_run_xdp_zc - Executes an XDP program in zero-copy path
> > + * @rx_ring: Rx ring
> > + * @xdp: xdp_buff used as input to the XDP program
> > + *
> > + * Returns any of ICE_XDP_{PASS, CONSUMED, TX, REDIR}
> > + */
> > +static int
> > +ice_run_xdp_zc(struct ice_ring *rx_ring, struct xdp_buff *xdp)
> > +{
> > +	int err, result = ICE_XDP_PASS;
> > +	struct bpf_prog *xdp_prog;
> > +	struct ice_ring *xdp_ring;
> > +	u32 act;
> > +
> > +	rcu_read_lock();
> > +	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
> > +	if (!xdp_prog) {
> > +		rcu_read_unlock();
> > +		return ICE_XDP_PASS;
> > +	}
> > +
> > +	act = bpf_prog_run_xdp(xdp_prog, xdp);
> > +	xdp->handle += xdp->data - xdp->data_hard_start;
> > +	switch (act) {
> > +	case XDP_PASS:
> > +		break;
> > +	case XDP_TX:
> > +		xdp_ring = rx_ring->vsi->xdp_rings[rx_ring->q_index];
> > +		result = ice_xmit_xdp_buff(xdp, xdp_ring);
> > +		break;  
> 
> From the quick look at the code it wasn't clear to me how you deal with
> XDP_TX on ZC frames. Could you describe the flow of such frames a
> little bit?

Sure, here we go.
The ice_xmit_xdp_buff() is calling a convert_to_xdp_frame(xdp) which in that
case falls to the xdp_convert_zc_to_xdp_frame(xdp), because xdp->rxq->mem.type
is set to MEM_TYPE_ZERO_COPY. 

Now we are in the xdp_convert_zc_to_xdp_frame(xdp), where we allocate the
extra page dedicated for struct xdp_frame, copy into this page the data that are
within the current struct xdp_buff and everything is finished with a
xdp_return_buff(xdp) call. Again, the mem->type is the MEM_TYPE_ZERO_COPY so
the callback for freeing ZC frames is invoked, via:

xa->zc_alloc->free(xa->zc_alloc, handle);

And this guy was set during the Rx context initialization:

ring->zca.free = ice_zca_free;
err = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
				 MEM_TYPE_ZERO_COPY,
				 &ring->zca);

Finally, the ice_zca_free will put the ZC frame back to HW Rx ring. At this
point, the ZC frame was recycled and the content from that frame sit in the
standalone page, represented by struct xdp_frame, so we are free to proceed
with transmission and that extra page will be freed during the cleanup of Tx
irq, after it got transmitted successfully.

I might over-complicate this description with too much code examples, so let me
know if that makes sense to you.

Maciej

> 
> > +	case XDP_REDIRECT:
> > +		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
> > +		result = !err ? ICE_XDP_REDIR : ICE_XDP_CONSUMED;
> > +		break;
> > +	default:
> > +		bpf_warn_invalid_xdp_action(act);
> > +		/* fallthrough -- not supported action */
> > +	case XDP_ABORTED:
> > +		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
> > +		/* fallthrough -- handle aborts by dropping frame */
> > +	case XDP_DROP:
> > +		result = ICE_XDP_CONSUMED;
> > +		break;
> > +	}
> > +
> > +	rcu_read_unlock();
> > +	return result;
> > +}  
> 

