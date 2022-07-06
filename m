Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D788D567F2D
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 09:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbiGFHAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 03:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbiGFHAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 03:00:18 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D021F2DC;
        Wed,  6 Jul 2022 00:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=R46HUaC7dh3ENW3T9JD/LPCN0Q73/N8vSw6Q2zMi/zs=; b=vOm/O/oIezRVCyIO8pt7RST9FS
        c0ALDfi9HMbz8Vxvmsju3KsbI2eUJASfRzM4wlPSLViIZ2jp5PRhygeJUzgVObOSIkUA818QIL6hv
        7VIjlRE+GoqmMDDguZDLAKkOHSXH1rS5lfUiRQkoWEykBEpe8/1T7r0wGqNRtefDwq0OYdx4p99vW
        XvAJZPD5k5+KjlJWgqthaCHi1G2ngvYWMK7HFsZ8SaIcD9xnsidmEW81T7CX3BeIAKbRmJr1cdemD
        cxfyt0z128b5NXZj95mP2YrSMk1zswZ681CgAorn3aHZ07qd++0Wr7WCShFW+i4dzdAIuIHFKeQ1X
        1uzohvaA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8z10-006tU3-EX; Wed, 06 Jul 2022 07:00:03 +0000
Date:   Wed, 6 Jul 2022 00:00:02 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Alan Maguire <alan.maguire@oracle.com>,
        Yixun Lan <dlan@gentoo.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        linux-riscv@lists.infradead.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH] RISC-V/bpf: Enable bpf_probe_read{, str}()
Message-ID: <YsUy8jBpt11zoc5E@infradead.org>
References: <20220703130924.57240-1-dlan@gentoo.org>
 <YsKAZUJRo5cjtZ3n@infradead.org>
 <CAEf4BzbCswMd6KU7f9SEU6xHBBPu_rTL5f+KE0OkYj63e-h-bA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbCswMd6KU7f9SEU6xHBBPu_rTL5f+KE0OkYj63e-h-bA@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 05, 2022 at 10:00:42PM -0700, Andrii Nakryiko wrote:
> riscv existed as of [0], so I'd argue it is a proper bug fix, as
> corresponding select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE should
> have been added back then.

How much of an eBPF ecosystem was there on RISC-V at the point?
