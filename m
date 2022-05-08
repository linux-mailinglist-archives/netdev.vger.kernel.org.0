Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF98351ED44
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 13:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbiEHMD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 08:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232569AbiEHLwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 07:52:08 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2D5E013;
        Sun,  8 May 2022 04:48:17 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id c14so10017399pfn.2;
        Sun, 08 May 2022 04:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=78GiAOcDFncQpxS3zJf0oIIsYa1BfjnHtYeGhRAmaco=;
        b=eD6eGLRe6NGh0IxAF1cXnuOGWl6JVY1GAzSEyk7VT9zSinKK0vtUfjaeC165b19kH1
         mE2DCDKw6eLM8uF6HqdwgRjXy8kLpte6ejvwtEte0WUKzdnbTvZps2yZoMOKRYUeMW+N
         7n0RQAWlUYZhpB0ONWgfcOUQdPWA+7J/VYGtkfaRsyeOjyZ37h4APer6qmNFFrGkAlX+
         WHwd5rpja0fzgPsjQPlq45oKY8Q4t2UvTM7TAx1ymxylZSVFe0aSJi08R8FiTL8tqt1H
         Ur20Gh/YZHbfo8NwdfIm3z8Muz6H/aIv3K+FO+S5R5xRcaAi9tA17EOSJV3NXB3lJxBN
         vWjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=78GiAOcDFncQpxS3zJf0oIIsYa1BfjnHtYeGhRAmaco=;
        b=4dJ5Skvw40WfkmMEn1K+dsZJix2YBm7tqS/e6BE0QUS/RMJLh5F9+1lS4v2tQ4vlc4
         Ph/yC0UJirI4CxBDKzBApR2ic7koaxfd+ndXxk2fMX1l6abt2qv/f6kBZt2DW6UDE+P9
         gKq8YrhuV32tfPYBHBhEFDPLNgWhsAq09MrAk8uFELSydNw2YtRqdhBDj5J29qeUYlZz
         H8y9gVo0rSFRTMBye1r1HA868l1xSMo6TzsICBqByZzyFnD5RBFz4tu2NhS7uTH5e01t
         FaPYRr+P6PjBni2O3blos+K1xakX7JAAN9qB7I8fE5Z55D0mNEHdCPxS6bU05xCyEuEI
         F0Bw==
X-Gm-Message-State: AOAM532p0POkgr45I0eo6WSSpC8TzaQWFeAxRYGW2yV3QXQcavRHxJP4
        ErW6uMtHeZXE1dP3z9OnMxA=
X-Google-Smtp-Source: ABdhPJxpCSfAVDVRnbHSqMuz2nPP3bs7F50tRdZX6SrsJr+n2JBZpbm4jmiquICfhPCpNS/DFbH5Qg==
X-Received: by 2002:a05:6a00:b52:b0:510:5cbd:de94 with SMTP id p18-20020a056a000b5200b005105cbdde94mr11526599pfo.19.1652010497430;
        Sun, 08 May 2022 04:48:17 -0700 (PDT)
Received: from [192.168.11.5] (KD106167171201.ppp-bb.dion.ne.jp. [106.167.171.201])
        by smtp.gmail.com with ESMTPSA id gf1-20020a17090ac7c100b001cd4989fedesm10448954pjb.42.2022.05.08.04.48.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 May 2022 04:48:16 -0700 (PDT)
Message-ID: <0cf2306a-2218-2cd5-ad54-0d73e25680a7@gmail.com>
Date:   Sun, 8 May 2022 20:48:10 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
From:   Akira Yokosawa <akiyks@gmail.com>
Subject: Re: [PATCH net-next v3] net/core: Rephrase function description of
 __dev_queue_xmit()
To:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Ben Greear <greearb@candelatech.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220507084643.18278-1-bagasdotme@gmail.com>
Content-Language: en-US
In-Reply-To: <20220507084643.18278-1-bagasdotme@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/05/07 17:46,
Bagas Sanjaya wrote:
> Commit c526fd8f9f4f21 ("net: inline dev_queue_xmit()") inlines
> dev_queue_xmit() that contains comment quote from Ben Greear, which
> originates from commit af191367a75262 ("[NET]: Document ->hard_start_xmit()
> locking in comments.").It triggers htmldocs warning:

What I asked was the explanation of *why* the inlining of the
function caused the new warning.

Your explanation above tries to tell *what* the offending commit
did, which is not what I asked.  Furthermore, your explanation
is not accurate in that the comment block does not belong to
dev_queue_xmit() but to __dev_queue_xmit().

After seeking the answer myself, I reached a conclusion that
it is wrong to meddle with the comment block.

So, appended below is my version of the fix with the answer to
Stephen's question, "I am not sure why this has turned up just now."

Stephen, Jakub, what do you think?

        Thanks, Akira

----8<--------------
From: Akira Yokosawa <akiyks@gmail.com>
Subject: [PATCH -next] net/core: Hide __dev_queue_xmit()'s kernel-doc

Commit c526fd8f9f4f21 ("net: inline dev_queue_xmit()") added
export of __dev_queue_exit() to cope with inlining of its
wrapper functions dev_queue_xmit() and dev_queue_xmit_accel().
This made __dev_queue_exit()'s comment block visible to Sphinx
processing in "make htmldocs" because
Documentation/networking/kapi.rst has the directive of:

    .. kernel-doc:: net/core/dev.c
       :export:

Unfortunately, the kernel-doc style comment has a number of
issues when parsed as RestructuredText.  Stephen reported a
new warning message from "make htmldocs" caused by one of
such issues.

The leading "__" in the function name indicates that it is an
internal API and should not be widely used.
Exposing documentation of such a function in HTML and PDF
documentations does not make sense.

For the time being, hide the kernel-doc style comment from Sphinx
processing by removing the kernel-doc marker of "/**".

Proper kernel-doc comments should be added to the inlined
wrapper functions, which is deferred to those who are familiar
with those netdev APIs.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: c526fd8f9f4f21 ("net: inline dev_queue_xmit()")
Link: https://lore.kernel.org/linux-next/20220503073420.6d3f135d@canb.auug.org.au/
Signed-off-by: Akira Yokosawa <akiyks@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Pavel Begunkov <asml.silence@gmail.com>
---
 net/core/dev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index c2d73595a7c3..a97fd413d705 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4085,8 +4085,7 @@ struct netdev_queue *netdev_core_pick_tx(struct net_device *dev,
 	return netdev_get_tx_queue(dev, queue_index);
 }
 
-/**
- *	__dev_queue_xmit - transmit a buffer
+/*	__dev_queue_xmit - transmit a buffer
  *	@skb: buffer to transmit
  *	@sb_dev: suboordinate device used for L2 forwarding offload
  *
-- 
2.25.1

