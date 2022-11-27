Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF79C639D03
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 21:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiK0Uuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 15:50:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiK0Uua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 15:50:30 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02955FCD8
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 12:50:10 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id j16so14536007lfe.12
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 12:50:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:mime-version:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=biw1utCmNyI+ef9futimPqL2qrgw3YwY9eWMD1oBQZg=;
        b=HKQEkVMbOPjTNjDcZXOlPScsv1e/bmf51vb+pHgsXq4jAv/A1TTxtf+oE68sPjBXNY
         KcemqalfUGB8H+BVAei8q075lRGB4GAQWQLC5c8cijCFN5B1OrMSDDL1ZLDC6JA8CpHW
         C445lKXMZARVgd/FtYF/yqTByE5QbDPFJ5qfS8ROzH6hAhPnLsuguMj0Npux5bCFZwCV
         o4ZB3w6KAZUTcHRyAuTEbyWFKQbQiHSe8OxrWIGxdEur7CNYR1D5lsRTyFzVDoTQieuY
         L7XCaPnuVvDoiQJXncSHxFITMAjqZ61EwLDO/eKV0o8zR1rnuIOARY9nTyTv/nfltTMf
         cE4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:mime-version:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=biw1utCmNyI+ef9futimPqL2qrgw3YwY9eWMD1oBQZg=;
        b=ePLck4wIMUiD2Y0URzgN+ooGuEMyXb3tF2TqKEysZPEb/qSwbmnaSYlaB19OtDKXtW
         PuVC0DehFUofx0ttLCe6ARM6wDTJ3LYzUiEt4PDEAW1j+o4ZhWnFFGvdaktMNP5ML8ZC
         IEaS4vpFk73vpWSJSqQZb2QcJbKLt6n4BB8Sbcaf/GFn84fzuZGltgjCoKSfMyo/JGCP
         T6b3ezSuimZL/J+0PmNgPA+5Yym+1qP11RloubprYDTT+7LXJeHkiZ38E7NpBqg1PmNS
         TrQWTWeAdJwL2AP1888ersY5ri5qdM5YxDYYUAZb39JdL34nbqUhXT8+kKvrzDeHI6Ln
         VcQA==
X-Gm-Message-State: ANoB5pnt2LOxxR1cAq+rl5pCjF7P4/BZwx8/64kPYde+im99keUOS5+y
        AbauJYp+EJjgQUP3iquyxiFGTBO21O1ZdLmscKDbYHazhqPvaw==
X-Google-Smtp-Source: AA0mqf4rrk3FBGN3QZWocR22ti5lbcdulvUYfBtwSx0cak7o2yAvXASPGOaVTjhTZfcUFFQSx2KsjYdoto+oZoyP+LQ=
X-Received: by 2002:a05:6512:340b:b0:4a2:5897:2b44 with SMTP id
 i11-20020a056512340b00b004a258972b44mr17879773lfr.431.1669582209018; Sun, 27
 Nov 2022 12:50:09 -0800 (PST)
Received: from 332509754669 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 27 Nov 2022 12:50:08 -0800
From:   RICHARD EDWARD <richardeddward@gmail.com>
Mime-Version: 1.0
Date:   Sun, 27 Nov 2022 12:50:08 -0800
Message-ID: <CAGpQqipkxBv_NYG2gVBOUTHWco5nFXFNz_1jNPBw40e022HydQ@mail.gmail.com>
Subject: HARD HAT
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To whom it may concern,
I would like to order HARD HAT . I would be glad if you could email me
back with the types and pricing you carry at the moment .

Regards ,
Mr HAROLD COOPER
PH: 813 750 7707
