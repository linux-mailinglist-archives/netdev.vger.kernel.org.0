Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3A0505EE9
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 22:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238677AbiDRUeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 16:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238619AbiDRUeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 16:34:18 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364C730576
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 13:31:38 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 11so13719249edw.0
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 13:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=H9EMcf4lAGC7okP41SfpykkhFU9dvOEPn4KAvQHmq3A=;
        b=P6z59lWyokj9wj+rpp3p7XmKc8otlbyPnaBXrik5nLnvy339ymt7AR0MfrW4iucBXP
         rbt+5IgwKXtFL34bjWbZzoPfn2pD0+0hj8jtjEowi5Cd+S6SVf8w4jwuz6L2pfwi6uGQ
         s68bn82z2JzgZ0MtP9b2yUcRskKmI8mWubPQ+lJLkTvTo6t/VqUbuqMNr7bxNbuFP1GB
         wXvpMImol3l9bt1AbXexngNHJKr8YXbXgeDZWRIfdgKlUs7vX5yCRm1xgRXzqDLIqw/B
         JSWV9UprN5SpUZLwS3XP2F9JQru5AA+VDXJWM0bSBlNU1ccJXwaTbRj3e4vJz4szL2lV
         wt5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H9EMcf4lAGC7okP41SfpykkhFU9dvOEPn4KAvQHmq3A=;
        b=xOSNYkhLlFlhDpP9qu5BTl2qem7KoFpHIPZUfjCgdXknROnFLTRFTvLySRVQ5oNA+s
         MSLxcGDgAzHFVMmm6uWWuNpPvZpLK5smuaa8tIVW0KVAgxM+bV8PWFdImmDqVBvDOAhB
         y5o6njUEehr1RRuB9T3zue8DcWwOLqm5lIp8rj78vXD8ufr6ebqc51D4dk1LKOJJO61Q
         QRc+g/od+FMDVu0MOFK1z8Wjx/002M0qVbJKS9YsTFJpSWsU/NcWe4/yNigo2w7egXk3
         V0shHcNgJp+qDfN9t2ppOo/n2RsRFdr3xBucWvOv5XGx38vME9pPk5SylYNc84cDXa4T
         rlEA==
X-Gm-Message-State: AOAM533skK8PnDTKmDMDgPhtLRkbhXA1M90RFxMExdZQix7wmEmtcye9
        DjO16aKa3OAdVf9rKBV5tkVVnffuzsZDwA==
X-Google-Smtp-Source: ABdhPJyBAjHB82AHZf//NVFbnCyChru6OBSwLg09WH1UKs6C71r2p5GjfysK1Gjf48e6eXCV+PJv3A==
X-Received: by 2002:a50:fc89:0:b0:41d:83d1:9df3 with SMTP id f9-20020a50fc89000000b0041d83d19df3mr13557798edq.19.1650313896497;
        Mon, 18 Apr 2022 13:31:36 -0700 (PDT)
Received: from localhost (91-113-2-155.adsl.highway.telekom.at. [91.113.2.155])
        by smtp.gmail.com with ESMTPSA id x4-20020a170906b08400b006e493cb583esm4891503ejy.47.2022.04.18.13.31.35
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 13:31:35 -0700 (PDT)
From:   luca.boccassi@gmail.com
To:     netdev@vger.kernel.org
Subject: [PATCH iproute2 2/2] man: use quote instead of acute accent
Date:   Mon, 18 Apr 2022 22:31:28 +0200
Message-Id: <20220418203128.747915-2-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220418203128.747915-1-luca.boccassi@gmail.com>
References: <20220418203128.747915-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luca Boccassi <bluca@debian.org>

Lintian complains:

I: iproute2: acute-accent-in-manual-page usr/share/man/man8/tc-bpf.8.gz:220

"This manual page uses the \' groff sequence. Usually, the intent to
 generate an apostrophe, but that sequence actually renders as an acute
 accent.
 For an apostrophe or a single closing quote, use plain '. For single
 opening quote, i.e. a straight downward line ' like the one used in
 shell commands, use '\(aq'."

Before:

´s,c t f k,c t f k,c t f k,...´

After:

's,c t f k,c t f k,c t f k,...'

Signed-off-by: Luca Boccassi <bluca@debian.org>
---
Maybe this was the original intention, maybe not, but Lintian nags me, so let's fix it

 man/man8/tc-bpf.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man8/tc-bpf.8 b/man/man8/tc-bpf.8
index e4f68aaa..01230ce6 100644
--- a/man/man8/tc-bpf.8
+++ b/man/man8/tc-bpf.8
@@ -217,7 +217,7 @@ identifiers which would need to reparse packet contents.
 .SS bytecode
 is being used for loading cBPF classifier and actions only. The cBPF bytecode
 is directly passed as a text string in the form of
-.B \'s,c t f k,c t f k,c t f k,...\'
+.B \(aqs,c t f k,c t f k,c t f k,...'
 , where
 .B s
 denotes the number of subsequent 4-tuples. One such 4-tuple consists of
-- 
2.34.1

