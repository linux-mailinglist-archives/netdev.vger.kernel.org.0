Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFA365A3C8A
	for <lists+netdev@lfdr.de>; Sun, 28 Aug 2022 09:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbiH1Hpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 03:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233259AbiH1Hph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 03:45:37 -0400
Received: from mail-yw1-x1143.google.com (mail-yw1-x1143.google.com [IPv6:2607:f8b0:4864:20::1143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CECE333A1B
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 00:45:36 -0700 (PDT)
Received: by mail-yw1-x1143.google.com with SMTP id 00721157ae682-3321c2a8d4cso129714727b3.5
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 00:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=js8jdg7UWifkhRoiGZNtqX+ncfiv/MFe1dhMSWZmt4I=;
        b=CBm02tzvB15XnCVQdKxVar3phi29CnlXeKrxO0gTuRESwAWYVCiswtMUfNkrS04RLQ
         5wX1m+3TNUMn32KoswBwchRIJR+5G0pSKOWUoTVLRs52DswUiE/AJNJAkBYM+bQEHlQQ
         8bK5WnN/V82NZWfgt4psw82ev6R+DYSQRXFbmuvaXbfhx8SslRJmHpi5zOtxMuEMuJSD
         Dh60oAEatqzgsBcILr/QcsecOnPWLU9vywQksWPhD41b7ZqTV7dPmfXkNVOhadbhjSJX
         F2NotVMH7F4Yby/SY2XpwXDcp25DwnwlYuvP8kvvOBJVZWv2FxvR238pbOKbV5VxWpE0
         oVRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=js8jdg7UWifkhRoiGZNtqX+ncfiv/MFe1dhMSWZmt4I=;
        b=0Zx5MnB2/5SXMLCt27KSDgKvVb/NI8blJ2hyEx5EQIjJNiM1Q1uTno7iRNe6OWT3ni
         e8jOqZRbRamr1fz0vhodN8lOJrIWRkxfDfAeBZ55P8IQ6KeL/P7jXsb8vpoqaRsxrAS5
         CQP7PldCSSVm7hBlcvacXPoBzrkF7GiVGYO6bnSMCIay1OwvXyIAymls5MyUsH8k8y2U
         Iood6nAQ0duD4MSQbDoCj5zVS6jq3xmIQQc9BavvQygnr8TEv7eVl1eYkVvGJz4dmg7F
         PbPBXhk2J1AtokoiK6XaHZh9BToKnHAoA7dcH5DsQxqw5FHSmP5aEEWQ5XQ00eVjKXtK
         oPuw==
X-Gm-Message-State: ACgBeo2U4jbIstlM0KBnnUQlXxCEJbFbVD7aYyTST+uyM38AmWrYHj26
        TQnijEQM3RWsd1SSAGMTIso/HSg2f33iQEokJ5Q=
X-Google-Smtp-Source: AA6agR7fMazM8kUY0901PIdfzRQ2OVrAM3xbhJpAPbjt7iGx5Udfoum2TdXo39T+sNDSADm9MfXWAY8PxcOgXN5UOcQ=
X-Received: by 2002:a81:af45:0:b0:33d:cbb3:d06f with SMTP id
 x5-20020a81af45000000b0033dcbb3d06fmr5850924ywj.485.1661672736109; Sun, 28
 Aug 2022 00:45:36 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7000:c51b:0:0:0:0 with HTTP; Sun, 28 Aug 2022 00:45:35
 -0700 (PDT)
Reply-To: sam1965kner@yahoo.com
From:   Sam <jeanemail.keison@gmail.com>
Date:   Sun, 28 Aug 2022 08:45:35 +0100
Message-ID: <CANVjhpqFb43Qj7KSjv-3fF5HOmsQ+9pY-u5zfAi4RTWLRfdFNQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1143 listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.6473]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [jeanemail.keison[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, I am aware that the Internet has become very unsafe, but
considering the situation I have no option than to seek for foreign
partnership through this medium.I will not disclose my Identity until
I am fully convinced you are the right person for this business deal.
I have access to very vital information that can be used to move a
huge amount of money to a secured account outside United Kingdom. Full
details/modalities will be disclosed on your expression of Interest to
partner with me. I am open for negotiation importantly the funds to be
transferred have nothing to do with drugs, terrorism or Money
laundering, regards.
