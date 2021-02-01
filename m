Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D274F30A42E
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 10:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbhBAJQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 04:16:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbhBAJQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 04:16:00 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614ABC0613ED
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 01:14:48 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id s15so9610114plr.9
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 01:14:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tIgxEglgDq94h20dACXorEPmkHGZ+ULYl1UV0oBneL0=;
        b=l/UPIwvKonDOk/qSO9SsKNyTIzRy/jgu1MgqefJRPoG7+zqzLucrtvdK06O7HIV5yN
         Eq9eq5UQ5XMyHbxXHzxv0GuYY/TlBenJQK1SiayWYq6x8IMqyY5wXStxh7BdATc62T0r
         KlyxyeGYCfR6FbDYnZTGIPWgqOJBoxMo0SCw+jI41IIpawEoyQ2k/GDPS2BDYjIKxGNk
         MYMWhrJD+s/exO5YMrZ82AkDZ+NIxqD3zmhwUzBjNllWzbGAjmDXjs/Vlh1yeqibTMO8
         lzazIJBXgYxqBNrDeniwj8RRy2r78lbdtOr2c7Od4dvXi090X9ljoAATEKnU2nUipOYM
         BOXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tIgxEglgDq94h20dACXorEPmkHGZ+ULYl1UV0oBneL0=;
        b=tx1lok0ejUT/fR8rXRZVTrpCZHy0q0Oc6pNQ6XlCcOM1uhZXGdMmpS6Da0I3Bu85bs
         NqJX2jc0zDJc4M9sNDd6/2FtJrNqmQarbvvOwbTiYN5V8qzjTcbj5eZTzvysHy5slI6x
         YNdQKl6Ow5dKtId+suQWBw2a5hrCh2KXZLMvjxkNLdgzJJRPva9igKfnDvumHa9xfYki
         nBTHwTY4P3t9uQYhg26qOgBPeJZ1WsvKl+19AF8qqY75HpuYengPpFkVJyPR9xukWXMr
         WsrSo3RRjeeWFuUtQxk8GyvqCIvISfGUuRJcA/zetQmT5xUq13xjHQIPQwxIdxgieDP1
         hKxg==
X-Gm-Message-State: AOAM530VGosDCx0//G2pOd5P9s1g1b1vcI5q3RJknhJQjBqAo4+HmAnb
        uWq+9RRBdWqDdQpVmcZz+qMVP4q/OnDqxQ==
X-Google-Smtp-Source: ABdhPJwAXTmfnbU4E6G09p1g4J6h/4uYwNR/CjLDT4hW+BXr4/1aY31jVRyOCg/oe/ZSg1kayTyH7Q==
X-Received: by 2002:a17:90a:c84:: with SMTP id v4mr16568068pja.228.1612170887722;
        Mon, 01 Feb 2021 01:14:47 -0800 (PST)
Received: from tardis.. (c-67-182-242-199.hsd1.ut.comcast.net. [67.182.242.199])
        by smtp.gmail.com with ESMTPSA id o13sm17700751pfp.101.2021.02.01.01.14.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 01:14:47 -0800 (PST)
From:   Thayne McCombs <astrothayne@gmail.com>
To:     netdev@vger.kernel.org, stephen@networkplumber.org,
        vadim4j@gmail.com
Cc:     Thayne McCombs <astrothayne@gmail.com>
Subject: [PATCH iproute2-next] ss: Add clarification about host conditions with multiple familes to man
Date:   Mon,  1 Feb 2021 02:14:23 -0700
Message-Id: <20210201091423.22737-1-astrothayne@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210128081018.9394-1-astrothayne@gmail.com>
References: <20210128081018.9394-1-astrothayne@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In creating documentation for expressions I ran into an interesting case
where if you use two different familie types in the expression, such as
in `ss 'sport inet:ssh or src unix:/run/*'`, then you would only get the
results for one address family (in this case unix sockets).

The reason is that in parse_hostcond if the family is specified we
remove any previously added families from filter->families, and
preserve the "states" if any states are set. I tried changing this to
not reset the families, but ran into some issues with Invalid Argument
errors in inet_show_netlink, I think related to the state.

I can dig into that more if supporting this is useful, but I'm not sure
if these types of expressions would actually be useful in practice. Or
perhaps an error should be given if an expression contains conditions
with multiple families (besides inet and inet6)?

Anyway, for now, this patch just notes the limitation in the man page.

Signed-off-by: Thayne McCombs <astrothayne@gmail.com>
---
 man/man8/ss.8 | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/man/man8/ss.8 b/man/man8/ss.8
index 3da279f9..3c4beede 100644
--- a/man/man8/ss.8
+++ b/man/man8/ss.8
@@ -511,7 +511,9 @@ The general host syntax is [FAMILY:]ADDRESS[:PORT].
 .P
 FAMILY must be one of the families supported by the -f option. If not given
 it defaults to the family given with the -f option, and if that is also
-missing, will assume either inet or inet6.
+missing, will assume either inet or inet6. Note that all host conditions in the
+expression should either all be the same family or be only inet and inet6. If there
+is some other mixture of families, the results will probably be unexpected.
 .P
 The form of ADDRESS and PORT depends on the family used. "*" can be used as
 a wildcord for either the address or port. The details for each family are as
-- 
2.30.0

