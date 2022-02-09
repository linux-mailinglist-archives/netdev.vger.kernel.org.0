Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 462514AEFED
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 12:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiBILZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 06:25:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiBILY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 06:24:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 86695E12D71D
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 02:19:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644401820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YoAHclFfpdWOR3Rz2pjOqXwysYaFTuu6PzBf6Mjo0WA=;
        b=gJojFMOpn1FZjbItGg4Q4OhdCJ8Q2W5+PHYzzRNbi99YQGK8FV1NM+//e35MpwhManxpMZ
        e3pGOz3P8u1y5oVcDe5d7Pl85gOqkh4/mMZ8MiLQMRuJhefe7NN5nYxmNRexfxDBGOqKyP
        xGLpTy3FsjWslKMo/8Z/lCTkq8bWWDI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-513-0-7_EnN5OKuVEAklmvS8VA-1; Wed, 09 Feb 2022 04:57:42 -0500
X-MC-Unique: 0-7_EnN5OKuVEAklmvS8VA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0FEB918B9EC3;
        Wed,  9 Feb 2022 09:57:40 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.40.208.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 12EC25BC4B;
        Wed,  9 Feb 2022 09:57:38 +0000 (UTC)
Date:   Wed, 9 Feb 2022 10:57:35 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] selftests: netfilter: fix exit value for
 nft_concat_range
Message-ID: <20220209105735.5cefed1d@elisabeth>
In-Reply-To: <20220209082551.894541-1-liuhangbin@gmail.com>
References: <20220209082551.894541-1-liuhangbin@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Feb 2022 16:25:51 +0800
Hangbin Liu <liuhangbin@gmail.com> wrote:

> When the nft_concat_range test failed, it exit 1 in the code
> specifically.
> 
> But when part of, or all of the test passed, it will failed the
> [ ${passed} -eq 0 ] check and thus exit with 1, which is the same
> exit value with failure result. Fix it by exit 0 when passed is not 0.

Oops, right, thanks for fixing this!
 
> Fixes: 611973c1e06f ("selftests: netfilter: Introduce tests for sets with range concatenation")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

