Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFB2F20F5D9
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 15:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732984AbgF3Ng1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 09:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbgF3Ng0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 09:36:26 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54525C061755;
        Tue, 30 Jun 2020 06:36:26 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqGQr-002oZE-KJ; Tue, 30 Jun 2020 13:36:17 +0000
Date:   Tue, 30 Jun 2020 14:36:17 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: linux-next: build failures after merge of the vfs tree
Message-ID: <20200630133617.GG2786714@ZenIV.linux.org.uk>
References: <20200616010502.GA28834@gondor.apana.org.au>
 <20200616033849.GL23230@ZenIV.linux.org.uk>
 <20200616143807.GA1359@gondor.apana.org.au>
 <20200617165715.577aa76d@canb.auug.org.au>
 <20200617070316.GA30348@gondor.apana.org.au>
 <20200617173102.2b91c32d@canb.auug.org.au>
 <20200617073845.GA20077@gondor.apana.org.au>
 <20200618100851.0f77ed52@canb.auug.org.au>
 <20200630115857.48eab55d@canb.auug.org.au>
 <20200630021401.GA20427@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630021401.GA20427@gondor.apana.org.au>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 12:14:01PM +1000, Herbert Xu wrote:

> Could you please fold these changes into your tree?

Done and pushed.  Sorry, had been buried in the regset mess
lately... ;-/
