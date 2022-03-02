Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B03694CA7CF
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 15:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242854AbiCBOUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 09:20:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiCBOT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 09:19:59 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68CCF33348;
        Wed,  2 Mar 2022 06:19:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Lj3aRKRkY+BfmD5oAlJkiAq4kMLr57fwLNlaF9yRDmg=; b=M0YzU/bBm/PwdAQ4a6sJ4McqfR
        657Nz2+bPI/CdBdb0ywPUAqK3DlHUFq4imQHPNzREPJlETnY80Ca9qlDCBKzRsvlJ5Y2ieLfuH4+/
        DZBTzoSAHEP37dpWukVq0N+mKFR1a5tLnJrJ6h1Uh6BF2prdiTVPD7dvtPa73S0fLhP5HtU8IA6ob
        epJXIVbd8BWRfrA+GERVSkDIpI+rB7r/MeXHI4zIWEyBFS6CDXZ6WO9ihDcC8lBPdwFdR+vPybLqM
        hYYZpGn1VELi1vJq26PGr9+JufZk9CTwzCe+xR8aXDVgqcNqOID+QL4FJ1Ix/gWbl6ftBNHScsjd0
        tWptpnSA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nPPop-00Ag0b-HK; Wed, 02 Mar 2022 14:19:07 +0000
Date:   Wed, 2 Mar 2022 14:19:07 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Nick Terrell <terrelln@fb.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        cai.huoqing@linux.dev, Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [next] warning: the frame size of 1120 bytes is larger than 1024
 bytes [-Wframe-larger-than=]
Message-ID: <Yh982ysEPvl5feRZ@casper.infradead.org>
References: <CA+G9fYvUHjwU9sOMs+zNwuauGLqah3Ce_5VKtifZucOuXqw2qA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvUHjwU9sOMs+zNwuauGLqah3Ce_5VKtifZucOuXqw2qA@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 12:13:49PM +0530, Naresh Kamboju wrote:
> Following warnings noticed while building Linux next-20220301
> for arm KASAN builds [1].

Are any of them actually new?  They all look pretty familiar to me,
and they don't have just one cause; they each need to be addressed
individually (if they need to be addressed at all).
