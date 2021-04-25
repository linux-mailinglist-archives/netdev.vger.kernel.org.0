Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFEF36A661
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 11:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhDYJyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 05:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhDYJyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 05:54:49 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2B4C061574
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 02:54:09 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id a11so686281ioo.0
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 02:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=ljZfsNw8ex69sV7WYLQqGS3jVhN6e3mpz6FSpZD67wA=;
        b=pG9zRLvD948InvSMic/dEjqq8A8NhhMmo3ftAJkPe8emOzebmszojqZBcIToZloN3P
         U9xD0s1vTcRe4JDstJYgtAWWBduz2v8FNMs0gDo4LYtIFeXqBJCFYSGGiruPQh28BHod
         N6uEb0S1rIh0Hvhw8jt/F0Ubr9TMe1qicn9tkngRYX1de3ZUQ0BX4MbKmeRxHgbWr44K
         eBVLpIRMyfzWM89tryuxGenZnTowGUAxNLjPI1WEwQycApuYy8NfEMJRRcY0TAefoq2R
         80zEcisyvoo0/gw6fVcw0sB25f1/qkWS+5sVKazCA29IjLsLu5Xo9kEcbOO4VnE3ife4
         fVYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=ljZfsNw8ex69sV7WYLQqGS3jVhN6e3mpz6FSpZD67wA=;
        b=HzSBXYJhuoE4xBFFnTISLxfqyVywDdYYHJsMbe6vj2Rnpx5/FfH4gFpy+QpzBtTgbg
         3oBFGfYC5C+43+2uIawICL3I5XQzcxgwtjPVtH7lDvhQHzilnVu070XaGjslTogEM5Qn
         ejjydiomOSV+vbZX2hX0knJEzXvxJj/sUWgTemrNo/mJAPbyzzqfyJiuSmdgSgzmqlGn
         YbIq3UUJUXJlTsb4ajalVCLUZAzjCst/vypx4e/SeyR09s/jXdpnt4/UcdauEQKyPHkU
         7vvnpPmsN17R3Yowm0MqKaOY1It8NVnmKTvpYP0sjiw1iiNz0N8OpB+h9y7pvQVNtgrU
         VBDw==
X-Gm-Message-State: AOAM532d+r0FfEcbX1gdQ785yULG2Vvg1iKYJDj6CSJQF+EZ1b01uZeD
        XaLjw8JvvtzmUXPgAH8g50iojPfTbcW4h86/A1k=
X-Google-Smtp-Source: ABdhPJzXXpWiXSnm/iVmWnRF1KAlsYcdX3oxyCTFf4ewyBS46s69vKWOl39V//fkn6JpRjmIZbI16l0vzBw7TUXhaWg=
X-Received: by 2002:a05:6602:58d:: with SMTP id v13mr9497298iox.64.1619344449364;
 Sun, 25 Apr 2021 02:54:09 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a4f:fb0f:0:0:0:0:0 with HTTP; Sun, 25 Apr 2021 02:54:08
 -0700 (PDT)
Reply-To: fionahill578@gmail.com
From:   Fiona Hill <klouboko@gmail.com>
Date:   Sun, 25 Apr 2021 09:54:08 +0000
Message-ID: <CA+Adgp7gs02Bc6iSRjBv4mCHbcQ-TTzGg4dAOtUgzNU5NwuO0g@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Have you see my message ?
