Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B607C6E8646
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 02:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjDTAUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 20:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjDTAUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 20:20:01 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C4D1738
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 17:20:00 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id b16so2588840ejz.3
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 17:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681949998; x=1684541998;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Hqz9HeI/vJVNk82x8juGc4PpO/MP0d9td2E9snrpgyw=;
        b=MfE/e7hRpqGwQXA37QTXcM47HVrJ/My1Kncr9LOD3IOh0xdwtowwVnLDP5Or+N6irz
         zZ3aW/kniZcCMj4S8xOHbstUsXd7vQdVM19lWF/D2vp44uZj1d/RSfSPdNoysUEw8ml9
         tcwm/BKbt6b2QgCZ1cqdZqApi6NBhXUsaRlWGlbKhHzobdzW/Z8ynZlYk2txOIzBNjto
         hygMBe+nC/0gQKg/rifki2ecDkka8+qjyhV5zuXf5ZzIfN6i24ujE2AA01hqEcg2FnCg
         k3qS6CmvY0QLTQ5wJIkCoyZ2UpOsiQuL/SSYxizJRuhwk0kHceIalk/fCPicRNmg1MFO
         QiQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681949998; x=1684541998;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Hqz9HeI/vJVNk82x8juGc4PpO/MP0d9td2E9snrpgyw=;
        b=DHiBMBAAtxDP9yO8HjZBGU/jQAQt6z7MfuoScnKGMvDcs4+avxU0/5ojYHhzMz14Si
         J0t24T2gZFp5RfrQba7ZEIDteJ9fLNln+30OrsEmiQYYU38OJLLPAXXQJqmu4MMAA4mV
         KRrin1zUM5xeu/PcBtNdXeCwsKaDAH1Lwge6x2nm74wIcYLMmox+h1S/EM5fCmwe+yMl
         1CnxdQ6NVTDCNmk1ZHaXsBCGoPTQzSKKYycscHymgGwJ5aGptH/TYnaQBvAsHo+Qag21
         G92JHHU6VIvGFEI+f78lJxWGymsuVsNWONmK4V/VhFMpk0X9WA1pt3aua/O1wY4kCcX/
         FjnQ==
X-Gm-Message-State: AAQBX9c7PvkUNeUEsOkylD6U60Z04LpnHWGscaaKNcVM/v5pqNxeVDAp
        Biz2qa+KjbFkmaJs5P3wiBK3gnY/I6y2Bxg/zvY=
X-Google-Smtp-Source: AKy350Z4a1sDyWXJoDbzLisqUdTmzNrjYT6a8n5c/rD4qw4YByUgaeybHwCH1CAfKwGRAwpI4VWV5lL00RpeipPKop0=
X-Received: by 2002:a17:907:3f0a:b0:94f:3eca:ab05 with SMTP id
 hq10-20020a1709073f0a00b0094f3ecaab05mr17477498ejc.59.1681949998275; Wed, 19
 Apr 2023 17:19:58 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:907:6295:b0:8e1:534d:ec2d with HTTP; Wed, 19 Apr 2023
 17:19:57 -0700 (PDT)
From:   Federal Inland Revenue Service <inlandservice@gmail.com>
Date:   Wed, 19 Apr 2023 17:19:57 -0700
Message-ID: <CAMWbD51cK4XPCNQpQZaLP-GHXORKA6o4FScN+ZwXMMHpOkiAAg@mail.gmail.com>
Subject: Good Business Proposal.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.1 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_00,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_MONEY_PERCENT,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

STRICTLY CONFIDENTIAL

TRANSFER OF US$35,500.000.00

We are making this contact with you after satisfactory information
gathered from the Nigerian Chamber of Commerce. Based on this, we are
convinced that you will provide us with a solution to effect
remittance of the sum of $35,500.000.00 resulting from over costing of
job/services done for the Nigerian National Petroleum Corporation
(NNPC), by foreign companies.

We are top officials of NNPC. We evaluate and secure approvals for
payment of contracts executed for NNPC. We have tactfully raised
values to a foreign company for onward disbursement among ourselves
the Director of Accounts/Finance and Director of Audit. This
transaction is 100% safe. We are seeking your assistance and
permission to remit this amount into your account.

We have agreed to give you 25% of the total value, while our share
will be70%. The remaining 5% will be used as refund by both sides to
off set the cost that must be incurred in the areas of public
relations, engaging of legal practitioner as attorney, taxation and
other incidentals in the course of securing the legitimate release of
the fund into your account.

Please indicate your acceptance to carry out this transaction urgently
on receipt of this letter. I shall in turn inform you of the
modalities for a formal application to secure the necessary approvals
for the immediate legitimate release of this fund into your account.

Please understand that this transaction must be held in absolute
privacy and confidentiality.Please respond if you are

interested through my alternative address:


Thanks for your co-operations.


Yours faithfully,
Mr.Lambert Gwazo.
