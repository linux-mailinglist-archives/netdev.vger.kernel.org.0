Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74ED16B3BF1
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 11:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbjCJKXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 05:23:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbjCJKX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 05:23:26 -0500
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953A419C67
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 02:23:14 -0800 (PST)
Received: by mail-qk1-x741.google.com with SMTP id g20so1760850qkm.7
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 02:23:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678443793;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pyILUwa0Z6Xv6XvO9j9B6myvIlhq3c07p0l3fgO9YMc=;
        b=HCnJmRMgkGQUVbKm5gHkqTQDSMZ+HjAameRU+VVoClL0sCXvvsZFWBxFeuYQ8FeT0m
         hnoraSilj6d2OyabHQ5K16hU+P9+0WWJWjIdNuY5fFsa4iQwwYZR7L8JlFmyVwrpvBkn
         xSaL5OsJ8Ju9yb/BsG3YxxKRcokffIZzaEaBe3/UH5+nY5/Gw/wg0gGs+eXxMqpcnUq9
         WklS3MFD4ewCGpYceCgUJAB1Gnu9Ohv3EZwxcZ00eag4mFH1Jga9RT3O5xhfNG02O+MN
         vUolgkNL1JjiUc4H7yLqhe6Pw/refXpydzhZmflGVSmrZRwqWq0eyowyrgcYS/ew1HHk
         pdlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678443793;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pyILUwa0Z6Xv6XvO9j9B6myvIlhq3c07p0l3fgO9YMc=;
        b=IuhT4kBQhw1rR1T5x+xk5rlNsqpBe+t6mKaXE5RDrDQKkyNFWgPFfn33TTmMg540UW
         5IBF9KDtuWddNIozCMklkxZ3G3D8APeVuMxAQUt0FDGhTfXkwfWLlEh0B93h6TQT5n3t
         XHuODamoZbEjM+S68Wk0lUcqDPg5wsgnaes6766Qd1CSOT3Tv4l164tM5Rre9qOQrWmA
         K5/UDfnZe4eJZlOTWTcdBE4vUjPqfJOWZctyudUMi127sBMXW3zNPwBdwww6Rv1naOn/
         nCq3VhuVdHILMUyMRd05xhcWAWWICXt9TeS0kK14BnXQY8ptTBGMFyHAFchLpeBSoCYe
         V5Tg==
X-Gm-Message-State: AO0yUKUJFVW5bDMVVJZ1UsbZ7ez0xZZS1TqD83Qa8sJIVEsyrsdnj1EG
        UZXjIR0bYJrGVhe50vA4KY/q3U8jlR7ZZDMskGg=
X-Google-Smtp-Source: AK7set/Jabu2IeOiWn0MhJaAI9pacg+c0mRTns25vItB0qPxJovHvlMZekUj+XZpXNKZjhJWU5orf5+YzrIhqslv9bY=
X-Received: by 2002:a05:620a:2215:b0:742:cbfd:33b8 with SMTP id
 m21-20020a05620a221500b00742cbfd33b8mr516664qkh.9.1678443793693; Fri, 10 Mar
 2023 02:23:13 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a0c:eb47:0:b0:572:4a3d:39cf with HTTP; Fri, 10 Mar 2023
 02:23:13 -0800 (PST)
Reply-To: chantalls306@gmail.com
From:   "L.S Chantal" <adamgold9805@gmail.com>
Date:   Fri, 10 Mar 2023 10:23:13 +0000
Message-ID: <CAFoXcHff+3iUNrwd6f9eZqqJ1etOWcON7RjV5zeOXOOvpw6MZw@mail.gmail.com>
Subject: hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.7 required=5.0 tests=BAYES_99,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:741 listed in]
        [list.dnswl.org]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 0.9950]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [adamgold9805[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [adamgold9805[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [chantalls306[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello dear, how are you?


You are compensated for the amount of =E2=82=AC5.5 million in this.
Payment will be issued on the atm visa card and sent.
To you from Santander Bank We need your address and address.
whatsapp number



thank you
