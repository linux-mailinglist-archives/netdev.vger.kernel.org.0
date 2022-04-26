Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68A6450FB51
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 12:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344781AbiDZKt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 06:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349389AbiDZKsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 06:48:41 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2EFB86A
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 03:42:36 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id 79so18937792iou.7
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 03:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=aPTFbZr4LhKGppGQDkO7tNLWiZLizgW3cwR+POXjY4E=;
        b=JoFJxyaSDCSG7DGh8LqgkxBbW0+68RQEfFq3y/8gwImTLFTt2pihl7TTRwA0j+bvJ9
         ybwlKopxfookz6S87+/nNzIP1nngcysrNeigAj4s+6/1NiBbyr02LsYIYEnAm8DVK61p
         HHyC3dyHcq1oabKdXPcTRtHf3wPaXkJyfILfRGH7Nd2IYZnawgq1fEqRIzOkE0+pD2uw
         luzbJd+7vFbC/dFPWp7CwlOV3DhYuvMY3iTLRzgP3PhT27WIIosBLldFjfdzdGQllhab
         DhMwQ8YDA16PE2TraKMtW2qYIf97RuihaNYhHeeY981WRrRxQceAZpch3cc+QvHrhyG6
         zGAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=aPTFbZr4LhKGppGQDkO7tNLWiZLizgW3cwR+POXjY4E=;
        b=eaAeHARrAXnzi6K8eNOI4OZ863hinI8kEGQ/FNrhkPE9ZHaBeTSGuaU6L58FjKKfzL
         Lv8Tqyhk/XCcQZ7TbT83zh5MJgXYQrOhLwzpe4kGwpFReCzywOH5dVkPtgVfEqpKg9n1
         IN3Z4r1rFxl+z1w892fWbLZANwhbzlK5FDS817ybt8vW/qBZCXYLkV8isBK9A9v6X3Aj
         RkwFpriStrwP0yVtw6BGbCXt6DzDLAIW2IsCKTTxdpffvQGYW4l+T/VBzxCNPWpJcJJQ
         DwJFi1eR7DnWYcD482/841zNUBbQg2UZDTbd2NCu5iFDuabzp+M/tiYJMhQxVcVoh+IB
         mr7w==
X-Gm-Message-State: AOAM533HW/ZS/af/I1VbMLzctheDmbR9bxvssTyOaCYI8MbS78zG8ZPS
        g5j4I85xt4vm8TXMsvq2PPqHCRxwHlC76jS9Wq4=
X-Google-Smtp-Source: ABdhPJyAZoJKU5v39U/F9OJbfVfX8v+HOtC5IZrIAHVuxsrGTXfMG7JOfwe2moj7DRyZLDkWf1n+saoroy3gj4rHMPM=
X-Received: by 2002:a05:6e02:15c6:b0:2c2:5ab0:948 with SMTP id
 q6-20020a056e0215c600b002c25ab00948mr8653138ilu.171.1650969756087; Tue, 26
 Apr 2022 03:42:36 -0700 (PDT)
MIME-Version: 1.0
Reply-To: dr.tracymedicinemed1@gmail.com
Sender: mrawutamamma2@gmail.com
Received: by 2002:a6b:8d54:0:0:0:0:0 with HTTP; Tue, 26 Apr 2022 03:42:35
 -0700 (PDT)
From:   Dr Tracy William <ra6277708@gmail.com>
Date:   Tue, 26 Apr 2022 18:42:35 +0800
X-Google-Sender-Auth: oitI9buvRA74FktpLorVkvfy4Aw
Message-ID: <CAEZRNsSOsY=QCv=Pw_mFi2k+7hRCzZmKG=xRzFRup6W3=+Gv=g@mail.gmail.com>
Subject: From Dr Tracy from United States
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:d44 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4990]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [ra6277708[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [dr.tracymedicinemed1[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mrawutamamma2[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  3.6 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dear,

how are you today,I hope you are doing great.

It is my great pleasure to contact you,I want to make a new and
special friend,I hope you don't mind. My name is Tracy William from
the United States, Am an English and French nationalities. I will give
you pictures and more details about my self as soon as i hear from
you Kisses.

Pls resply to my personal email(dr.tracymedicinemed1@gmail.com)

Thanks.
Tracy,
