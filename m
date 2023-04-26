Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8086EED0C
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 06:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239026AbjDZErO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 00:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjDZErN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 00:47:13 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED596133
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 21:47:11 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id 4fb4d7f45d1cf-506b20efd4cso11177173a12.3
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 21:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682484430; x=1685076430;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JEkw1KmmzfmMdZjy2G/k2kJ9Rp06l3CUoffIihDDUro=;
        b=eBK20lwwpuq8w6rQ7GPJkwXQTNb1GxfSKHD4jd5yA51sq/QDkP8eiPs2c/HhEiNT/n
         yo/CgfehV9buMifZZVQT1U+l/boQs9xCbksELp44hTIkwGqLQm4WGvkmSPKMZYB+SQ/T
         aR4PhSkRK8sUeIY8QTzAR0ALmAlckUsfdB6ephjjnHjsFCb0zyu9c3SHcwOMJ5KD8oZf
         oZJJgOGpPlsdHeEQPjVMV9j7OvqjYSfPVxGwxgXgrTOvZzRMkxkNLL7lTRSBT6y23Pk/
         JsxCidBfB35T6qC9o7FhWKZsTpfyXRR0dwx+dA1zZYjb2JV4QOfReoUS3fOubz4jkhpX
         9KKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682484430; x=1685076430;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JEkw1KmmzfmMdZjy2G/k2kJ9Rp06l3CUoffIihDDUro=;
        b=ZCdY4vu8xAMA0Ts+tNtCI6MiOQ7kZXDUTmoUlIn9gBzKqQU7bhIAFWB4OsncJEZFQA
         ozMJb35ZMSBoUJqFjX8avaMO0gK9VoDlWf6e33/omT1jEILjGGM3EpWOxzPQZFI6kZmc
         3JlOftmfnlLA99tRXE5X31Pej47TjHLH9k0OCLj2NasdcJYrMYgqtV6AtWOePMq1DWta
         JlsdYjaIB0rhKu7yInrE+7ppTSrw6tVFcLusrCXQ2jmdL+ZvVjOyfU0XXl+8h+i1N3RD
         N96HtvHPesJ4omm5Aj2Aa7/oBncwziPOCIi1F3qCrH4YkBrEMQVFOJBCziRe2oIJ28Oz
         MOPg==
X-Gm-Message-State: AAQBX9cE7aSErXHBQGPudKSVLiWcoxyM1gh8g2MihzsoJ/VbzhO+xzI9
        K/kfgHCkGw87F3SdAikJB7oNl5dHVpe2Y+r/Y2s=
X-Google-Smtp-Source: AKy350Y7iUXha6kJlVTeeU+Jm5KcqGzX7Pcvp+gkZ+0Df9bPGAQVM+WiXhWsFxeu5n1laeEPAEXZaZZq/F6IMVU1k44=
X-Received: by 2002:aa7:c684:0:b0:506:bd8f:9301 with SMTP id
 n4-20020aa7c684000000b00506bd8f9301mr16343764edq.2.1682484430080; Tue, 25 Apr
 2023 21:47:10 -0700 (PDT)
MIME-Version: 1.0
Sender: mohamedazzouzi77@gmail.com
Received: by 2002:a05:7412:b83:b0:c7:8b80:7580 with HTTP; Tue, 25 Apr 2023
 21:47:09 -0700 (PDT)
From:   AVA SMITH <avasmith1181@gmail.com>
Date:   Wed, 26 Apr 2023 04:47:09 +0000
X-Google-Sender-Auth: W0cWOY5PLapuRjI2b4u8Fz-sOKU
Message-ID: <CAC-Hp7sCHY1atd6YUnv5RrzMDSZghEufGVSY1XZo82gxehtV7g@mail.gmail.com>
Subject: Hello,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
My name is Dr Ava Smith,a medical doctor from United States.I have
Dual citizenship which is English and French.I will share more details
about me as soon as i get a response from you.

Thanks
Ava
