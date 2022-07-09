Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 176A456C4DB
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 02:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiGIACW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 20:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiGIACU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 20:02:20 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41AB39B1A9
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 17:02:20 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id 136so241076ybl.5
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 17:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=f+r3QaQymsSPGcEeFlQ2NB6qelvQaE6Mf0SzYBIHNoE=;
        b=cOMo/IlznKfnVmmRvTF1CFLbzSWVzEsdBrqCsydEqhjyzxGAdKJDAFxSHtgbFrrdI4
         F2FGQY3fRjQ9G27vgzcAO0Pp1ICwQoorMqWdXEBIgQdWs0FC+IQ0tjkRq4PENu3JBn/i
         UxBANZaqE3TmeMh8hZ610XFNpRr/MO1hQxX9Z/DKokl/dILmEj0ycKxLL8Q2uLhGyDVb
         TvnptdiLE9T5ZHiq//D7/IrH7iQI+mErtuZQ0YeQcd/B3kv9M87PahQk5Pr7CfykUYeH
         T0mTnIL6IbNeE0eAJ9fc6CX35tFH/1VgY2G3EcMSWmXZ67MX0ESwwIO7uqP5+3U/TOK8
         LTyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=f+r3QaQymsSPGcEeFlQ2NB6qelvQaE6Mf0SzYBIHNoE=;
        b=QfkuXOyrwWjNYs0/mgtpdny4DwRIEZcN5Sf9ElvxRQ25mqO5TWqU3PrrZudjObHFZs
         AWrfT56Mey/0ZarZi0Tc/LLRK/UK60wYsVFcJNWMiVGtyXAwkVlNx902Zu6VaGDCl3RB
         IeKo9mkG13kO2WXNZcCZc43n3VQm3awkytqFPPGj1XD8JeGohAjCca6IovG/RHzksTr/
         8MZ7S3oFJ6XJR/V54kjt9BPG6sfxdg0NhPVgOc45VntHTuKWfBzCpGIIVa84y+cSuTeq
         6QS/OdXZ+ozffB8is5/XRWaiyrYtDEe+xwD2LGaJ1X+XumsH/4fhRPCE0Ms3Gkyet86Z
         rFEQ==
X-Gm-Message-State: AJIora/rTJxZsAABr++llL9389AEABtePYvFVyDj1CPKd/Dgo0iRdip6
        nbDuFqm4ssBUhwscnwYgCOb+ZypNOXoyiPl4VZQ=
X-Google-Smtp-Source: AGRyM1s6CqbvoID2H+MVJvwgADq4QsKNYkX2ErTSY54Wv6rVMPQXVLDUhI+4H7PjTw0xt+u2W4jpEY0XWEFME0Ktjjw=
X-Received: by 2002:a5b:c0e:0:b0:66e:4c80:c6ee with SMTP id
 f14-20020a5b0c0e000000b0066e4c80c6eemr6426901ybq.635.1657324939437; Fri, 08
 Jul 2022 17:02:19 -0700 (PDT)
MIME-Version: 1.0
Sender: novnovigno12@gmail.com
Received: by 2002:a05:6918:8a48:b0:c9:72e2:ae87 with HTTP; Fri, 8 Jul 2022
 17:02:18 -0700 (PDT)
From:   Jessica Daniel <jessicadaniel7833@gmail.com>
Date:   Sat, 9 Jul 2022 00:02:18 +0000
X-Google-Sender-Auth: NJtqShZTjc4yWQCJkXwURQCRRjQ
Message-ID: <CADVVueUKft=B+q-sP701+NGKO6mYkHLUxJW=ZgxGSpcx4ZUKSw@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello, How is your day going
