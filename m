Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E60BD660B33
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 02:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbjAGBEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 20:04:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236553AbjAGBEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 20:04:00 -0500
Received: from mail-oa1-x43.google.com (mail-oa1-x43.google.com [IPv6:2001:4860:4864:20::43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DF38408F
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 17:03:59 -0800 (PST)
Received: by mail-oa1-x43.google.com with SMTP id 586e51a60fabf-1322d768ba7so3414635fac.5
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 17:03:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C56Q+YV0i1VwzqpPgsaApjf/2tDIDNvnJyLhwVpmM08=;
        b=Ui1nZAQwen1JZHhk/UNb1oDDJUikJKWwSFDQT7fDxIdrjTsFTfnr65aD0MQpJxZuMF
         RmyXYHMc9Ky4LUKKCV35cfXeVKg9kcUaSr4tiVZgaqF5EFPOnEzUzKBi95ahnFWEJuB/
         wikAeNAEQCrGUuHayT33w+2rQ4+HBUUxhxKBasC1xNVeOOKwbrPJi4n0XGoiGNV0Ta5k
         CclCoy5QAcIdpNT2BCRseJKd9epac9YGs66Cgc9nZMojVBhKvtImHmE+ZbhBIfigRiBi
         98nZh86gtiJqweGJlylRyzSsCuKNMTFPzlfmr38W444ZCFDfVUVeCB+li6CwVFx/Asvw
         l86g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C56Q+YV0i1VwzqpPgsaApjf/2tDIDNvnJyLhwVpmM08=;
        b=SJ2fiKgBhpoa6gkODaTo1K4WhCaaxhr1D7yaj/xWUoeeszs/vSTm1TtdEZjoD0Y6hv
         KdoXspJyw00V0wt3jeFdHc3hPO11OfjwCLS0e4JRGq38DETFormUzOqL8p2W4xbSL+Y/
         qwYvDyQg/jfeVkcBU+ZJ5ifINMUX8RKo+fRSzr0Rjdd5I1A5LMuCak/X3vdQd1dsVSXn
         4PxlUrnxT4aTatczrTsviXYWLFQD5MAYeAKEW7/SapZws3qJO9NwmFO1dJrSXxB4b3z5
         ee+0Z8Yg4etJcYBtpPyjL/goklZGaI6HTySm2BxYK24RRM+qgOgcpx9gp+ozjFt2cjU7
         2yNg==
X-Gm-Message-State: AFqh2krcOmyWXohesXouG+XqfuzzZYsWFekb24k6IP2bSuaPD2GrQeOG
        s9kLJ69NSzf94E/Llj6t7MLN0Q9cyOcw23qeCgs=
X-Google-Smtp-Source: AMrXdXuy6RV5DBW3idauFhx1utsKIy/tzX1PwuIHZiENrh5zCMKQgqD9oBX+tZBveG7/3LbSFusOjNssMxTFlJ2Y1NU=
X-Received: by 2002:a05:6870:4b8d:b0:14f:d35e:b7fa with SMTP id
 lx13-20020a0568704b8d00b0014fd35eb7famr3510003oab.222.1673053439258; Fri, 06
 Jan 2023 17:03:59 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6808:2387:0:0:0:0 with HTTP; Fri, 6 Jan 2023 17:03:58
 -0800 (PST)
Reply-To: jamesaissy13@gmail.com
From:   James AISSY <samueltia200@gmail.com>
Date:   Fri, 6 Jan 2023 17:03:58 -0800
Message-ID: <CAOD2y7mxfJEiJcw8zGx8n6ktU0yeDj2shbDio9PsogOVj9NGZQ@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2001:4860:4864:20:0:0:0:43 listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.7812]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [samueltia200[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [jamesaissy13[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [samueltia200[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello My Dear,

I hope this message finds you in good Health.

My name is Mr. James AISSY. I am looking for a partner who is willing to
team up with me for potential investment opportunities. I shall provide the
FUND for the investment, and upon your acknowledgment of receiving this
Message I will therefore enlighten you with the Full Details of my
investment proposal.

I'm awaiting your Response.

My regards,
Mr. James AISSY.
