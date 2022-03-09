Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4014D3725
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235250AbiCIQhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:37:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234340AbiCIQdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:33:52 -0500
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A96376E06;
        Wed,  9 Mar 2022 08:29:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1646843160;
    s=strato-dkim-0002; d=fpond.eu;
    h=Subject:References:In-Reply-To:Message-ID:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=Uq80fOiGqpSIpwp9BdSSfbQcuCBRb30aYGTDHn4N09c=;
    b=VgCPa6fg5PmIfnCObiaXGdc1Fq5FiOFuYVHYeJ/Oy8QmxuJl6Qshy5DkeSmSA3Wml8
    r9sDlGGbFgGs9i+ZP+SuLIbi9Se5D7Ehfjqbo5mPsLt9xk39H+daEhopHQ7KJku2IsPU
    FMPzEbM900pFBerXxI/vP/0jSnPkjahUWoC2iY3jCHBMyNlRTvQvK9qguaCNEGVngM99
    myrTZeeFIpZg3Bh0hwCD3RBhls0YsisjZhgrOHbFNE6CZeAIYGPmccGQLkHUEyHvWjuv
    MKa5TaRTtgidolIWEPAxaO/jUbcG1AIesMcgMqHzMFLoAM8hzFLn9Y6M0N2seeQSmlZR
    4BcA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73amq+g13rqGzvv3qxio1R8fCs/87J3I0="
X-RZG-CLASS-ID: mo00
Received: from oxapp05-03.back.ox.d0m.de
    by smtp-ox.front (RZmta 47.40.1 AUTH)
    with ESMTPSA id 646b0ey29GPxJW3
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
    Wed, 9 Mar 2022 17:25:59 +0100 (CET)
Date:   Wed, 9 Mar 2022 17:25:59 +0100 (CET)
From:   Ulrich Hecht <uli@fpond.eu>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Ulrich Hecht <uli+renesas@fpond.eu>
Cc:     linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, linux-can@vger.kernel.org,
        prabhakar.mahadev-lad.rj@bp.renesas.com,
        biju.das.jz@bp.renesas.com, wsa@kernel.org,
        yoshihiro.shimoda.uh@renesas.com, wg@grandegger.com,
        mkl@pengutronix.de, kuba@kernel.org, socketcan@hartkopp.net,
        geert@linux-m68k.org, kieran.bingham@ideasonboard.com
Message-ID: <616372185.25555.1646843159934@webmail.strato.com>
In-Reply-To: <CAMZ6RqK_39QmvZAjBZhoH2qbbmws9ac4JgrayR=d5m5p+e39XA@mail.gmail.com>
References: <20220209163806.18618-1-uli+renesas@fpond.eu>
 <20220209163806.18618-2-uli+renesas@fpond.eu>
 <CAMZ6RqK_39QmvZAjBZhoH2qbbmws9ac4JgrayR=d5m5p+e39XA@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] can: rcar_canfd: Add support for r8a779a0 SoC
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.5-Rev39
X-Originating-Client: open-xchange-appsuite
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your review!

> On 02/14/2022 8:10 AM Vincent MAILHOL <mailhol.vincent@wanadoo.fr> wrote:
> > -#define RCANFD_GERFL_ERR(gpriv, x)     ((x) & (RCANFD_GERFL_EEF1 |\
> > -                                       RCANFD_GERFL_EEF0 | RCANFD_GERFL_MES |\
> > -                                       (gpriv->fdmode ?\
> > -                                        RCANFD_GERFL_CMPOF : 0)))
> > +#define RCANFD_GERFL_ERR(x)            ((x) & (reg_v3u(gpriv, RCANFD_GERFL_EEF0_7, \
> > +                                       RCANFD_GERFL_EEF0 | RCANFD_GERFL_EEF1) | \
> > +                                       RCANFD_GERFL_MES | ((gpriv)->fdmode ? \
> > +                                       RCANFD_GERFL_CMPOF : 0)))
> 
> Instead of packing everything on the right, I suggest putting in a bit more air.
> Something like that:
> 
> #define RCANFD_GERFL_ERR(x)                                             \
>         ((x) & (reg_v3u(gpriv, RCANFD_GERFL_EEF0_7,                     \
>                         RCANFD_GERFL_EEF0 | RCANFD_GERFL_EEF1) |        \
>                 RCANFD_GERFL_MES |                                      \
>                 ((gpriv)->fdmode ? RCANFD_GERFL_CMPOF : 0)))
> 
> Same comment applies to other macros.

That does indeed look a lot better.

> >  /* Helper functions */
> > +static inline bool is_v3u(struct rcar_canfd_global *gpriv)
> > +{
> > +       return gpriv->chip_id == RENESAS_R8A779A0;
> > +}
> > +
> > +static inline u32 reg_v3u(struct rcar_canfd_global *gpriv,
> > +                         u32 v3u, u32 not_v3u)
> > +{
> > +       return is_v3u(gpriv) ? v3u : not_v3u;
> > +}
> 
> Nitpick but I would personally prefer if is_v3u() and reg_v3u()
> were declared before the macros in which they are being used.

So would I, but that would require extensive reshuffling of the code, which I think is not worth the effort for such a minor issue.

> > +               if (is_v3u(gpriv)) {
> > +                       cfg = (RCANFD_NCFG_NTSEG1(tseg1) |
> > +                              RCANFD_NCFG_NBRP(brp) |
> > +                              RCANFD_NCFG_NSJW(sjw) |
> > +                              RCANFD_NCFG_NTSEG2(tseg2));
> > +               } else {
> > +                       cfg = (RCANFD_CFG_TSEG1(tseg1) |
> > +                              RCANFD_CFG_BRP(brp) |
> > +                              RCANFD_CFG_SJW(sjw) |
> > +                              RCANFD_CFG_TSEG2(tseg2));
> > +               }
> 
> Nitpick: can't you use one of your reg_v3u() functions here?
> |        cfg = reg_v3u(gpriv, ..., ...)?

Technically yes, but I think of reg_v3u() as choosing between two register layouts, and this is something else.

CU
Uli
