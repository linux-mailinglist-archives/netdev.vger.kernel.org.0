Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC7864B71A
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 15:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235882AbiLMOQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 09:16:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235832AbiLMOQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 09:16:18 -0500
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A008A20BCF;
        Tue, 13 Dec 2022 06:15:00 -0800 (PST)
Received: by mail-pj1-f46.google.com with SMTP id js9so3542079pjb.2;
        Tue, 13 Dec 2022 06:15:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ps5uZAUuWjeHp0nRpK9UhOLpr3IlPI5fPiCauyAdajE=;
        b=J9r22i03DCWBFUPeNuUTf0oF1VmFeU+rIvoEcxvDUc3NUNSolNN/S+wlqVVG7WqtL0
         4ADpa7xH3Nxkinu/JuccBjDMQLa5hUwgvmlepUu3PBQTRvayfbT0MTflL5Z+k2bgXVg1
         z8O8Wqj6qKqtu8/Sk3rFPlJrKBV9phq1D4FlIdBLqOn+M6i+Wd1N22yvRl9vyjftaO51
         ie1+Ob2c5ecd6bRwLHkXTMvLYZYYZlN6I0/HUQG/zwqTCifzJLYH8OiaS984qh+C8YBr
         5HdapWl2ph4YAuTzoiMKLjs5C3k/tso8gXKEJQuS7UP0vmCctjlHeVSLvy5/FiRCMT22
         OHgA==
X-Gm-Message-State: ANoB5pmTBRMXxKikAW85sTZ3+8cztVhADNUrS2HFKfymP5WbWpaPPZIU
        BtWSqG3JiL6hHhmJphtD1wGvc6BQTkuDioA/LC8=
X-Google-Smtp-Source: AA0mqf7xG0f7BfAcXiF0riEYipevRTIgj/IwtJB8yZ8YXCAU7NAOUWaPcsnNL7BIuFc/u/r4MthsjDh1YUCyqPRhyFQ=
X-Received: by 2002:a17:903:452:b0:189:6574:7ac2 with SMTP id
 iw18-20020a170903045200b0018965747ac2mr66376173plb.65.1670940900044; Tue, 13
 Dec 2022 06:15:00 -0800 (PST)
MIME-Version: 1.0
References: <20221213153708.4f38a7cf@canb.auug.org.au> <20221213051136.721887-1-mailhol.vincent@wanadoo.fr>
 <20221213133954.f2msxale6a37bvvo@pengutronix.de>
In-Reply-To: <20221213133954.f2msxale6a37bvvo@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 13 Dec 2022 23:14:48 +0900
Message-ID: <CAMZ6Rq+w3ZG5Y=6m+dFL_p3WLUFUkLKarj253nWu9q3+-GOH6Q@mail.gmail.com>
Subject: Re: [PATCH] Documentation: devlink: add missing toc entry for
 etas_es58x devlink doc
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 13 Dec. 2022 at 22:39, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 13.12.2022 14:11:36, Vincent Mailhol wrote:
> > toc entry is missing for etas_es58x devlink doc and triggers this warning:
> >
> >   Documentation/networking/devlink/etas_es58x.rst: WARNING: document isn't included in any toctree
> >
> > Add the missing toc entry.
> >
> > Fixes: 9f63f96aac92 ("Documentation: devlink: add devlink documentation for the etas_es58x driver")
> > Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
>
> Added to linux-can-next + added Reported-bys.

Thanks :)

FYI, I now have access to a build environment. I confirmed that this
patch fixes the warning.

Yours sincerely,
Vincent Mailhol
