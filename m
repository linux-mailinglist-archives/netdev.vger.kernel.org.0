Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A12C51BA40
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 10:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237109AbiEEI1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 04:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235299AbiEEI1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 04:27:50 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B62EDCFD
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 01:24:10 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id x17so6241270lfa.10
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 01:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=8hzaWwN/CTukYPZc1X7BcyxoCPZGZBVC7SDYG7WP4LM=;
        b=aoujx0olfgNUveridX3PVg2C9H55Y82rmSzwLabYEbdXycRUZprxisr/oJ3beFCAW4
         ft5RjMTLxgAUOmBeHlzOomXEAQlm+G30oT0twE1IAcix8X1KYGjXrBkSdk2ptUFnfnsy
         q/+nAsRc85Kr27EiRi8yoivOSqloZUz02DVGBXc4HVp1SRv8WN2V3CqQGzYllqIKud7J
         I5wa2dtHsXQbIsnM5CClMGTPFsvMKHJMO8uHT9kgiLM1D1fSIZk+3ymu3JkK9hDXQgyC
         DJM+DT+N1mjG1M+TocA0WUeEyCS301HaEcoJP9ip80xY/6hhne7RzGaIbsSlskcJyte/
         nH2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=8hzaWwN/CTukYPZc1X7BcyxoCPZGZBVC7SDYG7WP4LM=;
        b=YfeYzBAmHfkagoNC+LWEOQ5cm3ANlOjnWNpifUbQAMeLQ60e7OJO3RoXjUvEl9VMVa
         nu8lsEWsGYo9fqHDXLLkVux7Y2DOKvGeCiWGKdzpFMg+ezshpBCit0sxyMnQ3/Y4A05G
         kpg98qY2/q8EGwLQ2H5Q1YKduL0iTacMx4nBSEol4rAyZOi9181eyCE8WeRxGNkJj5va
         prteoYqtXo3OCVPOUy9hxcOwH3JY34gSj17jHL/4/fUcdwwekR2ABzIFZwRwp5ffpApl
         Zu6Efi2veyQJ9cgQ5wgtarvRb4XZ0e6vDD7CQfl1yoNAXTZQcYIUUq7Dq/p5l0M6ZthQ
         gSqQ==
X-Gm-Message-State: AOAM5326YQmcYk5OLSGlZS/nu5Ib1VmGnXhZGShoWVJPs94cv4IDb484
        EbT93Isus40t7LoGlWwzauiXcI4raA6Z753lpzw=
X-Google-Smtp-Source: ABdhPJw/nqfLObYDqXxqatmBl/a2tyoNgJ7v06ByY4/cVOzpTz2Fr3g2AYneaPLGvR5cVkg4Ld1H++bW7Aa9e3HzAp0=
X-Received: by 2002:a19:ac04:0:b0:471:664f:95df with SMTP id
 g4-20020a19ac04000000b00471664f95dfmr17435949lfc.310.1651739048933; Thu, 05
 May 2022 01:24:08 -0700 (PDT)
MIME-Version: 1.0
Reply-To: corporatelawofficetogo@gmail.com
Sender: corporatelawconsulting@gmail.com
Received: by 2002:a05:6520:2f43:b0:1be:74f3:f245 with HTTP; Thu, 5 May 2022
 01:24:08 -0700 (PDT)
From:   CORPORATE LAW OFFICE <corporatelawofficetogo@gmail.com>
Date:   Thu, 5 May 2022 10:24:08 +0200
X-Google-Sender-Auth: HO6vNN-71n7btAbOfjNVh1sWrjk
Message-ID: <CAPC2syGVaP8J3yt=E7ijnzOETis9Tuy3Vty6gwrDk3Wzubquiw@mail.gmail.com>
Subject: regarding
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,LOTS_OF_MONEY,
        MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SCC_BODY_URI_ONLY,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  =E2=80=9CI am contacting you regarding my deceased client from the same
family as you.=E2=80=9D The alleged deceased left the sum. ( "  $ 9,500,000=
 "
) in the bank without a beneficiary until the bank mandates me to
present a close relative to them for the release of the property to
his family. Looking forward to a cordial business relationship with
you.Am waiting for your reply so that I can furnish you with more
details.
