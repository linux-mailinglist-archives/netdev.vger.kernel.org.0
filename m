Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41378463423
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 13:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbhK3MYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 07:24:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbhK3MYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 07:24:45 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8979C061574
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 04:21:25 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id n33-20020a05600c502100b0032fb900951eso19359444wmr.4
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 04:21:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=dOS+7NsGEDf91N6vA63l46bMZLuHcr6dF2DLYenVk4Y=;
        b=HWUGyD1oMVEoAqIdm3yC9kTMt2HHlA2xzOtYIuGbgIojIYYu8ASEfqvir256VYGRAq
         awf5ZTpkI0iEz18fOETiuYFN7cDX1whIpe66nq2acMoD3iJYS3iOVvBtFKdCuDSCSBOB
         QlEk4HWzFLseQq8G+IEnl+X6Ok44l9xXgWqVBO79eeL1qH599idEVs0P1LmrF+Toixgs
         Fo2RiRg5d3FePV2LEedvLEtgEtLaEtrcggQDTALFRgPxMKrUBREGO11kBybWfhG/BisJ
         H6Ssa/W1K2ipI6WWFAacALbtKa6mQ6NOCe6bMrjUf8BJN4fKTg2bID48zOM7zEPYDv1v
         3oJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=dOS+7NsGEDf91N6vA63l46bMZLuHcr6dF2DLYenVk4Y=;
        b=VCdozdo4ISWY9saN44xz29vMiFIT1ptzl8+Di8Q2WuoLLuC/9aaTx8G7ZJ54PJwBt4
         ivvot99Coy0Tb9jE2kH9dQowHmANpXgVNwzQfebKJTL/M+71KhvXNvVxTzss5gPqD5se
         uFw9d0zpeCy1jg1RPwh3tOsXVQJRFk7Fp3mYl8lloZH0grZJLXsw/j9o+1TylXRkJOOe
         kAvELryNMc12viFL5t1tmMl7/C3bOpDIVCC7ssFtr+j1sMjt4xt4bTfHMxs81edLq5vd
         45fSyUf3wc3oXZC24JTNYZgPeL7bgqfoIwJ6g17M17T5QSqqEcSM2DXHwGB2ioW8QMpi
         /Lug==
X-Gm-Message-State: AOAM5324MTkVCp7Q9tX7SyqrRiJlRVXEqWG3STjs7Jg0aNaRR+9LJbh/
        XxcZqI/35vvS1SlSXGJE6vuNR4eMpl8o9unHQq0=
X-Google-Smtp-Source: ABdhPJzdc2KgpfW/QUsjqyXZIWoatw7oX3YAU0Mr1J1UASNSgJOVNgLfcpq3ODD5TvCEL6yeE6+QBgV33nwggixEKIQ=
X-Received: by 2002:a1c:8:: with SMTP id 8mr4581085wma.106.1638274884442; Tue,
 30 Nov 2021 04:21:24 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a1c:9ac6:0:0:0:0:0 with HTTP; Tue, 30 Nov 2021 04:21:24
 -0800 (PST)
From:   lee soon <lees38459@gmail.com>
Date:   Tue, 30 Nov 2021 04:21:24 -0800
Message-ID: <CAP3vDPozAk98EL4SrurLS5OCkk_ku0XL074optWPk_9m16p0gA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
i guess you got my mail in parnership in Re-profilling funds
