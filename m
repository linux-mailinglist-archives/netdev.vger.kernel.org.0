Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6E16292B9
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 08:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbiKOHwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 02:52:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiKOHww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 02:52:52 -0500
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0871D0F0;
        Mon, 14 Nov 2022 23:52:51 -0800 (PST)
Received: by mail-pg1-f178.google.com with SMTP id q1so12554299pgl.11;
        Mon, 14 Nov 2022 23:52:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kZybfrF86Isnu1Sla8zVBFWj7ao5uvMkrnCtqwRprBM=;
        b=GIBF83ESPhpAGJZc4WUzStNWEqOcDE1E6/rtF1FPxQqOUhlcToklXPJKDFRcACTiYj
         PveElhxE0CRRH+1DTeX9ilom9MbcNCbEAZyEIsQ2jQakmDu7DHBodG0up3GQ577nhXLo
         OVnlaUQeeQnKuc8JWoPWWdDi8S50/mKDDR3eP7Qj2C8ofR7MKulQzZ5OCvCAborihR+u
         PTa8/Nyb7qiZMwmRxwrLDpnrPrRZFotEygW2tXsXkO3e7z5DNQnVueGWKLyDAEuBw1/d
         K9EPhkkYWvfQ4KRHKs7e99Fzb1iizh0I16P/yUVdRn0FG2TnQ5LTAa//LN6YH1XI1cC6
         5TMw==
X-Gm-Message-State: ANoB5plKKuFRUKDu77La+0lhUQKb8ZsxxCrIET4orIMmLri6OxRVavpB
        f2IKchua6LQ0utczRQyX7fcws+dy3f7Hx1KLZPw=
X-Google-Smtp-Source: AA0mqf41vXGArtfDSUyMswbfOLqJ1t1YqkneHkNvJ2EoA5l4fISCHPgoymwpBNQa/cVif7yIDFvjMLsgKQHVHbSAAaU=
X-Received: by 2002:a63:4d43:0:b0:41d:c892:2e9 with SMTP id
 n3-20020a634d43000000b0041dc89202e9mr14812125pgl.457.1668498770574; Mon, 14
 Nov 2022 23:52:50 -0800 (PST)
MIME-Version: 1.0
References: <20221111030838.1059-1-mailhol.vincent@wanadoo.fr>
 <20221113083404.86983-1-mailhol.vincent@wanadoo.fr> <20221114212718.76bd6c8b@kernel.org>
In-Reply-To: <20221114212718.76bd6c8b@kernel.org>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 15 Nov 2022 16:52:39 +0900
Message-ID: <CAMZ6RqJ-2_ymLiGuObmBLRDpNNy0ZpMCeRU2qgNPvq2oArnX8A@mail.gmail.com>
Subject: Re: [PATCH net-next v3] ethtool: doc: clarify what drivers can
 implement in their get_drvinfo()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Petr Machata <petrm@nvidia.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Amit Cohen <amcohen@nvidia.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        linux-kernel@vger.kernel.org,
        Leon Romanovsky <leonro@mellanox.com>,
        Leon Romanovsky <leonro@nvidia.com>
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

On Tue. 15 Nov. 2022 at 14:27, Jakub Kicinski <kuba@kernel.org> wrote:
> On Sun, 13 Nov 2022 17:34:04 +0900 Vincent Mailhol wrote:
> > - * Drivers should set at most @driver, @version, @fw_version and
> > - * @bus_info in their get_drvinfo() implementation.  The ethtool
> > - * core fills in the other fields using other driver operations.
> > + * Drivers should set at most @fw_version and @erom_version in their
> > + * get_drvinfo() implementation. The ethtool core fills in the other
> > + * fields using other driver operations.
>
> Can I still nit pick the working on v3? :)

Nitpicks are welcome!

> Almost half of the fields are not filled in by other operations,
> so how about we cut deeper? Even @erom_version is only filled in by
> a single driver, and pretty much deprecated

I do not like to say that it is "pretty much deprecated". Either it is
deprecated and we can start to clean things up, or it is not and
people can continue to use it. It is good to have a clear position,
whatever it is.

> (devlink is much more flexible for all FW version reporting and flashing).

Side note, I just started to study devlink.

> How about:
>
>  * Majority of the drivers should no longer implement this callback.
>  * Most fields are correctly filled in by the core using system
>  * information, or populated using other driver operations.

> * Majority of the drivers should no longer implement this callback.
                                                       ^^^^
In this context, "this callback" is not defined (there is no prior mention in
this struct doc). I will replace it with "the drv_info() callback".

I am fine to try to discourage the developper from implementing the
callback. But I still want a small note to state the facts (c.f. above
comment, unless we explicitly deprecate the drv_info(), I do not think
we should try to completely hide its existence).

What about this:


diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index dc2aa3d75b39..fe4d8dddb0a7 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -159,8 +159,10 @@ static inline __u32 ethtool_cmd_speed(const
struct ethtool_cmd *ep)
  *     in its bus driver structure (e.g. pci_driver::name).  Must
  *     not be an empty string.
  * @version: Driver version string; may be an empty string
- * @fw_version: Firmware version string; may be an empty string
- * @erom_version: Expansion ROM version string; may be an empty string
+ * @fw_version: Firmware version string; drivers can set it; may be an
+ *     empty string
+ * @erom_version: Expansion ROM version string; drivers can set it;
+ *     may be an empty string
  * @bus_info: Device bus address.  This should match the dev_name()
  *     string for the underlying bus device, if there is one.  May be
  *     an empty string.
@@ -180,9 +182,10 @@ static inline __u32 ethtool_cmd_speed(const
struct ethtool_cmd *ep)
  * Users can use the %ETHTOOL_GSSET_INFO command to get the number of
  * strings in any string set (from Linux 2.6.34).
  *
- * Drivers should set at most @driver, @version, @fw_version and
- * @bus_info in their get_drvinfo() implementation.  The ethtool
- * core fills in the other fields using other driver operations.
+ * Majority of the drivers should no longer implement the
+ * get_drvinfo() callback.  Most fields are correctly filled in by the
+ * core using system information, or populated using other driver
+ * operations.
  */
 struct ethtool_drvinfo {
        __u32   cmd;


Yours sincerely,
Vincent Mailhol
