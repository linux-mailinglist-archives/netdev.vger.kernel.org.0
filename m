Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24F253858B
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 17:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240480AbiE3PxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 11:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240814AbiE3Pw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 11:52:58 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B4F39B81
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 08:27:42 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id c62so11103531vsc.10
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 08:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=XJqXgw0Qi4Ge6Q57wB4GlvotoYnhUuSq68y9152a6AE=;
        b=f7tkYIe5oUSQDB76VXHhDSO9RACMSxKzd0pTTD3f6/11lS6I9Xz09z4dAry5Qkk27K
         DrUQanitJX4Mbaq3+Qr8Y6cDpJ472vgU/jlCkoBvCrekF1tVjoKh5l4ZSpLI8JvSAOG8
         ll6og9LXE8oe+RDj2ZqPgg/fgk8EsJdBGVinwat+wUi9C7698p6QPoUN6tZOT5+WHrS4
         zcq1kLz7mnks1cHHdxq8cO42F/IM7nc18cIqNrZtvz0qEoc2cNM+c6qqeMrbl9UDkgL+
         FhMRoQqTieg6fpGGlaIpl8iy1MxVv3xqA+gnN4TiI5Slpq6NTg+yXPGn+0EYLYQuhEx/
         gRiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=XJqXgw0Qi4Ge6Q57wB4GlvotoYnhUuSq68y9152a6AE=;
        b=KrAgvXLYNVuh47sgZAjBiPxgK7kSDCAd7Iko/PFB5xoVjY5KJu3/TPlFigMN2FdTi+
         FmYQqtodM6amn88AeH+VeouADIwoci5s7kkxskjU+ZvBES492hUbUbIdt9LJ1q44HmVH
         wyW7D0R/BTRC7zOdx+hzwfwVCkl7ClY1TBlliGzJ7tuMpF3Ne414GaAs5vhdw9bKCYsg
         H6HksRnIhYM5XPxu06VaSk1cNzakd4gMjLXMhWixurRRYNFQjXeQFDofxHua6Kv1Kuhu
         kRBwZluJOx8OoGux9VJLHnWrCZwpSMpvcwhuVnHQba8RdyJLa+fb4Q2e3EpfsNY9S/e6
         ri7Q==
X-Gm-Message-State: AOAM533f9y6RR3DD0/iOyP8CFpBDux/d0H2qjLYt9njrj9AQohMNioM+
        9mj6UH3Z7ZC6YdxRoiMBcYoI0fLKykkJPKRsK3I=
X-Google-Smtp-Source: ABdhPJx3kSfzcD9Cf12H/E70WINc54f/2y6Lib5P+22ET1+sQvwUYWi3LBqWrCxfBsIQVIVH4IugEI14ElDUyps4ubk=
X-Received: by 2002:a05:6102:38d4:b0:337:a198:2fe9 with SMTP id
 k20-20020a05610238d400b00337a1982fe9mr17015379vst.83.1653924461733; Mon, 30
 May 2022 08:27:41 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a59:c94c:0:b0:2a8:7408:9cd2 with HTTP; Mon, 30 May 2022
 08:27:41 -0700 (PDT)
Reply-To: barristerbenjamin221@gmail.com
From:   Attorney Amadou <djatodes@gmail.com>
Date:   Mon, 30 May 2022 08:27:41 -0700
Message-ID: <CAN_5zZh8rYJgcHLLUrOMT27Q4be6MEo7LefJKkuSLFA81g8_SQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:e30 listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.7506]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [djatodes[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [barristerbenjamin221[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8gZGVhciBmcmllbmQuDQoNClBsZWFzZSBJIHdpbGwgbG92ZSB0byBkaXNjdXNzIHNvbWV0
aGluZyB2ZXJ5IGltcG9ydGFudCB3aXRoIHlvdSwgSQ0Kd2lsbCBhcHByZWNpYXRlIGl0IGlmIHlv
dSBncmFudCBtZSBhdWRpZW5jZS4NCg0KU2luY2VyZWx5Lg0KQmFycmlzdGVyIEFtYWRvdSBCZW5q
YW1pbiBFc3EuDQouLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4NCuimquaEm+OB
quOCi+WPi+S6uuOAgeOBk+OCk+OBq+OBoeOBr+OAgg0KDQrnp4Hjga/jgYLjgarjgZ/jgajpnZ7l
uLjjgavph43opoHjgarjgZPjgajjgavjgaTjgYTjgaboqbHjgZflkIjjgYbjga7jgYzlpKflpb3j
gY3jgafjgZnjgIHjgYLjgarjgZ/jgYznp4HjgavogbTooYbjgpLkuI7jgYjjgabjgY/jgozjgozj
gbDnp4Hjga/jgZ3jgozjgpLmhJ/orJ3jgZfjgb7jgZnjgIINCg0K5b+D44GL44KJ44CCDQrjg5Dj
g6rjgrnjgr/jg7zjgqLjg57jg4njgqXjg5njg7Pjgrjjg6Pjg5/jg7NFc3HjgIINCg==
