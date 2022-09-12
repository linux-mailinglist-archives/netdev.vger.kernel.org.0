Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFF445B5912
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 13:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbiILLO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 07:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiILLOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 07:14:52 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DAE1B873
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 04:14:51 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id d189so12145979ybh.12
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 04:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=TymCxQQ+NVflZl4xQoGZgTrsDTCgU8yD3y9uspVMxUE=;
        b=ShhLLCbOMwV3NLgej9myTt6dnfq4NvdftU4QB9t3JthyhQvy8sAQ+fi/rCgd3I5VNe
         cv+9h/g3svKEQPsh2ltHZTM2dVumkx0qEg2ZxSf6eYUMOCfFqLfUI4BKgDwg3uA8y+sH
         lg9pGaPdbW0bmnZZJn9BMT5ll9sYV3Fj8QW1ZpHpcwJfQt4paHFp0V9fDZDwS3h7wlcJ
         fHJ9mpHuyw9IHIvd4qGF8sLb+kTnwraJ/uew17OB5L300i76slBVkGyqNe3ZPZPnRuFp
         +jVDWdKcolSHP1JnuzqU4ZN2miQMPoqqIeM+KQn5Y+P474S2KuyeUrBvIuQSDAAX35r1
         z/9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=TymCxQQ+NVflZl4xQoGZgTrsDTCgU8yD3y9uspVMxUE=;
        b=SsC1AMk8GaTfLurxLv7LhEScV8EExyGyl81exVfr3rTgv1pBJCVRwFrNK5PefnHgh8
         qOincLxW0z0sVXsDjjtt3dg6k8Gb24ehFaI334nrJy4sgi5II7lYNfj7Hw0jOFzSUgGq
         8RkdFKIwSZu//lFSeGGfFhZteue8LEgw5FCi4aSkXXgFXGKfbou/eRAEdPgF6hSkbdlL
         N6O2beZnUcwb8qNY7BvSrfGcz9SXo8hz60XlyxlhUmxyIF/erG6jvIAZ5MFV764SdbC5
         KpkBHbvy//B4bpKtfONCZJfvqzRwDxhZQdWUMR2IPnd6wIH22FyxNMv7b1x9ynYfWzHL
         ZcFA==
X-Gm-Message-State: ACgBeo19Iv34pN/J9+pTyOLh0qP8WudHm1Tw11Q1sg6oMpM1d9Mzffq8
        TiKL5+8IFQ3wRvf1XxSAcgqnoQfvVIL1uHcE/8o=
X-Google-Smtp-Source: AA6agR7jHDzM/pUi+kB2UW653RDorZTb1Vx6KGcI/jxvtDi7uK4G+20OWLvrJLeIlxZF14yYROTar5BN4UoDFRVBG3g=
X-Received: by 2002:a25:e485:0:b0:694:a701:c557 with SMTP id
 b127-20020a25e485000000b00694a701c557mr21109832ybh.243.1662981290033; Mon, 12
 Sep 2022 04:14:50 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7010:8f05:b0:2ee:cf83:94d7 with HTTP; Mon, 12 Sep 2022
 04:14:49 -0700 (PDT)
Reply-To: fredrich.david.mail@gmail.com
From:   Mr Fredrich David <nonyenora@gmail.com>
Date:   Mon, 12 Sep 2022 11:14:49 +0000
Message-ID: <CAOfyiR1UswqtW3=eggSpCuvP1yJ5BqXUjiVG2-QLTvbSKm5nNA@mail.gmail.com>
Subject: 4e3324
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-En in de reactie op uw e-mails, schrijf ik om u te informeren dat de
projecten zijn voltooid en dat u bent goedgekeurd!
Vriendelijke groeten,
De heer Fredrich David
