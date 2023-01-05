Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E26565EFBA
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 16:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbjAEPMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 10:12:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232489AbjAEPMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 10:12:20 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D905BA16
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 07:12:19 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id 203so40390012yby.10
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 07:12:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=u7IsthnA0BZiEpL+4ZShFyxP/+LeLk7pMcIBQfprQig=;
        b=OoT1F75ncTQ+AAeDL/AMbOLyds0pyudTGn0gzdn8KgT1ahU7ikL0Dt/SIQZcPEahyh
         js55nIcyArqPEBEiK59c/lETHxqHqVLw/mmD+c8i/l3BMgx2TTq0OwDUCLOGP4nAjXbv
         a6kQu6ufZ18ndRfjo9AYpKexLIsVUyBitZl6VtbrcaL4IJh+7wtpaw0QdSRUHEh5hOcG
         BjNtu1nyEh2eSwIQrd22v07YhhmA5oT3RjyYE5xi8CWYQCsV5RmxdH1g0hB/NvwJ1hVk
         pltmNGY+yBg4H08KMptUHfPp6MZCmd/VO6DLjMaCb0uMB3WP0MoLXnoT22472N1Cwi2U
         XJIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u7IsthnA0BZiEpL+4ZShFyxP/+LeLk7pMcIBQfprQig=;
        b=xW0pbmNYbPSsLONrQhQoFJ1gxExIFacBPfJO6py+YF5eL+z4qZ8EDHNnWbv9vvIuPp
         KL4oG7PUEp03xievEEToINpSN6+cYfFI9HbSxwXJwOBUew3rz72B0wy8Fb8XYgmC+c4v
         mJxbrRPbLyq6RM8mTdCm5mkG3GseJb8Z8Vp2xX7MOxU2DsCxsjXQu8kWCpTx8ygmd+0H
         QJ+XIskITJ9TJ9TZjTMAs0oOypgWXHfe1+xiBOOmCTZU1z0khWayr1LV7Rf+3xeiJr9f
         hX2kThTG3DLPeFa6RINI6Jid/Ht9BRCqXYvwmN1tcLREdq91ZH+YomKLP6RJVAwt0aFn
         uJQw==
X-Gm-Message-State: AFqh2krzDzMnOuo5uyQaX2mjAWFP3gbpL6g2cyYPApVIaXQ/IDulAEa+
        6DYnKz9zoubSHvO0MZm6ynTUF8PWNvJBnfk9CD0=
X-Google-Smtp-Source: AMrXdXtis66ZZp4iuOLsfD0EKxADLIBqL0mEo6PA3ru3IAV/Mk7OpewTX3LNI1xP26vq43Tpuz5qNani77SUFYTEVhs=
X-Received: by 2002:a25:c283:0:b0:70c:8bcc:6c94 with SMTP id
 s125-20020a25c283000000b0070c8bcc6c94mr6993225ybf.135.1672931539079; Thu, 05
 Jan 2023 07:12:19 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7010:a8a0:b0:316:cb40:61dc with HTTP; Thu, 5 Jan 2023
 07:12:18 -0800 (PST)
Reply-To: cristinacampel@outlook.com
From:   "Mrs. Cristina Campbell" <jp735098@gmail.com>
Date:   Thu, 5 Jan 2023 15:12:18 +0000
Message-ID: <CAG9MkKuu+7kE-OTrsGOGCE31EJ7HtSds4Vn=R7WjRTfrjVhWKw@mail.gmail.com>
Subject: Pouvez-vous m'aider
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        UNDISC_FREEM,UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b29 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5008]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [jp735098[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [jp735098[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.4 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  1.7 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cher bien-aim=C3=A9,

Je suis Mme Cristina Campbell de Londres, Royaume-Uni, il y a quelque
chose de s=C3=A9rieux dont nous devons parler si vous n'=C3=AAtes pas trop
occup=C3=A9, veuillez r=C3=A9pondre =C3=A0 mon courrier personnel qui est
(cristinacampel@outlook.com) afin que je puisse vous en dire plus sur
ce projet caritatif humanitaire dans votre pays d'une valeur de six
millions de dollars am=C3=A9ricains 6 000 000,00 USD.

Cordialement.
Mme Cristina Campbell
E-mail; cristinacampel@outlook.com
