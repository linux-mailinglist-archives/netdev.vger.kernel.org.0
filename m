Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED24A5FDCE7
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 17:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiJMPP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 11:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiJMPP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 11:15:28 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60CCAB3B0D
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 08:15:27 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id l127so2113617vsc.3
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 08:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=huYKu3zCGUAjNe1V+fwzWUibgp5qt9T7Bp033OSK+pw=;
        b=myA0NI28PnjipLLAv1aoU4cD+A/Nlerd+U1Mv6zlz6902CHvgadoUWydkDuaZpheL/
         1w/Vlf2NgaSARF0WOJgFivzpwnAiqkjmQG8sq9V2uOE1SfdgtgP0nJwIH6wrKY/1+/h+
         ru5b1Ye5i1bqlSoRZLSr+fhYi1RKatXhswC6NibdwNkJ1hMS4RDTwi1L8hnsRNQRprPj
         SkOI4h/L3yJbSCOBtz+EEJi33+Gsb9YxDrfgGwkzFLTqHjV0PoeeZ1ItwUOyVplEuckU
         grLI4oPa6nxz+ziTRjCKIMpjdWzAgDtXnCpIGiJBoHY79Yn5eh4yX3DlrX0cQVj7F3Gk
         Na6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=huYKu3zCGUAjNe1V+fwzWUibgp5qt9T7Bp033OSK+pw=;
        b=io6NcDzJN+iU2BD20ACU7dJ6wDUGddi1WZRLSmVouzj4E52GmfvYF2e5fGiXu7YPYV
         FIUKKOlHe3otzY78S/b1iArCy/4CPyrspXBya5lMO/ueza4rnlxNmKhy2XDXrSltLie0
         jX2cKwYwnZRsIj41TEuB263V2o0G29FYDdvjDqePSVfNhtNgCrhcpwXBo5rDUBfWIxJn
         T+6ES7Vpzag1J/F508rYPBXfYpTzDuL4M2qD7kq7kG0VCneBNLDsw6FIb8+dRdknu8Uk
         Y+Esug2aif8aFIjMi/pFm75rdCBMXe/+8PXJ9TptK96GJkaD1lV93sqCvL8KKzj1R3EB
         uWvA==
X-Gm-Message-State: ACrzQf0cRjRWsz6CipPiqfmlSX3XmDQNIqCo2oJ79J924fJZOVD/I7c9
        dOc5zQ+JZxrHeS0oZ1hWeIzsCSFQT2lznleRVUjQGzOpzjI=
X-Google-Smtp-Source: AMsMyM5fgFetq5qv9wxv/EUUzAsSski9Bt/FRAoZBkTGHa6drL8acSeUuLkTC81PWYwslXTAoQtFTzxwwJWY0YpvWJ4=
X-Received: by 2002:a05:6102:945:b0:3a6:1155:cb06 with SMTP id
 a5-20020a056102094500b003a61155cb06mr86144vsi.38.1665674126190; Thu, 13 Oct
 2022 08:15:26 -0700 (PDT)
MIME-Version: 1.0
Sender: williamsjeff859@gmail.com
Received: by 2002:a59:ac11:0:b0:319:bbcf:704a with HTTP; Thu, 13 Oct 2022
 08:15:25 -0700 (PDT)
From:   Pavillion Tchi <tchipavillion7@gmail.com>
Date:   Thu, 13 Oct 2022 15:15:25 +0000
X-Google-Sender-Auth: Qiw7TsVa0sqm2K5uY2TX18pE4eI
Message-ID: <CANPnRmexLkri_rXFrLd+Q6K0N-QK86nKOkM5gRnbPATMxfoLpg@mail.gmail.com>
Subject: Hallo
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hallo
Erhalten Sie meine vorherige E-Mail?
