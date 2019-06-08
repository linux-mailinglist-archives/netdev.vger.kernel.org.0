Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8864B39BDA
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 10:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbfFHIfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 04:35:39 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35244 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfFHIfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 04:35:39 -0400
Received: by mail-pg1-f193.google.com with SMTP id s27so2389811pgl.2;
        Sat, 08 Jun 2019 01:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=kxOYJf8od5LJPBcLGMCHl4bwa9e0qihFkjhJ+e7tcLY=;
        b=FQMgFyoY3SPy1YDxGb2RZSzlIRaPh3vMRIBK14e2HUPAvO6CPZzCOQq7ec33p2xY0L
         UQ2uvpu70kPRCxcvrqnYYnepCmNs8MAHXA+PCynUp6MQm8LlGHlZIVYJZsHe7uJK1T6f
         cFZNlVQh6mMCGEF0GdEw5ISy839RqHe0Ny9hx9vc4vaWWIaRAC/Np/FLfIcDrxp6uUfQ
         btmatTFP3nhSIAMaAPRaddAOPRJp9LzXyBpuxrzCWhkBzMgE/f2VYOgypg4oXFKfuGif
         t0E86toqiE8qL6J4JHHz0NyJjOOBGBgK+rLd2t+cN3PNEBe/+Cl+LoX/YXYim1uWYMBi
         gRSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=kxOYJf8od5LJPBcLGMCHl4bwa9e0qihFkjhJ+e7tcLY=;
        b=KKAoVqj7SYzg9PTgNumiEdDchGCm1kw6IZc/wCYDw3WvGlpfuHtRWPfpJF+eG61eqx
         SCMUceVy10CBtGs83MHJOF7W7CpmseUBYOUps0HEk8SeVZmpQRI82G22CvrT5em5hI+9
         otqNuiqAMLj/I8ma63N3yNIU5g8xXElPFc0jn4B2Oa5onGSXP6Q3YRxus6GpdDwAAYGj
         pRHG4JtjF48Tl1u4Kk16JFcXYjBsEssffYJ8DO67l/Mpv61IPSGvgKTu3XDajIMVgTrk
         y+GkzJ02E9CDGmTU40kKefhX2BbgMcokaszOJ5MWvuyMGFpDJ1uyTJJ20YMznqgwk5xb
         n7ag==
X-Gm-Message-State: APjAAAVyneIvTuPVbNaNrKJ5dvvUVcgJ7L1ZKbp9sCmRM1sTZqrVFzAK
        9q/gJvj36u92XwvnzxaCZX7UUsL2
X-Google-Smtp-Source: APXvYqytDfcNVeqfUCh+xtLHpyx3xh1INpZJ4G1NA1oWpEyBS5gia/XEzGP9ILLygL3/8gzHi+Mc0A==
X-Received: by 2002:a63:7ca:: with SMTP id 193mr6539961pgh.240.1559982938651;
        Sat, 08 Jun 2019 01:35:38 -0700 (PDT)
Received: from hari-Inspiron-1545 ([183.83.89.153])
        by smtp.gmail.com with ESMTPSA id i3sm4535972pfo.138.2019.06.08.01.35.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 01:35:37 -0700 (PDT)
Date:   Sat, 8 Jun 2019 14:05:33 +0530
From:   Hariprasad Kelam <hariprasad.kelam@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ipv6: exthdrs: fix warning comparison to bool
Message-ID: <20190608083532.GA7288@hari-Inspiron-1545>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix below warning reported by coccicheck

net/ipv6/exthdrs.c:180:9-29: WARNING: Comparison to bool

Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
---
 net/ipv6/exthdrs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index ab5add0..e137325 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -177,7 +177,7 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
 					/* type specific length/alignment
 					   checks will be performed in the
 					   func(). */
-					if (curr->func(skb, off) == false)
+					if (!curr->func(skb, off))
 						return false;
 					break;
 				}
-- 
2.7.4

