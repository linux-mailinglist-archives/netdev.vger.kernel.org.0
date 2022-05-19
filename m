Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE8252D425
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 15:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236285AbiESNfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 09:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiESNfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 09:35:38 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE2B326CD
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 06:35:36 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id fd25so7028799edb.3
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 06:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=upg6jx/MWAkE+qQlJ+KDUV5z8BWgL7Rr5Xf0qqGPTsY=;
        b=J1xyqqV76g4iNtFAtRFEbT+V2+9NG72UAFuzmUtOHkoVwWVxIovvA/fRqM9DbaUGzp
         CRxWC3wAHGHBfvQhl14fGN/eqCzJ0lAzxaLwGtqRCXqkN82/gsv773lTkiuB3CLQbTFK
         uOlhlsUUqpx5tNqD9qDiKx33x5JGouxr58HwvFRm6RzyinAteaVSW78Tw3/6ofA4aCB8
         YojNzsl5yOfyhY/LDCbRI4vqPtiE2C49HaACgisGJO0CvweAxFZB+bp3Tq+577xqdKP9
         /7Y4DYaqIjv7QiOzYPHIJEZvrtW8KHAUrD2mJFZZXiWHI2Ax2UVm0QMgob5Q6C6KMECm
         TRIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=upg6jx/MWAkE+qQlJ+KDUV5z8BWgL7Rr5Xf0qqGPTsY=;
        b=2xI5DeuuGur/TykEus6bA9954Zy/cnAUEv3wPziL5nnoaQM8eu95+v7bhvXvcemxh8
         tk+6D8SPTzi85sj/lYpEFRF2nUoBxg08uo0p21qitOWQt3vhq3mGfR10kl3ajpYoa0dX
         EWQ7j/BQ2v4KAihx0GUchhMZysj+EYbXolA/sJYpR/jax8F5qH1NHEJPS7/mXr8xzMfw
         CcEIoyzNfIPNVt/nS5zupNlc8j0sUW7cwHFxo7k4WkWRSLyOm4iHZl9ajVhgmu0s3CMa
         WBkb5Cy8M0Tb/TSNCrX+6mUxcXuyAn/IQd30AaTUdlvZSaCe9ltq3HGHUA1JN124IFyy
         e6yA==
X-Gm-Message-State: AOAM5331cvAauCmL7QkGZE7PLXC8gnKK5b8TwAtLJeLTfYZHHJvWaTO0
        PQg4I4LsCUBAWmINrIXEZFKTltq0SOReX148Dis=
X-Google-Smtp-Source: ABdhPJz2kIjuUdCqLmMusIPdYEq5b48hf4OmUgleinyO5pKcXPsiC6WiAe3wlraIwaG/qCcoo+y/79iTHbW7kYAW7Is=
X-Received: by 2002:a05:6402:331d:b0:42a:d144:612c with SMTP id
 e29-20020a056402331d00b0042ad144612cmr5292981eda.325.1652967335238; Thu, 19
 May 2022 06:35:35 -0700 (PDT)
MIME-Version: 1.0
Sender: atkinspierretg.1@gmail.com
Received: by 2002:a05:640c:27d0:b0:155:22f7:1d98 with HTTP; Thu, 19 May 2022
 06:35:34 -0700 (PDT)
From:   Charles Renata <advocatecharlesranata.chembers@gmail.com>
Date:   Thu, 19 May 2022 13:35:34 +0000
X-Google-Sender-Auth: kQmaGWcfxdsofnoOoQGAuslbT0U
Message-ID: <CA+bgDHM-FjBfZzd8tUxwOZPbCH5HM7M8yWPVeJrLJqDFogm++w@mail.gmail.com>
Subject: Hello!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=2.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Buenos d=C3=ADas.

Soy el abogado Charles Renata, me comunico con usted nuevamente para
confirmar si ha recibido mi correo electr=C3=B3nico anterior con respecto a
la herencia estimada de mi difunto cliente de ($ 13,6 millones de
d=C3=B3lares). Le escribo porque tiene el mismo apellido que mi difunto
cliente.

Responde para m=C3=A1s informaci=C3=B3n
Sinceramente,
Charles Renata (abogado)
