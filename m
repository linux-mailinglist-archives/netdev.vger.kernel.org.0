Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B8B211270
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 20:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732620AbgGASSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 14:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728453AbgGASSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 14:18:02 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CE4C08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 11:18:02 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id n5so22182292otj.1
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 11:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=sMbnsRrPDBfNIlKxcT4/DAxF9Vuy/N30ZHTRcME+mwU=;
        b=QvSZtx1/w8J1ttfKS0Ih/ifKpu+3OviyCCq4UAjC5QebUYZx14fA7iWf+h6uxaBArI
         hqrSjhK8AV0zkDnRv8/Mm6OX3bB/t1niityHIr+vS+sCbYPdCRItmZ0Ft4dp0Y2JwVxT
         7HeAMG4ZLp9/9NPBBjipsIjc3Vga80bZlh0xMjOuepcoMrf3SZRxw32Gp5yiZ5lXjZvg
         B8BELskkbvXVpuZBosxILUlcxJYLlFkIyYaLH0ucVMpO4rIT8/nZ87tt+3CzA+bXScC/
         THDBAh0gGYtVlVT6tUC6Leinsh7StC3NvaBOD8M2V1w4IuNQER+vALsVb1Jo0j9bqBCs
         K46Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=sMbnsRrPDBfNIlKxcT4/DAxF9Vuy/N30ZHTRcME+mwU=;
        b=qYcSGct3DFYn1Y3SI3zczZQG7vO53r8EV4+6prSDBIIPuOCzE/nBzfZ9v3rTFHvgc/
         xuuSiOiyoGuVb331rOAPHnxbEa6lPlOndxKZpfd9iDDn6SE7Xzyw4TbwsFbkJ1s6yr0V
         YrZeiOzAsFZRHLAf2knmFO1qTpV9CeTmaKVUy2U6YoA9ExbcWr3NCdBsbeFN3CxNF3zA
         vk/eBzo5PS5/84qEFT4yn1SrIWPn/VtKfrlnE/08uYPGnqfz46aN6/jaMNbYFr+P5Jtc
         rPRCjeBGNXnAvwEPqQSo1pO3bkHRDbLO6I9k/PTcZCc3K+nuWiqR0re/4V1NoeP3Z6d0
         yTUA==
X-Gm-Message-State: AOAM533nFcXoBbtirH1n/GwROSW3XSa8ryHZK28hu8+j5hRpaYknWED9
        xzLIaAXh6FFfv7tetnTamTAVOUpeuNLFDoGrvNiK5DGn
X-Google-Smtp-Source: ABdhPJw6fCVXXdO4Gd5GK5nF3nvTbdHkVR9vnMX6XIbX6V1XKiYzuseG9PfcZIzQa5moNOQgfOPA4wvNErcR0QaU1Ho=
X-Received: by 2002:a9d:5503:: with SMTP id l3mr21313864oth.288.1593627481851;
 Wed, 01 Jul 2020 11:18:01 -0700 (PDT)
MIME-Version: 1.0
From:   Kegl Rohit <keglrohit@gmail.com>
Date:   Wed, 1 Jul 2020 20:17:51 +0200
Message-ID: <CAMeyCbgQcbqKgP-K3VvJedpuPnp18An0ifyJyanQCiQeSR5j6A@mail.gmail.com>
Subject: 
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

subscribe netdev
