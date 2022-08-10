Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8E0B58E824
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 09:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbiHJHsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 03:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbiHJHsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 03:48:37 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4485B6F541
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 00:48:36 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-328303afa6eso133901867b3.10
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 00:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=ze1eT5Lg5bNGve/aGYosnnSf8uaPmjR59Sgjcewn6dA=;
        b=frC8xrn8w5IgFYZnEWxcsb6S4a7NOctk0eVKr8x+p1hUUyyrWjEdtmO3OvKoWJ9XNn
         ohDD824BzwaMV2CBt2qy6TW84uacLlNx2MauCBEPRpLJB4+Gdr/gX6fau1eoewFOqgr2
         ZMfC8MtYQln4kRqz8f2D+aS45S+O/D6YS0sVJAXOy79xvi46UTuXyh61a62OBDRae4nJ
         C740wxG4InaFsMGG4yvUv9A/jJ698cuuvoE1dRk7NyGNCjvAXPeMtzD23/bkOPyPtjKK
         /oC2FpveMOnGFNabpzqRt599n+C6RO4luzeIqtDtLAcFbFKWZgS5aA7loLVxHnEyc+MG
         Gi0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=ze1eT5Lg5bNGve/aGYosnnSf8uaPmjR59Sgjcewn6dA=;
        b=unOrIdMqFzwYsXY/StmZM7RaC0PwqIsg3rmQOHIi1Ov0dp8vLfVbV4v5CbOZB4JuBw
         9VyfR1e4yd1C8DQVOWC/REP3Rers3RfR7tfGSzMiv6hjVk8uQciJTT/Od1opsEIvaNQx
         fnD2c8knUDRJ3u5rzj1zTsfJm6t1HP9Cd5IvB6Wl3acSiy6U1okHgV76CLEgaRaGitY/
         I2dV1xJU42w+ZQZZ3kMX4CYj/wqKPJUilQ+kZ06NmV1i0un27rsUCMsXeyDbdS0FOdVw
         ytsyJ9GxJt8Bj0q8UhBglnVLb7WkRW1SgJpSkW2leaniXHGMSdKpdYrO6Ggbw3hnbeBa
         2AHw==
X-Gm-Message-State: ACgBeo3MZzxjO8r1RPslTZNm78ZUHi81bBYxcecHvZIUB0i95DUzwTA/
        u42rdTV6ObgkQoLH7FNK/uDFuMbkmkGdkhlIJpU=
X-Google-Smtp-Source: AA6agR4pzlZKukbvIdyp/EdB/ZuaQu+11y/EcE5yQQSUvY/9VqqmuCi7yRgTy5OGSmyStsm2kDaNW0aeEHVgQ/caxUA=
X-Received: by 2002:a81:87c4:0:b0:329:f72e:5c6c with SMTP id
 x187-20020a8187c4000000b00329f72e5c6cmr6586993ywf.134.1660117715530; Wed, 10
 Aug 2022 00:48:35 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7000:8a20:0:0:0:0 with HTTP; Wed, 10 Aug 2022 00:48:35
 -0700 (PDT)
Reply-To: s.clarke@rahimglobalinc.com
From:   Sara Clarke <congratulationwinner1957@gmail.com>
Date:   Wed, 10 Aug 2022 10:48:35 +0300
Message-ID: <CAHN40gzVHzn6dYaTLMk10s_qTMgz+pjU94=w3Rx-+DraLbLzLQ@mail.gmail.com>
Subject: Enquiries
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
We are interested in purchasing your product, kindly furnish with us
your price list.

Best regard,
Sara Clarke,
Purchasing Manager
Rahim Consultants Office Address
17 Bridge Road East Molesey
Surrey KT8 9EU
United Kingdom
