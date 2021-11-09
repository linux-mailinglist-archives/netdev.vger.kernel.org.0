Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7EF44A56E
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 05:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241535AbhKIEFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 23:05:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhKIEFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 23:05:40 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1229DC061764;
        Mon,  8 Nov 2021 20:02:55 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id o4so4133882pfp.13;
        Mon, 08 Nov 2021 20:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=UG9q6G2BjwUWH74xhXcfBU7EE+jidL6jgypNu9B29wo=;
        b=ohWbT9CobePWC23pP+yX2XJKKR/ohsm3wpML+aI54B5cKMqPZiP5Ci6/R9MYaurMiD
         2s7BA+ON0KAmhelts8TVsf2cOMNjk4+hZafzHYmS2PdPY2ky5p33G4chupmN7NemJQO1
         khqa+iTi/Z/s4cCHmIkxzkc+7Bd/eqwVWVPLfk4juRDGwgap8M45E7heC8BW1JAurhwz
         asx0NnHII+dJI2OwZhVyq4LJf1Vxs5RY61Yzx0MfVCJSR5kNhIU2z8fr13sgcaHEkZcC
         HuS8pt9T9t3/WWV8wMz0l0pvPxv1XKKG2Qj9M3Gu76JVQLPfK2GVjHACf5Oga+82H+QW
         lLYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UG9q6G2BjwUWH74xhXcfBU7EE+jidL6jgypNu9B29wo=;
        b=fSozAUXZD1tIHM7rSgTLFnlchxLOlyzq5cO3sE276t3i0sDociXdvrMYylrgPgfUWh
         ZjmWN7AI4wcSg9kFtx8QgjkwiKYQ0D+91Xk3Cw/GwEBa4aaGH3dYIzFPTr5PGJEDWh+/
         zO3+CIV7E2WYfib7BKzEGFGCgpIGkkdgkq/4pJsYp41xaQHvUZIG/Y98lEOXTBB5PhZ5
         KInQJd2CX/gMNobx7x6/mlU3ZAP77E3sW8TasVw+bAJ9EqaSaQPhKuNE6i1SljNEnVs5
         7tW9Czwuk4C+vl2JRtYrqEiOIRRzHyqdoE9qvFJq9eFc8u3oVlj+7PSF/T/w7vZIRYqo
         9q7A==
X-Gm-Message-State: AOAM533ypdJohf4qv6c64jaQthYZsp3OKGKpOj+IiJ1HQ2MQ920IYPdw
        9In0uLklkG66EKeGab58SZmT3lKLI5Y=
X-Google-Smtp-Source: ABdhPJwt6aO5oipx4XJpGw634PaVTeI7qAjUbGLYA4bc39kLvIm/+miB22trjreDQGILH/R8yHzgDQ==
X-Received: by 2002:a05:6a00:24cd:b0:49f:bf3f:c42c with SMTP id d13-20020a056a0024cd00b0049fbf3fc42cmr4854389pfv.54.1636430574485;
        Mon, 08 Nov 2021 20:02:54 -0800 (PST)
Received: from xplor.waratah.dyndns.org (222-155-101-117-fibre.sparkbb.co.nz. [222.155.101.117])
        by smtp.gmail.com with ESMTPSA id i10sm13771358pfe.180.2021.11.08.20.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 20:02:53 -0800 (PST)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 7A51836020F; Tue,  9 Nov 2021 17:02:49 +1300 (NZDT)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, geert@linux-m68k.org
Cc:     alex@kazik.de, netdev@vger.kernel.org
Subject: [PATCH v9 0/3] Add APNE PCMCIA 100 Mbit support
Date:   Tue,  9 Nov 2021 17:02:39 +1300
Message-Id: <20211109040242.11615-1-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch enables the use of core PCMCIA code to parse
config table entries in Amiga drivers. The remaining two patches
add 16 bit IO support to the m68k low-level IO access code, and 
add code to the APNE driver to autoprobe for 16 bit IO on cards
that support it (the 100 Mbit cards). The core PCMCIA config
table parser is utilized for this (may be built as a module).

Tested by Alex on a 100 Mbit card. Not yet tested on 10 Mbit
cards - if any of those also have the 16 bit IO feature set
in their config table, this patch series would break on those
cards. 

Note that only patch 3 has been sent to netdev. Please CC
linux-m68k when providing comments.

v9 adds a couple of fixes following review comments by Geert.

Cheers,

   Michael

CC: netdev@vger.kernel.org


