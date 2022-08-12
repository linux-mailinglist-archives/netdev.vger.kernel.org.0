Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8DF5915DB
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 21:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232539AbiHLTS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 15:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbiHLTS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 15:18:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A148B089A;
        Fri, 12 Aug 2022 12:18:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1403F61789;
        Fri, 12 Aug 2022 19:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23509C433D6;
        Fri, 12 Aug 2022 19:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660331937;
        bh=WqMhNONXoMI/kYuDoJu2Q0n+iVmHXh49+6LV8nrfmJ4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XG33GjLvIfBnhfHkLKAWFpl8+zGC6lRkCYGvmDYnozjecYbfvOZzztAU4zRIHFqoA
         wWom2YxWB0EbpuH+xzWQAcTFVEcyzOWjSMpYzXp7JxTR0mhMs+j9k+za4qSfJwxH7E
         8UD/I3S5ILHs82KypnZLDk3CG2m8fuppEAywy3RVVDNMMlGtQBuT2M06vcDW/79Blk
         AWPoTDRcbttLnjEf9LIOnsJuLefspKcSoW4/zgec9Ptd9QqLYRgJd4jmeoZVZ3WQZC
         grJagSwBXnZBpKDv+I7fulbLdo8wNM2FA7y70Vz5CL9PTP6mBc0muaKabPCIJjwWW8
         BhEXop5gx6lgw==
Date:   Fri, 12 Aug 2022 12:18:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Habets <habetsm.xilinx@gmail.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>, davem <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>, ecree.xilinx@gmail.com,
        linux-pci@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        mst <mst@redhat.com>
Subject: Re: [PATCH net-next v2 0/2] sfc: Add EF100 BAR config support
Message-ID: <20220812121856.2e212b4d@kernel.org>
In-Reply-To: <YvYfmw44gpuqexYz@gmail.com>
References: <165719918216.28149.7678451615870416505.stgit@palantir17.mph.net>
        <20220707155500.GA305857@bhelgaas>
        <Yswn7p+OWODbT7AR@gmail.com>
        <20220711114806.2724b349@kernel.org>
        <Ys6E4fvoufokIFqk@gmail.com>
        <20220713114804.11c7517e@kernel.org>
        <Ys/+vCNAfh/AKuJv@gmail.com>
        <20220714090500.356846ea@kernel.org>
        <CACGkMEt1qLsSf2Stn1YveW-HaDByiYFdCTzdsKESypKNbF=eTg@mail.gmail.com>
        <YvYfmw44gpuqexYz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Aug 2022 10:38:35 +0100 Martin Habets wrote:
> FYI, during my holiday my colleagues found a way to use the vdpa tool for=
 this.
> That means we should not need this series, at least for vDPA.
> So we can drop this series.

=F0=9F=8E=89 small victories :)
