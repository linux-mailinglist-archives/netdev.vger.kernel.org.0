Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1FD0561FCE
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 18:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236228AbiF3P74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 11:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235514AbiF3P7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 11:59:55 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2534719038
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 08:59:55 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id v14so27953388wra.5
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 08:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:from:to:subject
         :content-transfer-encoding;
        bh=A6WkR2bbX+6nKt+MXz/xw/8OXFUy+eOLExGLg7mZyEY=;
        b=DHm0+dwyXjCCAqZnHwb76G0i67/HrqQSbJbZLsULDABjkdDK9R2jQE5123JXF8Em38
         q+fHjwDr5rDW++2tGjIRf8PE+OUnmzl8K0KznxOgoPdtRWIz6Sg4/GXibwSJ1rqputz6
         o/G+dSspyf6PwWcebKfRA4MtwZ/5dDAoxVXEmvgi9aKJzWjCStDABvVB2RD6s21FJ01Y
         kiqmoM5IBInlik/7O0LbHoeM8NBGgQYzFsOzSFDz32kR+mwgeJW3KaTKQmkLzO+Qgv42
         +V9uok862RADWKlFxxxL5XMX7U3HCH5YSedw1GUnSU1lF7MPKPlA93dxyKfDN1IMFCBb
         EJ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:from:to:subject
         :content-transfer-encoding;
        bh=A6WkR2bbX+6nKt+MXz/xw/8OXFUy+eOLExGLg7mZyEY=;
        b=h6cCl+7Oi+BtgDMhni2q1QO9KsOQ+N2l6dE89HE0dE6OmTQ+if8B1941hsB5pYn5Nq
         9S1nCFqXhW65OVb4YO76mvPHttBimO0lH+eKnbuIzFPp3PlQyGnw/L2JAm1rxQ18nLP6
         ypbC2pxHMwm68imlG46OtF67ZaykXQLODe/H4zHRtCyB+35fbQN2hI+n6wIYUW5+3BKL
         62HkQ9TVcXxMRybuIW0oa9v8PfqAUC0Tj5W4HfwYA/kQICaPFvZdvHF3Gy0NkmEWl+JC
         nLGgvNXdOKmM4YcJ4ZASeARVGwAs9xaE+Q0JPTYfRR8Kz/Gc9sVHYfhWv0CcJXTUcms7
         3/Lw==
X-Gm-Message-State: AJIora/qe5US8rreRBRO2d/wbr258lpsvuR2hgc0FM+jcGetYQ0aX2eq
        ACFhl+OJAu3OjVNVVA14BtCRFXbnpH7lT3cf
X-Google-Smtp-Source: AGRyM1uhSipxuAmag6y7I+rl1Kn41Dc33i2CFE9bIIazKx/Rtfcil2CHdIwwDBAe7N10tips2qmcAA==
X-Received: by 2002:a5d:4532:0:b0:21b:ab1e:e9fa with SMTP id j18-20020a5d4532000000b0021bab1ee9famr9072923wra.214.1656604793565;
        Thu, 30 Jun 2022 08:59:53 -0700 (PDT)
Received: from DESKTOP-L1U6HLH ([39.53.244.205])
        by smtp.gmail.com with ESMTPSA id c7-20020adffb07000000b0021b98d73a4esm19970992wrr.114.2022.06.30.08.59.52
        for <netdev@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Thu, 30 Jun 2022 08:59:53 -0700 (PDT)
Message-ID: <62bdc879.1c69fb81.7fcec.6951@mx.google.com>
Date:   Thu, 30 Jun 2022 08:59:53 -0700 (PDT)
X-Google-Original-Date: 30 Jun 2022 11:59:54 -0400
MIME-Version: 1.0
From:   prichard.dreamlandestimation@gmail.com
To:     netdev@vger.kernel.org
Subject: Estimating Services
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,=0D=0A=0D=0AWe provide estimation & quantities takeoff service=
s. We are providing 98-100 accuracy in our estimates and take-off=
s. Please tell us if you need any estimating services regarding y=
our projects.=0D=0A=0D=0ASend over the plans and mention the exac=
t scope of work and shortly we will get back with a proposal on w=
hich our charges and turnaround time will be mentioned=0D=0A=0D=0A=
You may ask for sample estimates and take-offs. Thanks.=0D=0A=0D=0A=
Kind Regards=0D=0APrichard Peter=0D=0ADreamland Estimation, LLC

