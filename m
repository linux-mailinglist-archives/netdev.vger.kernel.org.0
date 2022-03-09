Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAA634D3843
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 19:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235242AbiCIR7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 12:59:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiCIR7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 12:59:12 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECFB324BE0
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 09:58:12 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id o64so3431457oib.7
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 09:58:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ty8T93iv0UeEvszlFZ+z3Rm2zy1d4dzF9JOerDbs17g=;
        b=RHk3lCKZs6wmVvtsNLe05n+rM1IhQNac037eDzxWmNiVqDX4OOkzeaDRHSibrXkrbz
         lO7sOEeL4zoN0xOxzgc/rEIlmQyx+JG3kJ1V2XBLJ3zKTnx/7SBsVdw/ncjAI7PZifgy
         n9uyUMfcTo4oqOhF/nnUtxGbDDB8BoHlB6MlqbOSw6aRyN0g701dRx84RW27Ncb8fB4W
         rBVyk8LZk52kBlwluriSxKHrzdum+Wvx2q4kXDolFFYodEtbHFYYT0B+aP093lolqDek
         3Z8nijtBO5lEccj2yvjRCYzT8SxeBpUP1cFoTrf/mavfLfFGMKrfvlA9tawyfTXNYadF
         1rpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ty8T93iv0UeEvszlFZ+z3Rm2zy1d4dzF9JOerDbs17g=;
        b=KnxW/3z6x4ufPeWt/1ciPS3bztBalgsl3+O80Y1jHhVxrB0byTKuKArpAUi93urDMU
         GvgKfjqV/JXGyCc0Rq0jCelVg7YOIK3PE2sx/DFHkaf5TGRyCVvH3zOYweOA6Y3fUnq7
         MPDuwSv4YaXWMDWMvB3yGuuU+fGR6MtVhPalnw6y5A5OC6Y+shmY9wATMLAMMMzrRsqt
         79lId0SEnpEwlt86f5j1b14U+zspbJBDp/cgUWza5ViaIGGN0aWL8SKLqDrKqUSWV1Vj
         ugR6y1SZSruHvkQjRyY5PFdFyg6QxCjOV1FYMBX7mE/YXi9LoxbAi9/zEBHssdmd71Yc
         rhuw==
X-Gm-Message-State: AOAM533upFm1k016hKJU2XgY1F/fv0gV2l2oC9n3vxtWvCsfrGgr+xQy
        bZyJl6JPndI+xsMiFEjDOe1Gn8H4QdpDnA==
X-Google-Smtp-Source: ABdhPJy+eZT5PdnV73toImsLq6l5fcLUucK+nJMuTSPHalvWtSNmORlWNpADo4LW1Tmhj5C7p6u6Ow==
X-Received: by 2002:a05:6808:1590:b0:2d9:ca75:8edd with SMTP id t16-20020a056808159000b002d9ca758eddmr6692047oiw.189.1646848692058;
        Wed, 09 Mar 2022 09:58:12 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id bg35-20020a056820082300b0032113f5ef98sm1333758oob.27.2022.03.09.09.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 09:58:11 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v3] net: dsa: tag_rtl8_4: fix typo in modalias name
Date:   Wed,  9 Mar 2022 14:56:42 -0300
Message-Id: <20220309175641.12943-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
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

DSA_TAG_PROTO_RTL8_4L is not defined. It should be
DSA_TAG_PROTO_RTL8_4T.

Fixes: cd87fecdedd7 ("net: dsa: tag_rtl8_4: add rtl8_4t trailing variant")
Reported-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/tag_rtl8_4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_rtl8_4.c b/net/dsa/tag_rtl8_4.c
index 71fec45fd0ea..a593ead7ff26 100644
--- a/net/dsa/tag_rtl8_4.c
+++ b/net/dsa/tag_rtl8_4.c
@@ -247,7 +247,7 @@ static const struct dsa_device_ops rtl8_4t_netdev_ops = {
 
 DSA_TAG_DRIVER(rtl8_4t_netdev_ops);
 
-MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_RTL8_4L);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_RTL8_4T);
 
 static struct dsa_tag_driver *dsa_tag_drivers[] = {
 	&DSA_TAG_DRIVER_NAME(rtl8_4_netdev_ops),
-- 
2.35.1

