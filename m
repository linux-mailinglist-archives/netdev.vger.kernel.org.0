Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72C1E4C670C
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 11:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbiB1KYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 05:24:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiB1KYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 05:24:10 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 048003981F
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 02:23:31 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id f37so20433944lfv.8
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 02:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=a4f2WXyHgZjKg5JidE8hC8yNnvakX/4tiQgY1LG2SOU=;
        b=IWiLldMMxe2ONKrz1m2GhaojIsCZWzR7ZzLAqk87dXBdrtj270gKepAhdmNqvYe/cD
         0YIqqE0RZanvcVy8yiTfCzhUnvdLMjsZOVDNhVHgeM7Cxv6TLya5sVbw8DGolOp3D7qw
         of1crzHfITysc4UiNZFQ72F798BSW1lshiy3a7DXgN4LSP+DwnTOXo7gbgTv/DINrp4G
         ffgmHah/84IGCbiERDh9Wlc9mScI9FjWfZPY7PxUdTFD/FjwEwPu+pXVb2KRYjGQ5uWs
         sgd40iRYuRiUSlSzd431Sg5VRyZG+qlRA/kpiEPTi3GpADUdlwG0iyPp5T27QkMRbE3o
         zfTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=a4f2WXyHgZjKg5JidE8hC8yNnvakX/4tiQgY1LG2SOU=;
        b=gxJyGthnOOHrXsfmW9AIbPAQ5+fNH6U0XamlN1RYrm939iCDoGqQH5mubeYYC8NuxO
         5PLIZu1DdZbFSIZK7e2IjELL5FoK1pY1O+C4FA4InESk4xzFM1IdbwVzaTC7jk6JBDPO
         KiaM6vs0QtEHp+c9iIJlOzdT/HZtdKliF89cVXKtfXW2vZI/GcGMV6JrsMVDQ2Am7Ojl
         o3i2uXvkut31u99+UUOV7WKeV84B+aF6zf358K+JzaVgKFZG9/b+HvSpagvt1M1eYIpB
         CQflMaSmBunuekql9ZtXikA+FMG0icxFksJlfphrlBc5Y4SO8PCZ293j1cuYCW4/aSYN
         fXXg==
X-Gm-Message-State: AOAM5312nye6fkmqaqKMkCkEFMH7jwwar0Wr7sAraVId0kc0Y1kAzwKz
        I3vBxG8quyhSLgiyMKdHFnvuXw9czsgOJGpeT0I=
X-Google-Smtp-Source: ABdhPJz1UEsJ0ZsK9UjdmT2tZtceCoZTUxmm8cV2fB9VuM8fU6BE0JPbmo6w7VxKfmRkgg6jXkItsYoYUk+/+nfhTyE=
X-Received: by 2002:a05:6512:2097:b0:443:eaaa:3ddb with SMTP id
 t23-20020a056512209700b00443eaaa3ddbmr12055048lfr.185.1646043809229; Mon, 28
 Feb 2022 02:23:29 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6512:36cb:0:0:0:0 with HTTP; Mon, 28 Feb 2022 02:23:28
 -0800 (PST)
Reply-To: rolandnyemih200@gmail.com
From:   Rowland Nyemih <patrick14gnof1@gmail.com>
Date:   Mon, 28 Feb 2022 11:23:28 +0100
Message-ID: <CAFVN26fgSdZHon4RXmM5S7MdvNqe8ECK5ndDhG_VNNavfiqZxQ@mail.gmail.com>
Subject: Rowland
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HI,
Good day. Kindly confirm to me if this is your correct email Address
and get back to me for your interest.
Sincerely,
Rowland
