Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75C3350372
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 17:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235596AbhCaP3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 11:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235355AbhCaP3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 11:29:40 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F686C061574
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 08:29:40 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id f22-20020a7bc8d60000b029010c024a1407so1359479wml.2
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 08:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:from:mime-version:content-transfer-encoding
         :content-description:subject:to:date:reply-to;
        bh=of762KLdyKsIQqSd6i1lAmoFoTluBPZFqOpLx9cdtrY=;
        b=izRu2jPKn2cfPrLP6h7avkRjtPBxeHNOty0Y/9DkxVNzOrXTp89qmfp6GOfR72bG7U
         lHn5FhJiTn7wO2dh23Ceujza7fCLEHtjs2cW4gNOZBV2xEJVHMzBGOMSgJb6Hl+Ivz1b
         hvxjT8gWaCYrm3hm7q+2phPeSvJ+SJzUwLXv421QEek3oKkMjwLJKTFt9yMC7uBwYUmr
         fRLBR+9l5ZJupQ7hgIK9MnzvwEgvSer9S0DllyJy8IAQ/i5vXY99P8ribWybVLDycKg/
         V7pTHUJR7NqwR4hvTRoSRwO+jKiRBMtdK8+uzVlwhIqq48HBD73ekcE2/kZzfFuE82Eb
         8QKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:from:mime-version
         :content-transfer-encoding:content-description:subject:to:date
         :reply-to;
        bh=of762KLdyKsIQqSd6i1lAmoFoTluBPZFqOpLx9cdtrY=;
        b=rheJcb5souavIGz5SuWpmmR0kmKc63eTW1u03iGhZCX2glJXlJaijqZrd45E0TfJLK
         Uc7b3QXaLABvYYv/KUcUsGlOvjntIFVOy8LLKCVqRvw036L0b7bAfA8Ck9/TSvuVepmz
         usSoBDDlmaaAeB4K3fbqxTlse43Leo2O+DVtGAclltAUXqxmW9JUiEeJJY3SVRPHsVd0
         nH1dZc82oewkwwDXYQXYfXouvIpgL0zK+6w4OH5W7mGA3w9JNs2rKqrbmgVuc/xJp+Bm
         7SzpWg9g3LF+1LBtleBcqE0DRsf5JhIIqhN4EQfopo+Y/yhXGrmo8l37x1yM9bV1iU20
         +e3Q==
X-Gm-Message-State: AOAM532mD+/ku3bBJb+8IjFNiI9cr1DroMz3+8Oml7+0YfLjnbxbKy1+
        0jjn9a1c5mkeusOMZc2DHrI=
X-Google-Smtp-Source: ABdhPJz0QfiOM75LniCuphqQF2aS2ZFPu/7OmqowvD5G41zQaZBeb4yuZuf1/W0Am5DthpiIQEN73w==
X-Received: by 2002:a1c:498b:: with SMTP id w133mr3824403wma.134.1617204579133;
        Wed, 31 Mar 2021 08:29:39 -0700 (PDT)
Received: from [192.168.1.5] ([154.124.19.111])
        by smtp.gmail.com with ESMTPSA id m9sm5172396wro.52.2021.03.31.08.29.36
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 31 Mar 2021 08:29:38 -0700 (PDT)
Message-ID: <60649562.1c69fb81.1ab12.a69e@mx.google.com>
From:   calanta camara <ndiayeng66@gmail.com>
X-Google-Original-From: calanta camara
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: 
To:     Recipients <calanta@vger.kernel.org>
Date:   Wed, 31 Mar 2021 15:29:32 +0000
Reply-To: calanthacamara202@gmail.com
X-Mailer: cdcaafe51be8cdb99a1c85906066cad3d0e60e273541515a58395093a7c4e1f0eefb01d7fc4e6278706e9fb8c4dad093c3263345202970888b6b4d817f9e998c032e7d59
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

my name is calantha camara i want to talk to you
