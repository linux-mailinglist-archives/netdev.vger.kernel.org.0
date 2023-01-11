Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42DAB66599F
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 12:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbjAKLEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 06:04:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjAKLET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 06:04:19 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47FEA2BCC
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 03:04:18 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id k8so149707wrc.9
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 03:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PLPmlGGL/gTvueqKEBdKiHKfa75D3rcCxU1z3taEYt8=;
        b=p7N6ghl3iQR/fqkHZtsSrX96lkNIZULPCCBYYGtuC8+rLLEpZLO79VTGUNoCp1n32v
         4+sUzQj5YOzC1VoCF/o9e242gMA5PSbBFqCZ5y9Fo+w68OxgPzYmVRFE2Tqde5uyeqxj
         FUciAypX+9nu0l5P+S+wTZx4Zc/Ah74hUhH+dNWjJ/LOMYJ55fgr4RDBDWup2jUgn+Xn
         ILhEexr0oGvqPNeiGZ86gBo5TIwg4dRwtt/P+WIUQqgt65fXGMfdYhQDFQJr2I2RssIK
         d9wsf3KmNe7IEnw0yIw4Pzzx43s6V93Qq6llIPDlA8gXL3vUQldKsIj+igCraDzZYxwf
         GN5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PLPmlGGL/gTvueqKEBdKiHKfa75D3rcCxU1z3taEYt8=;
        b=lgjPEIBP56wZbk+z7E36BiReSbw4qPXQv0FrrRNrGcws4E80O4OhyGkZu9U6FzCt1v
         zOXnVLaKGssSg/Wbs4hUIZldEkQy7gDp3IUvIAlDn3VYcOFhC/S0hiPxz3nq7g7Xg4zP
         SchNoSZ6F5JHVh73/iZvBuej06+LYtYunFemyceLpo8w4fmCnzYod67FD5xtQrNAcW3+
         Lm/jT1li3usEFzMqgmNCCb5bMmlcqAKYSzPRDTc2HSb7qgBDgErWHa975CRbW4s/vaFf
         07uJHIkh95vXd/l1RfNPCu4SjkNTepDIcf++TRqWQuPEo0NWpGXONXPJF8l86U7LhL60
         8rKQ==
X-Gm-Message-State: AFqh2kpzceT1DtVZLZXXR33X7HE6qzlsqJNCQkMnP9A1cuFy6iCXSyUn
        h2za3x+aihDVi2kx+mF5l2Vr0Zkdh1GLRG973UY=
X-Google-Smtp-Source: AMrXdXtuYNe5TxAG4BCS8IUn9Z2LuJIG6ZIoY4U+KJLftzzvYJGe2x3rFVmMo0GbjJ88pngE/5h5Ax4abdDdOuEY5Q8=
X-Received: by 2002:a5d:6f10:0:b0:29a:c15a:f6c0 with SMTP id
 ay16-20020a5d6f10000000b0029ac15af6c0mr1486277wrb.498.1673435056764; Wed, 11
 Jan 2023 03:04:16 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6021:5216:b0:249:d53c:39b0 with HTTP; Wed, 11 Jan 2023
 03:04:16 -0800 (PST)
Reply-To: richardwilson19091@gmail.com
From:   Richard Wilson <peterwhite1723@gmail.com>
Date:   Wed, 11 Jan 2023 11:04:16 +0000
Message-ID: <CAP=iidmoo7sumbq2veaboZDV5uyTFPapWwHCCxW8QQWzuH5uqA@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,REPTO_419_FRAUD_GM,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:443 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5574]
        *  1.0 REPTO_419_FRAUD_GM Reply-To is known advance fee fraud
        *      collector mailbox
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [richardwilson19091[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [peterwhite1723[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [peterwhite1723[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear,
I am contacting you to assist retrieve his huge deposit Mr. Alexander
left in the bank before its get confiscated by the bank. Get back to
me for more detail's

Barr. Richard Wilson
