Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3B96C666A
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 12:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbjCWLSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 07:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbjCWLSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 07:18:44 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4ECCD523;
        Thu, 23 Mar 2023 04:18:42 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id x3so84800829edb.10;
        Thu, 23 Mar 2023 04:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679570321;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kYCUWf3Zvj1/UxaNqFmNj95KskpBbrfihe6wb1YCWcE=;
        b=nCl7KG4Pk8fM6Xc/uf7YRUR/AQRiLG2dWJsy6BZ85OAAQMZGOhzNmLgd2daMgrCvdj
         kSKOdHyb/qNMfKPAURlEWjk5nF6hO+ZVcGoOdbQvcmOz78WJzzT55ZKdJDFI+WjcVZeA
         j7uXfX30uZEbnLKduAdHOCVhY27CIMXnNhK9ftBE+lI5sjM0dlF9T6+vznpfb2J31NJY
         PfbOGMIhDiN0JU/G9KXA9B78WfZTBaSxgJNUbF8WCBh5ALoDAlJ1oEft2jafa/RhF7se
         v7I2EzaA6A9EoHAsYQCHXFjwJ1up/PTJ1Xqj54rsjPe2AZX2BJRGiLa9SfVh6pcfzfRP
         fz9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679570321;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kYCUWf3Zvj1/UxaNqFmNj95KskpBbrfihe6wb1YCWcE=;
        b=WWjIquAqbCAa5Iu7nVXr7f4KWxzcaLw7+z0Y479Og70u5sWTY2xj7p4EmRL2ldyene
         AqvDEh5KRXLmR6aGNkrTQNPx8aITccBZvPIzRSEcTrgXqYZpD97z69UXJq40SPA+vvgZ
         g4lqxKewRgILuPxWFHNVjrYumLLMaPnlBIAksdH/QsCQd1yX/Y7vFyna9ni06vUQTQKX
         gzbfKoV71QUfzj01pYOnRYZVixyWgIW1tmDJyPsXJDnbOfntGB2k1/k4V/PwlC6Xl4Mn
         mOHm1FzpIM0VH7rGj3loJUojMKXdLKu+iC+HQyemd8SZQ/gKzHCPQfV/eibSYMq/Nsto
         /K2w==
X-Gm-Message-State: AO0yUKVVG/9tawU1+y0HCjh08YhxER6T+YjCo/fXOUDHV+Y91WIZsd50
        SrgqsxNYvfZZwt+X06zZk0IXUGecNQcxa860CNiV/N3R7RI=
X-Google-Smtp-Source: AK7set/E/PTuyw2fsepEV9MFr61eF9vfeW2I0ewzJPj5zbg4Qy6dp0VzCBfKLn+fsicdjKXgS0UUNhcM/QGGK24gmKI=
X-Received: by 2002:a17:906:d79a:b0:933:2bb9:7c98 with SMTP id
 pj26-20020a170906d79a00b009332bb97c98mr3064389ejb.6.1679570321394; Thu, 23
 Mar 2023 04:18:41 -0700 (PDT)
MIME-Version: 1.0
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Thu, 23 Mar 2023 12:18:30 +0100
Message-ID: <CAKXUXMzggxQ43DUZZRkPMGdo5WkzgA=i14ySJUFw4kZfE5ZaZA@mail.gmail.com>
Subject: Status of linux-nfc@lists.01.org mailing list
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Krzysztof, dear Bongsu, dear Mark,

According to MAINTAINERS, you are all maintainers of some section that
asks to send patches to the linux-nfc@lists.01.org mailing list.
Recently I sent a patch mail to the linux-nfc@lists.01.org and I am
getting the response that the mail is not delivered to that list.

A quick ping from my local machine seems also to suggest the server is
not available anymore:

PING lists.01.org(ml01.01.org (2001:19d0:306:5::1)) 56 data bytes
From 2001:19d0:300:1::14 icmp_seq=1 Destination unreachable: Address unreachable

Are you aware of some temporary transition of the email server? Is
there a plan to set up a new mailing list at another domain? Is this
mailing list obsolete and should we just delete the references in
MAINTAINERS to that mailing list?


Best regards,

Lukas
