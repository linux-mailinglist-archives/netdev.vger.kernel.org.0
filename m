Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 143B1EA831
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 01:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfJaA0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 20:26:54 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36855 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbfJaA0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 20:26:54 -0400
Received: by mail-pf1-f194.google.com with SMTP id v19so2926972pfm.3
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 17:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O9nvjD4yZPVg2J5tozeAiwuKkeX6rtKSh6FQlR0Svn0=;
        b=CAXr5IbLVINefrqr40Fcw9ARU0FlzS0lLfXMrGpXaWO2+OqydOro9KJHZxLcbE1L1s
         2rCpfe7d5LouGHgJUTYBmR+zIdwvw/Pz+rt+slLDejbkJXtly4fMQmfCzlxkjhdczZJ+
         QADPUez362k/MbEZJIdD9TzgjkhOFwLXerZhBvEeH5wbC+nYT1Sp6znqQ6JVQNl1EqGE
         j+Pc4G3YKeip6L+sCabWSA0hd82KfM/hiJCNrMv0YNCTouYs4dJuTbWAs2jZ2EE1GXoQ
         8t/WmOnUJVvfcMVubKWwpVtrE6Mii7KalIM9C1Klvv1T28Pr22ijRwdlbZFRYnADQtdw
         xf7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O9nvjD4yZPVg2J5tozeAiwuKkeX6rtKSh6FQlR0Svn0=;
        b=b3/VMH1D9bTVg7d+yzcfgvxQmbNhrlMZINP9l6tA1AzskWdQXjMZPfzpomvjK0WTRa
         7q8EcRgqBpcBYjiK3OyRN0t7ZIlCOQF148fWnuXcFBcTk2/W5BAlcr6tfI05ZF4/ka9D
         Lt8/hnXVE5rhJqcUoqq/vGYD1SD6lG+TBG2yDFg0PI7HIshzFIKW6FVYS+FZe0VFeHJA
         9rAHmQ74+MqaXmtP23YfdHzzE7WAW1j173Y27HuOT66QwZmG0VD3cbXqynvp/X+I/yo1
         vRpUUjwiDo5zYWd1U2bzAxapClA3fn+U7yILsdZRc2jIV3MguEwWd3bhwfUyvcl144/w
         vj/g==
X-Gm-Message-State: APjAAAUrcIkb9yyyEAkzJoEhaSOYc/Pq9GqFtHquwEGYhMHazCvZX1xF
        imHpAbYbph9yugzrVLCccO0=
X-Google-Smtp-Source: APXvYqx7kwwzqDvqxL6kHGcLdXAK0TzFejA4NhLA+Ae7QUo2jerYcxfrMOg7AY9HSXegf8x1Vl2fwg==
X-Received: by 2002:a62:5258:: with SMTP id g85mr2404515pfb.180.1572481613463;
        Wed, 30 Oct 2019 17:26:53 -0700 (PDT)
Received: from localhost ([192.55.54.42])
        by smtp.gmail.com with ESMTPSA id k24sm946985pgl.6.2019.10.30.17.26.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 30 Oct 2019 17:26:53 -0700 (PDT)
Date:   Thu, 31 Oct 2019 01:26:44 +0100
From:   Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 3/9] ice: Add support for XDP
Message-ID: <20191031012644.00001162@gmail.com>
In-Reply-To: <20191030112754.05f04f6d@cakuba.netronome.com>
References: <20191030032910.24261-1-jeffrey.t.kirsher@intel.com>
        <20191030032910.24261-4-jeffrey.t.kirsher@intel.com>
        <20191030112754.05f04f6d@cakuba.netronome.com>
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.32; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Oct 2019 11:27:54 -0700
Jakub Kicinski <jakub.kicinski@netronome.com> wrote:

> On Tue, 29 Oct 2019 20:29:04 -0700, Jeff Kirsher wrote:
> > From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > 
> > Add support for XDP. Implement ndo_bpf and ndo_xdp_xmit.  Upon load of
> > an XDP program, allocate additional Tx rings for dedicated XDP use.
> > The following actions are supported: XDP_TX, XDP_DROP, XDP_REDIRECT,
> > XDP_PASS, and XDP_ABORTED.
> > 
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> > Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> 
> > +/**
> > + * ice_xdp_setup_prog - Add or remove XDP eBPF program
> > + * @vsi: VSI to setup XDP for
> > + * @prog: XDP program
> > + * @extack: netlink extended ack
> > + */
> > +static int
> > +ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
> > +		   struct netlink_ext_ack *extack)
> > +{
> > +	int frame_size = vsi->netdev->mtu + ICE_ETH_PKT_HDR_PAD;
> > +	bool if_running = netif_running(vsi->netdev);
> > +	struct bpf_prog *old_prog;
> > +	int i, ret = 0;
> > +
> > +	if (frame_size > vsi->rx_buf_len) {
> > +		NL_SET_ERR_MSG_MOD(extack, "MTU too large for loading XDP");
> > +		return -ENOTSUPP;
> 
> s/ENOTSUPP/EOPNOTSUPP/ everywhere

Ugh, right.

> 
> > +	}
> > +
> > +	if (!ice_is_xdp_ena_vsi(vsi) && !prog)
> > +		return 0;
> 
> This is handled by the core these days.

Yeah seems like I didn't address that after Maxim's patch for dev_change_xdp_fd
which you're pointing out.

I see that i40e has these lines as well. Is it ok if I submit the patch for
i40e outside of this set?

> 
> > +	/* need to stop netdev while setting up the program for Rx rings */
> > +	if (if_running && !test_and_set_bit(__ICE_DOWN, vsi->state)) {
> > +		ret = ice_down(vsi);
> > +		if (ret) {
> > +			NL_SET_ERR_MSG_MOD(extack,
> > +					   "Preparing device for XDP attach failed");
> > +			goto skip_setting_prog;
> > +		}
> > +	}
> > +
> > +	if (!ice_is_xdp_ena_vsi(vsi) && prog) {
> > +		vsi->num_xdp_txq = vsi->alloc_txq;
> > +		vsi->xdp_mapping_mode = ICE_VSI_MAP_CONTIG;
> > +		if (ice_prepare_xdp_rings(vsi)) {
> > +			NL_SET_ERR_MSG_MOD(extack,
> > +					   "Setting up XDP Tx resources failed");
> > +			ret = -ENOMEM;
> > +			goto skip_setting_prog;
> > +		}
> > +	} else if (ice_is_xdp_ena_vsi(vsi) && !prog) {
> > +		if (ice_destroy_xdp_rings(vsi)) {
> > +			NL_SET_ERR_MSG_MOD(extack,
> > +					   "Freeing XDP Tx resources failed");
> > +			ret = -ENOMEM;
> > +			goto skip_setting_prog;
> 
> The failures to destroy are kind of concerning, are you 100% sure
> XDP is still operational if destroy fails?

Failure destroy would mean that something went wrong with pruning the nodes
that were dedicated for XDP Tx rings from Tx scheduler. So far I haven't
experienced that so that's why this bug of not clearing the XDP prog in that
case was lying here I guess :p great catch.

> 
> > +		}
> > +	}
> > +
> > +	old_prog = xchg(&vsi->xdp_prog, prog);
> > +	if (old_prog)
> > +		bpf_prog_put(old_prog);
> > +
> > +	ice_for_each_rxq(vsi, i)
> > +		WRITE_ONCE(vsi->rx_rings[i]->xdp_prog, vsi->xdp_prog);
> > +
> > +	if (if_running)
> > +		ret = ice_up(vsi);
> > +
> > +skip_setting_prog:
> > +	return ret;
> 
> If this is not expanded by later patches and you don't have any other
> code to run, just return directly without the gotos please.

Of course.

> 
> Actually if ice_down(vsi) was run before shouldn't the error case do
> ice_up(vsi)?

Ending up with the interface in the downed state is indeed suspicious. Let's do
the ice_up(vsi) in that situation.

> 
> > +}
> > +
> > +/**
> > + * ice_xdp - implements XDP handler
> > + * @dev: netdevice
> > + * @xdp: XDP command
> > + */
> > +static int ice_xdp(struct net_device *dev, struct netdev_bpf *xdp)
> > +{
> > +	struct ice_netdev_priv *np = netdev_priv(dev);
> > +	struct ice_vsi *vsi = np->vsi;
> > +
> > +	if (vsi->type != ICE_VSI_PF) {
> > +		NL_SET_ERR_MSG_MOD(xdp->extack,
> > +				   "XDP can be loaded only on PF VSI");
> > +		return -EINVAL;
> > +	}
> > +
> > +	switch (xdp->command) {
> > +	case XDP_SETUP_PROG:
> > +		return ice_xdp_setup_prog(vsi, xdp->prog, xdp->extack);
> > +	case XDP_QUERY_PROG:
> > +		xdp->prog_id = vsi->xdp_prog ? vsi->xdp_prog->aux->id : 0;
> > +		return 0;
> > +	default:
> > +		NL_SET_ERR_MSG_MOD(xdp->extack, "Unknown XDP command");
> 
> Please drop the extack for unknown command, I'm concerned it will leak
> out somewhere where it's perfectly fine to ignore unknown commands.

Will do.

> 
> > +		return -EINVAL;
> > +	}
> > +}
> 
> > +/**
> > + * ice_run_xdp - Executes an XDP program on initialized xdp_buff
> > + * @rx_ring: Rx ring
> > + * @xdp: xdp_buff used as input to the XDP program
> > + * @xdp_prog: XDP program to run
> > + *
> > + * Returns any of ICE_XDP_{PASS, CONSUMED, TX, REDIR}
> > + */
> > +static int
> > +ice_run_xdp(struct ice_ring *rx_ring, struct xdp_buff *xdp,
> > +	    struct bpf_prog *xdp_prog)
> > +{
> > +	int err, result = ICE_XDP_PASS;
> > +	struct ice_ring *xdp_ring;
> > +	u32 act;
> > +
> > +	act = bpf_prog_run_xdp(xdp_prog, xdp);
> > +	switch (act) {
> > +	case XDP_PASS:
> > +		break;
> > +	case XDP_TX:
> > +		xdp_ring = rx_ring->vsi->xdp_rings[rx_ring->q_index];
> 
> Here you index the XDP ring with rx queue id but below ice_xdp_xmit()
> uses smp_processor_id(). That worries me a little. If TX and REDIRECT
> happens at the same time and rx->q_index != smp_processor_id() it could
> cause trouble, no?

Yeah and again i40e is affected. Let's stick to smp_processor_id() in both
cases.

> 
> > +		result = ice_xmit_xdp_buff(xdp, xdp_ring);
> > +		break;
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
> > +	return result;
> > +}
> > +
> > +/**
> > + * ice_xdp_xmit - submit packets to XDP ring for transmission
> > + * @dev: netdev
> > + * @n: number of XDP frames to be transmitted
> > + * @frames: XDP frames to be transmitted
> > + * @flags: transmit flags
> > + *
> > + * Returns number of frames successfully sent. Frames that fail are
> > + * free'ed via XDP return API.
> > + * For error cases, a negative errno code is returned and no-frames
> > + * are transmitted (caller must handle freeing frames).
> > + */
> > +int
> > +ice_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
> > +	     u32 flags)
> > +{
> > +	struct ice_netdev_priv *np = netdev_priv(dev);
> > +	unsigned int queue_index = smp_processor_id();
> > +	struct ice_vsi *vsi = np->vsi;
> > +	struct ice_ring *xdp_ring;
> > +	int drops = 0, i;
> > +
> > +	if (test_bit(__ICE_DOWN, vsi->state))
> > +		return -ENETDOWN;
> > +
> > +	if (!ice_is_xdp_ena_vsi(vsi) || queue_index >= vsi->num_xdp_txq)
> > +		return -ENXIO;
> > +
> > +	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
> > +		return -EINVAL;
> > +
> > +	xdp_ring = vsi->xdp_rings[queue_index];
> > +	for (i = 0; i < n; i++) {
> > +		struct xdp_frame *xdpf = frames[i];
> > +		int err;
> > +
> > +		err = ice_xmit_xdp_ring(xdpf->data, xdpf->len, xdp_ring);
> > +		if (err != ICE_XDP_TX) {
> > +			xdp_return_frame_rx_napi(xdpf);
> > +			drops++;
> > +		}
> > +	}
> > +
> > +	if (unlikely(flags & XDP_XMIT_FLUSH))
> > +		ice_xdp_ring_update_tail(xdp_ring);
> > +
> > +	return n - drops;
> > +}
> 
> > diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
> > index a914e603b2ed..f74ec83faa55 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_txrx.h
> > +++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
> > @@ -22,6 +22,16 @@
> >  #define ICE_RX_BUF_WRITE	16	/* Must be power of 2 */
> >  #define ICE_MAX_TXQ_PER_TXQG	128
> >  
> > +static inline __le64
> > +ice_build_ctob(u64 td_cmd, u64 td_offset, unsigned int size, u64 td_tag)
> > +{
> > +	return cpu_to_le64(ICE_TX_DESC_DTYPE_DATA |
> > +			   (td_cmd    << ICE_TXD_QW1_CMD_S) |
> > +			   (td_offset << ICE_TXD_QW1_OFFSET_S) |
> > +			   ((u64)size << ICE_TXD_QW1_TX_BUF_SZ_S) |
> > +			   (td_tag    << ICE_TXD_QW1_L2TAG1_S));
> > +}
> 
> Please move the build_ctob() rename to a separate patch. All changes
> which are not directly related to the objective of the patch make it
> harder to review.

Will do that.
