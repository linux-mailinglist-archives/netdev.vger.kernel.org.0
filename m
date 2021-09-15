Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C2440C059
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 09:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236528AbhIOHVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 03:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbhIOHVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 03:21:45 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1439C061574
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 00:20:26 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id y17so1796460pfl.13
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 00:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=6GbSj7gEvOoqZlIdbKLmE5E6KdpY13xxBb7ovvikPwQ=;
        b=Pf4AF4wSiP/2WLfaIKdllVt33XXXRcq9n0DhIlOhiTmi/oIERfi4lxfHdpspM3bVau
         4CrB52Hh8DgkVTEcDOQLyboOPvfpb1Wfkel+5e+H1Zfc/DD1lmq1qWgB/OuzJfTSUMGA
         HmQbKr9gvVFgTB79ZpOS/5omZl7WLyHZicHs7ddtMq6VGoJJS7uLxylGGQRp0fA05vBS
         A4dloOlJgxloZ/oZQwX52bmC3gYcoIyjP2QbGNT3zaXbVXr7VONQrt9UTWGdMhtAmDsK
         EBnwUdFC0tuqFM5H5NzMpIkgkvjqfMpkO+hzqe+PTAMxYh/KwDU9oqTpFv97S6L9MPSe
         qtBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=6GbSj7gEvOoqZlIdbKLmE5E6KdpY13xxBb7ovvikPwQ=;
        b=3uhHtQb0cvB+fm9IjFE3hTYvJWtcq1jsB9LFMKj+/zxCg6O1DjZE3dcSu/f7wMEALD
         G8AIOETlFC3NKWZT7LOXbIvucykV9Mj/nF7BwUWeZ/8C4OZldmRO0tNIPxpxKY6GdIeK
         lVnHbIk3GXRBxqBOhySyi2OBTzYty3GK6oMR/ekWBel+wbhOWNADFthP+UCc3gwLgcxA
         uf81SFT2z5/4w6L//LCQrhgQcn1jLqk0laYtRWUCLGB+jRk35xR4Czjh5ytsTI+nMnQa
         NePeoOTJMS84y4qBvkB/XynumilbcAvzQIOeIokSgRBBrEDTA+ki6XEhWxRwxPYGz29U
         d/Dg==
X-Gm-Message-State: AOAM530SmZ03keo8z/tOh3oRy3Ux1Nmrzms1iqv7z1f1KQvQV/Kgc/0C
        258tDJlA8x+juXOUCB1X8mE=
X-Google-Smtp-Source: ABdhPJx2G/6eAHLZ1y/uCjGiLBrb8oEeCenodtDk9kUuLbrveFAUo9Dq4c6QEO0Gu6VJR4Q+NU5uoQ==
X-Received: by 2002:a63:e00b:: with SMTP id e11mr19318038pgh.190.1631690426216;
        Wed, 15 Sep 2021 00:20:26 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id l6sm12483936pff.74.2021.09.15.00.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 00:19:53 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: tag_rtl4_a: Drop bit 9 from egress frames
Date:   Wed, 15 Sep 2021 15:19:01 +0800
Message-Id: <20210915071901.1315-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210913143156.1264570-1-linus.walleij@linaro.org>
References: <20210913143156.1264570-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 04:31:56PM +0200, Linus Walleij wrote:
> This drops the code setting bit 9 on egress frames on the
> Realtek "type A" (RTL8366RB) frames.

FYI, on RTL8366S, bit 9 on egress frames is disable learning.

> This bit was set on ingress frames for unknown reason,

I think it could be the reason why the frame is forwarded to the CPU.

> and was set on egress frames as the format of ingress
> and egress frames was believed to be the same. As that
> assumption turned out to be false, and since this bit
> seems to have zero effect on the behaviour of the switch
> let's drop this bit entirely.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
