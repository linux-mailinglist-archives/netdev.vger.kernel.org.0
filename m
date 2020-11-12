Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 767092B108B
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 22:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbgKLVrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 16:47:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbgKLVrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 16:47:04 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A4DFC0613D1;
        Thu, 12 Nov 2020 13:46:54 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id z2so6649723ilh.11;
        Thu, 12 Nov 2020 13:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gJQzehBuXm6C92Lj5elj4XU1FQdwGIcgz9/acmI2Ky0=;
        b=Coy+yN6EAmwsf0CqVZd+tstBGqGqE7dwwsuFlb5HS7W3LEcl6JVcuQZkb3xMfjdr5C
         nTflDyZhWOqgOW0HfRwfKpiu2ngMml5DL2A4q0Jsds5036VtYJqop06/+0xFhwZ3jQqn
         hanXcakqSUxsFrRn+hG1vU4Fp0Xt+Ybi7dNCA9OU9UmuNgJxiiriNHyZScuid8EGhHh/
         tKU+YprcHO9KQVd7Mq5F7YNh1LcBaFTHS93PNgXRdJfznD5q+6sDOm7sxJzC8w0rindQ
         m3WiJ3FEEVoxLAeAeUD7lJdKSFA/XJp0GY+qqxfp/eDpsDBardBUZWXiXiK2rSfzjg8s
         /p2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gJQzehBuXm6C92Lj5elj4XU1FQdwGIcgz9/acmI2Ky0=;
        b=RySP1TvPiwh87mY46H2gOW3y/JXNjmEN95h5+1JzKlyGCDkEvt0K/7t5c1aNU0fWfY
         62OVu7vxCZRjcuKROjaDgTQiRBsIOTLykxZfT+Voxk9WFHpSYDtOwNULmMtl4KQU0L/T
         n1sWDcxIIdojm+JdsPmu3AuwtAdF7f2l6vswMxy3mFT1qQX2vv4O71bPWX3IyArVkbtD
         S/mmL56OAquiekkdOqdPZQc7YPS/ASWYakeD05IXAir2QIE/c2X6e3MQ3+4iibtuW5L6
         wTneRXqzJooB1C1/M4J2nJThNh8MCw39itweWTL6jhE8Jz3mvEr8Db/E2tH8C+UQuL/A
         j+Og==
X-Gm-Message-State: AOAM532+ueM9k/xB3ll1MB46J0DAGgmGuZ6HEh2BpAZngQDa6sWiFtTu
        ui9ZPP2+9lavGjDMH5qT/eBfSuEWkyD8fZQ9vyI=
X-Google-Smtp-Source: ABdhPJzcZKY1Mte582qv4Rn5xjZqKg8ibVeHaz84xXHYDO/N9jRLhLGDm2DVU6X0suN37cmWlhOEzGTKEIvZMZYPo00=
X-Received: by 2002:a92:cb51:: with SMTP id f17mr1232420ilq.64.1605217612993;
 Thu, 12 Nov 2020 13:46:52 -0800 (PST)
MIME-Version: 1.0
References: <20201111071404.29620-1-naveenm@marvell.com> <20201111071404.29620-5-naveenm@marvell.com>
In-Reply-To: <20201111071404.29620-5-naveenm@marvell.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 12 Nov 2020 13:46:42 -0800
Message-ID: <CAKgT0UdeuvMAaMubMjFnUsBUCc5wgQQ6NC_pyHFGjZWN66k3=Q@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 04/13] octeontx2-af: Add mbox messages to
 install and delete MCAM rules
To:     Naveen Mamindlapalli <naveenm@marvell.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, saeed@kernel.org,
        sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, sbhatta@marvell.com, hkelam@marvell.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 11:22 PM Naveen Mamindlapalli
<naveenm@marvell.com> wrote:
>
> From: Subbaraya Sundeep <sbhatta@marvell.com>
>
> Added new mailbox messages to install and delete MCAM rules.
> These mailbox messages will be used for adding/deleting ethtool
> n-tuple filters by NIX PF. The installed MCAM rules are stored
> in a list that will be traversed later to delete the MCAM entries
> when the interface is brought down or when PCIe FLR is received.
> The delete mailbox supports deleting a single MCAM entry or range
> of entries or all the MCAM entries owned by the pcifunc. Each MCAM
> entry can be associated with a HW match stat entry if the mailbox
> requester wants to check the hit count for debugging.
>
> Modified adding default unicast DMAC match rule using install
> flow API. The default unicast DMAC match entry installed by
> Administrative Function is saved and can be changed later by the
> mailbox user to fit additional fields, or the default MCAM entry
> rule action can be used for other flow rules installed later.
>
> Modified rvu_mbox_handler_nix_lf_free mailbox to add a flag to
> disable or delete the MCAM entries. The MCAM entries are disabled
> when the interface is brought down and deleted in FLR handler.
> The disabled MCAM entries will be re-enabled when the interface
> is brought up again.
>
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>

A couple minor issues to address, called out in comments below.

> ---
>  drivers/net/ethernet/marvell/octeontx2/af/common.h |   2 +
>  drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  76 ++-
>  drivers/net/ethernet/marvell/octeontx2/af/npc.h    |  57 +-
>  drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  13 +
>  .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  19 +-
>  .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 217 ++++++-
>  .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 721 +++++++++++++++++++++
>  .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  12 +-
>  8 files changed, 1065 insertions(+), 52 deletions(-)
>

<snip>

> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
> index eb4eaa7ece3a..a7759ecfa586 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
> @@ -219,7 +219,7 @@ static int npc_get_nixlf_mcam_index(struct npc_mcam *mcam,
>         return npc_get_ucast_mcam_index(mcam, pcifunc, nixlf);
>  }
>
> -static int npc_get_bank(struct npc_mcam *mcam, int index)
> +int npc_get_bank(struct npc_mcam *mcam, int index)
>  {
>         int bank = index / mcam->banksize;
>
> @@ -241,8 +241,8 @@ static bool is_mcam_entry_enabled(struct rvu *rvu, struct npc_mcam *mcam,
>         return (cfg & 1);
>  }
>
> -static void npc_enable_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
> -                                 int blkaddr, int index, bool enable)
> +void npc_enable_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
> +                          int blkaddr, int index, bool enable)
>  {
>         int bank = npc_get_bank(mcam, index);
>         int actbank = bank;
> @@ -359,6 +359,41 @@ static void npc_get_keyword(struct mcam_entry *entry, int idx,
>         *cam0 = ~*cam1 & kw_mask;
>  }
>
> +static void npc_get_default_entry_action(struct rvu *rvu, struct npc_mcam *mcam,
> +                                        int blkaddr, int index,
> +                                        struct mcam_entry *entry)
> +{
> +       u16 owner, target_func;
> +       struct rvu_pfvf *pfvf;
> +       int bank, nixlf;
> +       u64 rx_action;
> +
> +       owner = mcam->entry2pfvf_map[index];
> +       target_func = (entry->action >> 4) & 0xffff;
> +       /* return incase target is PF or LBK or rule owner is not PF */
> +       if (is_afvf(target_func) || (owner & RVU_PFVF_FUNC_MASK) ||
> +           !(target_func & RVU_PFVF_FUNC_MASK))
> +               return;
> +
> +       pfvf = rvu_get_pfvf(rvu, target_func);
> +       mcam->entry2target_pffunc[index] = target_func;
> +       /* return if nixlf is not attached or initialized */
> +       if (!is_nixlf_attached(rvu, target_func) || !pfvf->def_ucast_rule)
> +               return;
> +
> +       /* get VF ucast entry rule */
> +       nix_get_nixlf(rvu, target_func, &nixlf, NULL);
> +       index = npc_get_nixlf_mcam_index(mcam, target_func,
> +                                        nixlf, NIXLF_UCAST_ENTRY);
> +       bank = npc_get_bank(mcam, index);
> +       index &= (mcam->banksize - 1);
> +
> +       rx_action = rvu_read64(rvu, blkaddr,
> +                              NPC_AF_MCAMEX_BANKX_ACTION(index, bank));
> +       if (rx_action)
> +               entry->action = rx_action;
> +}
> +
>  static void npc_config_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
>                                   int blkaddr, int index, u8 intf,
>                                   struct mcam_entry *entry, bool enable)
> @@ -406,6 +441,11 @@ static void npc_config_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
>                             NPC_AF_MCAMEX_BANKX_CAMX_W1(index, bank, 0), cam0);
>         }
>
> +       /* copy VF default entry action to the VF mcam entry */
> +       if (intf == NIX_INTF_RX && actindex < mcam->bmap_entries)
> +               npc_get_default_entry_action(rvu, mcam, blkaddr, actindex,
> +                                            entry);
> +
>         /* Set 'action' */
>         rvu_write64(rvu, blkaddr,
>                     NPC_AF_MCAMEX_BANKX_ACTION(index, actbank), entry->action);
> @@ -473,11 +513,12 @@ void rvu_npc_install_ucast_entry(struct rvu *rvu, u16 pcifunc,
>                                  int nixlf, u64 chan, u8 *mac_addr)
>  {
>         struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
> +       u8 mac_mask[] = { [0 ... ETH_ALEN] = 0xFF };

Is this supposed to be a 7 byte long array? I assume that is what is
meant by the 0 ... ETH_ALEN which would imply it covers entries 0 - 6.
This might be better as:
        u8 mac_mask[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };

> +       struct npc_install_flow_req req = { 0 };
> +       struct npc_install_flow_rsp rsp = { 0 };
>         struct npc_mcam *mcam = &rvu->hw->mcam;

Since the mcam line is longer normally it should be before the 2 new
lines in order to maintain the reverse xmas tree format.

> -       struct mcam_entry entry = { {0} };
>         struct nix_rx_action action;
> -       int blkaddr, index, kwi;
> -       u64 mac = 0;
> +       int blkaddr, index;
>
>         /* AF's VFs work in promiscuous mode */
>         if (is_afvf(pcifunc))
> @@ -487,20 +528,9 @@ void rvu_npc_install_ucast_entry(struct rvu *rvu, u16 pcifunc,
>         if (blkaddr < 0)
>                 return;
>
> -       for (index = ETH_ALEN - 1; index >= 0; index--)
> -               mac |= ((u64)*mac_addr++) << (8 * index);
> -
>         index = npc_get_nixlf_mcam_index(mcam, pcifunc,
>                                          nixlf, NIXLF_UCAST_ENTRY);
>
> -       /* Match ingress channel and DMAC */
> -       entry.kw[0] = chan;
> -       entry.kw_mask[0] = 0xFFFULL;
> -
> -       kwi = NPC_PARSE_RESULT_DMAC_OFFSET / sizeof(u64);
> -       entry.kw[kwi] = mac;
> -       entry.kw_mask[kwi] = BIT_ULL(48) - 1;
> -
>         /* Don't change the action if entry is already enabled
>          * Otherwise RSS action may get overwritten.
>          */
> @@ -513,20 +543,20 @@ void rvu_npc_install_ucast_entry(struct rvu *rvu, u16 pcifunc,
>                 action.pf_func = pcifunc;
>         }
>
> -       entry.action = *(u64 *)&action;
> -       npc_config_mcam_entry(rvu, mcam, blkaddr, index,
> -                             pfvf->nix_rx_intf, &entry, true);
> -
> -       /* add VLAN matching, setup action and save entry back for later */
> -       entry.kw[0] |= (NPC_LT_LB_STAG_QINQ | NPC_LT_LB_CTAG) << 20;
> -       entry.kw_mask[0] |= (NPC_LT_LB_STAG_QINQ & NPC_LT_LB_CTAG) << 20;
> +       req.default_rule = 1;
> +       ether_addr_copy(req.packet.dmac, mac_addr);
> +       ether_addr_copy(req.mask.dmac, mac_mask);

If this is all you were using the mac_mask for you could probably just
use a memset here to achieve the same thing and save yourself the
trouble of allocating the mac_mask. See eth_broadcast_addr().

> +       req.features = BIT_ULL(NPC_DMAC);
> +       req.channel = chan;
> +       req.intf = pfvf->nix_rx_intf;
> +       req.op = action.op;
> +       req.hdr.pcifunc = 0; /* AF is requester */
> +       req.vf = action.pf_func;
> +       req.index = action.index;
> +       req.match_id = action.match_id;
> +       req.flow_key_alg = action.flow_key_alg;
>
> -       entry.vtag_action = VTAG0_VALID_BIT |
> -                           FIELD_PREP(VTAG0_TYPE_MASK, 0) |
> -                           FIELD_PREP(VTAG0_LID_MASK, NPC_LID_LA) |
> -                           FIELD_PREP(VTAG0_RELPTR_MASK, 12);
> -
> -       memcpy(&pfvf->entry, &entry, sizeof(entry));
> +       rvu_mbox_handler_npc_install_flow(rvu, &req, &rsp);
>  }
>

<snip>

> +static void npc_update_flow(struct rvu *rvu, struct mcam_entry *entry,
> +                           u64 features, struct flow_msg *pkt,
> +                           struct flow_msg *mask,
> +                           struct rvu_npc_mcam_rule *output, u8 intf)
> +{
> +       u64 dmac_mask = ether_addr_to_u64(mask->dmac);
> +       u64 smac_mask = ether_addr_to_u64(mask->smac);
> +       u64 dmac_val = ether_addr_to_u64(pkt->dmac);
> +       u64 smac_val = ether_addr_to_u64(pkt->smac);
> +       struct flow_msg *opkt = &output->packet;
> +       struct flow_msg *omask = &output->mask;
> +
> +       if (!features)
> +               return;
> +
> +#define NPC_WRITE_FLOW(field, member, val_lo, val_hi, mask_lo, mask_hi)              \
> +do {                                                                         \
> +       if (features & BIT_ULL((field))) {                                    \
> +               npc_update_entry(rvu, (field), entry, (val_lo), (val_hi),     \
> +                                (mask_lo), (mask_hi), intf);                 \
> +               memcpy(&opkt->member, &pkt->member, sizeof(pkt->member));     \
> +               memcpy(&omask->member, &mask->member, sizeof(mask->member));  \
> +       }                                                                     \
> +} while (0)
> +

The placement of this macro seems wierd to me. Either it needs to be
boe moved before the function declaration, or it should be defined
where it is used instead of this block above it.

> +       /* For tcp/udp/sctp LTYPE should be present in entry */
> +       if (features & (BIT_ULL(NPC_SPORT_TCP) | BIT_ULL(NPC_DPORT_TCP)))
> +               npc_update_entry(rvu, NPC_LD, entry, NPC_LT_LD_TCP,
> +                                0, ~0ULL, 0, intf);
> +       if (features & (BIT_ULL(NPC_SPORT_UDP) | BIT_ULL(NPC_DPORT_UDP)))
> +               npc_update_entry(rvu, NPC_LD, entry, NPC_LT_LD_UDP,
> +                                0, ~0ULL, 0, intf);
> +       if (features & (BIT_ULL(NPC_SPORT_SCTP) | BIT_ULL(NPC_DPORT_SCTP)))
> +               npc_update_entry(rvu, NPC_LD, entry, NPC_LT_LD_SCTP,
> +                                0, ~0ULL, 0, intf);
> +
> +       if (features & BIT_ULL(NPC_OUTER_VID))
> +               npc_update_entry(rvu, NPC_LB, entry,
> +                                NPC_LT_LB_STAG_QINQ | NPC_LT_LB_CTAG, 0,
> +                                NPC_LT_LB_STAG_QINQ & NPC_LT_LB_CTAG, 0, intf);
> +
> +       NPC_WRITE_FLOW(NPC_DMAC, dmac, dmac_val, 0, dmac_mask, 0);
> +       NPC_WRITE_FLOW(NPC_SMAC, smac, smac_val, 0, smac_mask, 0);
> +       NPC_WRITE_FLOW(NPC_ETYPE, etype, ntohs(pkt->etype), 0,
> +                      ntohs(mask->etype), 0);
> +       NPC_WRITE_FLOW(NPC_SIP_IPV4, ip4src, ntohl(pkt->ip4src), 0,
> +                      ntohl(mask->ip4src), 0);
> +       NPC_WRITE_FLOW(NPC_DIP_IPV4, ip4dst, ntohl(pkt->ip4dst), 0,
> +                      ntohl(mask->ip4dst), 0);
> +       NPC_WRITE_FLOW(NPC_SPORT_TCP, sport, ntohs(pkt->sport), 0,
> +                      ntohs(mask->sport), 0);
> +       NPC_WRITE_FLOW(NPC_SPORT_UDP, sport, ntohs(pkt->sport), 0,
> +                      ntohs(mask->sport), 0);
> +       NPC_WRITE_FLOW(NPC_DPORT_TCP, dport, ntohs(pkt->dport), 0,
> +                      ntohs(mask->dport), 0);
> +       NPC_WRITE_FLOW(NPC_DPORT_UDP, dport, ntohs(pkt->dport), 0,
> +                      ntohs(mask->dport), 0);
> +       NPC_WRITE_FLOW(NPC_SPORT_SCTP, sport, ntohs(pkt->sport), 0,
> +                      ntohs(mask->sport), 0);
> +       NPC_WRITE_FLOW(NPC_DPORT_SCTP, dport, ntohs(pkt->dport), 0,
> +                      ntohs(mask->dport), 0);
> +
> +       NPC_WRITE_FLOW(NPC_OUTER_VID, vlan_tci, ntohs(pkt->vlan_tci), 0,
> +                      ntohs(mask->vlan_tci), 0);
> +
> +       npc_update_ipv6_flow(rvu, entry, features, pkt, mask, output, intf);
> +}
> +
