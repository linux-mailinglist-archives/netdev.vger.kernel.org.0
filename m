Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8FA65310DA
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 15:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234803AbiEWL2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 07:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234851AbiEWL2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 07:28:40 -0400
Received: from mail-oa1-x43.google.com (mail-oa1-x43.google.com [IPv6:2001:4860:4864:20::43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506DE4BBA1
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 04:28:38 -0700 (PDT)
Received: by mail-oa1-x43.google.com with SMTP id 586e51a60fabf-f16a3e0529so18068644fac.2
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 04:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=uc-cl.20210112.gappssmtp.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=qRpLPEXifhdSAN4HELhHufSxIshxP72+dn/Z3U8FF88=;
        b=MC/0Cul2Ww+RxaVaSGrFYipmaNM3McFP4bZMoWTOEZR+wDKlFdlJxT1wQ/vAHBx4bu
         NKtKFPp7M4QX+rDyatLFsh1ffQlytiNIu6NfBUgH9QRBdTWxcCKvpVjnigus1eJScAD1
         rY4TkDFUEnEVA0CjECwOeCZz5+uYlbE7oN+PUQcKulUvVajWEk12k9TNaFO/r6+TZk93
         Tw21gf8OTdgGit/JGPCtiJuTsJf7rGYZzw9O/f8D0+iXMJsqpxEinHUxvd4HN/b5xjeN
         7PWhuAIhaJR3Mv/cI9XEWsGdRzf0cHKAQsAAZH6x5yquhyFcGyyFqrYSDfdRYHfP3y1j
         /hhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=qRpLPEXifhdSAN4HELhHufSxIshxP72+dn/Z3U8FF88=;
        b=1w5N+DfY1rNAoomQVIZrpVvp/9mIaRjAK345q7hobRHf2tH5lL7hZDlOaHf1XdJNbW
         wI8/BOxQEZhwLEmgdpBWMWUf/i9tPjE5CWLmEmo5HTb1sGWOnjiSEjvfBQL/WNG+8MKP
         diqsmFe+mhkqvMLpKfeh3Fi7YDAXZP1eEMaqWekm/bUTerp5r9LNVKnpUU0UA4qmwJMw
         aKMgyoGQE2a6Uq7PFEkqsYm4vj14Xk7W4LLr3X6YooZTy25W3G5yWlEU3RlnWvozXQ8l
         1+fO5ualG6kj242jTeujY+1/vPU5KE+tnzaBKpW9j+hg0E6BUzG25opsnRAWuwHdbwuC
         5BzA==
X-Gm-Message-State: AOAM533XhwG4vHv+W6qmoqzdSW30G/1We0rYwjiOi1p8OfVzn7PKQNGe
        BeCxYc+Un79GpulVLdoJU2WHqUuoxGX+UnAxj0pqLA==
X-Google-Smtp-Source: ABdhPJxm+D2iL6Ohh6DoVvQ2oyMQnVunTxkLTCClI8UXqjaCFDWWed+9WpK8aH2rbx1l4graIIY1sxIPnWzWUtveA+I=
X-Received: by 2002:a05:6870:a449:b0:f1:9e97:5b6f with SMTP id
 n9-20020a056870a44900b000f19e975b6fmr11874067oal.179.1653305317527; Mon, 23
 May 2022 04:28:37 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6358:8790:b0:a1:c98:6be7 with HTTP; Mon, 23 May 2022
 04:28:37 -0700 (PDT)
Reply-To: cinoj00@gmail.com
From:   "Jack C. Financial Home" <npsherling@uc.cl>
Date:   Mon, 23 May 2022 19:28:37 +0800
Message-ID: <CAF54Vf6uMLftw37mU=irtJ4-Zp-GJx2fJCit368-Y4ZvzcVJYg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FORGED_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Jack C. Financial Home is giving out stress-free loans to new
applicants at a low interest rate of 3%. If interested, kindly apply
via cinoj00@gmail.com, call OR WhatsApp +1 (602) 730-1930. Thank you.
