Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F94E6197E0
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 14:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbiKDNaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 09:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbiKDNaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 09:30:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027862C655
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 06:30:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 749D5621D3
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 13:30:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB9DC433D6
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 13:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667568602;
        bh=p7NYPLDiMSVaPBbSaZ1LqtGh/rbhJgrtL9eOGGAj+M4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lU6+h7Gx0xXyF6ybd/DqamBcjsBjmuzmZZUTJA2CA7a4bjEjRGokAXbMWC7CFfUdH
         1vqXbgUMRHEH2blFPZEMqzdnfh9thJXRYsh8+4CNORQk/rMOpO+ZSxQ6bS+BDVfj2w
         4uco7R75uDVj75/vYknOQaAHZB1DlHEOqj+g2cwdnrnDpeiaRa1PmR8evp+HKIPsxf
         R6qJEaO7xOr/620AKBc+8n+ZJYKvaoTHHasL23pHZ9W8f0XeNCBPP4Dq4SaDgwJ59q
         GyYoBJ2zp+ECZyVRCPMOCT+lLXN294hjf1H/vUG2JcfxR0oIrHSe8VCv+TterVV9bQ
         kar8cFFkP/bUg==
Received: by mail-lf1-f45.google.com with SMTP id b3so7439591lfv.2
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 06:30:02 -0700 (PDT)
X-Gm-Message-State: ACrzQf0HccVFXnztWMnPBJuJcUs2oK1uHldNpAc3/OsLCHDH7CGfiXjV
        9KTECv1qTBNO46OTbE2Il16hcbiVBFStckp10hCUew==
X-Google-Smtp-Source: AMsMyM4fVdfYp1R3aiGeKK9liCS4g5DR/1+7C7UsfREwCvhk+qrLUh5vo/id7kyOfkxAhkJ6VcHjB4jTgA8ipDDVsm4=
X-Received: by 2002:a05:6512:2209:b0:4a2:6b07:9a97 with SMTP id
 h9-20020a056512220900b004a26b079a97mr12991376lfu.509.1667568600802; Fri, 04
 Nov 2022 06:30:00 -0700 (PDT)
MIME-Version: 1.0
References: <20221104094016.102049-1-asavkov@redhat.com>
In-Reply-To: <20221104094016.102049-1-asavkov@redhat.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Fri, 4 Nov 2022 14:29:49 +0100
X-Gmail-Original-Message-ID: <CACYkzJ4E37F9iyPU0Qux4ZazHMxz0oV=dANOaDNZ4O8cuWVYhg@mail.gmail.com>
Message-ID: <CACYkzJ4E37F9iyPU0Qux4ZazHMxz0oV=dANOaDNZ4O8cuWVYhg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix build-id for liburandom_read.so
To:     Artem Savkov <asavkov@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ykaliuta@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 4, 2022 at 10:41 AM Artem Savkov <asavkov@redhat.com> wrote:
>
> lld produces "fast" style build-ids by default, which is inconsistent
> with ld's "sha1" style. Explicitly specify build-id style to be "sha1"
> when linking liburandom_read.so the same way it is already done for
> urandom_read.
>
> Signed-off-by: Artem Savkov <asavkov@redhat.com>

Acked-by: KP Singh <kpsingh@kernel.org>

This was done in
https://lore.kernel.org/bpf/20200922232140.1994390-1-morbo@google.com
