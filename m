Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0AB251B6BD
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 05:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242153AbiEEDyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 23:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241728AbiEEDyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 23:54:16 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BF218E3C
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 20:50:26 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id fv2so3034408pjb.4
        for <netdev@vger.kernel.org>; Wed, 04 May 2022 20:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m+oo7vhQppCx61Aw51KngRQvH6xvApHjMjFYXcJPxtA=;
        b=UrVQJB7JQgvliirNAEtIz1NuvjjiM5nMhTGg3BNBEEsPqcqpv085o9RqF3k9jSctDd
         XMBkAq6lGohp9Vl+kk+xLnqvpXZRXGTVVnqih4a4frwxcPsjGOGqaPfyYJLZeU9nDQL4
         0Oe0ma9Jb7sTEp2eJwxZu1ZHJwlF5xUnLbrfjyS6jDwHk5StX5CZ6xNdiBRR4q4ZNbz+
         qop/PFGZWK/Els5yPXj/aN8M3GymAazskG0veatPON1s7Gm3oXGxdxfoOlqImJh4VaXo
         TaiKg/sT2HWoYrh+dx2SrfIm2hAmtZezKx/Vom7umB7/e0AKICg+kUuISWSw8+cpGLEq
         a30w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m+oo7vhQppCx61Aw51KngRQvH6xvApHjMjFYXcJPxtA=;
        b=W8xM3D2wQsrNBKtVbl4OHOcZ2eunYF/xoAUq5RCVng9zYl0PgX1aoGU/BvjFulpNtj
         vEElUx3enXe77wADhVx+TGRwZpwZRaUanKS4wcpzBC1mbU5RpzoCPrK7QKVK+VBQLJCa
         6lIGHFeIPOdkutfpHFIBGMhFv+Gqj6IQWIwoouvsCxnQz3lhKQ5VakRD/w45tpDVMyg+
         uJhKo1+6hYkOk/Ech1K2RqK9X8Cbw78ZzBPbhKEX+aUU63xN1/NqGdRBhSHXd5Zs6XTc
         ijDHEPMaqM9mxToYOp9VB1V34p4082F/czW4HGy195MetDmL9vRu4L5LNp7q9Xj0c+6v
         vkKA==
X-Gm-Message-State: AOAM531i/bLvJKsuiaBswRC8hTG6c/2z/LY7iHDEhtp0gM+kv+Xrh93Z
        WMS8j68bsTebeJ2VCUE9qP5ung==
X-Google-Smtp-Source: ABdhPJz/y6j67krcNJKOcTqMGc2R/29a7/yP/TSwD7uruCbf+yfTtD8wPcMb7nFZR2ALsRV/R6vWYA==
X-Received: by 2002:a17:90a:c302:b0:1bd:14ff:15 with SMTP id g2-20020a17090ac30200b001bd14ff0015mr3640917pjt.19.1651722626058;
        Wed, 04 May 2022 20:50:26 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id c2-20020a170902d48200b0015e8d4eb24asm286196plg.148.2022.05.04.20.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 20:50:25 -0700 (PDT)
Date:   Wed, 4 May 2022 20:50:23 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     "Magesh  M P" <magesh@digitizethings.com>
Cc:     David Ahern <dsahern@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: gateway field missing in netlink message
Message-ID: <20220504205023.5c0327ea@hermes.local>
In-Reply-To: <DM5PR20MB2055CCC42062AF5DB5827BAEAEC29@DM5PR20MB2055.namprd20.prod.outlook.com>
References: <DM5PR20MB2055102B86DB2C2E41682CE3AEC39@DM5PR20MB2055.namprd20.prod.outlook.com>
        <20220504223100.GA2968@u2004-local>
        <DM5PR20MB2055CCC42062AF5DB5827BAEAEC29@DM5PR20MB2055.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 May 2022 03:43:45 +0000
"Magesh  M P" <magesh@digitizethings.com> wrote:

> The librtnl/netns.c contains the parser code as below which parses the MULTIPATH attribute. Could you please take a look at the code and see if anything is wrong ?

Also assuming byte order and assuming sizeof(unsigned int) == sizeof(uint32_t) is likely
to lead you astray.
