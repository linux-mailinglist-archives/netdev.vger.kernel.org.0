Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4948265292C
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 23:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234006AbiLTWtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 17:49:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233854AbiLTWtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 17:49:43 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108151A801;
        Tue, 20 Dec 2022 14:49:41 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id r2-20020a9d7cc2000000b006718a7f7fbaso8091160otn.2;
        Tue, 20 Dec 2022 14:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4KwK1yvYQTjObRGV/Ee2Veug/uu37QDLEY9vwWk0iOE=;
        b=AolKwaJSKC8sS4em3frVIuMXYrzfLQHoYk+FeqQDnjYu502+iebUYqfVXiGTPKJSkB
         5qabtuIeAECRWYZiUSEhKalMzFWxUezyhwlRhN0P+xI6gHvaTc2pSDWRu0dhTrF+0CCM
         ivjVuJTdCv7HP+mNPQJfyK3hFZVwoUc+j7bpejSaFl+ePu8tljeJqDr8p+AHBMREdbih
         masOmBNUGWotHla7ys1uTRzBA9l1ktpGUioRn0wfJSF/QTOKwJHeYZ4gVTQC+NHajC0o
         S+kFBNWhJaEYz+sjNRftUzKg+8voxI0mxrN4n4pRa9QF/mFGKPJXJVTMg/7/CbX6chvu
         K0rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4KwK1yvYQTjObRGV/Ee2Veug/uu37QDLEY9vwWk0iOE=;
        b=1SnIi+eZy7RloedTyBQLrR/r95NG6Eck61OXPn7IRfDq0MpHuIbweg4ZCb+qjNfWb5
         JhhcQi7miMOuWc0WTBgknwsnhXVdQDu1zVKxRfzyHvuWqBYRo6Pxr4dawWgnnNGyXieP
         0Qmt8K0Knq6YqpSaMryyRrssdMqxRu3MWOGj3KVmx7/L4o6SlgMUzS4vXn/79OwjxVY8
         up3z3B/MNeB/4I0K9RdDqIa1iGG7E6e1vLPAMOWBlX0rH6RO+V2V4ddAi2rkrBooIOZL
         NTToyFJ9cLkfR/S2+tbq258PiF+dihvZFtRRM8fgEsYnSIqqrVKxSR62c45Y/MkU4tMP
         Y2pg==
X-Gm-Message-State: ANoB5plnilxbf4ZqSiza9QDvUQVmXIhNLQ+G6qeKgU+Qk7XsKoos+Hum
        epDsOrxCwXaLzJ4yS8aEhS4xyYvlTNcEqH3v6WM=
X-Google-Smtp-Source: AA0mqf6z3OMKzFXJlDBOAeENAWyiR1f/A/gvjR3yMwURMujquGwsiM3nAMBBcaYeM906MmAut53X+CxQ9XjlDkAR/q4=
X-Received: by 2002:a05:6830:3890:b0:670:9045:f754 with SMTP id
 bq16-20020a056830389000b006709045f754mr2986309otb.87.1671576580360; Tue, 20
 Dec 2022 14:49:40 -0800 (PST)
MIME-Version: 1.0
References: <cover.1671462950.git.lorenzo@kernel.org> <43c340d440d8a87396198b301c5ffbf5ab56f304.1671462950.git.lorenzo@kernel.org>
 <20221219171321.7a67002b@kernel.org> <Y6F+YJSkI19m/kMv@lore-desk>
In-Reply-To: <Y6F+YJSkI19m/kMv@lore-desk>
From:   Marek Majtyka <alardam@gmail.com>
Date:   Tue, 20 Dec 2022 23:51:31 +0100
Message-ID: <CAAOQfrF963NoMhQUTdGXyzLMdAjHfUmvzvxpOL0A1Cv4NhY97w@mail.gmail.com>
Subject: Re: [RFC bpf-next 2/8] net: introduce XDP features flag
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, hawk@kernel.org,
        pabeni@redhat.com, edumazet@google.com, toke@redhat.com,
        memxor@gmail.com, saeedm@nvidia.com, anthony.l.nguyen@intel.com,
        gospo@broadcom.com, vladimir.oltean@nxp.com, nbd@nbd.name,
        john@phrozen.org, leon@kernel.org, simon.horman@corigine.com,
        aelior@marvell.com, christophe.jaillet@wanadoo.fr,
        ecree.xilinx@gmail.com, grygorii.strashko@ti.com, mst@redhat.com,
        bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 20, 2022 at 10:20 AM Lorenzo Bianconi
<lorenzo.bianconi@redhat.com> wrote:
>
> > On Mon, 19 Dec 2022 16:41:31 +0100 Lorenzo Bianconi wrote:
> > > +=====================
> > > +Netdev XDP features
> > > +=====================
> > > +
> > > + * XDP FEATURES FLAGS
> > > +
> > > +Following netdev xdp features flags can be retrieved over route netlink
> > > +interface (compact form) - the same way as netdev feature flags.
> >
> > How likely is it that I'll be able to convince you that cramming more
> > stuff in rtnl is a bad idea? I can convert this for you to a YAML-
> > -compatible genetlink family for you in a jiffy, just say yes :S
> >
> > rtnl is hard to parse, and already overloaded with random stuff.
> > And the messages are enormous.
>
> Hi Jakub,
>
> I am fine to use YAML for this, but I will let Marek comment since he is the
> original author of this patch.
>
> >
> > > +These features flags are read only and cannot be change at runtime.
> > > +
> > > +*  XDP_ABORTED
> > > +
> > > +This feature informs if netdev supports xdp aborted action.
> > > +
> > > +*  XDP_DROP
> > > +
> > > +This feature informs if netdev supports xdp drop action.
> > > +
> > > +*  XDP_PASS
> > > +
> > > +This feature informs if netdev supports xdp pass action.
> > > +
> > > +*  XDP_TX
> > > +
> > > +This feature informs if netdev supports xdp tx action.
> > > +
> > > +*  XDP_REDIRECT
> > > +
> > > +This feature informs if netdev supports xdp redirect action.
> > > +It assumes the all beforehand mentioned flags are enabled.
> > > +
> > > +*  XDP_SOCK_ZEROCOPY
> > > +
> > > +This feature informs if netdev driver supports xdp zero copy.
> > > +It assumes the all beforehand mentioned flags are enabled.
> >
> > Why is this "assumption" worth documenting?
>
> I guess we can remove it.
> @Marek: any comment?
>
> >
> > > +*  XDP_HW_OFFLOAD
> > > +
> > > +This feature informs if netdev driver supports xdp hw oflloading.
> > > +
> > > +*  XDP_TX_LOCK
> > > +
> > > +This feature informs if netdev ndo_xdp_xmit function requires locking.
> >
> > Why is it relevant to the user?
>
> Probably not, I kept it since it was in Marek's original patch.
> @Marek: any comment?
>
> >
> > > +*  XDP_REDIRECT_TARGET
> > > +
> > > +This feature informs if netdev implements ndo_xdp_xmit callback.
> >
> > Does it make sense to rename XDP_REDIRECT -> XDP_REDIRECT_SOURCE then?
>
> yes, naming is always hard :)
>
> >
> > > +*  XDP_FRAG_RX
> > > +
> > > +This feature informs if netdev implements non-linear xdp buff support in
> > > +the driver napi callback.
> >
> > Who's the target audience? Maybe FRAG is not the best name?
> > Scatter-gather or multi-buf may be more widely understood.
>
> ack, fine. I will rename it in the formal series.
>
> Regards,
> Lorenzo
>
> >
> > > +*  XDP_FRAG_TARGET
> > > +
> > > +This feature informs if netdev implements non-linear xdp buff support in
> > > +ndo_xdp_xmit callback. XDP_FRAG_TARGET requires XDP_REDIRECT_TARGET is properly
> > > +supported.
> >
Everybody is allowed to make a good use of it. Every improvement is
highly appreciated. Thanks Lorenzo for taking this over.
Regards
Marek
