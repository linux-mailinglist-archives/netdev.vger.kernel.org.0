Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA9E46D3DC3
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 09:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbjDCHHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 03:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjDCHHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 03:07:24 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB305F9
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 00:07:21 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-54601d90118so378236577b3.12
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 00:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680505641;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r//wscmD6DqkDH7SDBc3decpjJkHCZvuOHM+LAwOwD8=;
        b=NWwMLizd615JthydMfZ+DwOeqOGN4fvCshvsVF2YTwCl8TwDnWchtVlLeykYkEtAei
         uM+7QVPRdeGY+x3JhUq8Gp5ZyjlJHJmpFIHPzgR6GirXY08v+g0FT97TGaZ8hHeRlf4Z
         EUgnoJz/ZpT+0yt9cBVqWZ/BW5o+etIKCPud/uNCPRCWoU8kp4JcAo0OFPZDIdKQivpc
         w66FHTats98drJnpQnzs52r9IGmeyY5BGGoWiwApE89thBxP8ukKUbQYFaowiSd5ohS/
         B/GEUfewVId1aQcR9Cv3w7efIHOaTO/EYx3CNSOKsPBBtcAIQz6v9k0WbPzbH2IjSMwy
         QPwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680505641;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r//wscmD6DqkDH7SDBc3decpjJkHCZvuOHM+LAwOwD8=;
        b=yV8xGY7pYSgIkeCFDW0gmVfupThSkRYCQ/yBVHDhDOu5CDIqoiMB9a/AGOiLYmyDZg
         BiRjEMfw3YwldHmWr0MUjaRacRZBDcS8Kp6XyXADWl/95sbM5xi/hT6fs/gccvNip2Ps
         lOWWWiUqEmFrKhfgScbzkPgahXAgcUbFmYPDsdcPxqZXv+RX3ysyTQw9IGGFYsfMd3A+
         9nRKTRFubvzWjpKMqBjbBt0MdWmEKzaPxeK2V5+QxRRpMmPlJg0H9JawXabqU3AqZXwx
         FST2DPf7MOEwUQ9S3lFxlVM97XjmzqJ1a4dWSo5z2eBaxZBwLIZ94A2xOFeuSXL4nLrU
         RMFg==
X-Gm-Message-State: AAQBX9fMXvzwhANvK2SS2oF92hbP5n6Ek62kgEV6GZ+eBz1NibnwGr53
        b+AmYpO6oNxz2U/GT+WiXVSDLXRdjeUCcXSHMaQ=
X-Google-Smtp-Source: AKy350bQAnH2TlEz/p51JrwrSFOHRpjrQaUATqrxtff/MVPmHsRBPZ8Lza5qb+c2wlR4l9wgA8pPEZSmWzhA9ezr27E=
X-Received: by 2002:a05:690c:727:b0:545:62c0:6226 with SMTP id
 bt7-20020a05690c072700b0054562c06226mr17679976ywb.6.1680505641022; Mon, 03
 Apr 2023 00:07:21 -0700 (PDT)
MIME-Version: 1.0
Sender: djamilaelhams@gmail.com
Received: by 2002:a05:7000:24c1:b0:499:f5db:2fb0 with HTTP; Mon, 3 Apr 2023
 00:07:20 -0700 (PDT)
From:   "Mrs. Rabi Juanni Marcus" <affasonrabi@gmail.com>
Date:   Mon, 3 Apr 2023 00:07:20 -0700
X-Google-Sender-Auth: -fexth5nkj__PXQQQhD4ilfr9l8
Message-ID: <CAG+mWz1rp1zjRkBO2ASGQyHtyFTeibMZfHzjQgY12xH6Np_mCA@mail.gmail.com>
Subject: WAITING FOR YOUR RESPONSE FOR MORE DISCUSSION.......
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,T_HK_NAME_FM_MR_MRS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello my beloved, good morning from here, how are you doing today? My
name is Mrs. Rabi Juanni Marcus, I have something very important that
i want to discuss with you.
