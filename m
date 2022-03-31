Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3484ED353
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 07:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiCaFi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 01:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbiCaFi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 01:38:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD39B14865A;
        Wed, 30 Mar 2022 22:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=p29tzLs7zbArA80t2+AEJP2/7OfrWVSV/z0IMyFFAek=; b=vbhxdY5reNpcS8vZGSC9E30dLW
        4FHTT4hxSaBUhQ0puWeb0LrMMPJmUY5xhzewVcyxHl1XmUZBLzi8u5jYxjvSnsqbtXori/uBk0uZO
        TAJk6D1FOMEmPH0m4u51QFSkYYUFRtkM6ks+r5gvy7nFK1U4mc0Kjf52ybRZzndG5KzmDTIrdCPz3
        S1TxP0dBD1xRVN/itQ5OpMg08jHw280/1395Yh84f4SbTEH9jSVAZJbsPsFOmvF5UO4wCroxwSmhX
        oTYUIRLnw1fSGPQPc1UxeLBQ0c6zIgpaRUPLAfpMwEZvuqjOjzuvY83VtnvbQ+mewkNcmdDY/yZhp
        LVIgyCiw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nZnUW-000iTg-Cq; Thu, 31 Mar 2022 05:37:04 +0000
Date:   Wed, 30 Mar 2022 22:37:04 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Song Liu <song@kernel.org>
Cc:     linux-mm@kvack.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        x86@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kernel-team@fb.com, akpm@linux-foundation.org,
        pmenzel@molgen.mpg.de, rick.p.edgecombe@intel.com
Subject: Re: [PATCH bpf 0/4] introduce HAVE_ARCH_HUGE_VMALLOC_FLAG for
 bpf_prog_pack
Message-ID: <YkU+ADIeWACbgFNA@infradead.org>
References: <20220330225642.1163897-1-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330225642.1163897-1-song@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 30, 2022 at 03:56:38PM -0700, Song Liu wrote:
> We prematurely enabled HAVE_ARCH_HUGE_VMALLOC for x86_64, which could cause
> issues [1], [2].
>

Please fix the underlying issues instead of papering over them and
creating a huge maintainance burden for others.
