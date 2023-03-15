Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC8A6BABEA
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 10:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbjCOJRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 05:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbjCOJRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 05:17:19 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072EA6C184
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 02:17:18 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id d22so4162818pgw.2
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 02:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678871837;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2db15S6iWXRPdgvftXuDGGeFS+ITB9v/lZ4kZjfX2FE=;
        b=BGvuCmv1dOx/81z13QlxA0ItOBfjBqUyH+Dn9wPpjSLL8BzrrP79EqaVKjtDx4ffO5
         c4fYX2zwhfsxTfUa8LFLD9MxR/YIUQtXZjhOOWVC0VMqGbJstcc/gnQx9sVLbMpGsewB
         aWrIryRgHExbrQRARYOinWlN77HSDHK1BhoxdBbn7hLcDzSjaZ7eje0hrIvKB9izrHaZ
         HTKv9LPORx/xh9HTxU/eXDtAmXXK7XtDgs3BaZZxEqSEJV9fELQbQXgAeCzStP7zjF/Q
         sLgihyy1WPS83n3Pp3JGWFWTFf5cuZt7zgfxkyeEvMISjz40Q+1ckZQlWqu9LFKOtbk7
         S42Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678871837;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2db15S6iWXRPdgvftXuDGGeFS+ITB9v/lZ4kZjfX2FE=;
        b=ILlXML+qyyL2bGpbdPI9fdkvmfisnCFBwuI46o5oUcYh6IxWMp+HvH3y7nToAmhi1L
         EK13aLh2J4SeLENETGol6R5i/NvoC1Uw4Nn9alG9gtah9VkCQpfrxrLzHUq9FX9+vG1z
         fJxthkg4pNaR/TfL3lG7MLpnDk7OFiBLxZxDzi9LD8YvpRgZO1EA7U7MuY2WaYghaRTd
         PyNAB6QczjhsHxWgQQEazxs2UKKjC1X5jV7cR5MsLW1q21r3VWkM31WY8tdgwjbN4YOg
         1IQDROrH6XvgYHMVtdRKNRtOdZzDx1bdYlZLKi6EIVMx89zCGjfowKexfcexUg0D14Wn
         8p9w==
X-Gm-Message-State: AO0yUKXWPBc+JClSR9bf8fxnxa4prdgWpkKptPazZM12MZuMWYYKN0xT
        aKx+Pkdb+8dpJCQQvlj+jDaAAz4zSwW8ewRjj55tKRw7Udl2XVlB
X-Google-Smtp-Source: AK7set+pK2E00aDh9+BDjpyosvN5hd0BnVdCUV7y3R5ng+NfPGeSJ2kc1HvFmOhMh1edlsS/EVot/s0TRozFbI7eUbk=
X-Received: by 2002:a65:66c9:0:b0:50b:188d:25bb with SMTP id
 c9-20020a6566c9000000b0050b188d25bbmr3262230pgw.5.1678871836810; Wed, 15 Mar
 2023 02:17:16 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a11:af25:b0:468:7cd1:9f67 with HTTP; Wed, 15 Mar 2023
 02:17:16 -0700 (PDT)
Reply-To: hitnodeby23@yahoo.com
From:   Hinda Itno Deby <abaapacharity@gmail.com>
Date:   Wed, 15 Mar 2023 02:17:16 -0700
Message-ID: <CABOb=hBYob97HC70WQ2bMDji3Ehnta4PwCYNf2J=Y8uJjEZmTA@mail.gmail.com>
Subject: Reply
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM,UNDISC_MONEY,URG_BIZ autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:544 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5001]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [abaapacharity[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [hitnodeby23[at]yahoo.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.6 URG_BIZ Contains urgent matter
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  2.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello

My name is Hinda Itno Deby Please I want us to discuss Urgent Business
Proposal, if you are interested kindly reply to me so i can give you
all the details.Thanks and God Bless You.
Ms Hinda Itno Deby
