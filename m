Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584FD3A2118
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 02:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbhFJABz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 20:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhFJABy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 20:01:54 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8881C061574
        for <netdev@vger.kernel.org>; Wed,  9 Jun 2021 16:59:51 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id c13so30677plz.0
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 16:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QA8H+Y0lHfKMF+38NmMn94C1f+NUCkkSA+qKqFxg/EM=;
        b=kfVyflSwSyBerTlV/0lQI6+iT/pKp0QreA9gmzogLi+j5mNp8qTn/3muONPmlxZs/e
         yIrt73ZsmOrufRCJ+nNhHxq0KOj5ZBRM0ytN4LiVflHBA2Wk+zpD0PJXnQBrSEb8BaEv
         HcXB6X8RQdxgL5dCQoqG6QS35Yt1Nb471X7t7+e+bgRBseE4HqwhcXN1mcpcLmitXvPW
         36CSMbisGaM/wgR2JKQ8fHY8N35MkaVjw9owjHoU8TNksZqEkSqOyVgJaeCnDoIJmgF5
         5iRAvmT+HkbJxzI2V0EDWnLC7jsFibqu4mRgjGjkmmeTRtCsU51j9La4IKIvrAAuXxv4
         QGoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QA8H+Y0lHfKMF+38NmMn94C1f+NUCkkSA+qKqFxg/EM=;
        b=WJfxV/xQgiWAmbu6T7hVQ/TyvyAj+JORm8F3n1BGNAwI+4woBI9HSAC++8MtiedD9F
         bltTfqzhhK51/5ih3U2Nd9P9Gzof0skdu1DTqDleKgh5Z2uUYhQi+lILjhtIqM/hV3qd
         iab7XJ/zjffcG35UqRWdnbv2u74NECXpFbt01AB74JFZNcU+F9lDYAbc4nsnk1v7uNLV
         89zDXP2eAmihRbnl7FMsuNWb6SlP231sXzdjMVnTQ9cvKryCrg4q/EnItLt4XG+H6s3s
         JuDqpKYtm9ppY8S0MD+wN0YPlQIfrUStW77FDvnD9JqEs7D+TfXk8cmEtq0KIwub+d/P
         iRFw==
X-Gm-Message-State: AOAM533rkhOqxwC9PUHclQT5OA/0ClZL1/a5yqULjsw7CD8ZX/H9xWJ8
        jOXQf1lwxAoqeftA/TTSndlRGAgrj1Anec1y
X-Google-Smtp-Source: ABdhPJzxOTb3GXO5za/y2qq4jcYSbQKOvd6P70UJKsC4/mTCvkPqu03kyd0YSXFttjgP2uY6Dv4Xwg==
X-Received: by 2002:a17:90a:89:: with SMTP id a9mr251536pja.47.1623283191352;
        Wed, 09 Jun 2021 16:59:51 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id s3sm774926pgs.62.2021.06.09.16.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 16:59:51 -0700 (PDT)
Date:   Wed, 9 Jun 2021 16:59:49 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] utils: bump max args number to 256 for batch
 files
Message-ID: <20210609165949.5806f75d@hermes.local>
In-Reply-To: <4a0fcf72130d3ef5c4ca91b518f66ac6449cf57f.1622565590.git.gnault@redhat.com>
References: <4a0fcf72130d3ef5c4ca91b518f66ac6449cf57f.1622565590.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Jun 2021 19:09:31 +0200
Guillaume Nault <gnault@redhat.com> wrote:

> Large tc filters can have many arguments. For example the following
> filter matches the first 7 MPLS LSEs, pops all of them, then updates
> the Ethernet header and redirects the resulting packet to eth1.
> 
> filter add dev eth0 ingress handle 44 priority 100 \
>   protocol mpls_uc flower mpls                     \
>     lse depth 1 label 1040076 tc 4 bos 0 ttl 175   \
>     lse depth 2 label 89648 tc 2 bos 0 ttl 9       \
>     lse depth 3 label 63417 tc 5 bos 0 ttl 185     \
>     lse depth 4 label 593135 tc 5 bos 0 ttl 67     \
>     lse depth 5 label 857021 tc 0 bos 0 ttl 181    \
>     lse depth 6 label 239239 tc 1 bos 0 ttl 254    \
>     lse depth 7 label 30 tc 7 bos 1 ttl 237        \
>   action mpls pop protocol mpls_uc pipe            \
>   action mpls pop protocol mpls_uc pipe            \
>   action mpls pop protocol mpls_uc pipe            \
>   action mpls pop protocol mpls_uc pipe            \
>   action mpls pop protocol mpls_uc pipe            \
>   action mpls pop protocol mpls_uc pipe            \
>   action mpls pop protocol ipv6 pipe               \
>   action vlan pop_eth pipe                         \
>   action vlan push_eth                             \
>     dst_mac 00:00:5e:00:53:7e                      \
>     src_mac 00:00:5e:00:53:03 pipe                 \
>   action mirred egress redirect dev eth1
> 
> This filter has 149 arguments, so it can't be used with tc -batch
> which is limited to a 100.
> 
> Let's bump the limit to the next power of 2. That should leave a lot of
> room for big batch commands.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Good idea, but we should probably go further up to 512.
Also, rather than keeping magic constant. Why not add value to
utils.h.

I considered using sysconf(_SC_ARG_MAX) gut that is huge on modern
machines (2M). And we don't need to allocate for all possible args.

diff --git a/include/utils.h b/include/utils.h
index 187444d52b41..6c4c403fe6c2 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -50,6 +50,9 @@ void incomplete_command(void) __attribute__((noreturn));
 #define NEXT_ARG_FWD() do { argv++; argc--; } while(0)
 #define PREV_ARG() do { argv--; argc++; } while(0)
 
+/* upper limit for batch mode */
+#define MAX_ARGS 512
+
 #define TIME_UNITS_PER_SEC     1000000
 #define NSEC_PER_USEC 1000
 #define NSEC_PER_MSEC 1000000
diff --git a/lib/utils.c b/lib/utils.c
index 93ae0c55063a..0559923beced 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -1714,10 +1714,10 @@ int do_batch(const char *name, bool force,
 
        cmdlineno = 0;
        while (getcmdline(&line, &len, stdin) != -1) {
-               char *largv[100];
+               char *largv[MAX_ARGS];
                int largc;
 
-               largc = makeargs(line, largv, 100);
+               largc = makeargs(line, largv, MAX_ARGS);
                if (!largc)
                        continue;       /* blank line */
 

