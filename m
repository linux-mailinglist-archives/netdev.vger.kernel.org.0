Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8EC66DFE3
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 15:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbjAQOFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 09:05:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231472AbjAQOEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 09:04:52 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63883BDA6
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 06:04:44 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id m15so1131413wms.4
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 06:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:to:from:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=U0grQs2LoYK/+4agHiEPH0BC1jVV5rsqbi3ktU4E+Vw=;
        b=BP2G7ayeFdkJ8EFxSaKMdgXI3T4+tdKgywwzyYXTpFQYJRPNfFTKILKBn5KUWigpy8
         8wFlL4k4uKSHY4K5JijfybE+tiEJT3MNZkqkUe/ixjHpk2YgEebI3KZ7IvnELQscqArR
         b7p/u3NJcrAUroebWLPs47+CAApHoyUxwMY/1vfxl74LbFzK2pbQWky/zBpH2RRaES6v
         4Z9Se/D0pEmvmUyf7UjxIPZbnCRZu452o/8WvnTSI5pZvdX/O22UbxetrJM8FCxx4S2t
         DJIF4uX3fWUCxS/582vkPEwWPeI/otr3NylxewQUJA8Q0rF+AlgbpNek6Q8ODcUN9CFo
         6qJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:to:from:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U0grQs2LoYK/+4agHiEPH0BC1jVV5rsqbi3ktU4E+Vw=;
        b=nlvvafAqeBvb6EAvmfq2onD2M8xZmppS2kem0YqJmedmjhq5OkrAIexj9BRcOXlo5Q
         Iv6GxI5OkIU893F1m6axdcUTum07KCcUlxN+Bg5S/d5JajjzORtYBNqq/mLlz5Kfz2VN
         sDis5KDeS//Fpd9xDkzAlguUZdqsMinJ8a7KTxJGM7brOM91GwZ3iG02g/ZCNWdjh1Pa
         GM9CIp02txHC5jGHnGq0Ws6NKQaU0AxtR1y1O91U1iSx4z+zp3E5AV6SidDODhUuNWjJ
         utbNuY+jFPaXIQPENW1AmVx9gP60Rom1dIgiUyEkPcgk3zOxjI8KGwTaF6Ro2MRp7dmE
         Pjiw==
X-Gm-Message-State: AFqh2kq06GsVDhKZ8C1/VnmP2pG6lg89LvTXErOOshB1rUp+gEu1ysgU
        1Cds8b4DEzQ/x2wZFJDyQb96zMhlNIA=
X-Google-Smtp-Source: AMrXdXsyxHxBytnCg21JrjTP5NZYi5wiDanyPftjGqQPf5HogJ392p5q+a3/bS5Rm17AjXcJ1qOEaw==
X-Received: by 2002:a05:600c:3596:b0:3da:1357:4ca2 with SMTP id p22-20020a05600c359600b003da13574ca2mr3231515wmq.11.1673964282708;
        Tue, 17 Jan 2023 06:04:42 -0800 (PST)
Received: from DESKTOP-53HLT22 ([39.42.156.237])
        by smtp.gmail.com with ESMTPSA id o19-20020a05600c511300b003d9862ec435sm28043003wms.20.2023.01.17.06.04.41
        for <netdev@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Tue, 17 Jan 2023 06:04:41 -0800 (PST)
Message-ID: <63c6aaf9.050a0220.1a047.595c@mx.google.com>
Date:   Tue, 17 Jan 2023 06:04:41 -0800 (PST)
X-Google-Original-Date: 17 Jan 2023 09:06:17 -0500
MIME-Version: 1.0
From:   felixlester984@gmail.com
To:     netdev@vger.kernel.org
Subject: TakeOff
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0D=0AHi,=0D=0A=0D=0ADo you have any estimating projects for us=0D=0A=
=0D=0AIf you are holding a project, please send over the plans in=
 PDF format for getting a firm quote on your project.=0D=0A=0D=0A=
Let me know if you have any questions or if you would like to see=
 some samples.=0D=0A=0D=0AWe will be happy to answer any question=
s you have. Thank you=0D=0A=0D=0ARegards,=0D=0AFelix Lester=0D=0A=
Crossland Estimation, INC

