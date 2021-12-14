Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70ED474277
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 13:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233922AbhLNM0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 07:26:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbhLNM0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 07:26:33 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745F9C061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 04:26:33 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id p13so17728863pfw.2
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 04:26:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=mTe6rsF1WlocKfWRCIawejpNJl6lRYSIlYxDz8jltlQ=;
        b=QjXY62EF6n2GTjYTXRHX87spzPPemayz1tiyJkV3WGRecxmFKliGY2plEJIqrQw7uC
         /xplWROIgivqtF5qwlENB0Sd9Xhs0g5CutyJzQZXIplVEHcNfdW1A7yk/wdUDuHmYpKU
         AyD7oI2FCdW7A35UaAA3AYnjRDih7P+tDxZ8AeUvtw0BttnMXzZUJ+VcZU+9rBykZfIf
         vvcSDp3kl9oQjrdMCJiJkCyOoP1r3CKrSxLFthKFBnM++QKMTGtvNXtyBmRvFSSzjule
         H0Ap6rF6PGoJgY/AtPKMzGOsrIRdph9hd+eJoHbwg2R/JrFxxQGHHGZ4CX2zkcPWHaQX
         pCNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=mTe6rsF1WlocKfWRCIawejpNJl6lRYSIlYxDz8jltlQ=;
        b=fRPtQRJ2Y+DS9OqQluU8UPff2euQcZSfco9H7yZH0kX1K26iWcBSmPzgRju34dmZK0
         9SpvrztkZwam43PZDbBbLDgc2ZCzKUk4dxGI6OABY1FYaPnn+OSsgNJ92V7TmghaBEJU
         CvVOWJct+ti01L10JRsKGKFSsH2BXgZaBKYXBkl7M2WVKEyqp6Ik4CWpJr3LezhQfX95
         4Ftl0F37ACjNunrLhLbWiANduyUbNPcZ/arlhSZsHuLnjEhZPkSKg1LIROMAlTFj9rOR
         HNHb5yvXMuboaraLAC9+1pShZP69uYhXsZ4+V/D6UuNUa1T9aLrHs1yD3HbsqRANOz3n
         mVoQ==
X-Gm-Message-State: AOAM533n254hbMHlpv6iEbkgKVMJMyLOqhOpdM0laly0D6PgAuez/G7f
        /WEdxhKv2gkdPkojdPr8XtQ7RKPIko+sRM7h3MM=
X-Google-Smtp-Source: ABdhPJzICcM9OgH3nco0lAKl5NykK2MRdJ9WvCyjYVeKg+5qlyJ1KIHmzm0HUwGIWhekmy3YH+q0d/pQrJpNuYAkghQ=
X-Received: by 2002:a63:ab0d:: with SMTP id p13mr3522640pgf.570.1639484793042;
 Tue, 14 Dec 2021 04:26:33 -0800 (PST)
MIME-Version: 1.0
Reply-To: zahirikeen@gmail.com
Sender: mouhamadoudiagana123@gmail.com
Received: by 2002:a05:6a11:326:0:0:0:0 with HTTP; Tue, 14 Dec 2021 04:26:32
 -0800 (PST)
From:   Zahiri Keen <zahirikeen2@gmail.com>
Date:   Tue, 14 Dec 2021 13:26:32 +0100
X-Google-Sender-Auth: 2SVBPYRBWz4QfJTXWRLC3RYURfU
Message-ID: <CAEzroUTkzpD6pW4RYamrcVFpsYH-0kGkbaktHTVA4BknVtZsrA@mail.gmail.com>
Subject: Urgent Please.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good Day,

I know this email might come to you as a surprise because is coming
from someone you haven=E2=80=99t met with before.

I am Mr. Zahiri Keen, the bank manager with BOA bank i contact you for
a deal relating to the funds which are in my position I shall furnish
you with more detail once your response.

Regards,
Mr.Zahiri
