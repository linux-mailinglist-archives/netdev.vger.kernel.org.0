Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3884C635B
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 07:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233372AbiB1GuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 01:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbiB1GuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 01:50:22 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD7F4ECF0
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 22:49:44 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id z11so1492721pla.7
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 22:49:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:from:to:subject
         :content-transfer-encoding;
        bh=QCO1/HEd7WRwUqwTXMKOXf4ebpkv4RyC7DMyuYkxZzY=;
        b=h9q6OUkqIuaZkHv423l/oU1M8TZvzcw46G2PbTRcHvTN0geQslHk27xwff05Seu9e0
         Ky5azB98bIBRfod04XzPV+1ophsLu1BQhQT4VeZh8QSPe0vcwKuUZcY+gt1E58MJaONm
         lztbmiXVvO9Y/hnZntX2qkRo1/6UlqvCUkOUSGIUWMRk8bMtsbGT5+7eHrzTSTAFws5d
         AFXgdeR/d9o8+XZPYQAIve6q/QyG1+vdA9qGCtCJoNIU2+lvadLU2o4A8rTg4t+Qx48x
         zZk4rTOvgiiKnXc1zGkqCBnyRcZ+oi6n+rs70qw2eGh7T0B+VTRfyiUwumzgCQIpkZRx
         LTkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:from:to:subject
         :content-transfer-encoding;
        bh=QCO1/HEd7WRwUqwTXMKOXf4ebpkv4RyC7DMyuYkxZzY=;
        b=2pZPyi0eQWBe1V7hUxnaGHcyz1+ueLxYuIJ/8F0hNp4oFlqWUXnTz+KXdiP75DHn4G
         Ct0y6jvBFLSQKsYKU78ovtINyvYVwlxCvVxb61/0cyLt5+DdARGzQLMCmYHYH1YU1wP+
         VjQBblMTWKIuLSjyhOqaT3ma/xTBoj59HGtL9xvYeERjaVJVfHBboxWKdIyz03lG+ll6
         Ee1mzPwRiQT9xlwwfKp0cMhkWRup0iYRtR+VAbVqSpjNIMrlWfoLg3nYRvgraDJdJdae
         0YIzl/0naX5Nbr782KsxZmhbT6LRqRKuM/JIK/TtUfj99cgBWRGBBetk20jQ0xItHxht
         EKfw==
X-Gm-Message-State: AOAM5323WGhfipbsQoGnZFdSdAsUrZ2W8PaB41S590zi9OmVkXhNb075
        /6Fw2uIadtx2ykXoA7B9NNlV600wv9s=
X-Google-Smtp-Source: ABdhPJz4jTNLv19K7AX4XWP2BSZY1bQyxrKE+pabMCyuNW47oQfxESb6ixdp1DJRu0Od5/ArV4FNcg==
X-Received: by 2002:a17:902:7403:b0:14f:9f55:f9e6 with SMTP id g3-20020a170902740300b0014f9f55f9e6mr19076217pll.21.1646030984152;
        Sun, 27 Feb 2022 22:49:44 -0800 (PST)
Received: from rsnbd ([103.108.60.140])
        by smtp.gmail.com with ESMTPSA id y191-20020a6264c8000000b004e1bf2f580csm11595343pfb.78.2022.02.27.22.49.43
        for <netdev@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Sun, 27 Feb 2022 22:49:43 -0800 (PST)
Message-ID: <621c7087.1c69fb81.36942.dc9f@mx.google.com>
Date:   Sun, 27 Feb 2022 22:49:43 -0800 (PST)
X-Google-Original-Date: 28 Feb 2022 12:49:36 +0600
MIME-Version: 1.0
From:   "Nancy Brown " <andrewrkopf@gmail.com>
To:     netdev@vger.kernel.org
Subject: looking for something?
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,PDS_OTHER_BAD_TLD,
        RCVD_IN_DNSWL_NONE,SCC_BODY_URI_ONLY,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLACK autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGFrZSBhcyB5b3Ugd2lzaApEaXJlY3QgQ29udGFjdCB3d3cub2ZmZXIydS54eXo=

