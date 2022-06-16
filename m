Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F3454E5B4
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 17:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377834AbiFPPIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 11:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377791AbiFPPIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 11:08:48 -0400
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB103F32A
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 08:08:48 -0700 (PDT)
Received: by mail-oo1-xc43.google.com with SMTP id f2-20020a4a8f42000000b0035e74942d42so301934ool.13
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 08:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=L5K1NUBULmGZ7/lAOd1A1xSFwQYe2qUxoRrdKo6SvOU=;
        b=YlFNhaB/jdqWsVZ2cEDJKz3SjjDDHve3+EU0QtK6Aw1U6SZkiBzREZ5jz2VYUS0gl+
         2dSTY9t6FF1MHml15b+rm7jSlALP2y/vaTlHoPR1C6xsAmQAKDYUEJvX1MdlhjAft+pW
         MEHbNB1zJY+xAMfIXQkrKTrziMavyO8F4ldmARa+QC5Lnj2uZTOUlt6Z2wVizku7c1pP
         G49JywXWCr6/lv3YyOoOWnnT/rb04EOv7xhACI9IRp4cx9q7XzE5W0CE9q0wEqFWlNFF
         9TOcS0GvPbkxZiLMaYxDpFCbYSMDc2EKyTuIOLf8j6IkAtQEJcQMbrMI7PrQVOM8zAAf
         I15w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=L5K1NUBULmGZ7/lAOd1A1xSFwQYe2qUxoRrdKo6SvOU=;
        b=1QP5QE+5QaZ4F64uYgDkLD9UEdGUoHgaMtcN3tUK1jtLaZVF57TrxS7y+JzezZ5dxi
         5VEjzCtTdXg6M1/GsirHtw86hS7ORl3CGm6DdP9qLOAuvR/mJlmQD1T0sZN2B+lH/jJ+
         qyIrmOVWagGH9jPVfZtaEqRqbftFhFFn3SPkpTujwfoQwpEuU21gCDMAciM4bd+c7jOp
         agT6c6QFIMizQiYix0qDuCifoBzgepV2ClrB8mWlM+l4wWl30FrCApMlSmAqJ3hlsuDZ
         cmfxZMm4pvcXqSxbrnvH5lH7FucXjDU2O9gWcb9BvE0AK8T382+PYpZiNFC/5XV2eGYz
         jP4w==
X-Gm-Message-State: AJIora9+vBYPdW/fm5hML9pS7S9zHlR09tIgqiiNTo/GNiek6F1Vkb0x
        YW6kOWuVH6LUB64wvdViajap0NuAAIRaj43fOs8=
X-Google-Smtp-Source: AGRyM1uPvSxjxs/Bg6Qe+DLkOViXB8qO4Uh5kCypZnRqKGXQiSVK3nlGzKl9yyzl2gDIid1o0WOEMTW7d6qfpOPLX7k=
X-Received: by 2002:a4a:9b84:0:b0:41b:e2a6:86ea with SMTP id
 x4-20020a4a9b84000000b0041be2a686eamr2151544ooj.87.1655392127256; Thu, 16 Jun
 2022 08:08:47 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sgtkalamanthey@gmail.com
Sender: kodjovirabby@gmail.com
Received: by 2002:a05:6838:e511:0:0:0:0 with HTTP; Thu, 16 Jun 2022 08:08:46
 -0700 (PDT)
From:   kala manthey <sgtkalamanthey@gmail.com>
Date:   Thu, 16 Jun 2022 08:08:46 -0700
X-Google-Sender-Auth: 5qRN265PN0IHnPqmH_ohQ9n8BQE
Message-ID: <CAFkDyg4sh10a1foV=j3WPp6V07LSWs9iFim0=j1mA0BkX6y=jw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

5Zeo77yM5Lqy54ix55qE77yM5L2g5pS25Yiw5oiR55qE6YKu5Lu25LqG5ZCX77yfIOivt+ajgOaf
peW5tuWbnuWkjeaIkQ0K
