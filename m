Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7BCB520F61
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 10:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237476AbiEJIKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 04:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235359AbiEJIKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 04:10:12 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25DB47AF7
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 01:06:15 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id p189so9660333wmp.3
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 01:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mEuVkyCJsFBpjnUuWHko4ZSvVy7NVBI70w4ICnwtVkY=;
        b=P1K5Pes2mQ8yH6JZAKvC6UE4R35Qnddv2X3u83VA8oQyUm7DQmtIwzQpoBsfK/yM7K
         ICGe5VL9AMlD0w57CbvIniAmdQgF3iAIAZuG5ta0R2+xuRZym2LhpCtY2tidHCTvl8YI
         Ci+hYU/PoBs632GbqLFctZVyUVasynD7C4/evtCS0GKIrbM07Oq3p5DYng739C3BkTur
         XKH0n/klrrRfgfQT+XcciU6K2VIJB5PEi56IcMviAKCc6ABb+3KEd9ESYwwBUbq0FURF
         j89fTq/lpd71uQiJX1UUaWW1t1xQt4O4+O4go3JdKn7/fyiBae8548SqTPAHMHFKB8YF
         bnug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=mEuVkyCJsFBpjnUuWHko4ZSvVy7NVBI70w4ICnwtVkY=;
        b=QJ7SPgHKtHj8Q7cN1Va9yxLlR0Sl6f0ZgmAXXVPHuPg0FPlC+JzSs4uV9JPhofWJ6U
         mnFYcXEhqIF5cO8Ie7PdY05S3SBNZ+kMXLfl3bbQpd2RuDc85oKP65jY3X0TSC9FjQtx
         ZN2V6cfp0BT7wRremZp8jrddnhguC2dbykArxFALBZxOgF/eG7M0m9ypXowbTBRalzMH
         Pgwg+47RRK0F8mDErstsONftwLhrSQthqYuCAyUm2JEfw8Aa/qhHLpsUAFeWUjSm5gH2
         CjHxn7KT7vL/t6icB3gNgd45Xpu+mkK8pldCraf5bFYm+Y/qFOVT8ZqInEb0ZDZrimF3
         7tnQ==
X-Gm-Message-State: AOAM5335ALI3ibe7+mc2EyDcyibuu7fvl6qKam5VEr10EJeX/Put72Qd
        JQ7/0sfPAWGsP91OU4HVljo=
X-Google-Smtp-Source: ABdhPJzw4EimZQMP9v8N7wAC89ngEWvzkznt8hbUvqGAIUZ2xlppAmLiw38cmclWC/qIDwmUj31J7A==
X-Received: by 2002:a7b:c047:0:b0:392:9e9b:8264 with SMTP id u7-20020a7bc047000000b003929e9b8264mr26812226wmc.192.1652169974196;
        Tue, 10 May 2022 01:06:14 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id o8-20020adfa108000000b0020c5253d8e5sm13511822wro.49.2022.05.10.01.06.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 10 May 2022 01:06:13 -0700 (PDT)
Date:   Tue, 10 May 2022 09:06:11 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     edumazet@google.com, pabeni@redhat.com, davem@davemloft.net,
        netdev@vger.kernel.org, ecree.xilinx@gmail.com
Subject: Re: [PATCH net-next v4 00/11]: Move Siena into a separate
 subdirectory
Message-ID: <20220510080611.4nmrjrct5kounjym@gmail.com>
Mail-Followup-To: Jakub Kicinski <kuba@kernel.org>, edumazet@google.com,
        pabeni@redhat.com, davem@davemloft.net, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com
References: <165211018297.5289.9658523545298485394.stgit@palantir17.mph.net>
 <165214261365.23610.13788193533410601676.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165214261365.23610.13788193533410601676.git-patchwork-notify@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

I reposted as discussed. This time the BPF bot grabbed the first 3.
I have no clue how or why that happened.

The other ones are still in patchwork:
https://patchwork.kernel.org/project/netdevbpf/list/?series=639815

Martin

On Tue, May 10, 2022 at 12:30:13AM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This series was applied to bpf/bpf-next.git (master)
> by Andrii Nakryiko <andrii@kernel.org>:
> 
> On Mon, 09 May 2022 16:31:06 +0100 you wrote:
> > The Siena NICs (SFN5000 and SFN6000 series) went EOL in November 2021.
> > Most of these adapters have been remove from our test labs, and testing
> > has been reduced to a minimum.
> > 
> > This patch series creates a separate kernel module for the Siena architecture,
> > analogous to what was done for Falcon some years ago.
> > This reduces our maintenance for the sfc.ko module, and allows us to
> > enhance the EF10 and EF100 drivers without the risk of breaking Siena NICs.
> > 
> > [...]
> 
> Here is the summary with links:
>   - [net-next,v4,01/11] sfc: Move Siena specific files
>     https://git.kernel.org/bpf/bpf-next/c/bfa92e0bdc8e
>   - [net-next,v4,02/11] sfc: Copy shared files needed for Siena (part 1)
>     https://git.kernel.org/bpf/bpf-next/c/bfa92e0bdc8e
>   - [net-next,v4,03/11] sfc: Copy shared files needed for Siena (part 2)
>     https://git.kernel.org/bpf/bpf-next/c/bfa92e0bdc8e
>   - [net-next,v4,04/11] sfc/siena: Remove build references to missing functionality
>     (no matching commit)
>   - [net-next,v4,05/11] sfc/siena: Rename functions in efx headers to avoid conflicts with sfc
>     (no matching commit)
>   - [net-next,v4,06/11] sfc/siena: Rename RX/TX functions to avoid conflicts with sfc
>     (no matching commit)
>   - [net-next,v4,07/11] sfc/siena: Rename peripheral functions to avoid conflicts with sfc
>     (no matching commit)
>   - [net-next,v4,08/11] sfc/siena: Rename functions in mcdi headers to avoid conflicts with sfc
>     (no matching commit)
>   - [net-next,v4,09/11] sfc/siena: Rename functions in nic_common.h to avoid conflicts with sfc
>     (no matching commit)
>   - [net-next,v4,10/11] sfc/siena: Inline functions in sriov.h to avoid conflicts with sfc
>     (no matching commit)
>   - [net-next,v4,11/11] sfc: Add a basic Siena module
>     (no matching commit)
> 
> You are awesome, thank you!
> -- 
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html
