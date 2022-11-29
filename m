Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA25B63BD19
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 10:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbiK2Jhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 04:37:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiK2Jhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 04:37:53 -0500
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026FE29815;
        Tue, 29 Nov 2022 01:37:53 -0800 (PST)
Received: by mail-pl1-f172.google.com with SMTP id k7so12838719pll.6;
        Tue, 29 Nov 2022 01:37:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q+AGSUb4FRLyd7s2US6m9NjBG7l9wn0Ll8edLLRQmpU=;
        b=maMOpqkzTRX349+LKxNQN3z0BKWmATNFMQ6dUtvfXuGUJTa9DBjDYwBe6ID6I5Tqeu
         p5o5vvQB3Bg63TBnR1CV/Z7M0NI0jRbIHpkJI9A4p3+5s8pg6F5GrjWVSTYtmLPj/DYF
         IoOLfVkq2IthZP2J/09x8pl7xRv6YfszV2dPNfWpx0FcGJ/DWUc1crmWefT+MelazfnE
         HEvr4aLblFb9WywCI9+h6hcSql2XzOeruUTHXSTXxQpgBZlwghmR0gZOcTjGu5eKMdBe
         3TO65JGTbj/YDd7Uk+Msbyau8xnspnQAAI1Wc99c8/0bIBvG+4KPXwvzgTjsSxC2BoNl
         vqyQ==
X-Gm-Message-State: ANoB5pm66IX6up5Sz1olCSK+qyBtLVliLFQRCCkuR08qwOclV1u555T/
        CZULL8FOnqjc6Tu/8Vn/eqpAHxvfEXgu+Fzun1g=
X-Google-Smtp-Source: AA0mqf7WfI50hoerRcgf3B/Jf6GLxqEsRVWE+x+RBOR4VhqxVFXsP3t8iwfzE3TOjubAK9pXbOzPm3C5PvcYml5Z24M=
X-Received: by 2002:a17:903:452:b0:189:6574:7ac2 with SMTP id
 iw18-20020a170903045200b0018965747ac2mr22126393plb.65.1669714672421; Tue, 29
 Nov 2022 01:37:52 -0800 (PST)
MIME-Version: 1.0
References: <20221129000550.3833570-1-mailhol.vincent@wanadoo.fr>
 <20221129000550.3833570-3-mailhol.vincent@wanadoo.fr> <Y4XCCl6F+N2w+ngn@nanopsycho>
In-Reply-To: <Y4XCCl6F+N2w+ngn@nanopsycho>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 29 Nov 2022 18:37:41 +0900
Message-ID: <CAMZ6RqJnxkDmMtXSvUF2aondZ_8BGYq4XL35Cg7Vxy9qqsfAeg@mail.gmail.com>
Subject: Re: [PATCH net-next v5 2/4] net: devlink: remove devlink_info_driver_name_put()
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Dimitris Michailidis <dmichail@fungible.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Shannon Nelson <snelson@pensando.io>, drivers@pensando.io,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Vadim Fedorenko <vadfed@fb.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vadim Pasternak <vadimp@mellanox.com>,
        Shalom Toledo <shalomt@mellanox.com>,
        linux-crypto@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-rdma@vger.kernel.org, oss-drivers@corigine.com,
        Jiri Pirko <jiri@mellanox.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hao Chen <chenhao288@hisilicon.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Shijith Thotton <sthotton@marvell.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 29 Nov. 2022 at 17:25, Jiri Pirko <jiri@resnulli.us> wrote:
> Tue, Nov 29, 2022 at 01:05:48AM CET, mailhol.vincent@wanadoo.fr wrote:
> >Now that the core sets the driver name attribute, drivers are not
> >supposed to call devlink_info_driver_name_put() anymore. Remove it.
> >
> >Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
>
> I agree with Jacob that this could be easily squashed to the previous
> patch. One way or another:

OK. Let's have the majority decide: I will squash patches 1 and 2 and send a v6.

> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Thank you for the review.
