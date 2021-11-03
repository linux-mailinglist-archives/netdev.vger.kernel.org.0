Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 891D244423B
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 14:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbhKCNTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 09:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhKCNTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 09:19:37 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42677C061714
        for <netdev@vger.kernel.org>; Wed,  3 Nov 2021 06:17:01 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id bu18so5228298lfb.0
        for <netdev@vger.kernel.org>; Wed, 03 Nov 2021 06:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=sMbnsRrPDBfNIlKxcT4/DAxF9Vuy/N30ZHTRcME+mwU=;
        b=Zn8rg2jdMNz2js7Kt0l2N6qfT4bbS6DCGHC4EkHGDzKgnfbTZjoix4fIX1JyTBJKh/
         U4fC/YVJyCaHjfoLAhIFzoR/2JxKy7hjAPpurKAEBVq6xNz8/0mkzODlXDDYAR864NXh
         CuJco2YSD1qY4M1aJJpRYP5mUpfufz8rNugoMMEtiyzmhJjLxZ3WuU8xm2rRHltPtQAv
         4dZvY4vz/+UgrgFTtN7GDT2sD7138nyEL4Z8prKDrvMrQINhepMRwJg3hfZsznGMqjVF
         D269UPJ/hR69ShixQITvQmebT0nyeNp1SpHdP1Jnd0e7BYpP4p2d4zhY0bWQdwIczGdf
         4kzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=sMbnsRrPDBfNIlKxcT4/DAxF9Vuy/N30ZHTRcME+mwU=;
        b=sELNTNJOmA8AlNOsGiq1v7IBOYOPvvTPj+nSaq8MlnZ6dV31jUNKIJ/RjQc39pgt9C
         sdsbLXwvAtXljBlZQ2oIT+Dbf3tYoA1ZqjpZYvJQ5sIhznVjCeNHRuMra5eCLFqIpwD9
         fsRePFlPEQnkzNxl4umFGIlrx9ppgH9k9nDkeTBGEQLMPNSxRVAS/q0kjSjv5fXkJiN3
         KsPpjH/TbI4yRe+9m+hFqaTGM1lzzfdQMTrAW3OgHZ4of1JBHaY18HZ2e0s3bJUckWNR
         NuEIeQXMPb+0TWxaBiXlA6szZKwcJgBOmw/zx7zDPOvUnRgkGYR9ZAXCojpNjCzgI3cz
         tQ5Q==
X-Gm-Message-State: AOAM532URCjbc/p86ZvMiRMDqTYUQ5zSABMMuSmrdFcFsKFRAOj4EIMV
        LvE8RJ0kBQ7oi3J1to6HuOrQM83olH5aiZCF8g4+MY942/US/w==
X-Google-Smtp-Source: ABdhPJwKenE1PlZD2DiCvsRVeIuHFWxXoW683FpKe08i4G2La6zFUIKkCSCH3fgQ59lSUmnaPs+7UgvqzQ4N1FO384I=
X-Received: by 2002:ac2:5d41:: with SMTP id w1mr26090926lfd.69.1635945419606;
 Wed, 03 Nov 2021 06:16:59 -0700 (PDT)
MIME-Version: 1.0
From:   Adrien Vasseur <adrien.vasseur@6wind.com>
Date:   Wed, 3 Nov 2021 14:16:49 +0100
Message-ID: <CAGLosMycCnViUqZ3amB6MbNXqC-4kKen5jbVyEJ0=QB6m9zQoA@mail.gmail.com>
Subject: 
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

subscribe netdev
