Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D19B58CF31
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 22:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244400AbiHHUdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 16:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235732AbiHHUda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 16:33:30 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444C31A824
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 13:33:30 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id dc19so18601015ejb.12
        for <netdev@vger.kernel.org>; Mon, 08 Aug 2022 13:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=ikbF0iB+mR8rkojYdMvfCJcBBEu5KuBLkj29sDf0d0Uh96bploc+mTm+8I8eEw00oc
         YqpbD3EARYbdo80iQ3xavC1CrsaDI+gv/5tbn6v6jlpRKj3bGi9MFY4M/Sn8mrUCKtoY
         VT+shGZR08xF8m3xVgYWB3a4lvtKJQryKMBv0jD9PTcL0s7S1dF1Y0pPcWCW8vdgF74L
         b7yRhaMCkDqvyqjEKVaPah7EQDCCeg1yckjYi4yK9inJtxN4JIOsgW/qPqOqAD2bCiEF
         bRBoXWH8MO4gSxA36Qhn7vPYX37y8GUew8A7mmBkXPDiE71UkVpXaf4ESwEWAn0IuAlA
         9yug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=7SWLHEKRhnLosrK3zhgch/HG3ii2v13yU4+r9lHmiqtRWr3QmeoEKuuevZayEhlaKI
         qsEYQJVILUhUxVPAAp60kiG4PN3RWZqpFxuOXjRnuOm5N3EO44SmWnUsLw/iqd9w7g7U
         cK24/jY+xWktATcydINA6JnL5GFpL9M7GAH0NS7DSQdZbrwmVsKwGrPs9xDPPjqm3aMv
         td7qm/vY4XANxEfpHy+JGlXA1dVpASJ6OXcXzzqg/xXKGIVF4MI8HYwsbws1mzSwTJmB
         r2MOPlvblRvKjXcmEXwlYTyI46iUDb9ZL+qn4JI5tLDJbg7mCHHMXTvCz4fvhg6QUtUC
         2Psg==
X-Gm-Message-State: ACgBeo23Ch4zy42K/AZvxg6NdSvWw92DtCzcGCPdov1UEU7eJi54AW4c
        URhSQdLWETih3/gVd6rIc1tpEUphwn6Yfq4yotQ=
X-Google-Smtp-Source: AA6agR5E5MQ+UiAYwCdsCQ0qVHill03EIvq4khBU6uHT5kgIG1VcdibVWpsu5EEGp54H90RBM26UCw/xP9isdsrxtDw=
X-Received: by 2002:a17:907:7601:b0:730:ab07:6d6c with SMTP id
 jx1-20020a170907760100b00730ab076d6cmr13912360ejc.139.1659990808754; Mon, 08
 Aug 2022 13:33:28 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:58d0:0:0:0:0 with HTTP; Mon, 8 Aug 2022 13:33:28
 -0700 (PDT)
From:   "Demirkol M. Sadik" <demirkol.m.sadik@gmail.com>
Date:   Mon, 8 Aug 2022 21:33:28 +0100
Message-ID: <CAGhyw-RUPCFzobp_6wpwTP4JVrTcOT0q3K3e+kkS9j_vEVBdjQ@mail.gmail.com>
Subject: Please I was wondering if you got chance to review my previous email.
 Thank you.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


