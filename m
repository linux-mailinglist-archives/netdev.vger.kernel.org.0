Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24925665BA1
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 13:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238846AbjAKMlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 07:41:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239237AbjAKMkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 07:40:33 -0500
Received: from mail-oa1-x43.google.com (mail-oa1-x43.google.com [IPv6:2001:4860:4864:20::43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE5119C26
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 04:39:19 -0800 (PST)
Received: by mail-oa1-x43.google.com with SMTP id 586e51a60fabf-15eaa587226so688330fac.8
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 04:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=baxoHBp4nwp+eSIfz7bow0djtitpVsI8N+RYIADhEnk=;
        b=VxHhkq0tOwwDHE1x7XWcccXsm0E+YZW3rs2tfplGrQB0vdUfGc9xJ1VvoPIIhS7e0T
         U+6SIqMDlwGZWh7sGjxLhjxe8ZSXcFS5OObCKhSS3EADBRuRq4hCIVhsgr952Lwala+f
         C7vLU8pBOta6tLX/3bVH55hFUKr65YXNCHkdXoyig9n2q8M9as6169+XnFEeIrGkASsE
         tTtsCB8a0reIjWmy4B6gk6KKIgbJa01/6c+VLwO+erDbwYgkvU+lqTeNYo3IgkHUosVj
         4SA/8s7hjNh5YSH6+y2bTFjKLt7NTaeKPxLN/a1EjsdN6oIMA/YfbhbZL7l51HIAVHuk
         Of8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=baxoHBp4nwp+eSIfz7bow0djtitpVsI8N+RYIADhEnk=;
        b=TxfJGVtjtn8Ryka6Mt/zeGUqIxJOFG3BqTSyLI/jMQV21bLktPlMww/Fb6lLfkxEnT
         RXvtgDT7Rymtluux+OEm6YgOg/3V6uBeRITPSHyS49k/MHMu435KGX4fw/LoRNiRzbIv
         +OqAyoQWZ8rpzFR2pBBTlmcDI+yPr8TRBLPcd71IjVISnsLQ6Hr6uBXXc/aCwwWMd34Y
         02xSDH6aUdbaik/oFZz+0Wc1JJsFaD2viNQm+wRzZMZ9gKZ7vaDl7+ht8CbyQlbu7j0Z
         qd6IT3cqGbFReXSilrL0adB8C9GMCOP54hcnvdqZXhjj5ZYijvA/sDq7t7w6f7WiZSf7
         so2A==
X-Gm-Message-State: AFqh2kpgpcgp7DDjUH8RIEtP6VlZMyxxU4JG6WFqy2ysl8GypI2kn0QG
        YVmydd+Wo5ZhnwP6d7pDqauEzymGxIIUqBfytbo=
X-Google-Smtp-Source: AMrXdXuPf97zXfDDhcHvJ6uqRcZxUdNW2pW0jUdFrJayOwm8HiOdwD+ONG3FzQL3dfQ+3K0IvrPMeN66H6rKQyLGAjE=
X-Received: by 2002:a05:6871:81f:b0:150:4b74:efbc with SMTP id
 q31-20020a056871081f00b001504b74efbcmr2860885oap.277.1673440758760; Wed, 11
 Jan 2023 04:39:18 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:684b:0:b0:48f:9b83:b750 with HTTP; Wed, 11 Jan 2023
 04:39:18 -0800 (PST)
Reply-To: mrslorencegonzalez@gmail.com
From:   "Mrs.lorence gonzalez" <deaskuiveariety@gmail.com>
Date:   Wed, 11 Jan 2023 04:39:18 -0800
Message-ID: <CAN9KCYFC-DB0MomdQBVB7T6EsOCFjau3F_ex1YP1BxJzHLDFqA@mail.gmail.com>
Subject: God Bless You As You Read This Message
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Am a dying woman here in the hospital, i was diagnose as a Cancer
patient over  2 Years ago. I am A business woman how dealing with Gold
Exportation. I Am from Us California
I have a charitable and unfulfilled project that am about to handover
to you, if you are interested please reply

Hope to hear from you.
Regard

mrslorencegonzalez@gmail.com

Mrs.lorence Gonzalez
