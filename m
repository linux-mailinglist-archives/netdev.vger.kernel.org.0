Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6217564224
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 20:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbiGBSoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 14:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiGBSoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 14:44:13 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DE5DF5D
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 11:44:12 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id z66so5326164vsb.3
        for <netdev@vger.kernel.org>; Sat, 02 Jul 2022 11:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=c0efiEkVxtTkTFENAKnUNGf6D7Eoa+H/DnhrKy6xKHg=;
        b=c6WFVqquH7MWLB6ALCipsXZAcb5WCcU2UlHWrS+4QBdjikrEa57Utoh+IICb0P8lZC
         3EUTUhiBBgZcggYyEZuFteu1eJXkU8/3pxfUIo2xUpQmJP8R/XJpbNz3MVxpgYwYPSHd
         DasAT/EvbIPwOoLqFXuWGCPvoSHdeDCUDp1+OXdwPxPVdbqc/1rTPhcwOaEAX2GxLRZq
         t5OBNEJAj8kBu4vF3kG4xSlfuHHuRAMSjHVuPTfnbnD/cu+cFrRywS7ymBGxUn7loPaT
         pvjoqT/e41STXRpgUWz8bMWSU2rESmgpX9699e15FcyL6YBRXHpWtPTvMGeZKycuKIJE
         Ow8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=c0efiEkVxtTkTFENAKnUNGf6D7Eoa+H/DnhrKy6xKHg=;
        b=15PVxTIxBvKCrNTgbYIS+sjeLUJnvFhpS7q4WTQk6qIU8ympukd4YtUx93u94qB9So
         58H00BVM1yqj/BFpXVuuYEX9sAvev1hsIK9K+oTryr7JXxJmoJQUSz+8oG1P2Lt7iomW
         8CtJmEoxEt8Yby6CBBs8Gs1ELijtiTdG23iK3znwFkT4pMKpX/C2bKe+HYHywv3WDyPm
         /YO34X5EY4gWsF//zbNxMAZ+vuVPcpl3Y8to9G+OWTiCAocH/2BTD85OeSMh0xTylqyP
         oHL7Pncb70llfoBZk++o8ce4V6vWnXcUGjON/+3h4QVFwJf3/MX2zyaKnOc8PAz+W6dE
         z6ug==
X-Gm-Message-State: AJIora9IXq6XfcL99CpxeoPkdReLA2KzOenehpWVpX1JsnGy6N4QR/MN
        TYEpMSMiWfew4RviP+atAva0bsvWq3SFcVYqz30=
X-Google-Smtp-Source: AGRyM1vSJZKXrjVNXSddQidIKv+gyM6uWrZIxIrWjNXU+7g8fhIBQ+rJDN8sRZ4mEUBae0zbGcl93NvxHjsvvP1ZzBw=
X-Received: by 2002:a67:ac0d:0:b0:356:a09d:b063 with SMTP id
 v13-20020a67ac0d000000b00356a09db063mr4137619vse.69.1656787451716; Sat, 02
 Jul 2022 11:44:11 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a59:d51c:0:b0:2d0:4b2d:9b9b with HTTP; Sat, 2 Jul 2022
 11:44:11 -0700 (PDT)
Reply-To: anwarialima4@gmail.com
From:   Alima Anwari <laurajrichardson55@gmail.com>
Date:   Sat, 2 Jul 2022 18:44:11 +0000
Message-ID: <CAO0kY96zA24_Vgh6Nz2eVq1v3Pofd2xbszDnuAEJh7xHfiFMHw@mail.gmail.com>
Subject: Good Day
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello dear friend, i'm Alima Anwari from Afghanistan, please reply
back to me and have an urgent issue to share with you. I will be waiting
for your response.
Thanks.
Alima.
