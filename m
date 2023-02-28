Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 471816A545F
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 09:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjB1IaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 03:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjB1IaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 03:30:16 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE94F233E9
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 00:30:14 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id x6so3684909ljq.1
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 00:30:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677573013;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aPR3wybdLDGQ751O+Ph+iKip/50WSjBMbLi5cBgGIUQ=;
        b=SCzrfgou23B756jLBrow2DC+PMVKCIOblVQ+puf9OwCJLmelA5YS8O7XJMfas9dudD
         9jBVb+/go15c263eRCuZpKQCtUerVUlpPpaEIzVQ20JDaur+pMBmTNadtok1Jzw2fvID
         IfOTwQ9z1nMSlj6JtFYbxkyY9vDR/nARv3yFXklxPNdrp42puqnaUv3bZXUzwK71eboM
         aL63WYeMqkuQpVszMBdTNqB4EGEVB579yMqa8c9rTHBZY+FDMAdpHDbxrLa8QzFWB/md
         f38NEiuP3rWLy2gjFMJPX1e9K8khLNfC+d4rhTQp8LBbRRnzFkRlVVQDSlXfk75sJSuv
         TjFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677573013;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aPR3wybdLDGQ751O+Ph+iKip/50WSjBMbLi5cBgGIUQ=;
        b=PMvFGRApXHeAfKZSn9OYbrgchin8P0YJeUqIPWneMWRsdMEx/+A94yU5ldAA3eDPB1
         kCJAF8SVTVZOpI1zk/aEdVMlHBLL3rbw2RSQ3xcQhnuNBnev+7hkwGQu4/e96QTne6IK
         8zaeAjqJfOa4A8D2hbN+FVQ2QbZaHMoMGqNf1GaLxdS2h9BTKAPAhbMiZj0450wg9IFP
         pjXVtlz1dyXmgDsbpiOM2eIKfafRm5Oe0Ps2Si2O1B/DHNEaspZxgogpDcdrUG0DmmGI
         GCkUlidCWN74Wq6u2mPHoYYrtc/a5g+2d7EoYHQJdVLaFOVqvMKbe7OX63GpkutfMGCz
         +IAA==
X-Gm-Message-State: AO0yUKXlc7wJrAFpsgGu3KswuPv1KwfjqsO86n0TVLRqlzdyKsBAQToV
        /v2m3Kwx6uaJ2Z6c3cdCEBSHxr1Tsk6v/Cbyd2I=
X-Google-Smtp-Source: AK7set9GG/mjuCeBJY/0gtPwb0uefYaHlJpM/4sEktkhtlAWOSxxZ/HNVELcIhuXpOO61EB1MEs4bXGPpRlW3ZxVI7k=
X-Received: by 2002:a2e:b5dc:0:b0:295:b0cd:522 with SMTP id
 g28-20020a2eb5dc000000b00295b0cd0522mr533747ljn.2.1677573012889; Tue, 28 Feb
 2023 00:30:12 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a9a:4387:0:b0:24f:361:322a with HTTP; Tue, 28 Feb 2023
 00:30:12 -0800 (PST)
Reply-To: leighhimworth1@gmail.com
From:   Leigh Himsworth <aishatuyarro07037820720@gmail.com>
Date:   Tue, 28 Feb 2023 16:30:12 +0800
Message-ID: <CAAPj31uYvNhS4dfJ8AzBgfvsvtNUikRo5e2j8ZLkpHO-mozb6g@mail.gmail.com>
Subject: =?UTF-8?B?T2zDoQ==?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        FROM_LOCAL_DIGITS,FROM_LOCAL_HEX,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:230 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FROM_LOCAL_DIGITS From: localpart has long digit sequence
        *  0.0 FROM_LOCAL_HEX From: localpart has long hexadecimal sequence
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [aishatuyarro07037820720[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [leighhimworth1[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [aishatuyarro07037820720[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ol=C3=A1,

Sou Leigh Himsworth, de Massachusetts, estou procurando investir um
ativo avaliado em US $ 350 milh=C3=B5es, no Astronaut Asteroid e em
qualquer outro projeto comercial lucrativo em seu pa=C3=ADs que possa gerar
nosso retorno esperado sobre o investimento.

Por favor, deixe-me saber se voc=C3=AA est=C3=A1 interessado para que possa=
mos
falar sobre isso com mais detalhes.

Cumprimentos.
Leigh Himsworth
