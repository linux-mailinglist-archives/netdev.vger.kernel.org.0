Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9F2491E85
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 05:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbiAREat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 23:30:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232334AbiAREas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 23:30:48 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23CE3C061574
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 20:30:48 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id l6-20020a17090a4d4600b001b44bb75a8bso1658729pjh.3
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 20:30:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kVWJDmtndYI9ZkKfBh5fSCkawynurwpP4JTid5+Zd0g=;
        b=zTd4wc2MZODqhJ7t0obKr7095Dh/mqvb5ilB6sidfOU/wWo2IbHmOuXeltJiEHIS2V
         R2OTp8xCIi/P9Ocy15PhJnuFaY0t+rVuABoTj9/i4PXcT4deqrDqpfNhML/LB9yfnGvm
         NImNzgSPv+qySSxtUTkAEN2inSi2mHQdEW/e6yE8hiQMBcDyZLqTJ4I2BcQ7VpSS/4or
         cPKup00g/UUDw8HlgAzvcyUrELjmW7uH0eJtzIx20HM3lr6qi2t5K7D+L34aanHVAonI
         JCCGJb8pP9IuJIuzB67zcj3PnOuB7cf53eobknwzsvMGctXXD4sRP2w05qEa4hSKdTAo
         unKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kVWJDmtndYI9ZkKfBh5fSCkawynurwpP4JTid5+Zd0g=;
        b=KiCEeLehGlyJHrdAzK1TXf7l3i44nogqfAuuyD8tHxfWTWWQ3ecrCfaH7LaF9pavhs
         fc9q8Clxt56ch2HjuduECBXyay5tr0JiK/RVSUx5YpKYvZYXyaJX0wG8UjRg2b/YLphO
         vT8vDeOBhud6/iPB4XVnrU2RMBjtPcDHvepRtrPLed0ylfeKGeeh0m2isfClCZ5avz4R
         b4sekmj+z2HXPzs68DfCaSRTizIMG1RS0oI7ktxOvUw9m2ZxhgYcoYTrlA00Vp2YBUYh
         nBvV9+NlyUIsIPzxjVgVwn4tHiRg6ZseQSBilNYwbfJZb6IGeN0BWujuK2LDHDu5c7nv
         ehjA==
X-Gm-Message-State: AOAM532EsXQvIOwC7CXcfsb1w9UjE22PjPp2AkX9vIzoqGw/WQDKGw7m
        9Hzk028VxAg/6LbinKqwAxpFMtDrOAzyAQ==
X-Google-Smtp-Source: ABdhPJyOcK4XOp13WqRfyBe2JreSN7UKClWovX5cFdYREZ+COKNlxFaECtJYYczXmF0x7C4K17AAQQ==
X-Received: by 2002:a17:90b:4d8e:: with SMTP id oj14mr38050372pjb.232.1642480247524;
        Mon, 17 Jan 2022 20:30:47 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id l27sm13208136pgb.0.2022.01.17.20.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 20:30:47 -0800 (PST)
Date:   Mon, 17 Jan 2022 20:30:44 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Wen Liang <liangwen12year@gmail.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, aclaudi@redhat.com
Subject: Re: [PATCH iproute2 v4 1/2] tc: u32: add support for json output
Message-ID: <20220117203044.0950e959@hermes.local>
In-Reply-To: <5d67bd669fe97a9a797263e18718cec3dab88cc4.1642472827.git.wenliang@redhat.com>
References: <cover.1642472827.git.wenliang@redhat.com>
        <5d67bd669fe97a9a797263e18718cec3dab88cc4.1642472827.git.wenliang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Jan 2022 21:42:20 -0500
Wen Liang <liangwen12year@gmail.com> wrote:

> Currently u32 filter output does not support json. This commit uses
> proper json functions to add support for it.
> 
> Signed-off-by: Wen Liang <liangwen12year@gmail.com>

Minor warnings from checkpatch, please fix:

WARNING: Missing a blank line after declarations
#88: FILE: tc/f_u32.c:1231:
+		__u32 htdivisor = rta_getattr_u32(tb[TCA_U32_DIVISOR]);
+		print_int(PRINT_ANY, "ht_divisor", "ht divisor %d ", htdivisor);

ERROR: space required after that ',' (ctx:VxV)
#114: FILE: tc/f_u32.c:1250:
+		char *link = sprint_u32_handle(rta_getattr_u32(tb[TCA_U32_LINK]),b1);
 		                                                                ^

WARNING: Missing a blank line after declarations
#115: FILE: tc/f_u32.c:1251:
+		char *link = sprint_u32_handle(rta_getattr_u32(tb[TCA_U32_LINK]),b1);
+		print_string(PRINT_ANY, "link", "link %s ", link);

WARNING: Missing a blank line after declarations
#202: FILE: tc/f_u32.c:1323:
+			unsigned int hmask = (unsigned int)htonl(sel->hmask);
+			print_hex(PRINT_ANY, "hash_mask", "    hash mask %08x ", hmask);

total: 1 errors, 3 warnings, 151 lines checked
