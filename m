Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94F7A561EF4
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 17:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233132AbiF3PRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 11:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiF3PRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 11:17:19 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA7C32ED8
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 08:17:18 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id f15so12129776ilj.11
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 08:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=eMKZayKvkcJE1NsJECMuqkGen+W+VhOA8980ZdLwenY=;
        b=mtuSGcCVrDEtgv6G6D8vNnz8tFMqjEmEfnE0mFeY4C4TyNkDEpzPNpJcX7+z+knTlC
         qkYxKlhCmV7DwI9LvbRNnLQ3tdtOdC0RO7qHKri/Zvw92qlCWME0Wtf3MhtZfM1Qdr0A
         AWbtODloNnwTI2appMo0sJH8PY4hOmRO0keptJmbJ48DLcm4BmCUypm7CqcitwwqBc0p
         NhcKp2lsG1HQh/lSlm2AxNs7XpKttICo8BHIBi+mZ2STCBhFVZpgyV1PCu5hU0bYWhDX
         Sjug0C/TnY452jz5qBwCslUO5VixMbLWtVsXqjnumTrxnH+AfuJDHdmBcLiJU6+u9YKd
         tKpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=eMKZayKvkcJE1NsJECMuqkGen+W+VhOA8980ZdLwenY=;
        b=YnLIK4LdI+vSslvICemEbBGoHHaILB3YO4bftOol4JesucwKjR42iIrh3RtnORn92J
         R+vLbS9F6BkU1Nn12Fa0dPjMmc38irpM0u2lRDv/m4wvpY+9tulCq7klNhRhGXZNsR8W
         zrGjirv5wIuaZGagw30mYvF/rJIWo0ztL3iaazPEJpc40EMclAv/JNfuUP6h8f+8kptU
         UyXkCi7qWaHnEC2kLswgX64w0s4RN3vyhz0I1kyDyAy4LN2uED0PzeeZbhfmnKlg2kBq
         km456o9in0ltF7yFAC0dnxP2cbTifkodmKc70Wu1C8LKqv0pIyEqSmDcZBmecN55Nkk/
         5wjg==
X-Gm-Message-State: AJIora+G7W+r19gFjyxk34SiSYWkGyx2Y87MAjgpS3coJ4cj34x99xax
        1V1BB8kQJbGRkctbbyDMrDLDoCFub/1kLXhDh2w=
X-Google-Smtp-Source: AGRyM1sJ9knTDkxu8WcdL4Z6xrCHyWq560idrqTSs86BAVj0GxC7cVwaghgc2OJXczQma8+cTnNWlafC7D1q9ZCYEB8=
X-Received: by 2002:a05:6e02:1486:b0:2da:9864:b480 with SMTP id
 n6-20020a056e02148600b002da9864b480mr5791873ilk.70.1656602237405; Thu, 30 Jun
 2022 08:17:17 -0700 (PDT)
MIME-Version: 1.0
Sender: adamuyunusamalqwi@gmail.com
Received: by 2002:a05:6638:32a0:0:0:0:0 with HTTP; Thu, 30 Jun 2022 08:17:16
 -0700 (PDT)
From:   "mydesk.ceoinfo@barclaysbank.co.uk" <nigelhiggins.md5@gmail.com>
Date:   Thu, 30 Jun 2022 16:17:16 +0100
X-Google-Sender-Auth: bwmIPwTSfUogJYoc-VlQuPJEwmQ
Message-ID: <CALKLisC27imD28fMhatU=jVWJ0VRpBBaA5pOnOEtozoaLASE+A@mail.gmail.com>
Subject: RE PAYMENT NOTIFICATION UPDATE
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FROM_2_EMAILS_SHORT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        SUBJ_ALL_CAPS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Congratulation!

This email is a good news regarding your unpaid inheritance with the
hope that you are alive. Detailed information awaits you when you
answer if you are alive.

Yours sincerely,

Nigel Higgins, (Group Chairman),
Barclays Bank Plc,
Registered number: 1026167,
1 Churchill Place, London, ENG E14 5HP,
SWIFT Code: BARCGB21,
Direct Telephone: +44 770 000 8965,
WhatsApp, SMS Number: + 44 787 229 9022
www.barclays.co.uk
