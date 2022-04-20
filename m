Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 720CB507F1A
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 04:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346007AbiDTCxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 22:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241926AbiDTCxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 22:53:16 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15D431341
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 19:50:30 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id n17so296418ljc.11
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 19:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=jxe6aaDFwdux36JQcvP6igMTeJQ+Mr5d6kdF2Kkf4S8=;
        b=Itd/G3B/lluDFqySfzU6vHOEE6ZtjTSLxvXR8SIXyHdZHcqi5xrd7BCHTUZaVCXUYM
         72WeGzv3i5w4lUY4YVjjSzjWqRLvW9tbV6E4qPD2XavlfDB4E8L0+vsFl2KqydaVpJrD
         FtUX8Ok7/mgsUF6LzCZLN6gKXBE935wANTgWetF516EIhzL49G09bnjVuNXSDuxje1Zt
         Wf6SRyeZvKUH2oySSlPaXGffm3PLRr0CRI4zep5lpPaeuCZ/71jdcjDh1AX4LAtJGvUF
         D+U1LRPpo6t0KzPS9Rnkt/f8/hQFSmh15GrZSLqfy/sTeSz80iKQaL3BJjAyoR2aSioU
         nw9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=jxe6aaDFwdux36JQcvP6igMTeJQ+Mr5d6kdF2Kkf4S8=;
        b=3VzVJTvh5OqIXugm2bqkV6eOuFHQ8NcTCwvS4TWdRGbCRsuGvAK1cSJ7Gi1j8p2LbF
         jIK8GcdQhZH8ezCPbxlkjoZAHaR/ZvG9rIaMrEO1Lan4lvMlHp4y7vPi9168BmgCrWX5
         +sDIzUKDJJQaR941M/kOs35zfxfmALTax/8l8p6ASALQEaqA6nrRErahav5j0axgjpU3
         Hj+GaQQOL0AGE83sohVE36VxeRULACtmEQaafoudRbeE6V4JQgTK6ZdC2gRj9PKdksh7
         xppr2G2SifH3u97ONp1na3aHKRJwLOY6w/NvH89zJy/CzSoSfrT+6c0/ayQxQRrI/NTy
         prNw==
X-Gm-Message-State: AOAM533cfKA58LeCZ7Kv8o6udoGyG0755JiDMY6AnOeIUYtOVwB3P/+E
        BlXFA1p7xtb/zrb7YU0S4mH1OaCsitjucxrTyMk=
X-Google-Smtp-Source: ABdhPJzjs85Rq/YKb010AcP60dWdMJeWg09+fckyA0AmK+77lKbvn1SPnrVYfadXnIJ6HNmZEeMxPngGaaF/Hv2YSJo=
X-Received: by 2002:a2e:9d06:0:b0:24c:7dee:4d58 with SMTP id
 t6-20020a2e9d06000000b0024c7dee4d58mr11925723lji.177.1650423028982; Tue, 19
 Apr 2022 19:50:28 -0700 (PDT)
MIME-Version: 1.0
Sender: alobadodji@gmail.com
Received: by 2002:a05:651c:505:0:0:0:0 with HTTP; Tue, 19 Apr 2022 19:50:28
 -0700 (PDT)
From:   Miss Reacheal <reacheal4u@gmail.com>
Date:   Wed, 20 Apr 2022 02:50:28 +0000
X-Google-Sender-Auth: 69LSrBzlnyfAVbbkdMq9_4j59Og
Message-ID: <CACNx-8pkM1gxbV+mKdLo--moTFSDshqgx_AziAixxnBcYX1BAg@mail.gmail.com>
Subject: Re: Hello Dear
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=2.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_NAME_FM_MR_MRS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

5L2g5aW977yMDQoNCuS9oOaUtuWIsOaIkeS5i+WJjeeahOa2iOaBr+S6huWQl++8nyDmiJHkuYvl
iY3ogZTns7vov4fkvaDvvIzkvYbmtojmga/lpLHotKXkuobvvIzmiYDku6XmiJHlhrPlrprlho3l
hpnkuIDmrKHjgIIg6K+356Gu6K6k5oKo5piv5ZCm5pS25Yiw5q2k5L+h5oGv77yM5Lul5L6/5oiR
57un57ut77yMDQoNCuetieW+heS9oOeahOetlOWkjeOAgg0KDQrpl67lgJnvvIwNCueRnueni+Ww
j+WnkA0K
