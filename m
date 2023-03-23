Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4596C6C23
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 16:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbjCWPTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 11:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbjCWPT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 11:19:28 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E80829E11
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 08:19:18 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id cy23so88045109edb.12
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 08:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679584756;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EaZEaoa5Az+Owk9kP8S9MV4iQTC6KYP+QCYd3agTLNY=;
        b=UFxDmiB9r9TT3WkxQ85bzVTaMkxWLKraP3zrahrcBP9ms/Ii29CT6ScO7teb0qyx++
         HOZ0aCpmkOZpBdojA1az8iKZoiDVlXOsgFS2lXivGUNzczJXmdbE8+BdPpVfNpXwuhJO
         Te8lytSIpFms6/dn84FXiQTZEZHxv+xM5mAUkH1EtKBr9WS6NV6Ggz0XJJk28UGaGBmK
         3U8amZSX7q1MUoYfm4A9z8TBG8hh97CSvmOCF5bhgHGkuIEkaDgiwMoqONTWNRIRb6Fm
         1S7CA+54SOfIgPXAMQOJv+cb4Fcfx29ha0/6ebJPNYd7VYwrvr/Dqy/M14wMwBUfsYUY
         JqjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679584756;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EaZEaoa5Az+Owk9kP8S9MV4iQTC6KYP+QCYd3agTLNY=;
        b=36wFYGbP7Jh0mr8uU1z6z2F65F4xhpiBk4ZHioqmCas3324JoDfTi2xTVw9tcjI0ID
         g5PY0qlyQ48Es+BgkpyPW3INNsvE9NK/sDpiVS/ur5FrFXTb7gYWeL96ITrp8Ilhh+Y5
         s4qLXkc/LtqPc5BnomYVlY+nPdRnVdN6/ZMXd+TDyaHIzmxWbrnp7p/sJi13BpRl90s0
         0nkYiZ7Gv4jkPFKVKpnU7BlwTrVxWEqK2h+cHUaDhpKKS3eVa0dDSR3vZ5qrmFT1N3ol
         XzAe58KZxhJGQMfpaMX9A+zj9ZPjxzI2wIshgLj4JKOFrYTmv4XJJBSWO0AER9v9FnJ4
         WRqw==
X-Gm-Message-State: AO0yUKX0H/yhtZM4XDTl7RSFB3FkDCkE4qwTjL0LfsK+bTQDRtBJM9Ig
        hoU5uBuOy03Bcghtwz3c27OPb2of9gyOwVDAqfA=
X-Google-Smtp-Source: AK7set9xwMvDyL6YnEWCYiR7RN14qP6O+SaqCSWGj6SoNyMVnPNZVQUOJG69/AYRefahEUsu7eIrOx3plZh+yhj0wk8=
X-Received: by 2002:a17:906:1e04:b0:934:b24e:26ba with SMTP id
 g4-20020a1709061e0400b00934b24e26bamr5198582ejj.7.1679584756713; Thu, 23 Mar
 2023 08:19:16 -0700 (PDT)
MIME-Version: 1.0
Sender: geremiekolani@gmail.com
Received: by 2002:a17:907:25c5:b0:8f8:3cef:b21 with HTTP; Thu, 23 Mar 2023
 08:19:16 -0700 (PDT)
From:   Kayla Manthey <sergeantkayllamanthey@gmail.com>
Date:   Thu, 23 Mar 2023 15:19:16 +0000
X-Google-Sender-Auth: oR5SmNFKtJEffGbl6qTDui80_cA
Message-ID: <CA+PxonVLef1wx6+V7UXboVsEHFhjfe7FWkz9j8SF4hbLuS9Phg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please,  did you receive my previous email?, thank you.
