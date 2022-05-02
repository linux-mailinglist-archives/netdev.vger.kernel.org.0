Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 202AC516F87
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 14:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233892AbiEBM1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 08:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233760AbiEBM1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 08:27:51 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFF5B85C
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 05:24:22 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id w187so25719222ybe.2
        for <netdev@vger.kernel.org>; Mon, 02 May 2022 05:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=gT0qunonoqmQDH3Sx35AGkd9jYv/vMqV6NEmgNMh3r8=;
        b=Bac2glqeKLtApRa9k3Bt1erT2bB5BXOkJNWyGnObm3uRVMmOOPZDe+FN70MBhQyTRV
         mZhYRfJpztqpHXPOzVVqN0mPKzj/atONki0DaOBVRpmyIX2nqWg6FkaHWA07EQVmQPbz
         xK1cV+YQzOG75WXYya4hlsD5ZaovnramFockINu3pnLRLbRh3YzfyVIHstrGHqtlaN6z
         oA+M8fhwQqe0N1q29kzQC8nmRwWz8PC4RKQbDbWKrItx/9aoz7jVek4ii4j5uNCUTs4H
         dU7PhfvJzwc2VvbmlXYJAxRO5lKVtGE7Co72tiQYa8JDBanZ2cGS2o3KaQsQkjupe2T1
         ESMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=gT0qunonoqmQDH3Sx35AGkd9jYv/vMqV6NEmgNMh3r8=;
        b=HHYy7O0rzW+w/shCBTnpZEDVnzTh2nb8ONa/XJI84O6r3srMdc7/0Ms55CUZT6PpwH
         9y/mH2jS3re0qCquF6NjOUCPOcNOmteThGfSLmnx5qbA2GGZed//jOYkILMT7JmBMnGq
         u50WWF5j5DfSmdi5WQMk9hgZ54pQEUa+ZRQ28O/NJVs3Jd3uNK0GnIoF6hjmjoTs7Y6y
         WcDd106Nma/xI1hbHT4+jJjpXiCayIje4H4KQ/9yqyfynkjJJ+8FQDlRnuxYntLQXMTr
         zU1tdOL2OhbNAQ9fb39NnRTK3ZAIQIWQ3mwPFKW3aVnd1VLbDSUutCo6A8izxUFPMvUY
         bKoQ==
X-Gm-Message-State: AOAM532RStOTDxBKrLZMbcvuv/Ri5OtA6qIPxWA3YRkb++QRAvBanlW1
        skLZaowTjpHX9NyBO2y85dGh2ghlCFHmd+CU7C4=
X-Google-Smtp-Source: ABdhPJyEHqNFna2IvV8H5YDHQEwwq35p7EoUCLKA1NyW1WLOycmujEHI3v2hqjyZ6NFZxkc4zV8JJF1mDKqSgdb+XB0=
X-Received: by 2002:a5b:603:0:b0:648:507a:b9f8 with SMTP id
 d3-20020a5b0603000000b00648507ab9f8mr9691319ybq.497.1651494261338; Mon, 02
 May 2022 05:24:21 -0700 (PDT)
MIME-Version: 1.0
Reply-To: nafi177z@hotmail.com
Sender: haman1zakaraya2015@gmail.com
Received: by 2002:a05:7010:45c5:b0:28b:99ed:bd86 with HTTP; Mon, 2 May 2022
 05:24:20 -0700 (PDT)
From:   Ms Nafisa Zongo <msnafisazongo@gmail.com>
Date:   Mon, 2 May 2022 05:24:20 -0700
X-Google-Sender-Auth: cuRQ-UxUyRI8Mp2NgBxybubkXXs
Message-ID: <CALXn+=WTkn5LM9cOeV6AN4y1=GvBByQdbpDtKMW-a5XEH8fTHQ@mail.gmail.com>
Subject: RE.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b29 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4998]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [msnafisazongo[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [haman1zakaraya2015[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I seek for your partnership in a transaction business which you will
be communicated in details upon response.

Best regards
Ms. Nafisa.
