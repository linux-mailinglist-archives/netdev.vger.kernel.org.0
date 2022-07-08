Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5AD56BFBB
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238470AbiGHRkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 13:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238052AbiGHRkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 13:40:15 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4BC5C9FF
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 10:40:14 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id n15so26705762ljg.8
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 10:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=DpnrVg3zAiOcGmVYnTSsbRQPiLMMhYEkRY8qpOgp5obSViGa4vqVvrYS/llTLgBCmd
         47Jt/oCJPq7eEAgObYdk4YO+NnIRe8xmaSfHoOfJOR1kmqWVOctY6ObJ4TjKKI91nroP
         dj7v2dRRePI+wWoXNWIHJ71GU4cxH7zjVPqIf2EnV0n+lnfz557jHSdeqZl4BICnpSfz
         VglzDys2xXfqIs+KiXVeWQ5mzyByEUiCOlMis6hZUZ1ItPokOsx3f3+q4NQs8hINVL7Z
         6IvB7xUQz8mIi4tNZB3t4K0iaVwoidypYbCf/Pxl4tH13GdREYqrII/0aO+yjWlNXbhX
         GQoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=spHPdoVHaIhbZCpmJ1FH8nlP9QUdlOaNATKZqINaCp6NawO3YoKBE4kVevubiQWitx
         nEeNRyPQjx5YOWHPa9uRQMjVQZv/PbT4n07XnoZwgx2Ig2B9WUBEkpIhRiESoJhTbkm1
         mINBfokQeMAVsmVUTA0/XdAppsN64apmn3TKS3uJTRmv65UU36XG64tvKmpmK1/YPC0H
         WmOBes0zK8ss/11m29iGj/nX9YA3KtPVtsRExNFRuoaAFt9cGkZ4R55bLRWQVIWt2rm8
         G2DxCEXEnlJ7+BpwpeLiwjyhU0I7sghVfytt4tuk9aawjlBx8V9oWrrGxZIvOzfHlX87
         pPNg==
X-Gm-Message-State: AJIora+WweqOekDAU9ZM+zV6nZGl/3EWcPVZYNtUjtuiXjEAPYZ5q3fd
        P0zGSqvwpLx5VvtNGbZh/GSqYu2NO24gVjqL0zY=
X-Google-Smtp-Source: AGRyM1shbirUCDQqJWCs3B5o3gyPYm4IbMmuiwzuqwSQtEZ+OmEwpQw1C1pmwKH+CMmJJ/NQwJ5GYkRrhnrrUA8xiSI=
X-Received: by 2002:a05:651c:553:b0:25b:ca1c:efb8 with SMTP id
 q19-20020a05651c055300b0025bca1cefb8mr2770873ljp.239.1657302012041; Fri, 08
 Jul 2022 10:40:12 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9a:b0b:0:b0:1f7:240d:6e7e with HTTP; Fri, 8 Jul 2022
 10:40:10 -0700 (PDT)
Reply-To: aishagaddafimuslim8@gmail.com
From:   Aisha Gaddafi <ozenabou23@gmail.com>
Date:   Fri, 8 Jul 2022 18:40:10 +0100
Message-ID: <CAPjGXPoSpN-LLjm10beMooqMOhjvEzWZgTnwHTGEY3mqA+0XKA@mail.gmail.com>
Subject: Hello Dear
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


