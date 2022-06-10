Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38346545E3B
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 10:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243411AbiFJILL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 04:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347159AbiFJILK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 04:11:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697F021E0EF;
        Fri, 10 Jun 2022 01:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=w8J2KWjgjx9J/jKYFe8GjW3jNW9wYeGtv0q5FHV/ys4=; b=GB5aPyYFM6PkAx1k8v49cM2BwJ
        WcHcAb9jUq2QalpM0aIhDr3+BATD+8EYM+eWrdcimaNJm2xzuBjssr8WpUOHCt60n94XAWc3FLON0
        Ea9J0QBamM6uWTM+4HzYRBxWYDjskhw+JmLncWTsnFKFqxOWIxsmL4IFLm4L1tdnFjZSI0pPplO8o
        9sJxX0TlKZO3aKYVSMxNIiHKcE1/kS+w9R9M0LWGRUAImkmbZyNxVDSII1uFSuj5x0bXfi1yfXOOK
        c3DmI+O3f6cqKS1/lbJzaDxCojVk8Q1W7xF3ZeNStt9QC+dLwogmOOIHoLpghg/0Ij+XccRx5toAG
        ilnXeRzQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nzZin-006gfR-MQ; Fri, 10 Jun 2022 08:10:21 +0000
Date:   Fri, 10 Jun 2022 01:10:21 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Bill Wendling <morbo@google.com>
Cc:     isanbard@gmail.com, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Phillip Potter <phil@philpotter.co.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jan Kara <jack@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Ross Philipson <ross.philipson@oracle.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-mm@kvack.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, alsa-devel@alsa-project.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH 04/12] blk-cgroup: use correct format characters
Message-ID: <YqL8bTQxrkQjlSBT@infradead.org>
References: <20220609221702.347522-1-morbo@google.com>
 <20220609221702.347522-5-morbo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220609221702.347522-5-morbo@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 09, 2022 at 10:16:23PM +0000, Bill Wendling wrote:
>  	vsnprintf(bdi->dev_name, sizeof(bdi->dev_name), fmt, args);
> -	dev = device_create(bdi_class, NULL, MKDEV(0, 0), bdi, bdi->dev_name);
> +	dev = device_create(bdi_class, NULL, MKDEV(0, 0), bdi, "%s", bdi->dev_name);

Please avoid the overly long line.  But given that bdi names aren't user
input this warning seems to shoot from the hip a bit.

