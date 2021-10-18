Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F166C4325A4
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 19:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbhJRR4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 13:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbhJRR4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 13:56:41 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD65C06161C
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 10:54:30 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id t127so4125069ybf.13
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 10:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=tFOETZLuOQb9mSBGt+hLHZA9n04aRA3h9zo36NeIcy8=;
        b=PWcl8Fc9eRuoCUlKTopBPcoZRH5BnjyigSFP7VvnxQIyHzTvZvSNVRrtrzsEn62zUh
         TZ94dOHk5f8tLZpdmhA5O7B+x/I18rFY+9dVoszcX8swHITyiYOYoJWLjN2fPaX00D2w
         VDgP4jBvtgzG/nfs+PWPf+JKv4Ov4es9MVU0Z51A3BtOE0VE08Ilr4hW+pI1LIQlJvxb
         5D/K91kaxEpDHfyfTH1Ch/Nc4QcYIxQFuPamoqEym/rXw7aQz7DhoR2TSpYeY9g5GDdD
         sYDSJNKl01Yu86LvcQc8B05oR187WsjzNffyjqotMYr38oxooi8uTF+zOMgitYJNpcZi
         uK4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=tFOETZLuOQb9mSBGt+hLHZA9n04aRA3h9zo36NeIcy8=;
        b=k0FIsO4N1PXhmHKkAo5/nMdWifJuTCVuvz7+nh0L+m1cr6XRybC0lG2YbEonAUXIVv
         4XE/p0Q2iM7TXZQ7H22o/tCmOlGAuYNNZysKm4+hFw/RNBa16T+oerOiWqfYfU8bXO/D
         TlBOblfGLo304qAjvpcsexGwSBXg2r4NOJ9ifJq6jwNsjuXFMWSlXaAmrvGJcX+2M4Vx
         DC+3NeFEt8Sat6G26y6m4Gjm7Rk6ULibglTEr4boKNxjUkhROKXS5CMg7QUxzkOw3mQ9
         P2Z7o+TtEUVIkWGwHZbx3KMMRPasqeXWntuF9jVR5Vk9WxdZuyiSq+VHlfYtM0KPu8N3
         JeTQ==
X-Gm-Message-State: AOAM532Rvssr1oBc/Yw7THizCaF5QBoErM1cGBGqF/oJCyxDzDdY3Bn1
        0ZaIx3c/6kysU/G1uWvTBKAxGdWmikXY5If/jlE=
X-Google-Smtp-Source: ABdhPJyFLe87qPo2MO5SgPLdP0OBGtBj9b0ZBvOs9JfD+Csvl61m4HSNvWVav4N4kWSLH1ruJ/Q/r3JJrY5BRP5/5Pg=
X-Received: by 2002:a25:678a:: with SMTP id b132mr28511663ybc.198.1634579669899;
 Mon, 18 Oct 2021 10:54:29 -0700 (PDT)
MIME-Version: 1.0
Reply-To: amadireina32@gmail.com
Sender: ritasanchez701@gmail.com
Received: by 2002:a05:7000:bf21:b029:109:c06a:da3a with HTTP; Mon, 18 Oct 2021
 10:54:29 -0700 (PDT)
From:   Reina Amadi <amadireina32@gmail.com>
Date:   Mon, 18 Oct 2021 17:54:29 +0000
X-Google-Sender-Auth: MorhKTtOdb6rOoAmy9mCAkbLQ18
Message-ID: <CA+Gx1wYwOgkokT1jdZTPGiDm8T6v7xCOYG_3qm0N4YF4jgvR0A@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Sir/Madam,

How are you doing today , I hope you are keeping safe in this pandemic
perilous times. Can we discuss the information i sent to you via email
some days ago?
