Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D27E5831B5
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 20:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243364AbiG0SNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 14:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239065AbiG0SNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 14:13:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E55015B79E;
        Wed, 27 Jul 2022 10:14:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A5EFB821D9;
        Wed, 27 Jul 2022 17:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C82FC433D6;
        Wed, 27 Jul 2022 17:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658942047;
        bh=Drc9VoiDq38c+VVgzDBjh8/IAt7o9BlTSKd0SiJ3oqc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uprA+ZNKeyCHIz4uy8mx8IkkYx5msEEx/B2RjukVnKT1YACfSJJguFLEpGl9X1HgE
         Wpp4oedO9iktPby0g7SLYZYiIKra+IQlvPlLqJuY6N0bLk3ZtvL5bw4u2JLYQM+Iqt
         FrcdEy7rze9387gMYnoyS4h99zsj+NRFATkeijfpBuy0WovSDIcGOf3LsRsPFuDpud
         IArDHB4Yw8uyQuC79IE2DwwVn29Hd68XrHbYpJm5Sj7BZww/goMy8xeyjjKjgrLIe6
         D2GBfWpMypYltrggbLQA87YXnAUbprclT3qAI6fK4zg1MWXI9fAPhIbCJrRuX8Lsw+
         trVACJRtEjWZw==
Date:   Wed, 27 Jul 2022 10:14:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH bpf-next 00/14] bpf: net: Remove duplicated codes from
 bpf_setsockopt()
Message-ID: <20220727101405.6e899947@kernel.org>
In-Reply-To: <20220727060856.2370358-1-kafai@fb.com>
References: <20220727060856.2370358-1-kafai@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Jul 2022 23:08:56 -0700 Martin KaFai Lau wrote:
> bpf: net: Remove duplicated codes from bpf_setsockopt()

nit: "code" is a mass noun, uncountable and always singular
