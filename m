Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28AEE39C09C
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 21:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbhFDTsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 15:48:00 -0400
Received: from mail-wm1-f49.google.com ([209.85.128.49]:40556 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbhFDTr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 15:47:59 -0400
Received: by mail-wm1-f49.google.com with SMTP id b145-20020a1c80970000b029019c8c824054so8547240wmd.5
        for <netdev@vger.kernel.org>; Fri, 04 Jun 2021 12:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qkJnhycDPhg0+Sps/O0zolSgQD1ZU1bbCfvTJVOuqqw=;
        b=r+Pml6EZEiFwM3Wv4q6hplnsGsXcCbgTXxgcZn3o1ssqv1gAia4OaovME60kd+5N50
         dxU8ujQgVtAJ47pHDwQoF5q3d1JR+jSDiSbuIJZ6JyYP3XWQhGUMUQ+KBGv9BBPWiX81
         Yh4AKHwE030m+5WSlgKNEqgh92lDLDi6dyHgOpc79nl/VnbP9HfjEEVgVsCnBsnPGGPy
         u4L/ORrsQ6OjjDeEyPuQA/fh3eBfTQyO/FkH9RNjkT8etB/bG1GoV734RLTRJVT+f1bg
         xjzG3q7SPFS4n2HzY0cY5ESTWPIxpMgssbTpJFDm+zYrRJFPTeFCjPs+itk2pcNyJqmk
         jUIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qkJnhycDPhg0+Sps/O0zolSgQD1ZU1bbCfvTJVOuqqw=;
        b=UUw5gh/1wQObtb0RR+gttRaJ6J7PRZKrLKkBK3OgqdOTmEAenNuJAiA6VAIx6V/JqL
         xP4UU5QvwGXdzsOuzqqqHKMVL+iB9JOS60CaADjQ9JBi5ZdeYS3KQ+SEBChlUnL9Vm25
         g//93M4QvszkEieBI5Ox1H+bZJTDi3K6MGyi4ft44bEVn6MItxZ+Wb29RuJH49DEtsLg
         QtUBQ63r/yvA2iHE/cBT6+EhPGyc9fBtZpXCI2hWYTs1NZQ+LI+VdsJyZq3p/CCliyRX
         0pzwnkHyQA8tIaHlVlNtBCA45En08itNqsVGJf4hILEEIyEYn6G8Cy41bwXU6tI+XZvF
         gmIw==
X-Gm-Message-State: AOAM5321WRHf44tevY1buQJESjX3FcYfilTYjKcxmoqP+OvKMaLBFDa0
        Al4LbuedGDXzzLMqwePPf04=
X-Google-Smtp-Source: ABdhPJyrnwfTxPEzfo/NoQJfpGegROunXWPkbX0GZ449H1QasyoM4bj7kqGRNySX5Al+jnko2uLhOg==
X-Received: by 2002:a1c:c256:: with SMTP id s83mr5057957wmf.86.1622835912252;
        Fri, 04 Jun 2021 12:45:12 -0700 (PDT)
Received: from localhost.localdomain (p200300f137127c00f22f74fffe210725.dip0.t-ipconnect.de. [2003:f1:3712:7c00:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id k8sm4761676wrp.3.2021.06.04.12.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 12:45:11 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     lxu@maxlinear.com
Cc:     andrew@lunn.ch, davem@davemloft.net, hkallweit1@gmail.com,
        hmehrtens@maxlinear.com, kuba@kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, tmohren@maxlinear.com,
        vee.khee.wong@linux.intel.com
Subject: RE: [PATCH v3] net: phy: add Maxlinear GPY115/21x/24x driver
Date:   Fri,  4 Jun 2021 21:44:28 +0200
Message-Id: <20210604194428.2276092-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210604161250.49749-1-lxu@maxlinear.com>
References: <20210604161250.49749-1-lxu@maxlinear.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

> Add driver to support the Maxlinear GPY115, GPY211, GPY212, GPY215,
> GPY241, GPY245 PHYs.
to me this seems like an evolution of the Lantiq XWAY PHYs for which
we already have a driver: intel-xway.c.
Intel took over Lantiq some years ago and last year MaxLinear then
took over what was formerly Lantiq from Intel.

From what I can tell right away: the interrupt handling still seems
to be the same. Also the GPHY firmware version register also was there
on older SoCs (with two or more GPHYs embedded into the SoC). SGMII
support is new. And I am not sure about Wake-on-LAN.

Have you considered adding support for these new PHYs to intel-xway.c?



Best regards,
Martin
