Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C315535B6C
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 10:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344836AbiE0IZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 04:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349764AbiE0IZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 04:25:18 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C779333E30
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 01:25:16 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id jx22so7250867ejb.12
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 01:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=mZ3wqB4NmL7z6lpFr/h15h1rYqsZKafJnUpMVahbEPg=;
        b=cKRdky2iLKTuMMOOfd8kxvE2/Xj5XusO4iS40GxeI4HVFSCLe2UopeR8BOWqsbC/jP
         w8C8C1sby4LTW5Ed6BDysmhC/NxftawK0SCRTqZd0168DjdT/QlVUXbXeGG/QdC+DRI+
         TbfOlk72TpxxuiBuZohu57m1lhyZUM6PPzB2I5SXboZfV7ctJXML8zr8wk22jiX95SWT
         FuCvQ45bkbQRuNDd3ytMBNpDGW4MlEzJvY8kplJ1CZJUCmzYtz//hivEymvT4eX09atc
         zD+9kKjZLV7pZyrm/4fvpA+F5mLBc0c5bGs56Y5bbJY3lyMhh/SUt7WDuCiJ2eGpJMvO
         WT8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=mZ3wqB4NmL7z6lpFr/h15h1rYqsZKafJnUpMVahbEPg=;
        b=wCblCtw+131jGlOpO2Nr5f/HThNTTR5WcK5QVpDhGeK3n0Dm6gjZIqMXWeUS8zv2Zx
         K9dQ+OaFX37PNUjGA45PAi1gN8u07Tnj+k/8B0Uzphk8ajdXwbnENl+wQvw50D2xGtiM
         PCZ3BqCqCH++yi6CMJi0dMwHQ3ar58Llj7PY2t6O7eJPshbuycMprHnhEXF97RPZZKar
         ePEVrP5tYVSujmb6lJQ1ZM6//ehZwfi+qa2QVLyaQF2lh7dGJ9rk35ND2GQG+zS0atQg
         uozrwGIP/c5XrpY84OoY0lQOKgty2tjSDulJEd5gaYtg2ZkBG6YjjZLFH8x3BaocDHU9
         yQSg==
X-Gm-Message-State: AOAM531zR+caKB2Np/s28U6o2+0C2+fgSrn/csljNb7pKWk+dckK7lTP
        31BD8B8+LvHiJtIYcmT4ecMbXvQkd8ChO8tzKZ4=
X-Google-Smtp-Source: ABdhPJyYx0AeayPmPvv4+A+9LTVSUmqYh3CwuciDMPxsFnojcWUq/Ni9GAOOnpvcxaEUqRLlnPmJ8A1dOe/f8GQYKko=
X-Received: by 2002:a17:907:3da1:b0:6fe:aab4:e7db with SMTP id
 he33-20020a1709073da100b006feaab4e7dbmr31264611ejc.1.1653639915260; Fri, 27
 May 2022 01:25:15 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:2550:0:0:0:0:0 with HTTP; Fri, 27 May 2022 01:25:14
 -0700 (PDT)
Reply-To: tonywenn@asia.com
From:   Tony Wen <ezhejianghuayan@gmail.com>
Date:   Fri, 27 May 2022 04:25:14 -0400
Message-ID: <CAF6pdHysjx_+qvLqHJBc6u_LxqStuFons5OWjwXz+zqC_Q=PQA@mail.gmail.com>
Subject: services
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Can I engage your services?
