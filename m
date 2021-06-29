Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E42C3B77A5
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 20:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbhF2SRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 14:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232599AbhF2SRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 14:17:02 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A2CC061760
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 11:14:27 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id o5so12818734ejy.7
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 11:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=UsxNL+xKR116dOCp8y+XLHyts5J0w/gBSc9hD7jU6X0=;
        b=LrmGLOgilp0ruQlUAQdOvMCdYAp/MXwxeosFMnUxOjlNtEDJwH0VMITcZhmf7YIxdn
         rMd24/ZtG54o4ZIwBcds7/ByuaLcFmw+6hoA8SHhWdlKTbC2MY3cwlBqfPnq9Bc7GgG1
         Ho0zecX5gTt87BdiThV7Uj667vNyQurS1DV51FTM9eNs2VBF9peKIAJwGOynLsTZLBH2
         Y2c154INefQQ7rz4DXUxGpvP2+gymarfS7T6TSuL4w6kppms32LILblOpcU4xbU7Y9ib
         dkOLIhWSqRXXmvdTKvIOi5VOshKqEMTxlwvBnFfV2X9VL3MD78OO+tRNvvHNRi3JETp9
         K+rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=UsxNL+xKR116dOCp8y+XLHyts5J0w/gBSc9hD7jU6X0=;
        b=FgJc1praH6HFKj8zIVYCHpx3jHRoOrZYgf3CSe1cvjOJkSyn96Hqne8bYp/JvIQykT
         XXATU1WP1v11x49CcD5gpgT+fVF7Hqw2ng+UAtNZopwICY5paKqQyVaiexHcuQOmwqZU
         PGymhdWQTwfXUMvzAAleJTCGOM7VLcDW1y8mbeeO7DCRapImst+IKXsI6MfJWYCCGJO/
         SgdKxr4bCOql9rR3fUVNvpM++JZu7n2R//l3IOPEcgPXGmYC9I9Ueg8QJfWCNlu1Tr+A
         EBiqRzwxwMVLbRb4ZR7rpDNemecEcI6V2YcQ+b37bDMT/BxuHQ0puuIy9SMoXEC3AqCY
         9BtQ==
X-Gm-Message-State: AOAM531iaZ7xnTw3y/f7uba6yJLKb7TRZznlzixwnuU/MOWuwBYUbY3q
        dLOD2Yz52WxxXtsuxFMU2odJTFsvt4QE2hFSLeQ=
X-Google-Smtp-Source: ABdhPJydf5czzZcamTOb4hQ73gIgKg31oEMY+G8sCCyAOAGF4286zqKR6EpctfvhGN2Kw25XyDdyqRdr3f5PNodw4GE=
X-Received: by 2002:a17:906:19cc:: with SMTP id h12mr30663254ejd.306.1624990466348;
 Tue, 29 Jun 2021 11:14:26 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:7f0b:0:0:0:0:0 with HTTP; Tue, 29 Jun 2021 11:14:25
 -0700 (PDT)
Reply-To: c1nicele22@gmail.com
From:   Stefano Pessina <robertcooker110@gmail.com>
Date:   Tue, 29 Jun 2021 21:14:25 +0300
Message-ID: <CAPv+YtZJeMkfxOU2vXk5y1P27bvzO8ou6v-2-7vr71X-QQ8C3A@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello,

I'm Stefano Pessina, an Italian business tycoon, investor, and
philanthropist. the vice chairman, chief executive officer (CEO), and
the single largest shareholder of Walgreens Boots Alliance. I gave
away 25 percent of my personal wealth to charity. And I also pledged
to give away the rest of 25%  this year 2021 to Individuals  because
of the covid-19 heart break. I have decided to donate (Two Million
dollars) to you. If you are interested in my donation, do contact me
for more info. via my email at:c1nicele22@gmail.com

All replies should be forwarded to: c1nicele22@gmail.com

Warm Regard
CEO Walgreens Boots Alliance
Stefano Pessina
