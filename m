Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 938925F1E9C
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 20:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiJAScC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 14:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiJAScA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 14:32:00 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE946110E;
        Sat,  1 Oct 2022 11:31:54 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id c11so11357528wrp.11;
        Sat, 01 Oct 2022 11:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:message-id:subject:date:mime-version:from
         :content-transfer-encoding:from:to:cc:subject:date;
        bh=yaHo/fkgmKtjiFvYg9anrP08CzFGCMg8qvbZ1d5sC1k=;
        b=aWMe/fbVkGVihePt+VxdzffL0P5cREVtQXx1bHsJ/nWbKFjOtoSjbemU+RULpXNsFV
         gg0O80SK1F4MsSQpvP0HtBV+u7ea6pB5iwR1mVu3oxVcpdKanD2QXyEfrVVsKl7Kca3r
         eEVMKv8Y9eUPMsrr036cqGsMKVtjqx64mrKZ4ZwrZ3sVqGmH4XB6F8nDsVmuMLBGTFII
         2o/Un6QtsVoLgTPCnjhWwix7Gtby1cAbhTjwLyGvlzPyyuyn1Z/YKce20asZVjqPlSlY
         RpslfeM8/9svfEhZFQaQLWswokprr3dj+C8/RV/L8o7g76US29NI6AqhHwvApCaDzXZq
         v3Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:cc:message-id:subject:date:mime-version:from
         :content-transfer-encoding:x-gm-message-state:from:to:cc:subject
         :date;
        bh=yaHo/fkgmKtjiFvYg9anrP08CzFGCMg8qvbZ1d5sC1k=;
        b=4tlMCD0hz/Ppf1a6D9+6o74/rpjBwQz3ZCk9Fb57nejTZNWRDHH3xJ2oVaTkX/xIdQ
         mKW3NAZW8tCsUDQ+uS1N3klcWdtoHV5geiLBbK1PeND/XlPbTSazp7ql8Ec9kUf6GpLU
         Rl3a6rfj0GAtmqIMfkn+bb6AstQUrvfxgOm5zOX6RuibIIIyp0o7h+Rt1nzHn0e1dLBT
         S0aW9yzLIEjLHeSb1mpn003N5EmjjJ8YlW6G7BIw5AXtWHs470dY1FWdeCzXmwi3mKWa
         PCz4rEFaOAwfShz5rCnLYUpf6WG+qLJuXJzikEXb4aSBxPXKjZgIcNokl2+OGX9ZftoI
         xM+Q==
X-Gm-Message-State: ACrzQf2G65t6n+9dWn6PPn1forbuqBHFI/yh0JlGYSw8p1o7bD+sThOB
        9Y0Lc8CPZHu6WyTE+a+dR6A=
X-Google-Smtp-Source: AMsMyM5QQHUq8fdJTm+Z4Y5RAZnuTJQ8zM7iliBjxOfC7YNAQp5mBIn9N2cHGwE6yfLgh0jCeM0zBQ==
X-Received: by 2002:a5d:6d8e:0:b0:22a:4831:e0e with SMTP id l14-20020a5d6d8e000000b0022a48310e0emr8509923wrs.442.1664649112807;
        Sat, 01 Oct 2022 11:31:52 -0700 (PDT)
Received: from smtpclient.apple (2a02-842a-869b-9901-9890-b0fd-0193-07b5.rev.sfr.net. [2a02:842a:869b:9901:9890:b0fd:193:7b5])
        by smtp.gmail.com with ESMTPSA id y10-20020adffa4a000000b00228da845d4dsm5871076wrr.94.2022.10.01.11.31.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Oct 2022 11:31:52 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Bassam Hamze <hamze.bassam1988@gmail.com>
Mime-Version: 1.0 (1.0)
Date:   Sat, 1 Oct 2022 20:31:41 +0200
Subject: Re: [PATCH net-next 0/5] Add QoS offload support for sparx5
Message-Id: <91AB6DB2-C090-4B4B-86F5-2E229EBC0514@gmail.com>
Cc:     Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        casper.casan@gmail.com, davem@davemloft.net, edumazet@google.com,
        horatiu.vultur@microchip.com, kuba@kernel.org,
        lars.povlsen@microchip.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, rmk+kernel@armlinux.org.uk
To:     daniel.machon@microchip.com
X-Mailer: iPhone Mail (20A380)
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arr=C3=AAt sur mon mail cordialement=20

Envoy=C3=A9 de mon iPhone=
