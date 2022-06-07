Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE4B53F89F
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 10:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238452AbiFGIut convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 7 Jun 2022 04:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238794AbiFGIuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 04:50:11 -0400
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923C1F04;
        Tue,  7 Jun 2022 01:49:41 -0700 (PDT)
Received: by mail-yb1-f179.google.com with SMTP id w2so30005219ybi.7;
        Tue, 07 Jun 2022 01:49:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rntn/tCRx1lKBz+y/6qXmacJXp7/iYXkar6tLR/7k/M=;
        b=RSiU2YF/CtlT3NCxAWRTTViQ0i0Iw7rv6GOipEAQermpmGbgnKLZLaYYkvQ2sbnD1R
         tM3QcRvOtJPDS6m00koskGV4sAjX0/xKOd5UGE2/7IgSAcYUM+RtmLQKgBvcNGr4Mejv
         Sx5QMzLWhZ3d1hLAfmUJuLtCgMwqxLBK2Y0NRNV+iPRz0L41RcKlWk/ffe4JL5PbLdWj
         F7BPZRjRKk0xrxouW5luQipbl3VDvCocYGW6sEpweqnwXvznMHIyCoDBQYie/VqGZsnB
         6m4ENEHhpmuMzjqp6y3T8ZLmPGSuTpNXTjotIVCfv9bPX/0h+qxA1XPVmERX5+gjq1j+
         vwQw==
X-Gm-Message-State: AOAM5321TVgzX+aeIYP5rX2m66eujlf0PhsSaaSa+fB+nR+pqSImMo8Q
        leDoMaxHoeL264CG8QJ/TyiJJWwVLORNE7O2/olYx8EJ+HI=
X-Google-Smtp-Source: ABdhPJwWWRPNwbUCUePbec/w4+tOfNMuOQ+dvHHeMqQL11PvXfqLmCR/ywlVEJb7EpGz0GBcU5Z6C0Ln7Bi4GtQfjdI=
X-Received: by 2002:a25:9841:0:b0:663:eaf2:4866 with SMTP id
 k1-20020a259841000000b00663eaf24866mr291844ybo.381.1654591780761; Tue, 07 Jun
 2022 01:49:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220604163000.211077-1-mailhol.vincent@wanadoo.fr> <2e8666f3-1bd9-8610-6b72-e56e669d3484@hartkopp.net>
 <CAMZ6RqKWUyf6dZmxG809-yvjg5wbLwPSLtEfv-MgPpJ5ra=iGQ@mail.gmail.com> <20220607071305.olsrshjqtmkrp5et@pengutronix.de>
In-Reply-To: <20220607071305.olsrshjqtmkrp5et@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 7 Jun 2022 17:49:29 +0900
Message-ID: <CAMZ6RqK9cN9y3gtMCBc-NYmGT15ArvHU60KK6RyWp9dkA+WNLA@mail.gmail.com>
Subject: Re: [PATCH v5 0/7] can: refactoring of can-dev module and of Kbuild
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-can <linux-can@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Max Staudt <max@enpas.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 7 Jun. 2022 at 16:13, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 07.06.2022 11:49:30, Vincent MAILHOL wrote:
> [...]
> > So I think that the diagram is correct. Maybe rephrasing the cover
> > letter as below would address your concerns?
>
> BTW: I got the OK from Jakub to send PR with merges.
>
> If you think the cover letter needs rephrasing, send a new series and
> I'm going to force push that over can-next/master. After that let's
> consider can-next/master as fast-forward only.

I will first wait for Oliver’s feedback. Once we are aligned, I can do
the v6 and I really hope that would be the last one.
