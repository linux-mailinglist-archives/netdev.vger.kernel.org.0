Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3455C4A9F1B
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 19:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377593AbiBDSfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 13:35:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377579AbiBDSfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 13:35:31 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81DEC061401
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 10:35:31 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id m10so9546558oie.2
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 10:35:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8xik0QAzPDQ85r7JS3gUAX6SdvSq+GnyJ357557KziY=;
        b=ZH/qr+D5+aOduFTeJdyvWHqAC+Teewt5+znTx5b/7EkFJzrDihLXZfbP7iweXmcdDc
         +56HM2nC91Ysf+ej6QyraPcd3C3nPXTpw68RotpFUaaAnDAKm63DB3V1AipTMZOUiUvC
         PB7Tvh3pf4JQfOdHgGrkB4nmpsQNUamSlg+LvaYfYi5nr9pf0y4PY3jQZnlqY9Zoocnx
         dG9aujxARmWi/W1GQUP7/VXZ368lZth3jd0EHlLQCLlI/CzygVTfs4TGbLQly3ueBFjH
         n4xTuSjE/Feoa7vI1j5AugPcxtfzLmgmsYM71GbapJr/AGJl9ULN4js/hWE7h+vN5Ulf
         /n3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8xik0QAzPDQ85r7JS3gUAX6SdvSq+GnyJ357557KziY=;
        b=Zg8rbne31BhBR9CM6uBWEZnRqIuzX3auDx002BQUidYsBH2DJszCyl4VggyoUdWfN2
         CBA5JdGLQnsy5vKJZy7ZpLlnbsUijuA0sFVV71DiyMPZfNUzCLs7kB6LJ2MN+m37CIS9
         il/fZfBQs7+RBB41DaqkCD1TL03cJArBuV5Akyc+RHIpH4GXXP/2XVrOZvdHgnYcifrI
         9RIVsPB2uiXaIwHCG5+PPy/rUM0ixzbH30BU3w2B9k1Ds1L0menSD90+XrVPi10WYzQ3
         5/YoEw4nvdVyGmV4IK38Y4qGpfpYv/I/8ne7FHrxSluZQHj1u5/Q4m6m2F9qj0deiP+3
         4hQg==
X-Gm-Message-State: AOAM533bSgQhCVPFMJW84O8NYVdcmOp9NnJDGxBcfEPF/0qa5Or+/uPO
        CoodTNkGXpA6YYyE292zksm7wgz/v5UGQA==
X-Google-Smtp-Source: ABdhPJzY6V1oBbVZMY7ogvceH2Vkd2PMk4xJ5iz+JXpcGqdGINCosCN64zh7W2+k9A/dVcMj2wHHlg==
X-Received: by 2002:a05:6808:1154:: with SMTP id u20mr2034723oiu.169.1643999731210;
        Fri, 04 Feb 2022 10:35:31 -0800 (PST)
Received: from builder.lan ([2600:1700:a0:3dc8:3697:f6ff:fe85:aac9])
        by smtp.gmail.com with ESMTPSA id 100sm1044182oth.75.2022.02.04.10.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 10:35:30 -0800 (PST)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Alex Elder <elder@linaro.org>, agross@kernel.org,
        robh+dt@kernel.org
Cc:     jponduru@codeaurora.org, cpratapa@codeaurora.org, elder@kernel.org,
        davem@davemloft.net, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        evgreen@chromium.org, linux-arm-msm@vger.kernel.org,
        mka@chromium.org, avuyyuru@codeaurora.org, kuba@kernel.org
Subject: Re: (subset) [PATCH] arm64: dts: qcom: add IPA qcom,qmp property
Date:   Fri,  4 Feb 2022 12:35:19 -0600
Message-Id: <164399969245.3386915.16495815225797600052.b4-ty@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220201140723.467431-1-elder@linaro.org>
References: <20220201140723.467431-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Feb 2022 08:07:23 -0600, Alex Elder wrote:
> At least three platforms require the "qcom,qmp" property to be
> specified, so the IPA driver can request register retention across
> power collapse.  Update DTS files accordingly.
> 
> 

Applied, thanks!

[1/1] arm64: dts: qcom: add IPA qcom,qmp property
      commit: 73419e4d2fd1b838fcb1df6a978d67b3ae1c5c01

Best regards,
-- 
Bjorn Andersson <bjorn.andersson@linaro.org>
