Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D35E546FA7
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 00:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346799AbiFJWbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 18:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245351AbiFJWbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 18:31:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB23E0AD;
        Fri, 10 Jun 2022 15:31:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D13861DE0;
        Fri, 10 Jun 2022 22:31:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64D5C3411F;
        Fri, 10 Jun 2022 22:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654900290;
        bh=AVfCC1fETxPTgXCRwrza1gBNxP00l26r7VULa0HXKGQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=g5Gjy3Sf7Clm90OoqDorPxtXtST43OI2tVXPJ+r7EaNqD+bhOYdZTE8oBRFj8LJ01
         KKYBTm4JgqXuwVYuViZnct8LDUi5euGhvhIqTVmSkvrnRL4Y4kq9Q3Ti5CIa7FsxCA
         B+qDYAuBjegcGaYSsAE8DI99UiQ+TztPAXqzxB+yqL9vYdr4u8IiDwUBGzPUXQv3yV
         e5RVv46GproAAtFqhR49Q193CkPKgoz+Gz5cW1JHnjnrlmJj/8lhafS1dC08fxt3SY
         kZw8RTyzPsPlLXA6KzwNDwGO/AyEa/WRTp2JwbtlO5/SoZrSwlRXg6r34vA1aoiw1U
         k3CJRx58ITkrA==
Received: by mail-ua1-f47.google.com with SMTP id 63so109354uaw.10;
        Fri, 10 Jun 2022 15:31:30 -0700 (PDT)
X-Gm-Message-State: AOAM53380tadOB10fpRWyT8qcjiQIkFjc7ZNYkHVGTifA9CFmLPuWPU5
        GXVbP+j+C3PXxFxSkcpzqLxPXZ/YUT0SJEKeIA==
X-Google-Smtp-Source: ABdhPJx3xQ8ITVyyWAJdAJwirIobVRExZF94y1CEM3afCD1tLwr7d4qzVRC8E6iM9JYc3WVITj9nOAXj0yWWHpoRKqE=
X-Received: by 2002:ab0:7546:0:b0:374:ac43:ba1a with SMTP id
 k6-20020ab07546000000b00374ac43ba1amr19128032uaq.86.1654900289749; Fri, 10
 Jun 2022 15:31:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220315123315.233963-1-ioana.ciornei@nxp.com>
In-Reply-To: <20220315123315.233963-1-ioana.ciornei@nxp.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Fri, 10 Jun 2022 16:31:18 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLtXJ7HaRuDNGs9rfGWrTBb3dkc2hesduA0Gvs0e1OvFQ@mail.gmail.com>
Message-ID: <CAL_JsqLtXJ7HaRuDNGs9rfGWrTBb3dkc2hesduA0Gvs0e1OvFQ@mail.gmail.com>
Subject: Re: [PATCH net-next] dt-bindings: net: convert sff,sfp to dtschema
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 6:33 AM Ioana Ciornei <ioana.ciornei@nxp.com> wrote:
>
> Convert the sff,sfp.txt bindings to the DT schema format.
>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
>  .../devicetree/bindings/net/sff,sfp.txt       |  85 ------------
>  .../devicetree/bindings/net/sff,sfp.yaml      | 130 ++++++++++++++++++
>  MAINTAINERS                                   |   1 +
>  3 files changed, 131 insertions(+), 85 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/sff,sfp.txt
>  create mode 100644 Documentation/devicetree/bindings/net/sff,sfp.yaml

Going to respin this patch? I don't normally care too much, but this
one is high (86 occurrences on arm64 dtbs) on my list of compatibles
without schemas and is generic.

Rob
