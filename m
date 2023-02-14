Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFFDC69616E
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 11:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbjBNKuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 05:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232698AbjBNKuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 05:50:12 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14947D96
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 02:49:35 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id n2so9974144pgb.2
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 02:49:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1676371772;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=eJUTbsdIDNX95V/oJFpC9RkiUx6gR3zHQ7/qS8TWsfyM2SybbiSmnqJksL7PcKhUh0
         S4QPS478JkJvvjm3B+ZYvbDwonE2er2ix2XRGapi/Y9wwdMbEHoBXzX6tDJAx/PCnVsP
         SgfP7nxMMzJRH7vWasfwCAfDKrTIj7UQ29HimALXB4toMKGx/VyI3n7g0uGcXZIuFSP7
         HgsTt164Iroml8Lrzg880hsTh0uWAUTDomz/7xIQNRRkrdCTDWgkoa0qZHeg5JpyE3qQ
         mD2IauZK/9bhPIe2TZ9VPhdmOyuBXRsZzSlNFgvxtff55bhUzxEOaO8bW8cyHBmZHP23
         Yb3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676371772;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=QH0aUOyKu/EEEb/uxgqzdW4ceXMPi1ic+wq9/obQPJLWdnXuChLtqfSQ9wfgYAtNRv
         vT9dW8tPGZySU80cmCEDelE1Pqhh5lHQPpdvzVa5HNXKSFD8uThuH+ySvU2NWTSdyOd3
         u8U0RFOQf94MR9yPt921khqN45OtIeApquoaQBJhE2aw3mcNtwtwmHEAyueGCD8vHZ8W
         YL2OuUw7Ih1LHqNL2zsw0YLVkKHj49XDIRLSQtPgpAZyfihtDaQcFCiKEp9Kc4z1nbZI
         LjimSfqE0xnuM5FWfUA37BKoV1AV6KcqjSTd6nXsWHG9yLK8D4qhWbiTMc/J3s6q6pLv
         wxig==
X-Gm-Message-State: AO0yUKXqew1VD0ckFm8m3L2y5xK7aT3/xaGzvh/UQnHTPj5Wk7B/yW6H
        yOFrNaGuG3+iWnBRRg3TgkMM0QOVTmozWvgp5XY=
X-Google-Smtp-Source: AK7set/ccIX3gEl0Z+ZrA/mBggg921g9VIdlU/AFiz1afzfyVBwJA3HoUQXIlEf9s7Czdi84IbwAcqvbnylApS/ijHs=
X-Received: by 2002:aa7:8e82:0:b0:5a8:7d65:c13d with SMTP id
 a2-20020aa78e82000000b005a87d65c13dmr363786pfr.39.1676371771749; Tue, 14 Feb
 2023 02:49:31 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a10:f2c4:b0:412:871b:c490 with HTTP; Tue, 14 Feb 2023
 02:49:31 -0800 (PST)
Reply-To: ava014708@gmail.com
From:   Dr Ava Smith <smith019a@gmail.com>
Date:   Tue, 14 Feb 2023 11:49:31 +0100
Message-ID: <CALZunAd82AEeNTw8CPPaiOTQ2xrjrV2c7mcTEf35NORK-eN3DQ@mail.gmail.com>
Subject: Hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello Dear,
how are you today?hope you are fine
My name is Dr Ava Smith ,Am an English and French nationalities.
I will give you pictures and more details about me as soon as i hear from you
Thanks
Ava
