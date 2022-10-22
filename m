Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B69D608BF6
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 12:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbiJVKwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 06:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbiJVKv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 06:51:58 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193707B5AF
        for <netdev@vger.kernel.org>; Sat, 22 Oct 2022 03:08:44 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id q19so14399942edd.10
        for <netdev@vger.kernel.org>; Sat, 22 Oct 2022 03:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VaaSLAJ+hgNGNq49WyPsh3ndDLo+mnrYcswrOHpJSv8=;
        b=Yy0RuSBUv+sOuLDhRVeMZt/91kWKigJ8FNTkHfwvoHGGzxR1oP+0UYIHEr+2MiNymx
         l2YnuE7Xnuxjo+fW32hhFjfl4HDMy0+/5lxp4R7XDA0mYAXhVO5fRUhSe8uX8/ano+hT
         Rw895Bu42p6R9+RNeRHoMiVHYI0bJAlVe/g/aIQgvduNnmqjyM/XmSAnEnsHmxMcd9in
         vB2kgiJ6YMGI7hsk/sCt6+GOT2rdgZofNDsPmUY6qf9m1wpY1WF547qgp3OZZr8JFgNw
         0oZKjIudBiZMKfwWZUZCWl8oxNsFbVlTg1WlHw5TnqntsppvU66PCZiNdR6t3znKA6+i
         Zxuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VaaSLAJ+hgNGNq49WyPsh3ndDLo+mnrYcswrOHpJSv8=;
        b=wQ3h3Iq7ZHRXGMDQ+BHur7FTv+f/SD0WUbngj3pidYBlIE1Nm9zd/6D/lBI1Wn1u2c
         qDu2XnnY7AT6HSHummcYbodIFQrL0SXb/Tpk9FGls9bVhIFR7ez0yLO9rw7bO/6LDBQs
         wXruDv4yiyKvDTArsCzk4QlNOGj/W8wYgLijf4Vf7euYqEpeH5PYH4W+Ky9HFnYAiZMp
         XtuRb/RHroykFDVo2JOclHR743aig16byINkieQ0dgyIUysB10E21up1hPWI9l35DNVA
         W4vIi7k2O2azJb1kN12iRSSPqxs/fggJx25MK1LkOPpCi0X2I8E7UQqpDg1c7H3IRQQQ
         N7Lg==
X-Gm-Message-State: ACrzQf2/cOsQJOqalMWuPvZvSTX7IcNCOSRcPoIqMe+pfy5TbCnC6MLh
        oXbIuvsfz/MXrcrOSxe7/QXEM+GvZweBq61nlh4M6a0hfSA=
X-Google-Smtp-Source: AMsMyM70APPTWSsOWkCuMmkEHP7vXsMKAm0X8jxjci5/Zhr7T/aVqoqBfTE4uBCkygxYmKOuQctyd1oJRzvEAlTLANM=
X-Received: by 2002:a05:6402:4282:b0:459:befa:c79c with SMTP id
 g2-20020a056402428200b00459befac79cmr21607519edc.23.1666426552026; Sat, 22
 Oct 2022 01:15:52 -0700 (PDT)
MIME-Version: 1.0
Reply-To: mrs.susanelwoodhara17@gmail.com
Sender: mrs.arawayann04@gmail.com
Received: by 2002:a17:906:6882:b0:78d:4170:b3b4 with HTTP; Sat, 22 Oct 2022
 01:15:51 -0700 (PDT)
From:   Mrs Susan Elwood Hara <mrs.susanelwoodhara17@gmail.com>
Date:   Sat, 22 Oct 2022 08:15:51 +0000
X-Google-Sender-Auth: mMZsXPRk8lY5iSCghosfZoIPFNE
Message-ID: <CAP-cSYCHZ3W6YDC4m8uhFsC9updsVcPwGL+j_8DapehEKpiZgA@mail.gmail.com>
Subject: GOD BLESS YOU AS YOU REPLY URGENTLY
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,T_HK_NAME_FM_MR_MRS,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GOD BLESS YOU AS YOU REPLY URGENTLY

 Hello Dear,
Greetings, I am contacting you regarding an important information i
have for you please reply to confirm your email address and for more
details Thanks
Regards
Mrs Susan Elwood Hara.
