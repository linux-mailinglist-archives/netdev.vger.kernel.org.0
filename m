Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C2766112D
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 19:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbjAGSwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 13:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbjAGSwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 13:52:12 -0500
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A2129C
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 10:52:12 -0800 (PST)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-142b72a728fso4796477fac.9
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 10:52:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XppnWxwUDd4VKlDQMnttNa0YhBi85GdHW05upV3mZfc=;
        b=JHrjx+CPI6+o8vI5XaPTU8d4Rba2fyliEd8VcPnHjc4QNFglXkrbpA+dm9IYsMkn5/
         dl6zWRAkwai8c+Bzs+KUIraJdD0FtmYTyCF/IPXRp+9EGEmXnCqu/3qII+/UTCzbZm1T
         j5qyMcUudr4ZCMHTWHUxvtRu8C4QeZkwBGzi+MoTV4Tu3tQX8XWHOJMc/s02qPGs/5uW
         +4x7Yol8rGkVOc5lJLMrG+ClDnF/ECarwuE8r95xLhuYVlLgAuAgH7LjtmdbDwil2+iT
         MdUVh3Aw1HDRXnhKEhMpcVYulb5AxdjW2ISJjyBNKemHS5KQPGw3a6KzXtlKsVRFqKe+
         BAKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XppnWxwUDd4VKlDQMnttNa0YhBi85GdHW05upV3mZfc=;
        b=PVWqWtDB8/MY7pxOG9uOJDIJHcTWcGhAsi5nElZ8IUvjyPbH0I/rn6cFXLnmpXf67a
         8aXpn88dc8KXO8GUiaX0XG6Smqz9y/CvYRUFAxlFa4DxtHtRATO/vz45pbz+D9+9f9b9
         Cb02u+w0BoWzijMFDA6TLz2WflUeAQZdKEHAiVge1lGaZp3UFkkbpaf8ETzxM3pI/B0p
         7Xe+5nszCJuvksVLQA7EqSLSizf7kNkFIJ+j35ZU0lwASh/unq+LGZbdHJUAT4fVvROl
         Z1eU9t4NOoZkH9IlXe+HUcFDvhqSi4/U+Ise3IRyaC/+vJ+lVQBBqbpBfLO9xsCLF6od
         L8Ig==
X-Gm-Message-State: AFqh2kpaD8wB82RwnIMDO9EpC0UBTXQzms3NguGXoLTFjEs9ZSBShanv
        lHrEa+FmWxmpm154v4aYSEba6W1Ywf/hA9XOvgA=
X-Google-Smtp-Source: AMrXdXtZ2uwxjGIccmfG79+cJAxs3h3LHmtN7hCXAvTJ9zPAvEB9bZ5FIulx4x9FwGNv6Q1Eoa6XHk+/I2V8VIqFmiE=
X-Received: by 2002:a05:6870:54d4:b0:150:7c93:9cd7 with SMTP id
 g20-20020a05687054d400b001507c939cd7mr2560230oan.180.1673117531532; Sat, 07
 Jan 2023 10:52:11 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6838:2307:b0:577:153e:6778 with HTTP; Sat, 7 Jan 2023
 10:52:10 -0800 (PST)
Reply-To: lisaarobet@gmail.com
From:   Lisa <ws6392981@gmail.com>
Date:   Sat, 7 Jan 2023 18:52:10 +0000
Message-ID: <CALcNZmHG0gNY4Ti-KB1DhyREvaaE7tXn3oTGASJNtu5fon+9Ug@mail.gmail.com>
Subject: Greetings
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Just wanted to check in and see if you receive my request?

Thanks
