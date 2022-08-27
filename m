Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133405A378E
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 14:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbiH0MN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 08:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiH0MN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 08:13:28 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC5086719
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 05:13:28 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id s206so3706805pgs.3
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 05:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc;
        bh=lb7mKHsaIcUxW+3Jy2BJQ41sCMA+sLqu9myEjLcTq6E=;
        b=om4c5qL7GfmMV1HnRmp/q7obk6GvR1HBXBTmlz+J3+VXofiaYqqAJViOiZCvnCIJ68
         F58rwcr+wiLftHJRZr+zJtg6TXZOESkI1m0ni8tqhR4eMlyPLR1MBP1HN9HnJ7B0sDep
         Q1m/EQo6kmBiHRzTRJ07g1PZ/9iHzjqiNBoxNrhgcXwImKaOxqYHcgrLx+D67aKZmDIe
         AuqSITMxaLNvopLMQhNghzuxBN2VOKf8dp2BGTRVRY0fFGTZH68LOMVVOdrfbmQ2EICR
         UoA6KCrYYNayrFX83Eh9z9Fmc2xAwkbvvt+4gJ2xYUwdhV/PAySQm3rW0cWE1r+Gzg4U
         +2tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc;
        bh=lb7mKHsaIcUxW+3Jy2BJQ41sCMA+sLqu9myEjLcTq6E=;
        b=je+xtloIuwbYll11DTLJGJ9uPzJXhgDtTOZJW4ZfVNm+SlZgW9xyAdUbOtqhtI28A0
         UQMb9cBCYNsS7W7tLgAMswPuBX2AIoUu3ddn5bHpQ5NbtUOgphuLj8b9ap8kkKva4vbY
         IKPCcw3k2nosJgn+4EICSoD0/HYXTnUJjg8V2QEEqShXC3BEuVxCNig0dZMmbIA/dbyf
         t7L5pB/eqDaLxx7EMcbABvR2Tm57q8ibMpt9G1MBlRKRfwLLbXdlvQcskXrNhX35soza
         3CRhynaCSZ2h969HlU3HkAXwq6orYYWOPBUM0kNwEXcB7QmcBi9dQvwABz8FJHadCuZ6
         OI9Q==
X-Gm-Message-State: ACgBeo1CncxxV0QVCEdT5LsiDaYtooCONwhSN+JcJi8cqrlZa0eH7B6i
        KzpzCM0FKpuE+JL+sJr0qriFh5q3Qep1tvlG6w0=
X-Google-Smtp-Source: AA6agR4gVA8nwh0FoGkx6+MMK5s2QCAux09qtzirLEcUgD6HJw4d5pObsJHzrNHOmRlTaZhfgtmmH7LeBBNZztbtQBA=
X-Received: by 2002:a63:e102:0:b0:41b:3901:990e with SMTP id
 z2-20020a63e102000000b0041b3901990emr6714749pgh.107.1661602407911; Sat, 27
 Aug 2022 05:13:27 -0700 (PDT)
MIME-Version: 1.0
Sender: ndubuisiu000@gmail.com
Received: by 2002:a17:90b:1a81:0:0:0:0 with HTTP; Sat, 27 Aug 2022 05:13:27
 -0700 (PDT)
From:   Jessica Daniel <jessicadaniel7833@gmail.com>
Date:   Sat, 27 Aug 2022 12:13:27 +0000
X-Google-Sender-Auth: DqdhJjuuQXZ1nXxwaXhMb-V9S9A
Message-ID: <CAPxcwwh--PNY9oE2NAzmV3Bo0NY_dxykG4qr5PDz6ZqQEoWwgA@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello Dear,
Did you receive my mail
thanks??
