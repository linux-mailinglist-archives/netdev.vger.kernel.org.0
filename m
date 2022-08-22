Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE5459BBC5
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 10:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbiHVIiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 04:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233125AbiHVIiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 04:38:16 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55143B0E
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 01:38:15 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id a15so7344355qko.4
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 01:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc;
        bh=lSgQ+C33H7jMVVVjAP0XsD0Vcuw4E2zmQBpJbTssXTs=;
        b=XaBiDcDuR7JB881a3lFw3WatOxxB9GtDPbxoF8uHseFoYng+OFAhGcRikdOzA2GUDA
         0ZT+kEWGH/fEm2gvt3gMFh/QxGnJ8CPUs9JFZWSz4feup2NLIK59hxIWhn8m/0HR4pv0
         p4l66ilT113Pk0o7cceIG/Pw4HzCIQ5phA4nzcOhY7LlQ7EnRjBFZGqQAk6885v9Mu4E
         8GJerGiterV7HHASP8rZlKrcUuLkmVlvhE7H0EZmtNkO0cqtuq3YZGIC8ycXytaGQ8RS
         34a/MpqyX8tX2uqTNepI7bFJL+ReT7KFEnh8fNXtANfb3vorxm1Y1WH3rju9Bhz1OTf1
         bfuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc;
        bh=lSgQ+C33H7jMVVVjAP0XsD0Vcuw4E2zmQBpJbTssXTs=;
        b=zStjxMvvAulciHiQj8ACVO3Mn65xvSMLBaXVXpYsVI8c0WR4yhhneyqKQ5C2RRLPtR
         qPprZ9D7fatYaLrhG7wjHJl2Vdi/ZTkloM2eoLmWOVZtH+ROE0r4rwbzwl82wa5HskL+
         NDXil7aqVDt5HxLCTle3ZGYfcuuRchgieF2lDbsWiv2pWhXvgzCZxAJ75uZ9MX9w7QvL
         +Ci/wheh4MBSLyFEY44DQVr4N22LN+QQe55WqVASpBe6xhRPO6hSrnEWg7eIh2VwGM9X
         NeN5fF1wiviYy+k6UboZ0S1lpRKXOWufol0pT+3qhmXGCdLQqa3AUDzZ3Y1Ip8qEqQZ9
         1jXw==
X-Gm-Message-State: ACgBeo2/jNOlBI0e5PkGdPE6PBnPDQ3Nda5UK13agDQ0CF8dKYIjSiXD
        2HnBPBOocg2Bc4qfVgyH+ewICpDo0YqkeK+bpHc=
X-Google-Smtp-Source: AA6agR7hXAqELQz2SyCEfjuNA7MjiBj1MTorm1vqi0AdpINT1TttJrujD8ycGOmcl85QVe5KQc445vruykftkoc1bsE=
X-Received: by 2002:a37:6905:0:b0:6bb:5827:e658 with SMTP id
 e5-20020a376905000000b006bb5827e658mr12198269qkc.735.1661157494380; Mon, 22
 Aug 2022 01:38:14 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6200:5e89:b0:46b:a78:b506 with HTTP; Mon, 22 Aug 2022
 01:38:13 -0700 (PDT)
Reply-To: jon768266@gmail.com
From:   johnson <novelav950@gmail.com>
Date:   Mon, 22 Aug 2022 08:38:13 +0000
Message-ID: <CAPCDeFJXW1TXHkhW3QoYkLGsUbDd2pnzEiZitujjyNwm3xiOuQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2YrZiNmFINis2YrYr9iMDQoNCiDYo9mG2Kcg2KfZhNiz2YrYryDYo9mI2LHZhNin2YbYr9mIINmF
2YjYsdmK2LMg2Iwg2YPZitmBINit2KfZhNmDINiMINij2KrZhdmG2Ykg2KPZhiDYqtmD2YjZhiDY
qNiu2YrYsSDZiNio2LXYrdipINis2YrYr9ip2J8g2YfYsNinINmH2YgNCtmE2KXYqNmE2KfYutmD
INij2YbZhtmKINmC2K8g2KPYqtmF2YXYqiDYp9mE2YXYudin2YXZhNipINio2YbYrNin2K0g2YXY
uQ0K2KjZhdiz2KfYudiv2Kkg2LTYsdmK2YMg2KzYr9mK2K8g2YXZhiDYp9mE2YfZhtivINmI2KfZ
hNii2YYg2KrZhSDYqtit2YjZitmEINin2YTYo9mF2YjYp9mEINil2YTZiSDYrdiz2KfYqNmHINin
2YTZhdi12LHZgdmKINiMDQoNCg0K2YHZiiDYuti22YjZhiDYsNmE2YMg2Iwg2YLYsdix2Kog2KPZ
hiDYo9i52YjYttmDINio2YXYqNmE2LogMi41MC4wMDAuMDAg2K/ZiNmE2KfYsQ0KKNmF2KfYptiq
2KfZhiDZiNiu2YXYs9mI2YYg2KPZhNmBINiv2YjZhNin2LEg2KPZhdix2YrZg9mKINmB2YLYtykg
2KjYs9io2Kgg2KzZh9mI2K/ZgyDYp9mE2LPYp9io2YLYqSDYjA0K2LnZhNmJINin2YTYsdi62YUg
2YXZhiDYo9mG2YMg2K7Zitio2Kog2LjZhtmKINi52YTZiSDYt9mI2YQg2KfZhNiu2LcuINmE2YPZ
hiDZhdi5INiw2YTZgyDYo9mG2Kcg2LPYudmK2K8g2YTZhNi62KfZitipDQrZhNil2YbZh9in2KEg
2KfZhNi12YHZgtipINio2YbYrNin2K0g2K/ZiNmGINij2Yog2YXYtNmD2YTYqSDZiNiw2KfZgw0K
2YfZiCDYp9mE2LPYqNioINmB2Yog2KPZhtmG2Yog2YLYsdix2Kog2KrYudmI2YrYttmDINio2YXY
qNmE2LoNCjIuNTAuMDAwLjAwINiv2YjZhNin2LEg2K3YqtmJINiq2LTYp9ix2YPZhtmKINin2YTZ
gdix2K3YqS4NCg0K2KPZhti12K3ZgyDYqNin2YTYp9iq2LXYp9mEINio2LPZg9ix2KrZitix2KrZ
iiDZhNmE2K3YtdmI2YQg2LnZhNmJINio2LfYp9mC2Kkg2LXYsdin2YEg2KLZhNmKINio2YLZitmF
2KkgMi41MC4wMDAuMDAg2K/ZiNmE2KfYsQ0K2KfYrdiq2YHYuNiqINmE2YMuINin2KrYtdmEINio
2Ycg2KfZhNii2YYg2K/ZiNmGINij2Yog2KrYo9iu2YrYsS4NCg0K2KfYs9mFINin2YTYs9mK2K8g
2KzZiNmGDQrYp9mE2KjYsdmK2K8g2KfZhNil2YTZg9iq2LHZiNmG2Yo6IChqb243NjgyNjZAZ21h
aWwuY29tKQ0KDQoNCtmK2LHYrNmJINil2LnYp9iv2Kkg2KfZhNiq2KPZg9mK2K8g2YTZhyDYudmE
2Ykg2KfZhNmF2LnZhNmI2YXYp9iqINin2YTYqtin2YTZitipOg0KDQrYp9iz2YXZgyDYp9mE2YPY
p9mF2YQ6Li4uLi4uLi4NCti52YbZiNin2YbZgzouLi4uLi4uLi4uDQrYqNmE2K/ZgzouLi4uLi4u
Li4uDQrYudmF2LHZgzouLi4uLi4uLi4NCtmF2YfZhtiq2YM6Li4uLi4uLi4uLg0K2LHZgtmFINmH
2KfYqtmB2YMg2KfZhNmG2YLYp9mEOi4uLi4uLi4uLi4NCtis2YjYp9iyINin2YTYs9mB2LEg2KPZ
iCDYsdiu2LXYqSDYp9mE2YLZitin2K/YqSDYp9mE2K7Yp9i12Kkg2KjZgzogLi4uLi4uLi4uDQoN
CtmE2KfYrdi4INij2YbZhyDYpdiw2Kcg2YTZhSDYqtix2LPZhCDYpdmE2YrZhyDYp9mE2YXYudmE
2YjZhdin2Kog2KfZhNmF2LDZg9mI2LHYqSDYo9i52YTYp9mHINio2KfZhNmD2KfZhdmEINiMINmB
2YfZiA0K2YTZhiDZitmC2YjZhSDYqNil2LXYr9in2LEg2KjYt9in2YLYqSDYp9mE2LXYsdin2YEg
2KfZhNii2YTZiiDZhNmDINmE2KPZhtmHINmK2KzYqCDYo9mGINmK2KrYo9mD2K8g2YXZhiDYsNmE
2YMNCtij2YbYqi4g2KfYt9mE2Kgg2YXZhtmHINij2YYg2YrYsdiz2YQg2YTZgyDYp9mE2YXYqNmE
2Log2KfZhNil2KzZhdin2YTZiiAoMi41MC4wMDAuMDAg2K/ZiNmE2KfYsSkg2YTYqNi32KfZgtip
DQrYp9mE2LXYsdin2YEg2KfZhNii2YTZiiDYjCDZiNmH2Ygg2KfZhNmF2KjZhNi6INin2YTYsNmK
INij2LfZhNio2Ycg2YXZhtmDDQrYo9io2YLZiSDZhNmDLg0KDQrZhdi5INij2LfZitioINin2YTY
qtit2YrYp9iq2IwNCg0K2KfZhNiz2YrYryDYo9mI2LHZhNin2YbYr9mIINmF2YjYsdmK2LMNCg==
