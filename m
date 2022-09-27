Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E92F5EC748
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 17:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbiI0PK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 11:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbiI0PKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 11:10:55 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC06F5080
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 08:10:54 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id z20so2474569plb.10
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 08:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :reply-to:mime-version:from:to:cc:subject:date;
        bh=/ZejGMeA7/cXZydeKaPk4SxxtzDgXEH4s+XL5esmIiw=;
        b=SUxc09RDSEFh9nwslrU/ucLwy3znfY2sDL9SEBS36SOP79o96bz6u8Jm1U00c9oemR
         67UZB0M0tjJ/Qe2fnmVlw8oiHa4b1upnTZHw+P8I0xIDFDGF/SZOvRthe4nvF/xIj2wJ
         4su0p37NT9ntSA9yrfFljw9ajgrlphOg/bsS9WqZ/Ca8l5Jto9v8Cc+ej+UL0zfGLQrL
         OTozp4In4gwXOr7VRJmAHubmDJXA8N7+PKhRaobsvg1EgVzEnOZA+NTGpWvxIVydSjQh
         /Ino76JxJt9v2d/qnRJo0rpRHqFaeDkIxvNsg/9NgdBrzDNRUz11/On9Ikpk21+irg3Q
         CO8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=/ZejGMeA7/cXZydeKaPk4SxxtzDgXEH4s+XL5esmIiw=;
        b=qTY3ES6u3gXI4pSMYSWlQk8GpNXPBXV5F3zBx+1c8zIfwbMu9VpPhxLBXAK3FyuQGQ
         QIE+WUjt7iYdFoAFMscTdLywANWe+IcrKKTDTPbuwQFf2P+3AfRv9mwHf9gazTnuB8VP
         q3M5p9dW2yFe5bYyZNzPxeRy1GcVib7qaQeRAFnEjU+R2CVSUBBsROsPaV4DkH2m7aUo
         XLtw3R/JiLUgZO6nWe3ZIPywNrDkyb6Nf6jjLdyjZsCBDWlD4zvtFmJu8tsB3jJFM/uj
         kArFR0XSQXM0oFbDNCw1kEcMOugLS3lhTIEPUpIz+MNeKEMR5/Hspd2oI9DpAO2/EPg8
         6D5A==
X-Gm-Message-State: ACrzQf24zKOBqP9pcvrxRxM3Y185ieNoNnWP7NI34s/ZAzzP0T0mz4pF
        Viglb/5n86LacEZpMhStxfTBFvQ7mRlh4QGczTY=
X-Google-Smtp-Source: AMsMyM5giwbeKkmWFH6qJhhwZzXrg4b2NwAC+lPq0igsd4/wVDwDbH9f/KgPrKSqMgQ0K3PNd8bmhT1IReFdplX4RbQ=
X-Received: by 2002:a17:902:a50a:b0:178:b06f:ea1f with SMTP id
 s10-20020a170902a50a00b00178b06fea1fmr27975724plq.13.1664291454431; Tue, 27
 Sep 2022 08:10:54 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sgtkalamanthey@gmail.com
Sender: mjostchekpi@gmail.com
Received: by 2002:a05:7300:a50c:b0:7c:ab7a:8829 with HTTP; Tue, 27 Sep 2022
 08:10:53 -0700 (PDT)
From:   kala manthey <sgtkalamanthey@gmail.com>
Date:   Tue, 27 Sep 2022 08:10:53 -0700
X-Google-Sender-Auth: Wji9RvGcoL9kcxBhzCqvJCaber0
Message-ID: <CAGYN+O8zWNk3Vhi7p0W96QtuO1tW0Y-1upEk1-GPfHvW2_T44g@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Salut, ai primit cele dou=C4=83 e-mailuri anterioare ale mele? te rog anunt=
a-ma
