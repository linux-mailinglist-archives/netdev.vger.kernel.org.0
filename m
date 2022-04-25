Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C57BC50DD87
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 12:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241455AbiDYKFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 06:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240774AbiDYKFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 06:05:05 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5A11DA57
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 03:01:59 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id f5so8991575ilj.13
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 03:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=s9IGPqOTuFEFxKMxMPq1P/MfyJrhGXNasZNiCUUGkGw=;
        b=mfBSgqpd258gF/mDojQzkT92K/mdXCE9sxCrM4yGMa5NNZaRDqi4FOAqQYgP216hoa
         L8E1lPC3exK4kwdHjIFo3BUavOCN7CBGikPk5WKZkv6z4dfxegrkWJHHWSZJ7A3Q1xPF
         tj3bRROUNbbOk51qGiEtYFE35AA0q432NEUiDpOT4+lUw888DpKYsK4a9K4wkA0ZVeh3
         64GvETBjjmhn6TAI77s9pBnwLKOYOib6zO3AiVMSA5HWVCe4nTlNbdb7voL6MGnpLilx
         FXHT2d9ysOL3NUsTziLCust4KH+XrKeMkvtS9aKXv7rdNNSbCmfE9aNTaYZLcSwvsnQr
         QThw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=s9IGPqOTuFEFxKMxMPq1P/MfyJrhGXNasZNiCUUGkGw=;
        b=ZVk7puzvu8OUoSq26v4Rp1yY0FdLqWjQZ1Xa5gdumEb2c4XAuqQOzYYNMGLysMhbOk
         j9z6OSZr7ZEDFF0lrdGBaSeCseaP8k1YQSFOly2ylFA9yCiskj+4hTgxRrawXL39kswc
         /d3CQtSOHsC2fadOf3Ua5tW5MPN3uY403tGZQ2te7YZXEjNo9jPCaLO5GNBg3FUx72FT
         3b7ewNRZ6NQrnc6pK86BLjQm2GbP305v1APwRJ3Vpv4XuIUL+aJweFgqHft6baARNaaf
         gwsjIxuIJy1M0rDB8mRnJDY/DczrfuIij5/q6xybwYt5oizRQuOA1LO+zLi//fycfcpr
         YkAw==
X-Gm-Message-State: AOAM532t5EqJYQGm3FOuU0F9MJ0fpL7X6/hTxVrQwmqHa0NwMEhTHQBS
        yl0PDN8pfKEZxsFUzt6ww/P0FYlQT4WwGOf4LxM=
X-Google-Smtp-Source: ABdhPJzwVinA8gg1OKj5Gh+bs6RL9MQYbbjpa8oWWLTYS1AYSEhdNuLrySNEFZFMWPpbqcY2N/ODUf5bRyPE6gphHHg=
X-Received: by 2002:a92:d01:0:b0:2c5:daa4:77e0 with SMTP id
 1-20020a920d01000000b002c5daa477e0mr6730625iln.154.1650880918783; Mon, 25 Apr
 2022 03:01:58 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a4f:cf93:0:0:0:0:0 with HTTP; Mon, 25 Apr 2022 03:01:58
 -0700 (PDT)
Reply-To: lawrencetansanco.y@gmail.com
From:   Lawrence Tansanco <lt01102204@gmail.com>
Date:   Mon, 25 Apr 2022 10:01:58 +0000
Message-ID: <CAFdNJhhVjGD5dkL1=+JV9kyyPwgdtOskrqSbv6+w5pdaVOnHYA@mail.gmail.com>
Subject: THANKS FOR YOUR RESPONSE AND GOD BLESS
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,SUBJ_ALL_CAPS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:144 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4643]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [lt01102204[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [lt01102204[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  3.6 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

.
I will like to disclose something very important to you,
get back for more details please.

Regards.
Mr Lawrence Tansanco Y.
