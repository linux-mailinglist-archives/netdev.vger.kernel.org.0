Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4402352AF42
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 02:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbiERAjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 20:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232704AbiERAjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 20:39:36 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB8B3D1CA;
        Tue, 17 May 2022 17:39:34 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4L2vJM1qpTz4xZ2;
        Wed, 18 May 2022 10:39:30 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1652834372;
        bh=PfasWlhYL5IIEatPGqyd0PllM8n5gWkCvmvKfOjR5ZI=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=ifBigZ+VFYy/C+eimo7bpL5w+3/z23uyazvVk5US29tdXqfEiyiE2kgsivrZ9PIIY
         xi0/+sPtH+wVDTUG0qAjQJTiIjqyDqlL2IbsUzxiu+s+dCJ4zWZp+Ehr10/1HqDsYt
         hEKGFpjk44MjU3NvI8HBJAVNkEuJSlxBdnD/xv1GMNgSd69NNeAHvGIltaDYCpZLAr
         uq0Vu4JdKVZ4PcikfUl4RGDPutZ8MoQlrUs82K/KMzD7oqdCZepJvmEPNAhwA6RjgK
         os8uDWp7ExAUFBZdGl8wH36Vnq/WpSfhCyHnbhrrSltUexy+gwulzJLOZshcUK0aCG
         VuB3+hsPMHw2A==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>
Cc:     akpm@linux-foundation.org, x86@kernel.org,
        linux-alpha@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: unexport csum_and_copy_{from,to}_user
In-Reply-To: <YoQcNkB6R/E3vf51@zeniv-ca.linux.org.uk>
References: <20220421070440.1282704-1-hch@lst.de>
 <YoQcNkB6R/E3vf51@zeniv-ca.linux.org.uk>
Date:   Wed, 18 May 2022 10:39:17 +1000
Message-ID: <87y1yzoeru.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Al Viro <viro@zeniv.linux.org.uk> writes:
> On Thu, Apr 21, 2022 at 09:04:40AM +0200, Christoph Hellwig wrote:
>> csum_and_copy_from_user and csum_and_copy_to_user are exported by
>> a few architectures, but not actually used in modular code.  Drop
>> the exports.
>> 
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Acked-by: Al Viro <viro@zeniv.linux.org.uk>
>
> Not sure which tree should it go through - Arnd's, perhaps?

It's already in akpm's tree:

https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?h=mm-nonmm-stable&id=6308499b5e99c0c903fde2c605e41d9a86c4be6c

cheers
