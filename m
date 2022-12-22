Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0D0653DCE
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 10:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235108AbiLVJ7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 04:59:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234914AbiLVJ7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 04:59:14 -0500
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CA420189
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 01:59:13 -0800 (PST)
Received: by mail-vs1-xe31.google.com with SMTP id q128so1219095vsa.13
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 01:59:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1TlZIPAMYUXO2C8s3Dlu64nz54zmLOKNkzOi+/CR/rc=;
        b=d/AHhAG0XP0hjdj4T9olqbhlA2tiSsiTPC5nhg74nYvw2wonVBnLZne98r1IHGYErH
         XvDfr4yZ/CFocPmtkjj8TsNevxbp/pzCyqXQnph/dYXKrTsDeR4R+OZjSzClDrqDPUGT
         pDmJ+7Vh4JfRSK1B9MqtX/6zT8rxbZwXoXFcU5gqdYfKwNzeYSNWCK0tDHUugIOGauQe
         5ZQFWnoisfNpBZGE1BbGIvVDdDu08KMyR0L0AdTMwcTtjEAJ0EOQpASaimu7S0RoHYz1
         YD2Qlg0OsT7Jc96rCOYAOIpXsB42EcIHraqHloR02ONPW/iMyjzxsdpHu3aZdGcMqzcm
         zm1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1TlZIPAMYUXO2C8s3Dlu64nz54zmLOKNkzOi+/CR/rc=;
        b=WT45sfS4773ghHbblts3vNBwF4o1p5QRLxp5LaGXKn8Db+LcD66vEFPY/gsnb0Ec/I
         d8TiOtuUtGh/egE9yS8sd0LCjAAB8KU8TxBRzQbY4ILVWbJvsF6cHIi0/TF4COisKt3U
         jGFxIJik0O+B+HwQ492G9Hw3OxpNwiM1yCL/LvKa/vjqyJr8Y+Zq0IDNhN5FcLk05LGP
         VE72DPiCjt1L6ft/YNux06UmOOhK0rukuBrzW0yNyroVFjZJT3/XeAo8ilwIW6mCMPpp
         omefn/RP44ysOmP1s5CYuueuzmXylvtKl2YIvKED9SzssdPDitlOXMA+v3wk5mplZ5+o
         JvyA==
X-Gm-Message-State: AFqh2kpm1N4MSLGDXD/q6kycXH1K399+gKF0alOQqpqDaSa+W0LFgDIx
        Fw9UTyudsEGYNgkH1PLr3ypzgRRMUm/9xRpUcXM=
X-Google-Smtp-Source: AMrXdXuO8ctLkncnNookkKpkZDOLcx4RO0G76jTahBDc2quVuJXiulDSKTx1E7Hkt6T2ZvGvve5BLHL757SGiH8iBLA=
X-Received: by 2002:a67:e402:0:b0:3b5:b06:cc6c with SMTP id
 d2-20020a67e402000000b003b50b06cc6cmr533610vsf.83.1671703152250; Thu, 22 Dec
 2022 01:59:12 -0800 (PST)
MIME-Version: 1.0
Reply-To: sana.mohamad@aol.com
Sender: alberrtlin070@gmail.com
Received: by 2002:a59:c1ac:0:b0:324:a256:8c35 with HTTP; Thu, 22 Dec 2022
 01:59:11 -0800 (PST)
From:   Sana Mohamad <msnfo387@gmail.com>
Date:   Thu, 22 Dec 2022 01:59:11 -0800
X-Google-Sender-Auth: cmKhD_cF0p6vJCdMHaUpZx1HjJU
Message-ID: <CADAFq3rPux6WKC51Gq4p5dw0X_zhJrrkwTUfEiQyF4Xpa-J9ng@mail.gmail.com>
Subject: Business Offer
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi dear, I was wondering if you have had a chance to check your email
since I last contacted you. Please acknowledge receipt of this
message, as I have important information that I would like to share
with you.



Yours sincerely,
Mr. Sana Mohamad
