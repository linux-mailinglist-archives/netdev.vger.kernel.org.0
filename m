Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE7CC15E8A2
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392604AbgBNRBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 12:01:43 -0500
Received: from mail-yb1-f180.google.com ([209.85.219.180]:34230 "EHLO
        mail-yb1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392028AbgBNRBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 12:01:40 -0500
Received: by mail-yb1-f180.google.com with SMTP id w17so5095161ybm.1
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 09:01:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=EnQS2KnIxN7BCSO5F//UhvzDYP3PJE3iF9kT17l1WIY=;
        b=fZxAQ8+vlLqgc2GcW/Wl3ruZWQdbaozHHfEB99MV8pMysoMpi1k3ofjvwAKUf4vv18
         99fL+xpq2Q6ky73YEvQCiOoRFfOZy+477fXKjRykA6GKMHW1qoGfcNW9kVVzR0p9+Ed6
         py6pvYNZzftlhHPJLEfIvpO0OCW0Obin8IziFq5zpKG2erftUiqlZMjFvlSd6MioVhAM
         yeSpoDve8W41q0lDsqTn+SVYC9I86/nqaWR2AcciIPHYQtDpAMblc6QtHVw+giAApfbx
         XRTf/zRHPKj4QS72cmKfYt2Uu5zT3EUKLZb+NlA/OknmRvLzp4n4DwddQYv6uAUzh/1R
         9ZOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=EnQS2KnIxN7BCSO5F//UhvzDYP3PJE3iF9kT17l1WIY=;
        b=AsAkx360rKUEcSk5n2MCjZXN943SrRCWz8PSIe9mTGfewECcwW56hC3mtvv7vdfvpH
         NVwU8fBWxCGN/0bg4SDAVTB8t57QuasI8vQpysxiN7nD2d28jBEpr63JbJ1cB77ApCK/
         Nr+FR8Rmd2ZMreUfiK/RmC+i9DZPLOcaA/+iMg5TMV44fCsoYe+3yGxpwg1FMs8Kd99y
         VYq8OK3n9ta70aG2uZWMETS/izY1n17D8MrR4rPEyfMeAg/yDn527ZvJJdlTFKk3Tye0
         e0++ypgfQXGLY+HE5mmGFYGg3rBG//GaGZ+V+f7kXV4Q8UlwybVNIVGUOy6MrkosbaKf
         Ciaw==
X-Gm-Message-State: APjAAAW37tJ40m8h7u2wG5X+nQtAtyAkuz2CfHWbNELCU3AD0ADGSeMq
        BY4XaWTiLzNZlK7D41wsJHJAeA16BUx3CGBhuTjOZyWDpEg=
X-Google-Smtp-Source: APXvYqyC3DPmnJF+b+ojPRUL8ngW9j3QpzkT1hKAaCnSYyESznqyuA6Ykh1wCGWgCyIBKODw4afRtnQ32wccZ3YuAYs=
X-Received: by 2002:a25:cb49:: with SMTP id b70mr3466703ybg.233.1581699695649;
 Fri, 14 Feb 2020 09:01:35 -0800 (PST)
MIME-Version: 1.0
From:   Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date:   Fri, 14 Feb 2020 22:31:24 +0530
Message-ID: <CABPxzYLzNMtv1ahd94+RvKWd5oc5BhR1hwyf=h51_zaVUSdb=w@mail.gmail.com>
Subject: QDISC: pfifo_fast reordering in tx for single_q device
To:     netdev <netdev@vger.kernel.org>, john.fastabend@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Guys,

Raised a bug already, just posting here for quicker response.
https://bugzilla.kernel.org/show_bug.cgi?id=206497

This has one fix for pfifo reorder, but still sometimes able to repro, esp with
multiple QoS streams.

Cheers.
Chaitanya.
