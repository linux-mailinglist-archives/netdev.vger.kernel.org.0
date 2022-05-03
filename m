Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B610951879D
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 16:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237617AbiECPDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 11:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237531AbiECPDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 11:03:19 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D338C3980E
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 07:59:46 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id a14-20020a7bc1ce000000b00393fb52a386so1547449wmj.1
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 07:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=PmuVHgQTGSW4pBgLHyr3r3J1G7KlM6k/vY2ryTt9UVA=;
        b=jbuqLxdM8ITEWEquTm0MZ04ST0VVWQAVW3NNLA4YiENAq+ehQzCsgjOP3Tu0pzXfEU
         zhwNWomj0mOLKVMOyezMc8XXhHXo9SAJ/4+9vtZn4eYoJ8lffhMwT0IB9hiabTDv170Y
         UFBDuxno3Bi4hdzoFfV/OanYRXlKmOvo4reG8tiLb/Mvn1GeOY5xudXNBSu5lXlSrZHT
         20u36eqFdru0jIP65W3yfhwPD/bIiNVYospwOS+NNX7+/BqK9lsolrvfzCEojcyvmQ/O
         ovBYb6s+tc4d3NHAPuoVC/Epd+G3g/XysV7FazFDVUROQlNFiri/ygrU8Xz0e/F5SWs9
         9UKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=PmuVHgQTGSW4pBgLHyr3r3J1G7KlM6k/vY2ryTt9UVA=;
        b=TLwZhhplRLif37/yr7Xx0OFfysb/vcZfF3K73HDAEcAA/rcfeWrig5QlxFHNZ5oGPH
         GR99MTMA+cnWkx6GDNYdvO/VDGALwGME25IoXKg4ALStZGKwAvmgI44PHP2wGuQDKaiZ
         njnllveSFfUPoZx1VVcPf1+0TPxbVsEWFkqyLwZ/LqVEh5MvPfRD7EXt6fjNKD75riF6
         lU4LVHsLU+i9OcSyZborvsGxC93r5J1iy4Y/8LmpJwlF9XswVGpqfoKguP3bPoqTJWI4
         FLPqmI87O3ms4ARzbJSfh3ubWyQLwhWgN/xwqU5C+yOlrT1c0L0/sQEiTWZmEpObsel+
         tHmA==
X-Gm-Message-State: AOAM530gL/WCcKShH2hfG7sURrw6hhKd30DxIED6NT+w7uoLBpEsxeA+
        PZRLH3sp4f9QTzc8tvMuBf80DyxfQwmmIIvJ7SQ=
X-Google-Smtp-Source: ABdhPJwaM2meOxZ3i5tx3ygNa23fV0/kwO+/XE6Hv+fJYvA3hfD9wFLAP+BoOkoPkrPMdx57j4pHr9YeLXO9qolag4k=
X-Received: by 2002:a7b:c341:0:b0:37b:ed90:7dad with SMTP id
 l1-20020a7bc341000000b0037bed907dadmr3704622wmj.138.1651589985292; Tue, 03
 May 2022 07:59:45 -0700 (PDT)
MIME-Version: 1.0
Reply-To: dr.zeida.chedsworth@gmail.com
Sender: drjackrufon@gmail.com
Received: by 2002:a5d:56cc:0:0:0:0:0 with HTTP; Tue, 3 May 2022 07:59:44 -0700 (PDT)
From:   Dr Zeida Chedsworth <dr.zeida.chedsworth@gmail.com>
Date:   Tue, 3 May 2022 07:59:44 -0700
X-Google-Sender-Auth: VcBtGQ48ao-YXJKb8lKM5MaRBJg
Message-ID: <CAJqTYvg58SgB4+RpWfHnHzoU4hQnekfND5rBNEGUCsftTzSv0w@mail.gmail.com>
Subject: Good Friend,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good Friend,

I have a client who has indicated interest in investing overseas. He
also intends to partner with anyone with a good knowledge of business
in the country of the investment who shall act as the Managing partner
as he may not be able to relocate out of his country at the moment to
manage the business because he holds a political appointment with the
government. Please, if you're interested, reply for further
discussions. Contact the director here for more explanation Regards
Management,

Dr Zeida Chedsworth,
